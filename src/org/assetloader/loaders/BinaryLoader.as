package org.assetloader.loaders 
{
	import org.assetloader.base.AssetParam;
	import org.assetloader.core.ILoader;
	import org.assetloader.core.ILoadUnit;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]

	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]

	[Event(name="ioError", type="flash.events.IOErrorEvent")]

	[Event(name="progress", type="flash.events.ProgressEvent")]

	[Event(name="complete", type="flash.events.Event")]

	[Event(name="open", type="flash.events.Event")]

	/**
	 * @author Matan Uberstein
	 */
	public class BinaryLoader extends EventDispatcher implements ILoader
	{

		protected var _loadUnit : ILoadUnit;

		protected var _request : URLRequest;
		protected var _loader : URLLoader;

		protected var _progress : Number;		protected var _invoked : Boolean;
		protected var _loaded : Boolean;

		protected var _data : *;

		public function BinaryLoader() 
		{
		}

		public function start() : void
		{
			if(!_invoked)
			{
				_invoked = true;
				_request = _loadUnit.request;
				
				if(_loadUnit.hasParam(AssetParam.HEADERS))
					_request.requestHeaders = _loadUnit.getParam(AssetParam.HEADERS);
			
				_loader = new URLLoader();
				_loader.dataFormat = URLLoaderDataFormat.BINARY;
				
				_loader.addEventListener(Event.COMPLETE, loader_complete_handler);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioError_handler);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityError_handler);				_loader.addEventListener(ProgressEvent.PROGRESS, loader_progress_handler);
				_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
				_loader.addEventListener(Event.OPEN, dispatchEvent);
			
				_loader.load(_request);
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
					_loader.close();	
				}catch(error : Error)
				{
				}
			}
		}

		public function destroy() : void
		{
			removeLoaderListener();
			stop();
			
			_request = null;
			_loader = null;
			_data = null;
			_loaded = false;
			_invoked = false;
		}

		protected function loader_ioError_handler(event : IOErrorEvent) : void 
		{
			removeLoaderListener();
			
			dispatchEvent(event);
		}

		protected function loader_securityError_handler(event : SecurityErrorEvent) : void 
		{
			removeLoaderListener();
			
			dispatchEvent(event);
		}

		protected function loader_complete_handler(event : Event) : void 
		{
			removeLoaderListener();
			
			var ba : ByteArray = new ByteArray();
			ba.writeBytes(_loader.data);
			ba.position = 0;
			
			_data = ba;
			
			_loaded = true;
			dispatchEvent(event);
		}

		protected function loader_progress_handler(event : ProgressEvent) : void
		{
			_progress = (event.bytesLoaded / event.bytesTotal) * 100;
			
			dispatchEvent(event);
		}

		protected function removeLoaderListener() : void
		{
			if(_loader)
			{
				_loader.removeEventListener(Event.COMPLETE, loader_complete_handler);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, loader_ioError_handler);
				_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityError_handler);				_loader.removeEventListener(ProgressEvent.PROGRESS, loader_progress_handler);
				_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
				_loader.removeEventListener(Event.OPEN, dispatchEvent);
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
			if(_loader)
				return _loader.bytesLoaded;
			return 0;
		}

		public function get bytesTotal() : uint
		{
			if(_loader)
				return _loader.bytesTotal;
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
