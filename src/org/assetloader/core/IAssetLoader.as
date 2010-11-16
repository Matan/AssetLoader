package org.assetloader.core
{
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;

	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public interface IAssetLoader extends ILoader
	{
		/**
		 * Lazy adds asset to loading queue.
		 * <p>Recommendation: Create a class with static constants of the asset ids.</p>
		 * 
		 * @param id Unique String that identifies asset.
		 * @param url String URL to load.
		 * @param type String that defines the type of asset.
		 * @param assetParams Rest arguments for parameters that are passed to the <code>ILoadUnit</code>. Also accepts an Array of AssetParams.
		 * 
		 * @return ILoader created for this asset.
		 * 
		 * @see flash.net.URLRequest
		 * @see org.assetloader.base.AssetType
		 * @see org.assetloader.base.Param
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.core.ILoader
		 * @see #add()
		 * 
		 * @example addLazy(AssetId.SOME_FILE_ID, sample.xml);
		 */
		function addLazy(id : String, url : String, type : String = "AUTO", ...params) : ILoader

		/**
		 * Adds asset to loading queue.
		 * <p>Recommendation: Create a class with static constants of the asset ids.</p>
		 * 
		 * @param id Unique String that identifies asset.
		 * @param request URLRequest to execute.
		 * @param type String that defines the type of asset.
		 * @param assetParams Rest arguments for parameters that are passed to the <code>ILoadUnit</code>. Also accepts an Array of AssetParams.
		 * 
		 * @return ILoader created for this asset.
		 * 
		 * @see flash.net.URLRequest
		 * @see org.assetloader.base.AssetType
		 * @see org.assetloader.base.Param
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.core.ILoader
		 */
		function add(id : String, request : URLRequest, type : String = "AUTO", ...params) : ILoader

		/**
		 * Adds asset to loading queue.
		 * <p>Recommendation: Create a class with static constants of the asset ids.</p>
		 * 
		 * @param unit ILoadUnit
		 * 
		 * @return ILoader created for this asset.
		 * 
		 * @see flash.net.URLRequest
		 * @see org.assetloader.base.AssetType
		 * @see org.assetloader.base.Param
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.core.ILoader
		 */
		function addLoader(loader : ILoader) : void

		/**
		 * Adds multiple assets to the loading queue. Once invoked the an implematation of the IConfigParser is constructed.
		 * 
		 * @param config String, If a url is passed, the file will be loaded first and then IConfigParser will convert string into required type.
		 * 
		 * @see #configParserClass
		 */
		function addConfig(data : String) : void

		/**
		 * Removes asset from queue and destroys it's ILoader instance.
		 * 
		 * @param id Unique String that identifies asset.
		 */
		function remove(id : String) : ILoader

		/**
		 * Starts the asset with id passed.
		 * @param id Asset id.
		 */
		function startLoader(id : String) : void

		/**
		 * Checks if ILoader with id exists.
		 * 
		 * @param id String id of the asset.
		 * @return Boolean
		 * @see org.assetloader.core.ILoader
		 */
		function hasLoader(id : String) : Boolean

		/**
		 * Gets the ILoader created when adding an asset to the queue.
		 * 
		 * @param id String id of the asset.
		 * @return ILoader created on adding of asset.
		 * @see org.assetloader.core.ILoader
		 */
		function getLoader(id : String) : ILoader

		/**
		 * Checks if the loader has return data.
		 * 
		 * @param id String id of the asset.
		 * @return Boolean
		 */
		function hasAsset(id : String) : Boolean

		/**
		 * Gets the data that was loaded by the ILoader. Data will only be available after the ILoader instance has finished loading.
		 * 
		 * @param id String id of the asset.
		 * @return The result after asset has been loaded.
		 */
		function getAsset(id : String) : *

		/**
		 * All the ids of the assets added.
		 * 
		 * @return Array of Strings
		 */
		function get ids() : Array

		/**
		 * All the ids of the assets that have been loaded.
		 * 
		 * @return Array of Strings
		 */
		function get loadedIds() : Array

		/**
		 * The amount of assets/load units added.
		 * 
		 * @return int
		 */
		function get numLoaders() : int

		/**
		 * The amount of assets loaded.
		 * 
		 * @return int
		 */
		function get numLoaded() : int

		/**
		 * Gets the number of connections this group will make.
		 * <p>Setting numConnections to 0 (zero) will cause the group to start all assets at the same time.</p>
		 * @return int
		 * @default 3;
		 */
		function get numConnections() : int

		/**
		 * Sets the amount of connections to make. Value must be set before start is called, otherwise it has no effect.
		 * <p>Setting numConnections to 0 (zero) will cause the group to start all assets at the same time.</p>
		 * @param value int
		 */
		function set numConnections(value : int) : void

		function get base() : String

		function set base(base : String) : void

		function get onChildOpen() : LoaderSignal

		function get onChildError() : ErrorSignal

		function get onChildComplete() : LoaderSignal

		function get onConfigLoaded() : LoaderSignal
	}
}
