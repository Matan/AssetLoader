package runner.view 
{
	import runner.utils.StatsMonitor;

	import flash.display.Sprite;

	/**
	 * @author Matan Uberstein
	 */
	public class SWFArea extends Sprite 
	{
		protected var _width : Number;
		protected var _height : Number;

		protected var _swf : Sprite;
		protected var _statsMonitor : StatsMonitor;

		public function SWFArea()
		{
			_statsMonitor = new StatsMonitor();
			addChild(_statsMonitor);
		}

		public function setSize(width : Number, height : Number) : void 
		{
			_width = width;
			_height = height;
			
			_statsMonitor.x = width / 2 - _statsMonitor.width / 2;
			_statsMonitor.y = height / 2 - _statsMonitor.height / 2;

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
		
		public function get statsMonitor() : StatsMonitor
		{
			return _statsMonitor;
		}
	}
}
