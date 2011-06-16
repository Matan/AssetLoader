package org.assetloader.example
{
	import org.assetloader.AssetLoader;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.utils.ALLogger;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * @author Matan Uberstein
	 */
	public class ALLoggerExample extends Sprite
	{
		// --- Controls ---//
		protected var _btns : Array = [];
		// ----------------//

		protected var _assetloader : IAssetLoader;
		protected var _field : TextField;
		protected var _logger : ALLogger;

		public function ALLoggerExample()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			initControls();
			initConsole();

			_assetloader = new AssetLoader("pr-group");

			// AssetLoader Logger, will output trace statements.
			_logger = new ALLogger();
			_logger.onLog.add(append);

			// Sample swapping out of indent char.
			_logger.indentChar = "--> ";
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// HANDLERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		protected function load_click_handler(event : MouseEvent) : void
		{
			append("//------------------------------------------------------------------------------//");
			append("USER COMMAND: Load Config");

			_assetloader.onConfigLoaded.addOnce(onConfigLoaded_handler);
			_assetloader.addConfig("complex-queue-config.xml");
		}

		protected function start_click_handler(event : MouseEvent) : void
		{
			append("//------------------------------------------------------------------------------//");
			append("USER COMMAND: Start Loading");
			append("//------------------------------------------------------------------------------//");

			_assetloader.start();
		}

		protected function attach_click_handler(event : MouseEvent) : void
		{
			var field : TextField = event.currentTarget.getChildByName("field");
			var verbosity : int = int(TextField(getChildByName("attVInput")).text);
			var recursion : int = int(TextField(getChildByName("attRInput")).text);
			append("//------------------------------------------------------------------------------//");
			if(field.text == "Attach Logger ")
			{
				field.text = "Detach Logger";
				_logger.attach(_assetloader, verbosity, recursion);
				append("USER COMMAND: Attach Logger | verbosity=" + verbosity + " | recursion=" + recursion);
			}
			else
			{
				field.text = "Attach Logger ";
				_logger.detach(_assetloader, verbosity, recursion);
				append("USER COMMAND: Detach Logger | verbosity=" + verbosity + " | recursion=" + recursion);
			}
			append("//------------------------------------------------------------------------------//");
		}

		protected function explode_click_handler(event : MouseEvent) : void
		{
			var verbosity : int = int(TextField(getChildByName("expVInput")).text);
			var recursion : int = int(TextField(getChildByName("expRInput")).text);

			append("//------------------------------------------------------------------------------//");
			append("USER COMMAND: Explode | verbosity=" + verbosity + " | recursion=" + recursion);
			append("//------------------------------------------------------------------------------//");

			_logger.explode(_assetloader, verbosity, recursion);
		}

		protected function expStats_click_handler(event : MouseEvent) : void
		{
			var recursion : int = int(TextField(getChildByName("stsRInput")).text);

			append("//------------------------------------------------------------------------------//");
			append("USER COMMAND: Explode | recursion=" + recursion);
			append("//------------------------------------------------------------------------------//");

			_logger.explodeStats(_assetloader, recursion);
		}

		protected function clear_click_handler(event:MouseEvent) : void
		{
			_field.text = "";
		}

		protected function onConfigLoaded_handler(signal : LoaderSignal) : void
		{
			append("... Config Loaded");
			append("//------------------------------------------------------------------------------//");
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// CONTROLS
		// --------------------------------------------------------------------------------------------------------------------------------//
		protected function initControls() : void
		{
			addButton("Load Config", load_click_handler);
			addButton("Start Loading", start_click_handler);
			addButton("Attach Logger ", attach_click_handler);
			addInputs("att", 0, -1);
			addButton("Explode", explode_click_handler);
			addInputs("exp", 0, -1);
			addButton("Explode Stats", expStats_click_handler);
			addInputs("sts", 0, -1);
			addButton("Clear Console", clear_click_handler);

			removeChild(getChildByName("stsVInput"));
		}

		protected function addButton(label : String, clickHandler : Function) : Sprite
		{
			var field : TextField = new TextField();
			field.defaultTextFormat = new TextFormat("Arial", 12, 0xFFFFFF, true);
			field.autoSize = TextFieldAutoSize.LEFT;
			field.x = 4;
			field.y = 4;
			field.name = "field";
			field.mouseEnabled = false;
			field.text = label;

			var btn : Sprite = new Sprite();
			var pBtn : Sprite = _btns[_btns.length - 1];
			if(pBtn)
				btn.x = pBtn.x + pBtn.width + 6;
			with(btn.graphics)
			{
				beginFill(0x333333);
				drawRoundRect(0, 0, field.width + 8, field.height + 8, 3);
			}
			btn.buttonMode = true;
			btn.filters = [new BevelFilter(2, 45, 0xFFFFFF, .6, 0, .2, 5, 5, 1, 3), new DropShadowFilter(2, 45, 0, .3, 5, 5, 1, 3)];
			btn.addEventListener(MouseEvent.CLICK, clickHandler);
			btn.addChild(field);
			_btns.push(btn);
			addChild(btn);

			return btn;
		}

		protected function addInputs(prefix : String, valueV : int, valueR : int) : void
		{
			var btn : Sprite = _btns[_btns.length - 1];
			if(btn)
			{
				createInput(prefix + "V", valueV, btn.x, (btn.width / 2) - 4);
				createInput(prefix + "R", valueR, btn.x + (btn.width / 2) + 2, (btn.width / 2) - 4);
			}
		}

		protected function createInput(prefix : String, value : int, x : Number, width : Number) : void
		{
			var input : TextField = new TextField();
			input.defaultTextFormat = new TextFormat("Courier New", 12, null, null, null, null, null, null, "center");
			input.border = true;
			input.type = TextFieldType.INPUT;
			input.x = x;
			input.y = 32;
			input.width = width;
			input.height = 18;
			input.restrict = "\-0-4";
			input.maxChars = 2;
			input.name = prefix + "Input";
			input.text = String(value);
			addChild(input);
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
			_field.y = 60;
			_field.width = stage.stageWidth;
			_field.height = stage.stageHeight - 60;

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
			_field.height = stage.stageHeight - 60;
		}
	}
}
