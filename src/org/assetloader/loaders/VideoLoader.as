package org.assetloader.loaders 
{
	import org.assetloader.base.AssetParam;
	import org.assetloader.base.AssetType;
	import org.assetloader.core.ILoadUnit;
	import org.assetloader.core.ILoader;
	import org.assetloader.events.VideoAssetEvent;

	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
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
	public class VideoLoader extends EventDispatcher implements ILoader
	{

		protected var _loadUnit : ILoadUnit;

		protected var _request : URLRequest;

		protected var _netConnection : NetConnection;
		protected var _netStream : NetStream;

		protected var _progressTimer : Timer;

		protected var _progress : Number;
		protected var _invoked : Boolean;
		protected var _loaded : Boolean;

		protected var _data : *;
		protected var _hasDispatchedReady : Boolean;

		public function VideoLoader() 
		{
		}

		public function start() : void
		{
			if(!_invoked)
			{
				_invoked = true;
				_request = _loadUnit.request;
				
				_netConnection = new NetConnection();
				_netConnection.connect(null);
				
				_netStream = new NetStream(_netConnection);
				_data = _netStream;
				
				_netStream.addEventListener(IOErrorEvent.IO_ERROR, stream_ioError_handler);
				_netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, stream_asyncError_handler);				_netStream.addEventListener(NetStatusEvent.NET_STATUS, dispatchEvent);
				
				_progressTimer = new Timer(50);
				_progressTimer.addEventListener(TimerEvent.TIMER, progressTimer_handler);
				
				var client : Object = new Object();
		
				client.onPlayStatus = onPlayStatus;
				client.onCuePoint = onCuePoint;
				client.onTextData = onTextData;				client.onImageData = onImageData;				client.onMetaData = onMetaData;				client.onXMPData = onXMPData;
				
				_netStream.client = client;

				try
				{
					_netStream.play(_request.url, _loadUnit.getParam(AssetParam.CHECK_POLICY_FILE));
				}catch(error : SecurityError)
				{
					dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR, false, false, error.message));
					return;
				}
				
				_progressTimer.start();
			}
			else
			{
				destroy();
				start();
			}
		}

		public function stop() : void
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
			}
		}

		public function destroy() : void
		{
			removeListeners();
			stop();
			
			_hasDispatchedReady = false;
			_request = null;
			_netConnection = null;
			_netStream = null;
			_data = null;
			_loaded = false;
			_invoked = false;
		}

		protected function progressTimer_handler(event : TimerEvent) : void 
		{
			_progress = (bytesLoaded / bytesTotal) * 100;
			
			if(bytesLoaded > 4 && !_hasDispatchedReady)
			{
				_netStream.pause();
				_netStream.seek(0);
				
				dispatchVideoAssetEvent(VideoAssetEvent.READY);
				
				_hasDispatchedReady = true;
			}
			else if(bytesLoaded == bytesTotal && bytesTotal > 8)
			{
				_progressTimer.stop();
				
				removeListeners();
			
				_loaded = true;
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
			}
		}

		protected function stream_ioError_handler(event : IOErrorEvent) : void 
		{
			removeListeners();
			
			dispatchEvent(event);
		}

		protected function stream_asyncError_handler(event : AsyncErrorEvent) : void 
		{
			removeListeners();
			
			dispatchEvent(event);
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
				var event : VideoAssetEvent = new VideoAssetEvent(type, _loadUnit.id, AssetType.VIDEO, _netStream);
				event.data = data;
				return dispatchEvent(event);
			}
			return false;
		}

		protected function removeListeners() : void
		{
			if(_invoked)
			{
				_netStream.removeEventListener(IOErrorEvent.IO_ERROR, stream_ioError_handler);
				_netStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, stream_asyncError_handler);
				_netStream.removeEventListener(NetStatusEvent.NET_STATUS, dispatchEvent);
			
				_progressTimer.removeEventListener(TimerEvent.TIMER, progressTimer_handler);
			}
		}

		public function get loadUnit() : ILoadUnit
		{
			return _loadUnit;
		}

		public function set loadUnit(loadUnit : ILoadUnit) : void
		{
			_loadUnit = loadUnit;
		}

		public function get progress() : Number
		{
			return _progress;
		}

		public function get bytesLoaded() : uint
		{
			if(_netStream)
				return _netStream.bytesLoaded;
			return 0;
		}

		public function get bytesTotal() : uint
		{
			if(_netStream)
				return _netStream.bytesTotal;
			return 0;
		}

		public function get invoked() : Boolean
		{
			return _invoked;
		}

		public function get loaded() : Boolean
		{
			return _loaded;
		}

		public function get data() : *
		{
			return _data;
		}
	}
}
