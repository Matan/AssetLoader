package runner.controller 
{
	import runner.model.AssetId;
	import runner.view.Canvas;

	import org.assetloader.base.AssetParam;
	import org.assetloader.base.AssetType;
	import org.assetloader.core.IAssetLoader;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class StartupCompleteCommand extends Command 
	{

		[Inject]
		public var loader : IAssetLoader;

		override public function execute() : void 
		{
			var host : String = "http://www.matan.co.za/AssetLoader/testAssets/";			var preventCache : AssetParam = new AssetParam(AssetParam.PREVENT_CACHE, true);
			
			loader.addLazy(AssetId.SAMPLE_TXT, host + "sampleTXT.txt", AssetType.AUTO, preventCache);
			loader.addLazy(AssetId.SAMPLE_JSON, host + "sampleJSON.json", AssetType.AUTO, preventCache);
			loader.addLazy(AssetId.SAMPLE_XML, host + "sampleXML.xml", AssetType.AUTO, preventCache);
			loader.addLazy(AssetId.SAMPLE_CSS, host + "sampleCSS.css", AssetType.AUTO, preventCache);
			loader.addLazy(AssetId.SAMPLE_BINARY, host + "sampleZIP.zip", AssetType.AUTO, preventCache);
			
			loader.addLazy(AssetId.SAMPLE_SOUND, host + "sampleSOUND.mp3", AssetType.AUTO, preventCache);

			loader.addLazy(AssetId.SAMPLE_IMAGE, host + "sampleIMAGE.jpg", AssetType.AUTO, preventCache);
			loader.addLazy(AssetId.SAMPLE_VIDEO, host + "sampleVIDEO.mp4", AssetType.AUTO, preventCache, new AssetParam(AssetParam.ON_DEMAND, true));
			loader.addLazy(AssetId.SAMPLE_SWF, host + "sampleSWF.swf", AssetType.AUTO, preventCache);
						loader.addLazy(AssetId.SAMPLE_ERROR, host + "fileThatDoesNotExist.php");
			
			contextView.addChild(new Canvas());
		}
	}
}
