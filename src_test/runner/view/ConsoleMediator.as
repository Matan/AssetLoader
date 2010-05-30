package runner.view 
{
	import runner.events.ConsoleEvent;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Matan Uberstein
	 */
	public class ConsoleMediator extends Mediator 
	{

		[Inject]
		public var view : Console;

		override public function onRegister() : void 
		{
			eventMap.mapListener(eventDispatcher, ConsoleEvent.APPEND_TEXT, appendText_handler, ConsoleEvent);
		}

		protected function appendText_handler(event : ConsoleEvent) : void 
		{
			view.append(event.text);
		}
	}
}
