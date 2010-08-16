package org.assetloader.core 
{
	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public interface IGroupLoader extends ILoader
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
		function addUnit(unit : ILoadUnit) : ILoader

		/**
		 * Adds multiple assets to the loading queue. Once invoked the an implematation of the IConfigParser is constructed.
		 * 
		 * @param config String, If a url is passed, the file will be loaded first and then IConfigParser will convert string into required type.
		 * 
		 * @see #configParserClass
		 */
		function addConfig(config : String) : void

		/**
		 * Removes asset from queue and destroys it's ILoader instance.
		 * 
		 * @param id Unique String that identifies asset.
		 */
		function remove(id : String) : void

		/**
		 * Starts the asset with id passed.
		 * @param id Asset id.
		 */
		function startUnit(id : String) : void

		/**
		 * Checks if ILoadUnit with id exists.
		 * 
		 * @param id String id of the asset.
		 * @return Boolean
		 * @see org.assetloader.core.ILoadUnit
		 */
		function hasUnit(id : String) : Boolean

		/**
		 * Gets the ILoadUnit created when adding an asset to the queue.
		 * 
		 * @param id String id of the asset.
		 * @return ILoadUnit created on adding of asset.
		 * @see org.assetloader.core.ILoadUnit
		 */
		function getUnit(id : String) : ILoadUnit

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
		 * Gets loadGroup.
		 * @return ILoadGroup
		 */
		function get group() : ILoadGroup 

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
		function get numUnits() : int

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

		/**
		 * Gets the config parser class.
		 * 
		 * @default org.assetloader.base.config.XmlConfigParser
		 * 
		 * @return Class
		 * 
		 * @see org.assetloader.core.IConfigParser
		 */
		function get configParserClass() : Class 

		/**
		 * Sets the config parser class. This class must implement IConfigParser.
		 * 
		 * @default org.assetloader.base.config.XmlConfigParser
		 * 
		 * @see org.assetloader.core.IConfigParser
		 */
		function set configParserClass(value : Class) : void 
	}
}
