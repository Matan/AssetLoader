package org.assetloader.loaders 
{
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.signals.LoaderSignal;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class DisplayObjectLoader extends BaseLoader
	{
		protected var _displayObject : DisplayObject;
		
		protected var _loader : Loader;

		public function DisplayObjectLoader(id : String, request : URLRequest) 
		{
			super(id, request, AssetType.DISPLAY_OBJECT);
		}

		override protected function initParams() : void
		{
			super.initParams();
			setParam(Param.LOADER_CONTEXT, null);
		}

		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(this, DisplayObject);
		}
		
		override protected function constructLoader() : IEventDispatcher 
		{
			_loader = new Loader();
			return _loader.contentLoaderInfo;
		}

		override protected function invokeLoading() : void
		{
			_loader.load(request, getParam(Param.LOADER_CONTEXT));
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
			_displayObject = null;
		}

		override protected function complete_handler(event : Event) : void 
		{
			_data = _displayObject = _loader.content;
			
			var testResult : String = testData(_data);
			
			if(testResult != "")
			{
				_onError.dispatch(ErrorEvent.ERROR, testResult);
				return;
			}
			
			super.complete_handler(event);
		}

		/**
		 * @return Error message, empty String if no error occured.
		 */
		protected function testData(data : DisplayObject) : String
		{
			return !data ? "Data is not a DisplayObject." : "";
		}

		public function get displayObject() : DisplayObject
		{
			return _displayObject;
		}
	}
}
