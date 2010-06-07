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
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function hasGlobalParam(id : String) : Boolean

		/**
		 * Sets ALL ILoadUnit's param value.
		 * 
		 * @param id String, param id.
		 * @param value Parameter value.
		 * 
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function setGlobalParam(id : String, value : *) : void

		/**
		 * Returns a random asset's param value, as they all should be the same. Given you've used the "global" param methods.
		 * 
		 * @param id String, param id.
		 * @return Parameter value.
		 * 
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function getGlobalParam(id : String) : *

		/**
		 * Sets ALL ILoadUnit's param value. Same as calling setGlobalParam method.
		 * 
		 * @param param IAssetParam
		 * 
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function addGlobalParam(param : IParam) : void

		/**
		 * @return IGroupLoader - ILoader instance casted only once to IGroupLoader.
		 */
		function get groupLoader() : IGroupLoader 

		/**
		 * Gets the global parameters added to this group.
		 * 
		 * @return Object containing param values.
		 * 
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function get globalParams() : Object
	}
}
