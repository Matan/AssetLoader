/**
 * @exampleText This example shows you the different ways to add parameters to your assets.
 */
package sample 
{
	import org.assetloader.AssetLoader;
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoadUnit;
	import org.assetloader.core.IParam;

	import flash.display.BlendMode;
	import flash.display.Sprite;

	public class AddingAssetParamsSample extends Sprite
	{
		protected var _assetLoader : IAssetLoader;

		public function AddingAssetParamsSample() 
		{
			var preventCaching : IParam = new Param(Param.PREVENT_CACHE, true);
			
			//Image params
			var fillColor : IParam = new Param(Param.FILL_COLOR, 0x0);			var smoothing : IParam = new Param(Param.SMOOTHING, true);			var blendMode : IParam = new Param(Param.BLEND_MODE, BlendMode.DARKEN);
			
			var host : String = "http://www.matan.co.za/AssetLoader/testAssets/";
			
			//Recommendation: Create a class with static constants for the asset ids.
			assetLoader.addLazy("sampleXML", host + "sampleXML.xml", AssetType.AUTO, preventCaching);
			assetLoader.addLazy("sampleIMAGE1", host + "sampleIMAGE.jpg", AssetType.AUTO, fillColor, smoothing, blendMode);
			
			//OR can be added via an Array.
			var imageParams : Array = [fillColor, smoothing, blendMode];			assetLoader.addLazy("sampleIMAGE2", host + "sampleIMAGE.jpg", AssetType.AUTO, imageParams);			
			//OR BOTH - Note passing an Array containing IAssetParam instances will have the same effect.
			assetLoader.addLazy("sampleIMAGE3", host + "sampleIMAGE.jpg", AssetType.AUTO, imageParams, preventCaching);			
			//OR after you've added it. NOTE: Must be before assetLoader.start is called.
			assetLoader.addLazy("sampleIMAGE4", host + "sampleIMAGE.jpg");
			var image4LoadUnit : ILoadUnit = assetLoader.getUnit("sampleIMAGE4");
			image4LoadUnit.setParam(Param.FILL_COLOR, 0x0);			image4LoadUnit.setParam(Param.SMOOTHING, true);			image4LoadUnit.setParam(Param.BLEND_MODE, BlendMode.DARKEN);
			//This way excules AssetParam.PREVENT_CACHE it needs to process on creation.
			
			assetLoader.start();
		}

		public function get assetLoader() : IAssetLoader 
		{
			return (_assetLoader || _assetLoader = new AssetLoader());
		}
	}
}
