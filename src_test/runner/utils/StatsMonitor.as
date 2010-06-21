package runner.utils 
{
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoadStats;
	import org.assetloader.core.ILoader;
	import org.assetloader.events.AssetLoaderEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;

	/**
	 * @author Matan Uberstein
	 */
	public class StatsMonitor extends Sprite 
	{

		protected var _field : TextField;
		protected var _bar : Sprite;		protected var _bg : Sprite;

		protected var _width : Number = 150;
		protected var _loader : ILoader;

		public function StatsMonitor()
		{
			_bg = new Sprite();
			addChild(_bg);
			
			_bar = new Sprite();
			_bar.graphics.beginFill(0xFF0000, .5);
			_bar.graphics.drawRect(0, 0, 10, 10);
			_bar.width = 0;
			_bar.mouseEnabled = false;
			_bar.x = 5;
			addChild(_bar);
			
			_field = new TextField();
			_field.wordWrap = false;
			_field.multiline = true;
			_field.selectable = false;
			_field.mouseEnabled = false;
			_field.text = getStatText();
			_field.width = width;
			_field.x = 5;
			_field.y = 5;
			addChild(_field);
			
			_bar.y = _field.y + _field.height;
			
			_bg.graphics.lineStyle(1, 0xCCCCCC);
			_bg.graphics.beginFill(0xEEEEEE, .7);
			_bg.graphics.drawRoundRect(0, 0, width + 10, _bar.y + _bar.height + 10, 15, 15);
			
			mouseEnabled = false;
			mouseChildren = false;
		}

		public function attach(loader : ILoader) : void 
		{
			if(_loader)
				removeListeners(_loader);
			_loader = loader;
			
			addListeners(_loader);
			
			update();
		}

		protected function addListeners(loader : ILoader) : void 
		{
			if(loader is IAssetLoader)
			{
				loader.addEventListener(AssetLoaderEvent.PROGRESS, update);				loader.addEventListener(AssetLoaderEvent.COMPLETE, update);
			}
			else 
			{
				loader.addEventListener(ProgressEvent.PROGRESS, update);
				loader.addEventListener(Event.COMPLETE, update);
			}
		}

		protected function removeListeners(loader : ILoader) : void 
		{
			if(loader is IAssetLoader)
			{
				loader.removeEventListener(AssetLoaderEvent.PROGRESS, update);				loader.removeEventListener(AssetLoaderEvent.COMPLETE, update);
			}
			else 
			{
				loader.removeEventListener(ProgressEvent.PROGRESS, update);				loader.removeEventListener(Event.COMPLETE, update);
			}
		}

		protected function update(event : Event = null) : void 
		{
			_field.text = getStatText();
			
			_bar.width = _width * (_loader.stats.progress / 100);
		}

		protected function getStatText() : String
		{
			if(!_loader)
				return "PENDING ATTACHMENT\n\n\n\n\n\n\n";
			
			var stats : ILoadStats = _loader.stats;
			var txt : String = "ID: " + _loader.unit.id + "\n";
			txt += "Latency: " + Math.floor(stats.latency) + " milliseconds\n";			txt += "Speed: " + Math.floor(stats.speed) + " kb/s\n";
			txt += "Average Speed: " + Math.floor(stats.averageSpeed) + " kb/s\n";
			txt += "Progress: " + Math.floor(stats.progress) + "%\n";
			txt += "Bytes Loaded: " + Math.floor(stats.bytesLoaded) + "\n";
			txt += "Bytes Total: " + Math.floor(stats.bytesTotal) + "\n";
			return txt;
		}

		public function setSize(width : Number, height : Number) : void 
		{
			this.width = width;
			this.height = height;
		}

		override public function get width() : Number
		{
			return _width;
		}

		override public function set width(width : Number) : void
		{
			_width = width;
			
			_field.width = _width;
			
			if(_loader)
				_bar.width = _width * (_loader.stats.progress / 100);
			
			_bg.graphics.clear();
			_bg.graphics.lineStyle(1, 0xCCCCCC);
			_bg.graphics.beginFill(0xEEEEEE, .7);
			_bg.graphics.drawRoundRect(0, 0, width + 10, _bar.y + _bar.height + 10, 15, 15);
		}
	}
}
