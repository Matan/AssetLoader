package runner.controller 
{
	import org.assetloader.events.TextAssetEvent;

	/**
	 * @author Matan Uberstein
	 */
	public class TextLoadedCommand extends BaseOutputCommand 
	{

		[Inject]
		public var event : TextAssetEvent;

		override public function execute() : void 
		{
			output(event);
		}
	}
}
