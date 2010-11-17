package org.assetloader.loaders
{
	import flash.net.URLVariables;

	import org.assetloader.base.AbstractLoader;
	import org.assetloader.base.Param;
	import org.assetloader.core.ILoader;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class BaseLoader extends AbstractLoader implements ILoader
	{
		protected var _eventDispatcher : IEventDispatcher;

		public function BaseLoader(id : String, request : URLRequest, type : String)
		{
			super(id, type, request);
		}

		/**
		 * @inheritDoc
		 */
		override public function start() : void
		{
			if(!_invoked)
			{
				_invoked = true;
				_stopped = false;

				_stats.start();

				_eventDispatcher = constructLoader();

				addListeners(_eventDispatcher);

				invokeLoading();
			}
			else
			{
				_invoked = false;
				stop();
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

		override public function stop() : void
		{
			removeListeners(_eventDispatcher);
			_eventDispatcher = null;

			super.stop();
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy() : void
		{
			removeListeners(_eventDispatcher);
			_eventDispatcher = null;

			super.destroy();
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// HANDLERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		protected function error_handler(event : ErrorEvent) : void
		{
			if(_retryTally < getParam(Param.RETRIES))
			{
				_retryTally++;
				start();
			}
			else
			{
				removeListeners(_eventDispatcher);
				_onError.dispatch(event.type, event.text);
			}
		}

		protected function httpStatus_handler(event : HTTPStatusEvent) : void
		{
			_onHttpStatus.dispatch(event.status);
		}

		protected function open_handler(event : Event) : void
		{
			_stats.open();
			_inProgress = true;
			_onOpen.dispatch();
		}

		protected function progress_handler(event : ProgressEvent) : void
		{
			_stats.update(event.bytesLoaded, event.bytesTotal);
			_onProgress.dispatch(_stats.latency, _stats.speed, _stats.averageSpeed, _stats.progress, _stats.bytesLoaded, _stats.bytesTotal);
		}

		protected function complete_handler(event : Event) : void
		{
			_stats.done();
			_onProgress.dispatch();

			removeListeners(_eventDispatcher);

			_inProgress = false;
			_loaded = true;
			_onComplete.dispatch(_data);
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED
		// --------------------------------------------------------------------------------------------------------------------------------//
		protected function addListeners(dispatcher : IEventDispatcher) : void
		{
			if(dispatcher)
			{
				dispatcher.addEventListener(IOErrorEvent.IO_ERROR, error_handler);
				dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error_handler);

				dispatcher.addEventListener(Event.OPEN, open_handler);
				dispatcher.addEventListener(ProgressEvent.PROGRESS, progress_handler);
				dispatcher.addEventListener(Event.COMPLETE, complete_handler);

				dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_handler);
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

				dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_handler);
			}
		}

		override public function setParam(id : String, value : *) : void
		{
			super.setParam(id, value);

			switch(id)
			{
				case Param.PREVENT_CACHE:

					var url : String = _request.url;
					if(value)
					{
						if(url.indexOf("ck=") == -1)
							url += ((url.indexOf("?") == -1) ? "?" : "&") + "ck=" + new Date().time;
					}
					else if(url.indexOf("ck=") != -1)
					{
						var vrs : URLVariables = new URLVariables(url.slice(url.indexOf("?") + 1));
						var cleanUrl : String = url = url.slice(0, url.indexOf("?"));
						var cleanVrs : URLVariables = new URLVariables();

						for(var queryKey : String in vrs)
						{
							if(queryKey != "ck")
								cleanVrs[queryKey] = vrs[queryKey];
						}
						
						var queryString : String = cleanVrs.toString();
						if(queryString != "")
							url = cleanUrl + "?" + queryString;
					}
					_request.url = url;

					break;
				case Param.HEADERS:
					_request.requestHeaders = value;
					break;
			}
		}
	}
}
