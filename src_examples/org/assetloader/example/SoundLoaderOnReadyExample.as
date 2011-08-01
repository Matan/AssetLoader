package org.assetloader.example
{
	import flash.media.Sound;

	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.loaders.SoundLoader;
	import org.assetloader.AssetLoader;
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.utils.ALLogger;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Matan Uberstein
	 */
	public class SoundLoaderOnReadyExample extends Sprite
	{
		protected var _assetloader : IAssetLoader;
		protected var _field : TextField;
		protected var _logger : ALLogger;

		public function SoundLoaderOnReadyExample()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			initConsole();

			_assetloader = new AssetLoader("pr-group");

			_assetloader.setParam(Param.BASE, "http://www.matan.co.za/AudioMixer/");
			//_assetloader.setParam(Param.PREVENT_CACHE, true);

			var sndLoader : SoundLoader = SoundLoader(_assetloader.addLazy("sn-asset", "AquoVisit.mp3"));
			sndLoader.onReady.add(snd_onReady_handler);

			// AssetLoader Logger, will output trace statements.
			_logger = new ALLogger();
			_logger.attach(_assetloader, 2);
			_logger.onLog.add(append);

			// Sample swapping out of indent char.
			_logger.indentChar = "--> ";
			
			_assetloader.start();
		}

		protected function snd_onReady_handler(signal : LoaderSignal, sound : Sound) : void
		{
			append("READY!!!");
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
