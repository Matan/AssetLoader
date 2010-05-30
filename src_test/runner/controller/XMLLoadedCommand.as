package runner.controller 
{
	import runner.model.ConsoleModel;

	import org.assetloader.events.XMLAssetEvent;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class XMLLoadedCommand extends Command 
	{

		[Inject]
		public var consoleModel : ConsoleModel;

		[Inject]
		public var event : XMLAssetEvent;

		override public function execute() : void 
		{
			consoleModel.append(event.id + ": LOADED");			consoleModel.append(event.xml);			consoleModel.append("---------------------------------------------------------------------------------------------------------");		}
	}
}
