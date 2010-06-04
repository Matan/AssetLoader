package runner.controller 
{
	import runner.model.ConsoleModel;

	import org.assetloader.events.AbstractAssetEvent;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class BaseOutputCommand extends Command
	{

		[Inject]
		public var consoleModel : ConsoleModel;

		protected function output(event : AbstractAssetEvent) : void
		{
			consoleModel.append(event.id + " : " + event.type);
			consoleModel.append(String(event));
			consoleModel.append("---------------------------------------------------------------------------------------------------------");
		}	
	}
}
