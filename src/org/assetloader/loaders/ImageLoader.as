package org.assetloader.loaders 
{
	import flash.display.Bitmap;

	import org.assetloader.base.AssetParam;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;

	/**
	 * @author Matan Uberstein
	 */
	public class ImageLoader extends DisplayObjectLoader 
	{
		public function ImageLoader()
		{
		}

		override protected function testData(data : DisplayObject) : String 
		{
			var errMsg : String = "";
			try
			{
				var bitmapData : BitmapData = new BitmapData(_loader.contentLoaderInfo.width, _loader.contentLoaderInfo.height, _loadUnit.getParam(AssetParam.TRANSPARENT), loadUnit.getParam(AssetParam.FILL_COLOR));
				bitmapData.draw(data, _loadUnit.getParam(AssetParam.MATRIX), _loadUnit.getParam(AssetParam.COLOR_TRANSFROM), _loadUnit.getParam(AssetParam.BLEND_MODE), _loadUnit.getParam(AssetParam.CLIP_RECTANGLE), _loadUnit.getParam(AssetParam.SMOOTHING));
				
				_data = new Bitmap(bitmapData, _loadUnit.getParam(AssetParam.PIXEL_SNAPPING), _loadUnit.getParam(AssetParam.SMOOTHING));
			}
			catch(err : Error)
			{
				errMsg = err.message;
			}
			
			return errMsg;
		}
	}
}
