package runner.view 
{
	import flash.net.NetStream;

	import fl.controls.ProgressBar;

	import flash.media.Video;
	import flash.display.Sprite;

	/**
	 * @author Matan Uberstein
	 */
	public class VideoArea extends Sprite 
	{
		protected var _video : Video;
		protected var _bar : ProgressBar;
		protected var _netStream : NetStream;

		public function VideoArea()
		{
			_video = new Video();
			addChild(_video);
			
			_bar = new ProgressBar();
			_bar.height = 10;
			addChild(_bar);
		}

		public function setSize(width : Number, height : Number) : void 
		{
			_bar.width = width;
			
			_video.width = width;
			_video.height = height;
		}

		public function get bar() : ProgressBar
		{
			return _bar;
		}

		public function set netStream(netStream : NetStream) : void
		{
			_netStream = netStream;
			_netStream.resume();
			_video.attachNetStream(_netStream);
		}
	}
}
