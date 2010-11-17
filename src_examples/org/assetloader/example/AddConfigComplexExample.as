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
	public class AddConfigComplexExample extends Sprite
	{
		protected var _assetloader : IAssetLoader;
		protected var _field : TextField;

		public function AddConfigComplexExample()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			initConsole();

			// Just for the output's sake, We are giving our 'primary-loader' a shorther id that matches with the other groups
			_assetloader = new AssetLoader("pr-group");

			// Passing config as a URL.
			_assetloader.addConfig("complex-queue-config.xml");

			// Because we are passing the config as a URL, we need wait until AssetLoader fires onConfigLoaded before stating the queue.
			_assetloader.onConfigLoaded.add(onConfigLoaded_handler);
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// HANDLERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		protected function onConfigLoaded_handler(signal : LoaderSignal) : void
		{
			// Do your clean up!
			_assetloader.onConfigLoaded.remove(onConfigLoaded_handler);

			// Before we start, lets add the listener to the child group loaders.
			var group1 : IAssetLoader = IAssetLoader(_assetloader.getLoader('group-01'));
			addListenersToLoader(group1);

			// group-02 is nested inside group1.
			var group2 : IAssetLoader = IAssetLoader(group1.getLoader('group-02'));
			addListenersToLoader(group2);

			// Add Listener to our Primary Loader
			addListenersToLoader(_assetloader);

			// Now Start the queue!
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

			// Our AssetLoader's stats.
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
			loader.onChildOpen.add(onChildOpen_handler);
			loader.onChildError.add(onChildError_handler);
			loader.onChildComplete.add(onChildComplete_handler);

			loader.onComplete.add(onComplete_handler);
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
