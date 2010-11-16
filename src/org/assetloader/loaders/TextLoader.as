package org.assetloader.loaders 
{
	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	/**
	 * @author Matan Uberstein
	 */
	public class TextLoader extends BaseLoader
	{
		protected var _text : String;
		
		protected var _loader : URLStream;

		public function TextLoader(id : String, request : URLRequest) 
		{
			super(id, request, AssetType.TEXT);
		}
		
		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(this, String);
		}

		override protected function constructLoader() : IEventDispatcher 
		{
			_loader = new URLStream();
			return _loader;
		}

		override protected function invokeLoading() : void
		{
			_loader.load(request);
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
			super.stop();
		}

		override public function destroy() : void 
		{
			super.destroy();
			_loader = null;
			_text = null;
		}

		override protected function complete_handler(event : Event) : void 
		{
			var bytes : ByteArray = new ByteArray();
			_loader.readBytes(bytes);
			
			_data = _text = bytes.toString();
			
			var testResult : String = testData(_data);
			
			if(testResult != "")
			{
				_onError.dispatch(ErrorEvent.ERROR, testResult);
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

		public function get text() : String
		{
			return _text;
		}
	}
}
