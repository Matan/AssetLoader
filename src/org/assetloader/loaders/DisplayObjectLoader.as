package org.assetloader.loaders
{
	import flash.display.LoaderInfo;
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.signals.LoaderSignal;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class DisplayObjectLoader extends BaseLoader
	{
		/**
		 * @private
		 */
		protected var _displayObject : DisplayObject;

		/**
		 * @private
		 */
		protected var _loader : Loader;

		public function DisplayObjectLoader(request : URLRequest, id : String = null)
		{
			super(request, AssetType.DISPLAY_OBJECT, id);
		}

		/**
		 * @private
		 */
		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(DisplayObject);
		}

		/**
		 * @private
		 */
		override protected function constructLoader() : IEventDispatcher
		{
			_loader = new Loader();
			return _loader.contentLoaderInfo;
		}

		/**
		 * @private
		 */
		override protected function invokeLoading() : void
		{
			_loader.load(request, getParam(Param.LOADER_CONTEXT));
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
			_displayObject = null;
		}

		/**
		 * @private
		 */
		override protected function complete_handler(event : Event) : void
		{
			_data = _displayObject = _loader.content;

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
		 * @return Error message, empty String if no error occured.
		 */
		protected function testData(data : DisplayObject) : String
		{
			return !data ? "Data is not a DisplayObject." : "";
		}

		/**
		 * Gets the resulting DisplayObject after loading is complete.
		 * 
		 * @return DisplayObject
		 */
		public function get displayObject() : DisplayObject
		{
			return _displayObject;
		}

		/**
		 * Gets the current content's LoaderInfo.
		 * 
		 * @return LoaderInfo
		 */
		public function get contentLoaderInfo() : LoaderInfo
		{
			return _loader ? _loader.contentLoaderInfo : null;
		}
	}
}
