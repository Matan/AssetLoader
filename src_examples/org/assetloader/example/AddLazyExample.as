package org.assetloader.example
{
	import org.assetloader.core.ILoadStats;

	import flash.utils.Dictionary;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextField;

	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.AssetLoader;
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	import org.assetloader.signals.LoaderSignal;

	import flash.display.Sprite;

	/**
	 * @author Matan Uberstein
	 */
	public class AddLazyExample extends Sprite
	{
		protected var _assetloader : IAssetLoader;
		protected var _field : TextField;

		public function AddLazyExample()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			initConsole();

			_assetloader = new AssetLoader();

			// Child loaders will inherit params.
			_assetloader.setParam(Param.PREVENT_CACHE, true);
			_assetloader.setParam(Param.BASE, "http://www.matanuberstein.co.za/assets/sample/");

			// Add assets to queue.
			_assetloader.addLazy('txt-asset', "sampleTXT.txt");
			_assetloader.addLazy('jsn-asset', "sampleJSON.json");
			_assetloader.addLazy('css-asset', "sampleCSS.css");
			_assetloader.addLazy('xml-asset', "sampleXML.xml");

			_assetloader.addLazy('bin-asset', "sampleZIP.zip");
			_assetloader.addLazy('snd-asset', "sampleSOUND.mp3");
			_assetloader.addLazy('img-asset', "sampleIMAGE.png");
			_assetloader.addLazy('swf-asset', "sampleSWF.swf");

			// AssetLoader returns the ILoader created once added.
			var videoLoader : ILoader = _assetloader.addLazy('vid-asset', "sampleVIDEO.flv");
			videoLoader.setParam(Param.PREVENT_CACHE, false);
			videoLoader.setParam(Param.PRIORITY, 1);

			// This is a sample error, the AssetLoader's onComplete won't fire if you uncomment this.
			// _assetloader.addLazy('err-asset', "fileThatDoesNotExist.php");

			// Add listeners
			addListenersToLoader(_assetloader);

			// Start!
			_assetloader.start();
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// HANDLERS
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
