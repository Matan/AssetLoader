package runner.controller 
{
	import org.assetloader.events.JSONAssetEvent;

	/**
	 * @author Matan Uberstein
	 */
	public class JSONLoadedCommand extends BaseOutputCommand 
	{

		[Inject]
		public var event : JSONAssetEvent;

		override public function execute() : void 
		{
			output(event);
		}
	}
}
