package org.assetloader.loaders 
{
	import org.assetloader.base.AssetParam;
	import org.assetloader.base.LoaderStats;
	import org.assetloader.core.ILoadUnit;
	import org.assetloader.core.ILoader;
	import org.assetloader.core.ILoadStats;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
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
	public class AbstractLoader extends EventDispatcher implements ILoader
	{

		protected var _loadUnit : ILoadUnit;
		protected var _stats : ILoadStats;

		protected var _request : URLRequest;
		protected var _loaderDispatcher : IEventDispatcher;

		protected var _invoked : Boolean;
		protected var _loaded : Boolean;

		protected var _data : *;

		public function AbstractLoader() 
		{
			_stats = new LoaderStats();
		}

		/**
		 * @inheritDoc
		 */
		public function start() : void
		{
			if(!_invoked)
			{
				_invoked = true;
				_request = _loadUnit.request;
				
				if(_loadUnit.hasParam(AssetParam.HEADERS))
					_request.requestHeaders = _loadUnit.getParam(AssetParam.HEADERS);
			
				_stats.start();
				
				_loaderDispatcher = constructLoader();
				
				addLoaderListener(_loaderDispatcher);
				
				invokeLoading();
			}
			else
			{
				destroy();
				start();
			}
		}

		protected function constructLoader() : IEventDispatcher
		{
			return null;
		}

		protected function invokeLoading() : void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function stop() : void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function destroy() : void
		{
			removeLoaderListener(_loaderDispatcher);
			stop();
			
			_stats.reset();
			
			_invoked = false;
			_loaderDispatcher = null;
			_request = null;
			_data = null;
			_loaded = false;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// HANDLERS
		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function error_handler(event : ErrorEvent) : void 
		{
			removeLoaderListener(_loaderDispatcher);
			
			dispatchEvent(event);
		}

		protected function open_handler(event : Event) : void 
		{
			_stats.open();
			dispatchEvent(event);
		}

		protected function progress_handler(event : ProgressEvent) : void
		{
			_stats.update(event.bytesLoaded, event.bytesTotal);
			dispatchEvent(event);
		}

		protected function complete_handler(event : Event) : void 
		{
			_stats.done();
			
			removeLoaderListener(_loaderDispatcher);
			
			_loaded = true;
			dispatchEvent(event);
		}

		protected function addLoaderListener(dispatcher : IEventDispatcher) : void
		{
			if(dispatcher)
			{
				dispatcher.addEventListener(IOErrorEvent.IO_ERROR, error_handler);
				dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error_handler);
				
				dispatcher.addEventListener(Event.OPEN, open_handler);
				dispatcher.addEventListener(ProgressEvent.PROGRESS, progress_handler);
				dispatcher.addEventListener(Event.COMPLETE, complete_handler);
				
				dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
			}
		}

		protected function removeLoaderListener(dispatcher : IEventDispatcher) : void
		{
			if(dispatcher)
			{
				dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, error_handler);
				dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, error_handler);
				
				dispatcher.removeEventListener(Event.OPEN, open_handler);
				dispatcher.removeEventListener(ProgressEvent.PROGRESS, progress_handler);
				dispatcher.removeEventListener(Event.COMPLETE, complete_handler);
				
				dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get loadUnit() : ILoadUnit
		{
			return _loadUnit;
		}

		/**
		 * @inheritDoc
		 */
		public function set loadUnit(loadUnit : ILoadUnit) : void
		{
			_loadUnit = loadUnit;
		}

		/**
		 * @inheritDoc
		 */
		public function get stats() : ILoadStats
		{
			return _stats;
		}

		/**
		 * @inheritDoc
		 */
		public function get invoked() : Boolean
		{
			return _invoked;
		}

		/**
		 * @inheritDoc
		 */
		public function get loaded() : Boolean
		{
			return _loaded;
		}

		/**
		 * @inheritDoc
		 */
		public function get data() : *
		{
			return _data;
		}
	}
}
