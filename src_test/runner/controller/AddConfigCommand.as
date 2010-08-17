package runner.controller 
{
	import org.assetloader.base.config.JsonConfigParser;
	import org.assetloader.core.IAssetLoader;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class AddConfigCommand extends Command 
	{
		[Inject]
		public var assetloader : IAssetLoader;
		
		override public function execute() : void 
		{
			//Use Xml
			//assetloader.addConfig("sampleXmlConfig.xml");
			
			//Use Json
			assetloader.configParserClass = JsonConfigParser;			assetloader.addConfig("sampleJsonConfig.json");
			
			//GENERATE SAMPLE JSON CONFIG
			
			/*var loader : Object = {connections:3, base:"http://www.matan.co.za/AssetLoader/testAssets/"};
			
			var group : Object = {id:"SAMPLE_GROUP", connections:0, preventCache:false};
			group.assets = [];
			group.assets.push({id:"SAMPLE_TXT", src:"sampleTXT.txt"});
			group.assets.push({id:"SAMPLE_JSON", src:"sampleJSON.json"});
			group.assets.push({id:"SAMPLE_XML", src:"sampleXML.xml"});
			group.assets.push({id:"SAMPLE_CSS", src:"sampleCSS.css"});
			group.assets.push({id:"SAMPLE_BINARY", src:"sampleZIP.zip", weight:3493});
			group.assets.push({id:"SAMPLE_SOUND", src:"sampleSOUND.mp3", weight:"213 kb"});
			
			var paramGrouping : Object = {preventCache:true};
			paramGrouping.assets = [];
			paramGrouping.assets.push({id:"SAMPLE_IMAGE", src:"sampleIMAGE.jpg", weight:"328.5 kb"});
			paramGrouping.assets.push({id:"SAMPLE_VIDEO", src:"sampleVIDEO.mp4", weight:"10 mb", onDemand:true});
			paramGrouping.assets.push({id:"SAMPLE_SWF", src:"sampleSWF.swf", weight:941410, priority:1});
			
			loader.assets = [group, paramGrouping, {id:"SAMPLE_ERROR", base:"/", src:"fileThatDoesNotExist.php", type:"image", retries:5}];
			
			trace(JSON.encode(loader));*/
		}
	}
}
