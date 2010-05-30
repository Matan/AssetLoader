package runner.controller 
{
	import runner.model.ConsoleModel;

	import org.assetloader.events.AssetLoaderEvent;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class LoaderErrorCommand extends Command 
	{

		[Inject]
		public var consoleModel : ConsoleModel;

		[Inject]
		public var event : AssetLoaderEvent;

		override public function execute() : void 
		{
			consoleModel.append(event.id + " : " + event.errorType + " : " + event.errorText);
		}
	}
}
