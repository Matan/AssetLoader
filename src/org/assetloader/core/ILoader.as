package org.assetloader.core 
{

	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.HttpStatusSignal;
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.signals.ProgressSignal;

	import flash.net.URLRequest;

	/**
	 * Instances of ILoader will perform the actual loading of an asset. They only handle one file at a time.
	 * <p>It must dispatch at least these events. <code>Event.OPEN | Event.COMPLETE | ProgressEvent.PROGRESS</code></p>	 * <p>Also maintain it's own instance of ILoadStats</p>
	 * 
	 * @see org.assetloader.loaders.AbstractLoader
	 * 
	 * @author Matan Uberstein
	 */
	public interface ILoader
	{
		/**
		 * Starts/resumes the loading operation.
		 */
		function start() : void
		/**
		 * Stops/pauses the loading operation.
		 */
		function stop() : void
		/**
		 * Removes all listeners and destroys references.
		 */
		function destroy() : void

		/**
		 * Gets the parent loader of this loader.
		 * @return ILoader
		 * 
		 * @see org.assetloader.core.ILoader
		 */
		function get parent() : ILoader

		/**
		 * Gets the current loading stats of loader.
		 * @return ILoadStats
		 * @see org.assetloader.core.ILoadStats
		 */
		function get stats() : ILoadStats

		/**
		 * True if the load operation was started at least once.
		 * e.g. start is called then stop is called, invoked flag stays true.
		 * 
		 * <p>False before start is called and after destroy is called.</p>
		 * 
		 * @return Boolean
		 * 
		 * @see #inProgress
		 */
		function get invoked() : Boolean

		/**
		 * True if the load operation has been started.
		 * e.g. when <code>Event.OPEN</code> fires.
		 * 
		 * <p>False before start is called and after load operation is complete.</p>
		 * 
		 * @return Boolean
		 */
		function get inProgress() : Boolean

		/**
		 * True if the load operation has been stopped via stop method.
		 * 
		 * <p>False every other state.</p>
		 * 
		 * @return Boolean
		 */
		function get stopped() : Boolean
		/**
		 * True if the loading has completed. False otherwise.
		 * 
		 * @return Boolean
		 */
		function get loaded() : Boolean
		/**
		 * @return Data that was returned after loading operation completed.
		 */
		function get data() : *
		
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
		 * @return String of asset id.
		 */
		function get id() : String

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
		 * @return Object containing all parameters added to loadUnit.
		 * 
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function get params() : Object

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
		
		function get onError() : ErrorSignal

		function get onHttpStatus() : HttpStatusSignal

		function get onOpen() : LoaderSignal

		function get onProgress() : ProgressSignal

		function get onComplete() : LoaderSignal
		
		function get onAddedToParent() : LoaderSignal

		function get onRemovedFromParent() : LoaderSignal
	}
}
