package runner.view 
{
	import mu.display.image.Image;

	import runner.utils.StatsMonitor;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author Matan Uberstein
	 */
	public class ImageArea extends Sprite 
	{
		protected var _image : Image;
		protected var _statsMonitor : StatsMonitor;

		protected var _bitmap : Bitmap;

		public function ImageArea()
		{
			_image = new Image();
			_image.keepProportion = false;
			addChild(_image);
			
			_statsMonitor = new StatsMonitor();
			addChild(_statsMonitor);
		}

		public function setSize(width : Number, height : Number) : void 
		{
			_image.setSize(width, height);
			_statsMonitor.x = width / 2 - _statsMonitor.width / 2;			_statsMonitor.y = height / 2 - _statsMonitor.height / 2;
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

		public function get statsMonitor() : StatsMonitor
		{
			return _statsMonitor;
		}
	}
}
