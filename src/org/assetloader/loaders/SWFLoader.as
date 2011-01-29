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
		/**
		 * @private
		 */
		protected var _swf : Sprite;

		public function SWFLoader(request : URLRequest, id : String = null)
		{
			super(request, id);
			_type = AssetType.SWF;
		}

		/**
		 * @private
		 */
		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(this, Sprite);
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy() : void
		{
			super.destroy();
			_swf = null;
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
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

		/**
		 * Gets the resulting Sprite after loading is complete.
		 * 
		 * @return Sprite
		 */
		public function get swf() : Sprite
		{
			return _swf;
		}
	}
}
