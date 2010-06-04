package runner.controller 
{
	import org.assetloader.events.BinaryAssetEvent;

	/**
	 * @author Matan Uberstein
	 */
	public class BinaryLoadedCommand extends BaseOutputCommand 
	{

		[Inject]
		public var event : BinaryAssetEvent;

		override public function execute() : void 
		{
			output(event);
		}
	}
}
