package runner.view 
{
	import fl.controls.ProgressBar;

	import flash.display.Sprite;

	/**
	 * @author Matan Uberstein
	 */
	public class SWFArea extends Sprite 
	{
		protected var _width : Number;
		protected var _height : Number;

		protected var _swf : Sprite;
		protected var _bar : ProgressBar;

		public function SWFArea()
		{
			_bar = new ProgressBar();
			_bar.height = 10;
			addChild(_bar);
		}

		public function setSize(width : Number, height : Number) : void 
		{
			_width = width;
			_height = height;

			_bar.width = _width;

			if(_swf)
			{
				_swf.width = _width;
				_swf.height = _height;
			}
		}

		public function get swf() : Sprite
		{
			return _swf;
		}

		public function set swf(swf : Sprite) : void
		{
			_swf = swf;
			
			_swf.width = _width;
			_swf.height = _height;
			
			addChildAt(_swf, 0);
		}

		public function get bar() : ProgressBar
		{
			return _bar;
		}
	}
}
