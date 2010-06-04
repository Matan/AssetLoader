package org.assetloader.core 
{

	/**
	 * @author Matan Uberstein
	 */
	public interface ILoadGroup extends ILoadUnit
	{
		/**
		 * Checks if ALL ILoadUnit has a param with the passed id.
		 * 
		 * @param id String param id.
		 * @return Boolean
		 * 
		 * @see org.assetload.core.IAssetParam
		 * @see org.assetload.base.AssetParam
		 */
		function hasGlobalParam(id : String) : Boolean

		/**
		 * Sets ALL ILoadUnit's param value.
		 * 
		 * @param id String, param id.
		 * @param value Parameter value.
		 * 
		 * @see org.assetload.core.IAssetParam
		 * @see org.assetload.base.AssetParam
		 */
		function setGlobalParam(id : String, value : *) : void

		/**
		 * Returns a random asset's param value, as they all should be the same. Given you've used the "global" param methods.
		 * 
		 * @param id String, param id.
		 * @return Parameter value.
		 * 
		 * @see org.assetload.core.IAssetParam
		 * @see org.assetload.base.AssetParam
		 */
		function getGlobalParam(id : String) : *

		/**
		 * Sets ALL ILoadUnit's param value. Same as calling setGlobalParam method.
		 * 
		 * @param param IAssetParam
		 * 
		 * @see org.assetload.core.IAssetParam
		 * @see org.assetload.base.AssetParam
		 */
		function addGlobalParam(param : IParam) : void

		/**
		 * @return IGroupLoader - ILoader instance casted only once to IGroupLoader.
		 */
		function get groupLoader() : IGroupLoader 
	}
}
