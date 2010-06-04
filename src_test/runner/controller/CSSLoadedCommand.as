package runner.controller 
{
	import org.assetloader.events.CSSAssetEvent;

	/**
	 * @author Matan Uberstein
	 */
	public class CSSLoadedCommand extends BaseOutputCommand 
	{

		[Inject]
		public var event : CSSAssetEvent;

		override public function execute() : void 
		{
			output(event);
		}
	}
}
