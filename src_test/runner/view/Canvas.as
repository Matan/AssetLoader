package runner.view 
{
	import fl.controls.Button;
	import fl.controls.ProgressBarMode;
	import fl.controls.ProgressBar;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class Canvas extends Sprite 
	{
		protected var _image : ImageArea;
		protected var _video : VideoArea;
		protected var _swf : SWFArea;
		protected var _overallProgress : ProgressBar;
		protected var _console : Console;

		protected var _startBtn : Button;		protected var _stopBtn : Button;		protected var _destroyBtn : Button;
		public function Canvas()
		{
		}

		public function init() : void
		{
			_image = new ImageArea();
			addChild(_image);
			
			_video = new VideoArea();
			addChild(_video);
			
			_swf = new SWFArea();
			addChild(_swf);
			
			_overallProgress = new ProgressBar();
			_overallProgress.mode = ProgressBarMode.MANUAL;
			addChild(_overallProgress);
			
			_console = new Console();
			addChild(_console);
			
			_startBtn = new Button();
			_startBtn.label = "START";
			_startBtn.buttonMode = true;			addChild(_startBtn);
			
			_stopBtn = new Button();
			_stopBtn.label = "STOP";
			_stopBtn.buttonMode = true;
			addChild(_stopBtn);
			
			_destroyBtn = new Button();
			_destroyBtn.label = "DESTROY";
			_destroyBtn.buttonMode = true;
			addChild(_destroyBtn);
			
			_stopBtn.x = _startBtn.x + _stopBtn.width + 10;
			_destroyBtn.x = _stopBtn.x + _stopBtn.width + 10;
			
			stage.addEventListener(Event.RESIZE, resize_handler);
			drawNow();
		}

		public function drawNow() : void
		{
			var w : Number = stage.stageWidth;			var h : Number = stage.stageHeight;
			
			var hW : Number = w * .5;			var hH : Number = h * .5;
			
			_image.setSize(w / 3, hH - 5);
						_video.setSize(w / 3, hH - 5);
			_video.x = w / 3;
			
			_swf.setSize(w / 3, hH - 5);
			_swf.x = w / 1.5;
			
			_overallProgress.setSize(w, 10);
			_overallProgress.y = hH - 5;
						_console.setSize(w, hH - 30);
			_console.y = hH + 5;
			
			_startBtn.y = _stopBtn.y = _destroyBtn.y = h - _startBtn.height;
		}

		protected function resize_handler(event : Event) : void 
		{
			drawNow();
		}

		public function setOverallProgress(progress : Number) : void 
		{
			_overallProgress.setProgress(progress, 100);
		}

		public function get startBtn() : Button
		{
			return _startBtn;
		}
		
		public function get stopBtn() : Button
		{
			return _stopBtn;
		}
		
		public function get destroyBtn() : Button
		{
			return _destroyBtn;
		}
	}
}
