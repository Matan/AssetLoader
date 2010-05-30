package runner.controller 
{
	import runner.model.ConsoleModel;

	import org.assetloader.events.CSSAssetEvent;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class CSSLoadedCommand extends Command 
	{

		[Inject]
		public var consoleModel : ConsoleModel;

		[Inject]
		public var event : CSSAssetEvent;

		override public function execute() : void 
		{
			consoleModel.append(event.id + ": LOADED");			consoleModel.append(String(event.styleSheet));			consoleModel.append("---------------------------------------------------------------------------------------------------------");		}
	}
}
