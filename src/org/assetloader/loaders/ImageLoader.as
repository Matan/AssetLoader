package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.core.ILoader;
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
		protected var _bitmapData : BitmapData;
		protected var _bitmap : Bitmap;

		public function ImageLoader(id : String, request : URLRequest, parent : ILoader = null)
		{
			super(id, request, parent);
			_type = AssetType.IMAGE;
		}

		override protected function initParams() : void
		{
			super.initParams();
			setParam(Param.TRANSPARENT, true);
			setParam(Param.FILL_COLOR, 4.294967295E9);
			setParam(Param.MATRIX, null);
			setParam(Param.COLOR_TRANSFROM, null);
			setParam(Param.BLEND_MODE, null);
			setParam(Param.CLIP_RECTANGLE, null);
			setParam(Param.SMOOTHING, false);
			setParam(Param.PIXEL_SNAPPING, "auto");
		}
		
		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(this, Bitmap);
		}

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

		override protected function testData(data : DisplayObject) : String
		{
			var errMsg : String = "";
			try
			{
				_bitmapData = new BitmapData(_loader.contentLoaderInfo.width, _loader.contentLoaderInfo.height, getParam(Param.TRANSPARENT), getParam(Param.FILL_COLOR));
				_bitmapData.draw(data, getParam(Param.MATRIX), getParam(Param.COLOR_TRANSFROM), getParam(Param.BLEND_MODE), getParam(Param.CLIP_RECTANGLE), getParam(Param.SMOOTHING));

				_data = _bitmap = new Bitmap(_bitmapData, getParam(Param.PIXEL_SNAPPING), getParam(Param.SMOOTHING));
			}
			catch(err : Error)
			{
				errMsg = err.message;
			}

			return errMsg;
		}

		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}

		public function get bitmap() : Bitmap
		{
			return _bitmap;
		}
	}
}
