package org.assetloader.core 
{
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;

	/**
	 * Implemetation of IAssetLoader should manage and maintain connections, ILoadUnits and consolidate stats via ILoadStats.
	 * 
	 * @includeExample ../../../sample/ContextSample.as
	 * @includeExample ../../../sample/StandardSample.as	 * @includeExample ../../../sample/SingletonSample.as
	 * 
	 * @author Matan Uberstein
	 */
	public interface IAssetLoader extends IEventDispatcher 
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
		 * @see org.assetloader.base.AssetParam
		 * @see org.assetloader.core.IAssetParam
		 * @see org.assetloader.core.ILoader
		 * @see #add()
		 * 
		 * @example addLazy(AssetId.SOME_FILE_ID, sample.xml);
		 */
		function addLazy(id : String, url : String, type : String = "AUTO", ...assetParams) : ILoader

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
		 * @see org.assetloader.base.AssetParam		 * @see org.assetloader.core.IAssetParam		 * @see org.assetloader.core.ILoader
		 */
		function add(id : String, request : URLRequest, type : String = "AUTO", ...assetParams) : ILoader

		/**
		 * Removes asset from queue and destroys it's ILoader instance.
		 * 
		 * @param id Unique String that identifies asset.
		 */
		function remove(id : String) : void

		/**
		 * Starts (or resumes) the loading operation.
		 * 
		 * @param numConnections The number of simultaneous connections to make. Giving value 0 (zero) will load all assets at the same time.
		 */
		function start(numConnections : uint = 3) : void

		/**
		 * Starts the asset with id passed.
		 * @param id Asset id.
		 */
		function startAsset(id : String) : void

		/**
		 * Stops (pauses) the loading operation.
		 */
		function stop() : void

		/**
		 * Destroys all, but is still ready for use.
		 * If you add a few files, load them and then call destroy, you can add files again and start the loading operation.
		 */
		function destroy() : void

		/**
		 * Checks if ILoadUnit with id exists.
		 * 
		 * @param id String id of the asset.
		 * @return Boolean
		 * @see org.assetloader.core.ILoadUnit
		 */
		function hasLoadUnit(id : String) : Boolean

		/**
		 * Gets the ILoadUnit created when adding an asset to the queue.
		 * 
		 * @param id String id for the asset.
		 * @return ILoadUnit created on adding of asset.
		 * @see org.assetloader.core.ILoadUnit
		 */
		function getLoadUnit(id : String) : ILoadUnit

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
		 * Gets the current loading stats.
		 * 
		 * @return Current loading stats.
		 * @see org.assetloader.core.ILoadStats
		 */
		function get stats() : ILoadStats

		/**
		 * The amount of assets/load units added.
		 * 
		 * @return int
		 */
		function get numUnits() : int

		/**
		 * The amount of assets loaded.
		 * 
		 * @return int
		 */
		function get numLoaded() : int
	}
}
