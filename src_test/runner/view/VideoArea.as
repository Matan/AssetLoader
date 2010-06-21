package runner.view 
{
	import fl.controls.Button;

	import runner.utils.StatsMonitor;

	import flash.display.Sprite;
	import flash.media.Video;
	import flash.net.NetStream;

	/**
	 * @author Matan Uberstein
	 */
	public class VideoArea extends Sprite 
	{
		protected var _video : Video;
		protected var _startBtn : Button;
		protected var _netStream : NetStream;
		protected var _statsMonitor : StatsMonitor;

		public function VideoArea()
		{
			_video = new Video();
			addChild(_video);
			
			_statsMonitor = new StatsMonitor();
			addChild(_statsMonitor);
			
			_startBtn = new Button();
			_startBtn.label = "START ME!";
			addChild(_startBtn);
		}

		public function setSize(width : Number, height : Number) : void 
		{
			_statsMonitor.x = width / 2 - _statsMonitor.width / 2;
			_statsMonitor.y = height / 2 - _statsMonitor.height / 2;
			
			_video.width = width;
			_video.height = height;
			
			_startBtn.x = width / 2 - _startBtn.width / 2;			_startBtn.y = _statsMonitor.y + _statsMonitor.height + 5;
		}

		public function set netStream(netStream : NetStream) : void
		{
			_netStream = netStream;
			_netStream.resume();
			_video.attachNetStream(_netStream);
		}

		public function get startBtn() : Button
		{
			return _startBtn;
		}
		
		public function get statsMonitor() : StatsMonitor
		{
			return _statsMonitor;
		}
	}
}
