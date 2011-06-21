package org.assetloader.core
{
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;

	import flash.net.URLRequest;

	/**
	 * Instances of IAssetLoader can contain ILoader. Itself being an ILoader, the IAssetLoader can
	 * also be contained by other IAssetLoaders.
	 * 
	 * @see org.assetloader.core.ILoader
	 * 
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
		 * @param params Rest arguments for parameters that are passed to the <code>ILoader</code>. Also accepts an Array of Param objects.
		 * 
		 * @throws org.assetloader.base.AssetLoaderError INVALID_URL		 * @throws org.assetloader.base.AssetLoaderError ASSET_TYPE_NOT_RECOGNIZED		 * @throws org.assetloader.base.AssetLoaderError ASSET_AUTO_TYPE_NOT_FOUND
		 * @throws org.assetloader.base.AssetLoaderError ALREADY_CONTAINS_LOADER_WITH_ID		 * 
		 * @return <code>ILoader</code> created for this asset.
		 * 
		 * @see org.assetloader.base.AssetType
		 * @see org.assetloader.base.Param
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.core.ILoader
		 * @see #add()		 * @see #addLoader()
		 */
		function addLazy(id : String, url : String, type : String = "AUTO", ...params) : ILoader

		/**
		 * Adds asset to loading queue.
		 * <p>Recommendation: Create a class with static constants of the asset ids.</p>
		 * 
		 * @param id Unique String that identifies asset.
		 * @param url URLRequest to load.
		 * @param type String that defines the type of asset.
		 * @param params Rest arguments for parameters that are passed to the <code>ILoader</code>. Also accepts an Array of Param objects.
		 * 
		 * @throws org.assetloader.base.AssetLoaderError INVALID_URL
		 * @throws org.assetloader.base.AssetLoaderError ASSET_TYPE_NOT_RECOGNIZED
		 * @throws org.assetloader.base.AssetLoaderError ASSET_AUTO_TYPE_NOT_FOUND
		 * @throws org.assetloader.base.AssetLoaderError ALREADY_CONTAINS_LOADER_WITH_ID
		 * 
		 * @return <code>ILoader</code> created for this asset.
		 * 
		 * @see org.assetloader.base.AssetType
		 * @see org.assetloader.base.Param
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.core.ILoader
		 * @see #addLazy()
		 * @see #addLoader()
		 */
		function add(id : String, request : URLRequest, type : String = "AUTO", ...params) : ILoader

		/**
		 * Adds loader to loading queue.
		 * 
		 * @param loader ILoader
		 * 
		 * @throws org.assetloader.base.AssetLoaderError ALREADY_CONTAINS_LOADER_WITH_ID
		 * @throws org.assetloader.base.AssetLoaderError ALREADY_CONTAINED_BY_OTHER
		 * @throws org.assetloader.base.AssetLoaderError CIRCULAR_REFERENCE_FOUND
		 * 
		 * @see org.assetloader.base.AssetType
		 * @see org.assetloader.base.Param
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.core.ILoader
		 * @see #add()		 * @see #addLazy()
		 */
		function addLoader(loader : ILoader) : void

		/**
		 * Adds multiple assets to the loading queue.
		 * 
		 * @param config If a url is passed, the file will be loaded first and then IConfigParser will convert string into required type.
		 * 
		 * @throws org.assetloader.base.AssetLoaderError COULD_NOT_PARSE_CONFIG
		 * 
		 * @see org.assetloader.core.IConfigParser
		 * @see #add()		 * @see #addLazy()
		 * @see #addLoader()
		 */
		function addConfig(data : String) : void

		/**
		 * Removes ILoader from queue.
		 * <p>Note: Loaders removed in this manner are NOT destroyed. They are merely removed from this IAssetLoader.</p>
		 * 
		 * @param id Unique String that identifies loader.
		 */
		function remove(id : String) : ILoader

		/**
		 * Starts the ILoader with id passed.
		 * @param id loader id.
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
		 * Gets the ILoader.
		 * 
		 * @param id String id of the asset.
		 * @return ILoader
		 * @see org.assetloader.core.ILoader
		 */
		function getLoader(id : String) : ILoader

		/**
		 * Checks if IAssetLoader with id exists.
		 * 
		 * @param id String id of the asset.
		 * @return Boolean
		 * @see org.assetloader.core.IAssetLoader
		 */
		function hasAssetLoader(id : String) : Boolean

		/**
		 * Gets the IAssetLoader.
		 * 
		 * @param id String id of the asset.
		 * @return IAssetLoader
		 * @see org.assetloader.core.IAssetLoader
		 */
		function getAssetLoader(id : String) : IAssetLoader

		/**
		 * Checks if the ILoader with given id has returned data.
		 * 
		 * @param id String id of the loader.
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
		 * All the ids of the ILoaders in queue.
		 * 
		 * @return Array of Strings
		 */
		function get ids() : Array

		/**
		 * All the ids of the ILoaders that have been loaded.
		 * 
		 * @return Array of Strings
		 */
		function get loadedIds() : Array

		/**
		 * All the ids of the ILoaders that have failed.
		 * 
		 * @return Array of Strings
		 */
		function get failedIds() : Array

		/**
		 * The amount of ILoaders in queue.
		 * 
		 * @return int
		 */
		function get numLoaders() : int

		/**
		 * The amount of ILoaders loaded.
		 * 
		 * @return int
		 */
		function get numLoaded() : int

		/**
		 * The amount of ILoaders that have failed.
		 * 
		 * @return int
		 */
		function get numFailed() : int

		/**
		 * Gets the failOnError flag. If true the IAssetLoader will not dispatch
		 * onComplete if one or more of the child loaders have failed/errored. If
		 * false, the onComplete signal will dispatch regardless of child failures.
		 * 
		 * @default true
		 */
		function get failOnError() : Boolean

		/**
		 * Sets the failOnError flag. If true the IAssetLoader will not dispatch
		 * onComplete if one or more of the child loaders have failed/errored. If
		 * false, the onComplete signal will dispatch regardless of child failures.
		 * 
		 * @default true
		 */
		function set failOnError(value : Boolean) : void

		/**
		 * Gets the number of connections this IAssetLoader will make.
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
		 * Dispatches when a child ILoader in the loading queue dispatches <code>onOpen</code>.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>, loader:<strong>ILoader</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 *	 <li><strong>loader</strong> - The child ILoader that dispatched <code>onOpen</code>.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		function get onChildOpen() : LoaderSignal

		/**
		 * Dispatches when a child ILoader in the loading queue dispatches <code>onError</code>.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>ErrorSignal</strong>, loader:<strong>ILoader</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 *	 <li><strong>loader</strong> - The child ILoader that dispatched <code>onError</code>.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal		 * @see org.assetloader.signals.ErrorSignal
		 */
		function get onChildError() : ErrorSignal

		/**
		 * Dispatches when a child ILoader in the loading queue dispatches <code>onComplete</code>.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>, loader:<strong>ILoader</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 *	 <li><strong>loader</strong> - The child ILoader that dispatched <code>onComplete</code>.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		function get onChildComplete() : LoaderSignal

		/**
		 * Dispatches only if a URL is passed to the <code>addConfig</code> method and the config
		 * file has finished loading.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		function get onConfigLoaded() : LoaderSignal
	}
}
