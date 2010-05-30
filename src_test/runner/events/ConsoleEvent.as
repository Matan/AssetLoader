package runner.events 
{
	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class ConsoleEvent extends Event 
	{
		public static const APPEND_TEXT : String = "APPEND_TEXT";

		public var text : String;

		public function ConsoleEvent(type : String, text : String = "")
		{
			super(type);
			this.text = text;
		}
	}
}
