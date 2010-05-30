package org.assetloader.loaders 
{
	import org.assetloader.base.AssetParam;
	import org.assetloader.core.ILoader;
	import org.assetloader.core.ILoadUnit;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;

	[Event(name="error", type="flash.events.ErrorEvent")]

	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]

	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]

	[Event(name="ioError", type="flash.events.IOErrorEvent")]

	[Event(name="progress", type="flash.events.ProgressEvent")]

	[Event(name="complete", type="flash.events.Event")]

	[Event(name="open", type="flash.events.Event")]

	/**
	 * @author Matan Uberstein
	 */
	public class DisplayObjectLoader extends EventDispatcher implements ILoader
	{

		protected var _loadUnit : ILoadUnit;

		protected var _request : URLRequest;
		protected var _loader : Loader;

		protected var _progress : Number;
		protected var _invoked : Boolean;
		protected var _loaded : Boolean;

		protected var _rawData : DisplayObject;
		protected var _data : *;

		public function DisplayObjectLoader() 
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
			
				_loader = new Loader();
				
				var contentLoaderInfo : LoaderInfo = _loader.contentLoaderInfo;
				
				contentLoaderInfo.addEventListener(Event.COMPLETE, loader_complete_handler);
				contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_ioError_handler);
				contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityError_handler);
				contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loader_progress_handler);
				contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
				contentLoaderInfo.addEventListener(Event.OPEN, dispatchEvent);
			
				_loader.load(_request, _loadUnit.getParam(AssetParam.LOADER_CONTEXT));
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
			
			_rawData = _data = _loader.content;
			
			var testResult : String = testData(_data);
			
			if(testResult != "")
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, testResult));
				return;
			}
			
			_loaded = true;
			dispatchEvent(event);
		}

		protected function loader_progress_handler(event : ProgressEvent) : void
		{
			_progress = (event.bytesLoaded / event.bytesTotal) * 100;
			
			dispatchEvent(event);
		}

		/**
		 * @return Error message, empty String if no error occured.
		 */
		protected function testData(data : DisplayObject) : String
		{
			return data ? "Data is not a DisplayObject." : "";
		}

		protected function removeLoaderListener() : void
		{
			if(_loader)
			{
				var contentLoaderInfo : LoaderInfo = _loader.contentLoaderInfo;
				
				contentLoaderInfo.removeEventListener(Event.COMPLETE, loader_complete_handler);
				contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loader_ioError_handler);
				contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityError_handler);
				contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loader_progress_handler);
				contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
				contentLoaderInfo.removeEventListener(Event.OPEN, dispatchEvent);
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
				return _loader.contentLoaderInfo.bytesLoaded;
			return 0;
		}

		public function get bytesTotal() : uint
		{
			if(_loader)
				return _loader.contentLoaderInfo.bytesTotal;
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
