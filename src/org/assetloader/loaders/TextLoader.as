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
		/**
		 * @private
		 */
		protected var _text : String;

		/**
		 * @private
		 */
		protected var _loader : URLStream;

		public function TextLoader(request : URLRequest, id : String = null)
		{
			super(request, AssetType.TEXT, id);
		}

		/**
		 * @private
		 */
		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(String);
		}

		/**
		 * @private
		 */
		override protected function constructLoader() : IEventDispatcher
		{
			_loader = new URLStream();
			return _loader;
		}

		/**
		 * @private
		 */
		override protected function invokeLoading() : void
		{
			_loader.load(request);
		}

		/**
		 * @inheritDoc
		 */
		override public function stop() : void
		{
			if(_invoked)
			{
				try
				{
					_loader.close();
				}
				catch(error : Error)
				{
				}
			}
			super.stop();
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy() : void
		{
			super.destroy();
			_loader = null;
			_text = null;
		}

		/**
		 * @private
		 */
		override protected function complete_handler(event : Event) : void
		{
			var bytes : ByteArray = new ByteArray();
			_loader.readBytes(bytes);

			_data = _text = bytes.toString();

			var testResult : String = testData(_data);

			if(testResult != "")
			{
				_onError.dispatch(this, ErrorEvent.ERROR, testResult);
				return;
			}

			super.complete_handler(event);
		}

		/**
		 * @private
		 * 
		 * @return Error message, empty string if no error occured.
		 */
		protected function testData(data : String) : String
		{
			return data == null ? "Data loaded is null." : "";
		}

		/**
		 * Gets the resulting String after loading is complete.
		 * 
		 * @return String
		 */
		public function get text() : String
		{
			return _text;
		}
	}
}
