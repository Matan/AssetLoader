package org.assetloader.core 
{
	import org.assetloader.base.SmartURL;

	import flash.net.URLRequest;

	/**
	 * The ILoadUnit is the glue between the ILoader and IAssetLoader.
	 * 
	 * @see org.assetloader.core.IAssetLoader	 * @see org.assetloader.core.ILoader
	 * 
	 * @author Matan Uberstein
	 */
	public interface ILoadUnit 
	{

		/**
		 * Checks if ILoadUnit has a param with the passed id.
		 * 
		 * @param id String param id.
		 * @return Boolean
		 * 
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function hasParam(id : String) : Boolean

		/**
		 * Sets param value.
		 * 
		 * @param id String, param id.
		 * @param value Parameter value.
		 * 
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function setParam(id : String, value : *) : void

		/**
		 * Gets param value.
		 * 
		 * @param id String, param id.
		 * @return Parameter value.
		 * 
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function getParam(id : String) : *

		/**
		 * Adds parameter to unit. Same effect as calling setParam.
		 * 
		 * @param param IAssetParam
		 * 
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function addParam(param : IParam) : void

		/**
		 * @return ILoader instance who contains this unit.
		 * 
		 * @see org.assetloader.core.ILoader
		 */
		function get parent() : ILoadUnit

		/**
		 * @return String of asset id.
		 */
		function get id() : String
		/**
		 * @return ILoader instance created according to type.
		 * 
		 * @see org.assetloader.core.ILoader
		 */
		function get loader() : ILoader

		/**
		 * @return URLRequest
		 */
		function get request() : URLRequest

		/**
		 * @return String of asset type.
		 * 
		 * @see org.assetloader.base.AssetType
		 */
		function get type() : String

		/**
		 * @return String of URLRequest's url, just for quick reference.
		 */
		function get url() : String

		/**
		 * @return SmartURL instance created from url.
		 * 
		 * @see org.assetloader.base.SmartURL
		 */
		function get smartUrl() : SmartURL

		/**
		 * @return Object containing all parameters added to loadUnit.
		 * 
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function get params() : Object
		/**
		 * @return Class of loadUnit's unique event class for strongly typed data returns.
		 */
		function get eventClass() : Class

		/**
		 * Gets the amount of times the loading operation failed and retried.
		 * @return uint
		 * 
		 * @see AssetParam.RETRIES
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function get retryTally() : uint

		/**
		 * Sets the amount of times the loading operation failed and retried.
		 * @param value uint
		 * 
		 * @see AssetParam.RETRIES
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function set retryTally(value : uint) : void
	}
}
