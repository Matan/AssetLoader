package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class SWFLoader extends DisplayObjectLoader
	{
		protected var _swf : Sprite;

		public function SWFLoader(id : String, request : URLRequest)
		{
			super(id, request);
			_type = AssetType.SWF;
		}

		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(this, Sprite);
		}

		override public function destroy() : void
		{
			super.destroy();
			_swf = null;
		}

		override protected function testData(data : DisplayObject) : String
		{
			var errMsg : String = "";
			try
			{
				_data = _swf = Sprite(data);
			}
			catch(error : Error)
			{
				errMsg = error.message;
			}
			return errMsg;
		}

		public function get swf() : Sprite
		{
			return _swf;
		}
	}
}
