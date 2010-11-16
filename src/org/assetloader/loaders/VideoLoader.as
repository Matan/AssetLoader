package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.core.ILoader;
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
		protected var _onNetStatus : NetStatusSignal;
		protected var _onReady : LoaderSignal;

		protected var _netConnection : NetConnection;
		protected var _netStream : NetStream;

		protected var _progressTimer : Timer;
		protected var _hasDispatchedReady : Boolean;

		public function VideoLoader(id : String, request : URLRequest, parent : ILoader = null)
		{
			super(id, request, AssetType.VIDEO, parent);
		}

		override protected function initParams() : void
		{
			super.initParams();
			setParam(Param.CHECK_POLICY_FILE, true);
			setParam(Param.CLIENT, {onMetaData:function() : void
			{
			}});
		}

		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(this, NetStream);
			_onNetStatus = new NetStatusSignal(this);
			_onReady = new LoaderSignal(this, NetStream);
		}

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

		override protected function invokeLoading() : void
		{
			try
			{
				_netStream.play(request.url, getParam(Param.CHECK_POLICY_FILE));
			}
			catch(error : SecurityError)
			{
				_onError.dispatch(error.name, error.message);
			}

			_progressTimer.start();
		}

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

		override public function destroy() : void
		{
			super.destroy();

			if(_progressTimer)
				_progressTimer.removeEventListener(TimerEvent.TIMER, progressTimer_handler);

			_hasDispatchedReady = false;
			_netConnection = null;
			_netStream = null;
		}

		protected function progressTimer_handler(event : TimerEvent) : void
		{
			if(_netStream.bytesLoaded > 4 && !_hasDispatchedReady)
			{
				_netStream.pause();
				_netStream.seek(0);

				open_handler(new Event(Event.OPEN));

				_onReady.dispatch(_netStream);

				_hasDispatchedReady = true;
			}
			else if(_netStream.bytesLoaded != _stats.bytesTotal && _hasDispatchedReady)
				progress_handler(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _netStream.bytesLoaded, _netStream.bytesTotal));
			else if(_netStream.bytesLoaded > 8 && _netStream.bytesTotal > 8)
			{
				_progressTimer.stop();
				complete_handler(new Event(Event.COMPLETE));
			}
		}

		protected function netStatus_handler(event : NetStatusEvent) : void
		{
			var code : String = event.info.code;

			var errorEvent : ErrorEvent;

			switch(code)
			{
				case "NetStream.Play.StreamNotFound":

					errorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR);
					errorEvent.text = code;
					error_handler(errorEvent);

					break;

				default:
					_onNetStatus.dispatch(event.info);
					break;
			}
		}

		override protected function addListeners(dispatcher : IEventDispatcher) : void
		{
			if(dispatcher)
			{
				dispatcher.addEventListener(IOErrorEvent.IO_ERROR, error_handler);
				dispatcher.addEventListener(AsyncErrorEvent.ASYNC_ERROR, error_handler);
				dispatcher.addEventListener(NetStatusEvent.NET_STATUS, netStatus_handler);
			}
		}

		override protected function removeListeners(dispatcher : IEventDispatcher) : void
		{
			if(dispatcher)
			{
				dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, error_handler);
				dispatcher.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, error_handler);
				dispatcher.removeEventListener(NetStatusEvent.NET_STATUS, netStatus_handler);
			}
		}

		public function get onNetStatus() : NetStatusSignal
		{
			return _onNetStatus;
		}

		public function get onReady() : LoaderSignal
		{
			return _onReady;
		}

		public function get netConnection() : NetConnection
		{
			return _netConnection;
		}

		public function get netStream() : NetStream
		{
			return _netStream;
		}
	}
}
