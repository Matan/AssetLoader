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
		 * Initialized unit.
		 * 
		 * @param id String id.
		 * @param request URLRequest
		 * @param assetParams Array of parameters.
		 * 
		 * @throws org.assetloader.base.AssetLoaderError AssetLoaderError.INVALID_URL
		 */
		function init(id : String, request : URLRequest, type : String, assetParams : Array) : void

		/**
		 * Checks if ILoadUnit has a param with the passed id.
		 * 
		 * @param id String param id.
		 * @return Boolean
		 * 
		 * @see org.assetload.core.IAssetParam		 * @see org.assetload.base.AssetParam
		 */
		function hasParam(id : String) : Boolean

		/**
		 * Sets param value.
		 * 
		 * @param id String, param id.
		 * @param value Parameter value.
		 * 
		 * @see org.assetload.core.IAssetParam
		 * @see org.assetload.base.AssetParam
		 */
		function setParam(id : String, value : *) : void

		/**
		 * Gets param value.
		 * 
		 * @param id String, param id.
		 * @return Parameter value.
		 * 
		 * @see org.assetload.core.IAssetParam
		 * @see org.assetload.base.AssetParam
		 */
		function getParam(id : String) : *

		/**
		 * @return String of asset id.
		 */
		function get id() : String
		/**
		 * @return ILoader instance created according to type.
		 * 
		 * @see org.assetload.core.ILoader
		 */
		function get loader() : ILoader

		/**
		 * @return URLRequest
		 */
		function get request() : URLRequest

		/**
		 * @return String of asset type.
		 * 
		 * @see org.assetload.base.AssetType
		 */
		function get type() : String

		/**
		 * @return String of URLRequest's url, just for quick reference.
		 */
		function get url() : String

		/**
		 * @return SmartURL instance created from url.
		 * 
		 * @see org.assetload.base.SmartURL
		 */
		function get smartUrl() : SmartURL

		/**
		 * @return Object containing all parameters added to loadUnit.
		 * 
		 * @see org.assetload.core.IAssetParam
		 * @see org.assetload.base.AssetParam
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
		 */
		function get retryTally() : uint

		/**
		 * Sets the amount of times the loading operation failed and retried.
		 * @param value uint
		 * 
		 * @see AssetParam.RETRIES
		 */
		function set retryTally(value : uint) : void
	}
}
