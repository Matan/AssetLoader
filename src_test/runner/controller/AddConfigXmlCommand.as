package runner.controller 
{
	import org.assetloader.core.IAssetLoader;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class AddConfigXmlCommand extends Command 
	{
		[Inject]
		public var assetloader : IAssetLoader;
		
		override public function execute() : void 
		{
			assetloader.addConfig("sampleXmlConfig.xml");
		}
	}
}
