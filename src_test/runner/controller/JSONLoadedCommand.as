package runner.controller 
{
	import runner.model.ConsoleModel;

	import com.adobe.serialization.json.JSON;

	import org.assetloader.events.JSONAssetEvent;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class JSONLoadedCommand extends Command 
	{

		[Inject]
		public var consoleModel : ConsoleModel;

		[Inject]
		public var event : JSONAssetEvent;

		override public function execute() : void 
		{
			consoleModel.append(event.id + ": LOADED");
			consoleModel.append(JSON.encode(event.data));
			consoleModel.append("---------------------------------------------------------------------------------------------------------");		}
	}
}
