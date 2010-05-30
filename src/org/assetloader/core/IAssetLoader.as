package org.assetloader.core 
{
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public interface IAssetLoader extends IEventDispatcher 
	{
		/**
		 * Lazy adds asset to loading queue.
		 * 
		 * @param id Unique string that identifies asset.
		 * @param url String URL to load.
		 * @param type String that defines the type of asset.
		 * @param assetParams Rest arguments for parameters that are passed to the <code>ILoadUnit</code>
		 * 
		 * @return ILoader created for this asset.
		 * 
		 * @see flash.net.URLRequest
		 * @see org.assetloader.base.AssetType
		 * @see org.assetloader.base.AssetParam
		 * @see org.assetloader.core.IAssetParam
		 * @see org.assetloader.core.ILoader
		 */
		function addLazy(id : String, url : String, type : String = "AUTO", ...assetParams) : ILoader

		/**
		 * Adds asset to loading queue.
		 * 
		 * @param id Unique string that identifies asset.
		 * @param request URLRequest to execute.
		 * @param type String that defines the type of asset.
		 * @param assetParams Rest arguments for parameters that are passed to the <code>ILoadUnit</code>
		 * 
		 * @return ILoader created for this asset.
		 * 
		 * @see flash.net.URLRequest
		 * @see org.assetloader.base.AssetType
		 * @see org.assetloader.base.AssetParam		 * @see org.assetloader.core.IAssetParam		 * @see org.assetloader.core.ILoader
		 */
		function add(id : String, request : URLRequest, type : String = "AUTO", ...assetParams) : ILoader

		/**
		 * Starts (or resumes) the loading operation.
		 * 
		 * @param numConnections The number of simultaneous connections to make. Giving value 0 (zero) will load all assets at the same time.
		 */
		function start(numConnections : uint = 3) : void

		/**
		 * Stops (pauses) the loading operation.
		 */
		function stop() : void

		/**
		 * Destroys all, but is still ready for use.
		 * @example If you add a few files, load them and then call destroy, you can add files again and start the loading operation.
		 */
		function destroy() : void

		/**
		 * @param id String id for the asset.
		 * @return ILoadUnit created on adding of asset.
		 * @see org.assetloader.core.ILoadUnit
		 */
		function getLoadUnit(id : String) : ILoadUnit

		/**
		 * @param id String id for the asset.
		 * @return ILoader created on adding of asset.
		 * @see org.assetloader.core.ILoader
		 */
		function getLoader(id : String) : ILoader

		/**
		 * @param id String id for the asset.
		 * @return The result after asset has been loaded.
		 */
		function getAsset(id : String) : *

		/**
		 * @return Percentage value of consolidated loading progress.
		 */
		function get progress() : Number 

		/**
		 * @return unit of bytes loaded
		 */
		function get bytesLoaded() : uint

		/**
		 * @return unit of total bytes to load. This value will increase as the connections are opened.
		 */
		function get bytesTotal() : uint

		/**
		 * @return Total number of asset loaded.
		 */
		function get numLoaded() : int
	}
}
