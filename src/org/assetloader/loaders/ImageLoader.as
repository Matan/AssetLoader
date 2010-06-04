package org.assetloader.loaders 
{
	import flash.display.Bitmap;

	import org.assetloader.base.Param;

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
				var bitmapData : BitmapData = new BitmapData(_loader.contentLoaderInfo.width, _loader.contentLoaderInfo.height, _unit.getParam(Param.TRANSPARENT), _unit.getParam(Param.FILL_COLOR));
				bitmapData.draw(data, _unit.getParam(Param.MATRIX), _unit.getParam(Param.COLOR_TRANSFROM), _unit.getParam(Param.BLEND_MODE), _unit.getParam(Param.CLIP_RECTANGLE), _unit.getParam(Param.SMOOTHING));
				
				_data = new Bitmap(bitmapData, _unit.getParam(Param.PIXEL_SNAPPING), _unit.getParam(Param.SMOOTHING));
			}
			catch(err : Error)
			{
				errMsg = err.message;
			}
			
			return errMsg;
		}
	}
}
