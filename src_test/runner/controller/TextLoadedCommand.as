package runner.controller 
{
	import org.assetloader.events.TextAssetEvent;

	import runner.model.ConsoleModel;

	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class TextLoadedCommand extends Command 
	{

		[Inject]
		public var consoleModel : ConsoleModel;

		[Inject]
		public var event : TextAssetEvent;

		override public function execute() : void 
		{
			consoleModel.append(event.id + ": LOADED");			consoleModel.append(event.data);			consoleModel.append("---------------------------------------------------------------------------------------------------------");		}
	}
}
