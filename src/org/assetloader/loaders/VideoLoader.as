package org.assetloader.loaders 
{
	import org.assetloader.base.AbstractLoader;
	import org.assetloader.base.Param;
	import org.assetloader.base.AssetType;
	import org.assetloader.core.ILoader;
	import org.assetloader.events.VideoAssetEvent;

	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;

	[Event(name="ON_PLAY_STATUS", type="org.assetloader.events.VideoAssetEvent")]

	[Event(name="ON_CUE_POINT", type="org.assetloader.events.VideoAssetEvent")]

	[Event(name="ON_TEXT_DATA", type="org.assetloader.events.VideoAssetEvent")]

	[Event(name="ON_IMAGE_DATA", type="org.assetloader.events.VideoAssetEvent")]

	[Event(name="ON_META_DATA", type="org.assetloader.events.VideoAssetEvent")]

	[Event(name="ON_XMP_DATA", type="org.assetloader.events.VideoAssetEvent")]

	/**
	 * Dispatches when the <code>NetStream</code> is ready to be attached to a player.
	 */
	[Event(name="READY", type="org.assetloader.events.VideoAssetEvent")]

	[Event(name="open", type="flash.events.Event")]
	[Event(name="complete", type="flash.events.Event")]

	[Event(name="error", type="flash.events.ErrorEvent")]

	[Event(name="progress", type="flash.events.ProgressEvent")]

	[Event(name="netStatus", type="flash.events.NetStatusEvent")]

	[Event(name="ioError", type="flash.events.IOErrorEvent")]

	[Event(name="asyncError", type="flash.events.AsyncErrorEvent")]

	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]

	/**
	 * @author Matan Uberstein
	 */
	public class VideoLoader extends AbstractLoader implements ILoader
	{

		protected var _netConnection : NetConnection;
		protected var _netStream : NetStream;

		protected var _progressTimer : Timer;
		protected var _hasDispatchedReady : Boolean;

		public function VideoLoader() 
		{
			super();
		}

		override protected function constructLoader() : IEventDispatcher 
		{
			_netConnection = new NetConnection();
			_netConnection.connect(null);
				
			_netStream = new NetStream(_netConnection);
			_data = _netStream;
				
			_progressTimer = new Timer(50);
			_progressTimer.addEventListener(TimerEvent.TIMER, progressTimer_handler);
				
			var client : Object = new Object();
		
			client.onPlayStatus = onPlayStatus;
			client.onCuePoint = onCuePoint;
			client.onTextData = onTextData;
			client.onImageData = onImageData;
			client.onMetaData = onMetaData;
			client.onXMPData = onXMPData;
				
			_netStream.client = client;
			
			return _netStream;
		}

		override protected function invokeLoading() : void 
		{
			try
			{
				_netStream.play(_request.url, _unit.getParam(Param.CHECK_POLICY_FILE));
			}catch(error : SecurityError)
			{
				dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR, false, false, error.message));
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
				}catch(error : Error)
				{
				}
				try
				{
					_netConnection.close();
				}catch(error : Error)
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
				
				dispatchVideoAssetEvent(VideoAssetEvent.READY);
				
				_hasDispatchedReady = true;
			}
			else if(_netStream.bytesLoaded == _netStream.bytesTotal && _netStream.bytesTotal > 8)
			{
				_progressTimer.stop();
				
				complete_handler(new Event(Event.COMPLETE));
			}
			else if(_netStream.bytesLoaded != _stats.bytesLoaded)
				progress_handler(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _netStream.bytesLoaded, _netStream.bytesTotal));
		}

		protected function onPlayStatus(data : Object) : void
		{
			dispatchVideoAssetEvent(VideoAssetEvent.ON_PLAY_STATUS, data);
		}

		protected function onCuePoint(data : Object) : void
		{
			dispatchVideoAssetEvent(VideoAssetEvent.ON_CUE_POINT, data);
		}

		protected function onTextData(data : Object) : void
		{
			dispatchVideoAssetEvent(VideoAssetEvent.ON_TEXT_DATA, data);
		}

		protected function onImageData(data : Object) : void
		{
			dispatchVideoAssetEvent(VideoAssetEvent.ON_IMAGE_DATA, data);
		}

		protected function onMetaData(data : Object) : void
		{
			dispatchVideoAssetEvent(VideoAssetEvent.ON_META_DATA, data);
		}

		protected function onXMPData(data : Object) : void
		{
			dispatchVideoAssetEvent(VideoAssetEvent.ON_XMP_DATA, data);
		}

		protected function dispatchVideoAssetEvent(type : String, data : Object = null) : Boolean
		{
			if(hasEventListener(type))
			{
				var parentId : String;
				if(_parent)
					parentId = _parent.unit.id;
				
				var event : VideoAssetEvent = new VideoAssetEvent(type, _unit.id, parentId, AssetType.VIDEO, _netStream);
				event.data = data;
				return dispatchEvent(event);
			}
			return false;
		}

		
		override protected function addListeners(dispatcher : IEventDispatcher) : void 
		{
			if(dispatcher)
			{
				dispatcher.addEventListener(IOErrorEvent.IO_ERROR, error_handler);
				dispatcher.addEventListener(AsyncErrorEvent.ASYNC_ERROR, error_handler);
				dispatcher.addEventListener(NetStatusEvent.NET_STATUS, dispatchEvent);
			}
		}

		override protected function removeListeners(dispatcher : IEventDispatcher) : void 
		{
			if(dispatcher)
			{
				dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, error_handler);
				dispatcher.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, error_handler);
				dispatcher.removeEventListener(NetStatusEvent.NET_STATUS, dispatchEvent);
			}
		}
	}
}
