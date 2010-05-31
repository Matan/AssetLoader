/**
 * @exampleText Setting up implementation for a standard application. Try to always refer to an interface. PLEASE NOTE: This class is complete UNRELATED to the other samples.
 */
package sample
{
	import org.assetloader.AssetLoader;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.events.AssetLoaderEvent;
	import org.assetloader.events.CSSAssetEvent;
	import org.assetloader.events.XMLAssetEvent;

	import flash.display.Sprite;

	public class StandardSample extends Sprite
	{
		protected var _assetLoader : IAssetLoader;

		public function StandardSample() 
		{
			var host : String = "http://www.matan.co.za/AssetLoader/testAssets/";
			
			//Recommendation: Create a class with static constants for the asset ids.
			assetLoader.addLazy("sampleXML", host + "sampleXML.xml");
			assetLoader.addLazy("sampleCSS", host + "sampleCSS.css");
			
			assetLoader.addEventListener(AssetLoaderEvent.ERROR, assetLoader_error_handler);			assetLoader.addEventListener(AssetLoaderEvent.CONNECTION_OPENED, assetLoader_connectionOpened_handler);			assetLoader.addEventListener(AssetLoaderEvent.PROGRESS, assetLoader_progress_handler);			assetLoader.addEventListener(AssetLoaderEvent.ASSET_LOADED, assetLoader_assetLoaded_handler);			assetLoader.addEventListener(AssetLoaderEvent.COMPLETE, assetLoader_complete_handler);
						assetLoader.addEventListener(XMLAssetEvent.LOADED, assetLoader_xmlLoaded_handler);			assetLoader.addEventListener(CSSAssetEvent.LOADED, assetLoader_cssLoaded_handler);
			
			assetLoader.start();
		}

		protected function assetLoader_error_handler(event : AssetLoaderEvent) : void 
		{
			//Fire when an asset fails after set amount of retries
			trace("AssetLoaderEvent: " + event.type + " : " + event.id + " : " + event.errorType + " : " + event.errorText);
		}

		protected function assetLoader_connectionOpened_handler(event : AssetLoaderEvent) : void 
		{
			//When server responds to connection
			trace("AssetLoaderEvent: " + event.type + " : " + event.id);
		}

		protected function assetLoader_progress_handler(event : AssetLoaderEvent) : void 
		{
			//Overall progress
			trace("AssetLoaderEvent: " + event.type + " : " + event.progress);
		}

		protected function assetLoader_assetLoaded_handler(event : AssetLoaderEvent) : void 
		{
			//Using this event give you weak data type reference
			trace("AssetLoaderEvent: " + event.type + " : " + event.id + " : " + event.data);
		}

		protected function assetLoader_complete_handler(event : AssetLoaderEvent) : void 
		{
			//When all assets are loaded
			trace("AssetLoaderEvent: " + event.type + " : " + event.data);
		}

		protected function assetLoader_xmlLoaded_handler(event : XMLAssetEvent) : void 
		{
			//Strongly typed xml property
			trace("XMLAssetEvent: " + event.type + " : " + event.id + " : " + event.xml);
		}

		protected function assetLoader_cssLoaded_handler(event : CSSAssetEvent) : void 
		{
			//Strongly typed stylesheet property
			trace("CSSAssetEvent: " + event.type + " : " + event.id + " : " + event.styleSheet);
		}

		public function get assetLoader() : IAssetLoader 
		{
			return (_assetLoader || _assetLoader = new AssetLoader());
		}
	}
}
