package runner.controller 
{
	import runner.model.ConsoleModel;

	import org.assetloader.core.IAssetLoader;
	import org.assetloader.events.GroupLoaderEvent;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class GroupLoadedCommand extends Command 
	{
		[Inject]
		public var consoleModel : ConsoleModel;

		[Inject]
		public var event : GroupLoaderEvent;
		
		[Inject]
		public var assetLoader : IAssetLoader;

		override public function execute() : void 
		{
			consoleModel.append(event.id + ": LOADED");
			consoleModel.append(String(assetLoader.getGroupLoader(event.id).loadedIds));
			consoleModel.append("---------------------------------------------------------------------------------------------------------");
		}
	}
}
