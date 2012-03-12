package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.signals.NetStatusSignal;

	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	/**
	 * @author Matan Uberstein
	 */
	public class VideoLoader extends BaseLoader
	{
		/**
		 * @private
		 */
		protected var _onNetStatus : NetStatusSignal;
		/**
		 * @private
		 */
		protected var _onReady : LoaderSignal;
		/**
		 * @private
		 */
		protected var _onMetaData : LoaderSignal;

		/**
		 * @private
		 */
		protected var _netConnection : NetConnection;
		/**
		 * @private
		 */
		protected var _netStream : NetStream;

		/**
		 * @private
		 */
		protected var _progressTimer : Timer;
		/**
		 * @private
		 */
		protected var _isReady : Boolean;

		/**
		 * @private
		 */
		protected var _metaData : Object;

		public function VideoLoader(request : URLRequest, id : String = null)
		{
			super(request, AssetType.VIDEO, id);
		}

		/**
		 * @private
		 */
		override protected function initParams() : void
		{
			super.initParams();
			setParam(Param.CLIENT, {onMetaData:metaData_handler});
		}

		/**
		 * @private
		 */
		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(NetStream);
			_onNetStatus = new NetStatusSignal();
			_onReady = new LoaderSignal(NetStream);
			_onMetaData = new LoaderSignal(Object);
		}

		/**
		 * @private
		 */
		override protected function constructLoader() : IEventDispatcher
		{
			_netConnection = new NetConnection();
			_netConnection.connect(null);

			_netStream = new NetStream(_netConnection);
			_data = _netStream;

			_progressTimer = new Timer(50);
			_progressTimer.addEventListener(TimerEvent.TIMER, progressTimer_handler);

			_netStream.client = getParam(Param.CLIENT);

			return _netStream;
		}

		/**
		 * @private
		 */
		override protected function invokeLoading() : void
		{
			try
			{
				_netStream.play(request.url, getParam(Param.CHECK_POLICY_FILE) || true);
				_netStream.pause();
			}
			catch(error : SecurityError)
			{
				_onError.dispatch(this, error.name, error.message);
			}

			_progressTimer.start();
		}

		/**
		 * @inheritDoc
		 */
		override public function stop() : void
		{
			if(_invoked)
			{
				try
				{
					_netStream.close();
				}
				catch(error : Error)
				{
				}
				try
				{
					_netConnection.close();
				}
				catch(error : Error)
				{
				}
				_progressTimer.stop();
			}
			super.stop();
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy() : void
		{
			super.destroy();

			if(_progressTimer)
				_progressTimer.removeEventListener(TimerEvent.TIMER, progressTimer_handler);

			_isReady = false;
			_netConnection = null;
			_netStream = null;
			_metaData = null;
		}

		/**
		 * @private
		 */
		protected function progressTimer_handler(event : TimerEvent) : void
		{
			if(_netStream.bytesLoaded > 4 && !_isReady)
			{
				open_handler(new Event(Event.OPEN));

				_isReady = true;
				_onReady.dispatch(this, _netStream);
			}
			else if(_netStream.bytesLoaded != _stats.bytesTotal && _isReady)
				progress_handler(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _netStream.bytesLoaded, _netStream.bytesTotal));
			else if(_netStream.bytesLoaded > 8 && _netStream.bytesTotal > 8)
			{
				_progressTimer.stop();
				complete_handler(new Event(Event.COMPLETE));
			}
		}

		/**
		 * @private
		 */
		protected function netStatus_handler(event : NetStatusEvent) : void
		{
			var code : String = event.info.code;

			var errorEvent : ErrorEvent;

			switch(code)
			{
				case "NetConnection.Call.BadVersion" :
				case "NetConnection.Call.Failed" :
				case "NetConnection.Call.Prohibited" :
				case "NetConnection.Connect.AppShutdown" :
				case "NetConnection.Connect.Failed" :
				case "NetConnection.Connect.InvalidApp" :
				case "NetConnection.Connect.Rejected" :
				case "NetGroup.Connect.Failed" :
				case "NetGroup.Connect.Rejected" :
				case "NetGroup.Replication.Fetch.Failed" :
				case "NetStream.Connect.Failed" :
				case "NetStream.Connect.Rejected" :
				case "NetStream.Failed" :
				case "NetStream.Play.FileStructureInvalid" :

					errorEvent = new ErrorEvent(ErrorEvent.ERROR);
					errorEvent.text = code;
					error_handler(errorEvent);

					break;

				case "NetStream.Play.StreamNotFound":

					errorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR);
					errorEvent.text = code;
					error_handler(errorEvent);

					break;

				default:
					_onNetStatus.dispatch(this, event.info);
					break;
			}
		}

		/**
		 * @private
		 */
		protected function metaData_handler(data : Object) : void
		{
			if(_metaData)
				return;

			_metaData = {};

			for(var key : String in data)
			{
				_metaData[key] = data[key];
			}

			_onMetaData.dispatch(this, _metaData);
		}

		/**
		 * @private
		 */
		override protected function addListeners(dispatcher : IEventDispatcher) : void
		{
			if(dispatcher)
			{
				dispatcher.addEventListener(IOErrorEvent.IO_ERROR, error_handler);
				dispatcher.addEventListener(AsyncErrorEvent.ASYNC_ERROR, error_handler);
				dispatcher.addEventListener(NetStatusEvent.NET_STATUS, netStatus_handler);
			}
		}

		/**
		 * @private
		 */
		override protected function removeListeners(dispatcher : IEventDispatcher) : void
		{
			if(dispatcher)
			{
				dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, error_handler);
				dispatcher.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, error_handler);
				dispatcher.removeEventListener(NetStatusEvent.NET_STATUS, netStatus_handler);
			}
		}

		/**
		 * Dispatches when the NetStream reports a NetStatus event.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>NetStatusSignal</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.NetStatusSignal
		 */
		public function get onNetStatus() : NetStatusSignal
		{
			return _onNetStatus;
		}

		/**
		 * Dispatches when the NetStream is ready to be attached to a Video instance.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>, netStream:<strong>NetStream</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 *	 <li><strong>netStream</strong> - The NetStream instance.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		public function get onReady() : LoaderSignal
		{
			return _onReady;
		}

		/**
		 * Dispatches when the NetStream has loaded it's meta data.
		 * <p><strong>Note</strong>: onMetaData will only dispatch you leave the default client's onMetaData handler intact.</p>
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>, netStream:<strong>NetStream</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 *	 <li><strong>data</strong> - The NetStream's meta data object.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		public function get onMetaData() : LoaderSignal
		{
			return _onMetaData;
		}

		/**
		 * Gets the NetConnection used with the NetStream.
		 * <p>Note: this instance will be available as soon as the VideoLoader's
		 * start method is invoked.</p>
		 * 
		 * @return NetConnection
		 */
		public function get netConnection() : NetConnection
		{
			return _netConnection;
		}

		/**
		 * Gets the NetStream.
		 * 
		 * <p>Note: this instance will be available as soon as the VideoLoader's
		 * start method is invoked.</p>
		 * 
		 * @return NetStream
		 */
		public function get netStream() : NetStream
		{
			return _netStream;
		}

		/**
		 * Gets the latest meta data object.
		 * <p><strong>Note</strong>: this is only populated if you haven't overwritten the default CLIENT param.</p>
		 */
		public function get metaData() : Object
		{
			return _metaData;
		}

		/**
		 * Gets whether the NetStream instance is ready to be attached to a Video instance.
		 * 
		 * @see #onReady
		 */
		public function get isReady() : Boolean
		{
			return _isReady;
		}
	}
}
