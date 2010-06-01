/**
 * @exampleText Setting up implementation for a singleton in standard application. Try to always refer to an interface. PLEASE NOTE: This class is complete UNRELATED to the other samples.
 */
package sample
{
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.AssetLoader;

	public class SingletonSample 
	{
		protected static var _assetLoader : IAssetLoader;

		public function SingletonSample() 
		{
		}

		public static function get assetLoader() : IAssetLoader 
		{
			return (_assetLoader || _assetLoader = new AssetLoader());
		}
	}
}
