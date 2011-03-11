package org.assetloader.example
{
	import flash.display.BlendMode;
	import flash.text.TextFieldAutoSize;

	import org.assetloader.AssetLoader;
	import org.assetloader.base.Param;
	import org.assetloader.base.StatsMonitor;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoadStats;
	import org.assetloader.core.ILoader;
	import org.assetloader.core.IParam;
	import org.assetloader.loaders.SWFLoader;
	import org.assetloader.loaders.VideoLoader;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.signals.ProgressSignal;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Matan Uberstein
	 */
	public class StatsMonitorExample extends Sprite
	{
		protected var _monitor : StatsMonitor;

		protected var _field : TextField;

		protected var _progressField : TextField;
		protected var _progressBar : Sprite;

		public function StatsMonitorExample()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			initConsole();

			append("In the example we are using the StatsMonitor to consolidate");
			append("multiple loader's stats. These loaders are completely unrelated,");
			append("thus an approach like this makes it easy to see the overall progress");
			append("without adding all the assets into a parent IAssetLoader.");
			append("");

			// Common Params
			var base : IParam = new Param(Param.BASE, "http://doesflash.com/assets/sample/");
			var noCache : IParam = new Param(Param.PREVENT_CACHE, true);

			var group : IAssetLoader = new AssetLoader("group");
			group.addParam(base);
			group.addParam(noCache);

			// Add assets to queue.
			group.addLazy('vid-flv', "sampleVIDEO.flv").setParam(Param.WEIGHT, 315392);
			group.addLazy('vid-mp4', "sampleVIDEO.mp4").setParam(Param.WEIGHT, 10035200);

			// Create VideoLoader seperate from group1
			var video : ILoader = new VideoLoader(new URLRequest("sampleVIDEO.mp4"), "video");
			video.addParam(base);
			video.addParam(noCache);
			video.setParam(Param.WEIGHT, 10035200);

			// Create SWFLoader seperate from group1
			var movie : ILoader = new SWFLoader(new URLRequest("sampleSWF2.swf"), "movie");
			movie.addParam(base);
			movie.addParam(noCache);
			movie.setParam(Param.WEIGHT, 942080);

			// Add listeners
			addListenersToLoader(group);
			addListenersToLoader(video);
			addListenersToLoader(movie);

			// Create StatsMonitor and add the loaders.
			_monitor = new StatsMonitor();
			_monitor.add(group);
			_monitor.add(video);
			_monitor.add(movie);

			// Add listeners to monitor like you would add listeners to a loader.
			_monitor.onProgress.add(monitor_onProgress_handler);
			_monitor.onComplete.add(monitor_onComplete_handler);

			// Start the groups
			group.start();
			video.start();
			movie.start();
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// CHILD HANDLERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		protected function onChildOpen_handler(signal : LoaderSignal, child : ILoader) : void
		{
			append("[" + signal.loader.id + "]\t[" + child.id + "]\t\topened  \tLatency\t: " + Math.floor(child.stats.latency) + "\tms");
		}

		protected function onChildError_handler(signal : ErrorSignal, child : ILoader) : void
		{
			append("[" + signal.loader.id + "]\t[" + child.id + "]\t\terror  \tType\t: " + signal.type + " | Message: " + signal.message);
		}

		protected function onChildComplete_handler(signal : LoaderSignal, child : ILoader) : void
		{
			append("[" + signal.loader.id + "]\t[" + child.id + "]\t\tcomplete\tSpeed\t: " + Math.floor(child.stats.averageSpeed) + "\tkbps");
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// STANDARD HANDLERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		protected function onOpen_handler(signal : LoaderSignal) : void
		{
			append("[" + signal.loader.id + "]\t\t         \topened  \tLatency\t: " + Math.floor(signal.loader.stats.latency) + "\tms");
		}

		protected function onError_handler(signal : ErrorSignal) : void
		{
			append("[" + signal.loader.id + "]\t\t         \terror  \tType\t: " + signal.type + " | Message: " + signal.message);
		}

		protected function onComplete_handler(signal : LoaderSignal, payload : *) : void
		{
			var loader : ILoader = signal.loader;

			// Do your clean up!
			removeListenersFromLoader(loader);

			dumpStats(loader.id, loader.stats);
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// MONITOR HANDLERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		protected function monitor_onProgress_handler(signal : ProgressSignal) : void
		{
			_progressBar.width = (signal.progress * stage.stageWidth) / 100;

			_progressField.text = Math.ceil(signal.progress) + "% | " + Math.ceil(signal.bytesLoaded / 1024 / 1024) + " mb of " + Math.ceil(signal.bytesTotal / 1024 / 1024) + " mb";
		}

		protected function monitor_onComplete_handler(signal : LoaderSignal, stats : ILoadStats) : void
		{
			dumpStats("MONITOR", stats);
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// ADD / REMOVE LISTENERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		protected function addListenersToLoader(loader : ILoader) : void
		{
			if(loader is IAssetLoader)
			{
				var group : IAssetLoader = IAssetLoader(loader);
				group.onChildOpen.add(onChildOpen_handler);
				group.onChildError.add(onChildError_handler);
				group.onChildComplete.add(onChildComplete_handler);
			}
			else
				loader.onOpen.add(onOpen_handler);

			loader.onComplete.add(onComplete_handler);
			loader.onError.add(onError_handler);
		}

		protected function removeListenersFromLoader(loader : ILoader) : void
		{
			if(loader is IAssetLoader)
			{
				var group : IAssetLoader = IAssetLoader(loader);
				group.onChildOpen.remove(onChildOpen_handler);
				group.onChildError.remove(onChildError_handler);
				group.onChildComplete.remove(onChildComplete_handler);
			}
			else
				loader.onOpen.remove(onOpen_handler);
				
			loader.onComplete.remove(onComplete_handler);
			loader.onError.remove(onError_handler);
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// CONSOLE
		// --------------------------------------------------------------------------------------------------------------------------------//
		protected function initConsole() : void
		{
			_field = new TextField();
			_field.defaultTextFormat = new TextFormat("Courier New", 12);
			_field.multiline = true;
			_field.selectable = true;
			_field.wordWrap = false;
			_field.width = stage.stageWidth;
			_field.height = stage.stageHeight - 20;
			_field.y = 20;

			stage.addEventListener(Event.RESIZE, resize_handler);

			addChild(_field);

			_progressBar = new Sprite();
			_progressBar.graphics.beginFill(0x000000);
			_progressBar.graphics.drawRect(0, 0, 20, 20);
			_progressBar.width = 0;

			addChild(_progressBar);

			_progressField = new TextField();
			_progressField.defaultTextFormat = new TextFormat("Courier New", 12, 0xFFFFFF);
			_progressField.autoSize = TextFieldAutoSize.LEFT;
			_progressField.multiline = false;
			_progressField.selectable = true;
			_progressField.wordWrap = false;
			_progressField.blendMode = BlendMode.INVERT;

			addChild(_progressField);
		}

		protected function append(text : String) : void
		{
			_field.appendText(text + "\n");
		}

		protected function dumpStats(id : String, stats : ILoadStats) : void
		{
			append("\n[" + id + "]");
			append("LOADING COMPLETE:");
			append("Total Time:\t\t\t" + stats.totalTime + " ms");
			append("Average Latency:\t" + Math.floor(stats.latency) + " ms");
			append("Average Speed:\t\t" + Math.floor(stats.averageSpeed) + " kbps");
			append("Total MegaBytes:\t" + Math.ceil(stats.bytesTotal / 1024 / 1024) + " mb");
			append("");
		}

		protected function resize_handler(event : Event) : void
		{
			_field.width = stage.stageWidth;
			_field.height = stage.stageHeight - 20;
		}
	}
}
