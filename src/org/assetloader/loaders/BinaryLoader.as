package org.assetloader.loaders 
{
	import org.assetloader.core.ILoader;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
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
	public class BinaryLoader extends AbstractLoader implements ILoader
	{
		
		protected var _loader : URLLoader;

		public function BinaryLoader() 
		{
			super();
		}

		override protected function invokeLoading() : IEventDispatcher
		{
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
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
			var ba : ByteArray = new ByteArray();
			ba.writeBytes(_loader.data);
			ba.position = 0;
			
			_data = ba;
			
			super.complete_handler(event);
		}
	}
}
