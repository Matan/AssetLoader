package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.signals.LoaderSignal;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class ImageLoader extends DisplayObjectLoader
	{
		/**
		 * @private
		 */
		protected var _bitmapData : BitmapData;
		/**
		 * @private
		 */
		protected var _bitmap : Bitmap;

		public function ImageLoader(request : URLRequest, id : String = null)
		{
			super(request, id);
			_type = AssetType.IMAGE;
		}

		/**
		 * @private
		 */
		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(Bitmap);
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy() : void
		{
			super.destroy();
			try
			{
				_bitmapData.dispose();
			}
			catch(error : Error)
			{
			}
			_bitmap = null;
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
				var sourceBitmapData:BitmapData = Bitmap(data).bitmapData;
				var transparent:Boolean = (getParam(Param.TRANSPARENT) == undefined) ? sourceBitmapData.transparent : getParam(Param.TRANSPARENT);
				_bitmapData = new BitmapData(_loader.contentLoaderInfo.width, _loader.contentLoaderInfo.height, transparent, getParam(Param.FILL_COLOR) || 0x0);
				_bitmapData.draw(sourceBitmapData, getParam(Param.MATRIX), getParam(Param.COLOR_TRANSFROM), getParam(Param.BLEND_MODE), getParam(Param.CLIP_RECTANGLE), getParam(Param.SMOOTHING) || false);

				_data = _bitmap = new Bitmap(_bitmapData, getParam(Param.PIXEL_SNAPPING) || "auto", getParam(Param.SMOOTHING) || false);
			}
			catch(err : Error)
			{
				errMsg = err.message;
			}

			return errMsg;
		}

		/**
		 * Gets the resulting BitmapData after loading is complete.
		 * 
		 * @return BitmapData
		 */
		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}

		/**
		 * Gets the resulting Bitmap after loading is complete.
		 * 
		 * @return Bitmap
		 */
		public function get bitmap() : Bitmap
		{
			return _bitmap;
		}
	}
}
