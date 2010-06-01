package org.assetloader.base 
{

	/**
	 * AssetLoader errors.
	 * 
	 * @author Matan Uberstein
	 */
	public class AssetLoaderError extends Error 
	{
		public static const INVALID_URL : String = "Asset's url is invalid.";
		public static const ASSET_TYPE_NOT_RECOGNIZED : String = "Asset type not recognized. Try an asset type found on org.assetloader.base.AssetType .";
		public static const ASSET_AUTO_TYPE_NOT_FOUND : String = "Could not determine asset's type automatically. Please set the asset's type.";

		public function AssetLoaderError(message : * = "", id : * = 0)
		{
			super("[AssetLoaderError] " + message, id);
		}
	}
}
