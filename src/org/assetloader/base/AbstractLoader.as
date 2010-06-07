package org.assetloader.base 
{
	import org.assetloader.core.ILoadStats;
	import org.assetloader.core.ILoadUnit;
	import org.assetloader.core.ILoader;

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

		protected var _unit : ILoadUnit;
		protected var _stats : ILoadStats;

		protected var _request : URLRequest;
		protected var _eventDispatcher : IEventDispatcher;

		protected var _invoked : Boolean;
		protected var _inProgress : Boolean;
		protected var _stopped : Boolean;
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
				_stopped = false;
				
				_request = _unit.request;
				
				if(_unit.hasParam(Param.HEADERS))
					_request.requestHeaders = _unit.getParam(Param.HEADERS);
			
				_stats.start(_unit.getParam(Param.WEIGHT));
				
				_eventDispatcher = constructLoader();
				
				addListeners(_eventDispatcher);
				
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
			_stopped = true;
		}

		/**
		 * @inheritDoc
		 */
		public function destroy() : void
		{
			removeListeners(_eventDispatcher);
			stop();
			
			_stats.reset();
			
			_invoked = false;
			_eventDispatcher = null;
			_request = null;
			_data = null;
			_loaded = false;
			_stopped = false;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// HANDLERS
		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function error_handler(event : ErrorEvent) : void 
		{
			removeListeners(_eventDispatcher);
			
			dispatchEvent(event);
		}

		protected function open_handler(event : Event) : void 
		{
			_stats.open();
			
			_inProgress = true;
			
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
			
			removeListeners(_eventDispatcher);
			
			_inProgress = false;
			_loaded = true;
			dispatchEvent(event);
		}

		protected function addListeners(dispatcher : IEventDispatcher) : void
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

		protected function removeListeners(dispatcher : IEventDispatcher) : void
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
		public function get unit() : ILoadUnit
		{
			return _unit;
		}

		/**
		 * @inheritDoc
		 */
		public function set unit(loadUnit : ILoadUnit) : void
		{
			_unit = loadUnit;
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
		public function get inProgress() : Boolean
		{
			return _inProgress;
		}

		/**
		 * @inheritDoc
		 */
		public function get stopped() : Boolean
		{
			return _stopped;
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
