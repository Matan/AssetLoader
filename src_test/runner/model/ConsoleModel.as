package runner.model 
{
	import runner.events.ConsoleEvent;

	import org.robotlegs.mvcs.Actor;

	/**
	 * @author Matan Uberstein
	 */
	public class ConsoleModel extends Actor 
	{
		protected var _text : String;

		public function ConsoleModel()
		{
		}

		public function append(text : String) : void
		{
			_text += text + "\n";
			dispatch(new ConsoleEvent(ConsoleEvent.APPEND_TEXT, text));
		}
		
		public function get text() : String
		{
			return _text;
		}
	}
}
