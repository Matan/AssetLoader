package org.assetloader.loaders 
{
	import org.assetloader.core.ILoader;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;

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
	public class TextLoader extends AbstractLoader implements ILoader
	{
		protected var _loader : URLLoader;

		public function TextLoader() 
		{
			super();
		}

		override protected function invokeLoading() : IEventDispatcher
		{
			_loader = new URLLoader();
			_loader.load(_request);
			
			return _loader;
		}

		override public function stop() : void
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

		override public function destroy() : void 
		{
			super.destroy();
			_loader = null;
		}
		
		override protected function open_handler(event : Event) : void 
		{
			_stats.open(_loader.bytesTotal);
			
			super.open_handler(event);
		}

		override protected function complete_handler(event : Event) : void 
		{
			_data = _loader.data;
			
			var testResult : String = testData(_data);
			
			if(testResult != "")
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, testResult));
				return;
			}
			
			super.complete_handler(event);
		}

		/**
		 * @return Error message, empty string if no error occured.
		 */
		protected function testData(data : String) : String
		{
			return data == null ? "Data loaded is null." : "";
		}
	}
}
