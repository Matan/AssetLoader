package runner.controller 
{
	import org.assetloader.events.XMLAssetEvent;

	/**
	 * @author Matan Uberstein
	 */
	public class XMLLoadedCommand extends BaseOutputCommand 
	{

		[Inject]
		public var event : XMLAssetEvent;

		override public function execute() : void 
		{
			output(event);
		}
	}
}
