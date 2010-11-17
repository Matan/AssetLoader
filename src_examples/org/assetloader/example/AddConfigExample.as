package org.assetloader.example
{
	import org.assetloader.AssetLoader;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoadStats;
	import org.assetloader.core.ILoader;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * @author Matan Uberstein
	 */
	public class AddConfigExample extends Sprite
	{
		protected var _assetloader : IAssetLoader;
		protected var _field : TextField;

		public function AddConfigExample()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			initConsole();

			_assetloader = new AssetLoader();

			// Passing config as a URL.
			_assetloader.addConfig("simple-queue-config.xml");

			// Because we are passing the config as a URL, we need wait until AssetLoader fires onConfigLoaded before stating the queue.
			_assetloader.onConfigLoaded.add(onConfigLoaded_handler);

			// Add listeners
			addListenersToLoader(_assetloader);
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// HANDLERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		protected function onConfigLoaded_handler(signal : LoaderSignal) : void
		{
			// Do your clean up!
			_assetloader.onConfigLoaded.remove(onConfigLoaded_handler);

			// Start!
			_assetloader.start();
		}

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

		protected function onComplete_handler(signal : LoaderSignal, assets : Dictionary) : void
		{
			var loader : IAssetLoader = IAssetLoader(signal.loader);

			// Do your clean up!
			removeListenersFromLoader(loader);

			// Our Primary AssetLoader's stats.
			var stats : ILoadStats = loader.stats;

			append("\n[" + loader.id + "]");
			append("LOADING COMPLETE:");
			append("Total Time: " + stats.totalTime + " ms");
			append("Average Latency: " + Math.floor(stats.latency) + " ms");
			append("Average Speed: " + Math.floor(stats.averageSpeed) + " kbps");
			append("Total Bytes: " + stats.bytesTotal);
			append("");
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// ADD / REMOVE LISTENERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		protected function addListenersToLoader(loader : IAssetLoader) : void
		{
			loader.onChildOpen.add(onChildOpen_handler);
			loader.onChildError.add(onChildError_handler);
			loader.onChildComplete.add(onChildComplete_handler);

			loader.onComplete.add(onComplete_handler);
		}

		protected function removeListenersFromLoader(loader : IAssetLoader) : void
		{
			loader.onChildOpen.remove(onChildOpen_handler);
			loader.onChildError.remove(onChildError_handler);
			loader.onChildComplete.remove(onChildComplete_handler);

			loader.onComplete.remove(onComplete_handler);
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
			_field.height = stage.stageHeight;

			stage.addEventListener(Event.RESIZE, resize_handler);

			addChild(_field);
		}

		protected function append(text : String) : void
		{
			_field.appendText(text + "\n");
		}

		protected function resize_handler(event : Event) : void
		{
			_field.width = stage.stageWidth;
			_field.height = stage.stageHeight;
		}
	}
}
