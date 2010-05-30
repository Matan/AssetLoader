package  
runner.view
{
	import fl.controls.TextArea;

	import flash.display.Sprite;
	import flash.text.TextFormat;

	/**
	 * @author Matan Uberstein
	 */
	public class Console extends Sprite 
	{
		protected var _area : TextArea;

		public function Console()
		{
			_area = new TextArea();
			_area.textField.multiline = true;			_area.textField.wordWrap = true;
			_area.textField.defaultTextFormat = new TextFormat("courier new");
			addChild(_area);
		}

		public function setSize(width : Number, height : Number) : void 
		{
			_area.setSize(width, height);
		}

		public function set text(value : String) : void 
		{
			_area.text = value;
		}

		public function append(text : String) : void 
		{
			_area.appendText(text + "\n");
			_area.textField.scrollV = _area.textField.numLines;
		}
	}
}
