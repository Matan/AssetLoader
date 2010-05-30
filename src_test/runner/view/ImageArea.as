package runner.view 
{
	import fl.controls.ProgressBar;

	import mu.display.image.Image;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author Matan Uberstein
	 */
	public class ImageArea extends Sprite 
	{
		protected var _image : Image;
		protected var _bar : ProgressBar;
		
		protected var _bitmap : Bitmap;

		public function ImageArea()
		{
			_image = new Image();
			_image.keepProportion = false;
			addChild(_image);
			
			_bar = new ProgressBar();
			_bar.height = 10;
			addChild(_bar);
		}

		public function setSize(width : Number, height : Number) : void 
		{
			_bar.width = width;
			_image.setSize(width, height);
		}

		public function get bitmap() : Bitmap
		{
			return _bitmap;
		}

		public function set bitmap(bitmap : Bitmap) : void
		{
			_bitmap = bitmap;
			_image.bitmapData = bitmap.bitmapData;
		}
		
		public function get bar() : ProgressBar
		{
			return _bar;
		}
	}
}
