package org.assetloader.core
{

	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.HttpStatusSignal;
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.signals.ProgressSignal;

	import flash.net.URLRequest;

	/**
	 * Instances of ILoader will perform the actual loading of an asset. They only handle one file at a time.
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
		 * True if the load operation was started. False other wise.
		 * 
		 * @default false
		 * @return Boolean
		 * 
		 * @see #inProgress
		 */
		function get invoked() : Boolean

		/**
		 * True if the load operation has been started.
		 * e.g. when <code>opOpen</code> fires.
		 * 
		 * <p>False before start is called and after load operation is complete.</p>
		 * 
		 * @default false
		 * @return Boolean
		 */
		function get inProgress() : Boolean

		/**
		 * True if the load operation has been stopped via stop method.
		 * 
		 * <p>False every other state.</p>
		 * 
		 * @default false
		 * @return Boolean
		 */
		function get stopped() : Boolean

		/**
		 * True if the loading has completed. False otherwise.
		 * 
		 * @default false
		 * @return Boolean
		 */
		function get loaded() : Boolean

		/**
		 * True if the loader has failed after the set amount of retries.
		 * 
		 * @default false;
		 * @return Boolean
		 */
		function get failed() : Boolean

		/**
		 * @return Data that was returned after loading operation completed.
		 */
		function get data() : *

		/**
		 * Checks if a param with the passed id exists.
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
		 * Adds parameter to ILoader. Same effect as calling setParam.
		 * 
		 * @param param IParam
		 * 
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function addParam(param : IParam) : void

		/**
		 * @return String of ILoader id.
		 */
		function get id() : String

		/**
		 * @return URLRequest
		 */
		function get request() : URLRequest

		/**
		 * @return String of ILoader type.
		 * 
		 * @see org.assetloader.base.AssetType
		 */
		function get type() : String

		/**
		 * Object containing all parameters added to ILoader.
		 * Modifying this is not recommended as some params requires some work
		 * to be done once they are added. 
		 * 
		 * @return Object
		 * 
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function get params() : Object

		/**
		 * Gets the amount of times the loading operation failed and retried.
		 * @return uint
		 * 
		 * @see org.assetloader.base.Param#RETRIES
		 * @see org.assetloader.core.IParam
		 * @see org.assetloader.base.Param
		 */
		function get retryTally() : uint

		/**
		 * Dispatches when something goes wrong, could be anything.
		 * Most common causes would be an incorrect url or security error.
		 * Keep in mind that all error are consolidated into one place, so if
		 * load an XML file that has mal formed xml, this Signal will fire.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>ErrorSignal</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.ErrorSignal
		 */
		function get onError() : ErrorSignal

		/**
		 * Dispatches once the server has return a http status.
		 * 
		 * <p>Note: not all implemetations of ILoader dispatches this Signal.
		 * e.g. AssetLoader, VideoLoader and SoundLoader.</p>
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>HttpStatusSignal</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.HttpStatusSignal
		 */
		function get onHttpStatus() : HttpStatusSignal

		/**
		 * Dispatches when a connection has been opened this means that the
		 * transfer will start shortly.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		function get onOpen() : LoaderSignal

		/**
		 * Dispatches when loading progress has been made.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>ProgressSignal</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.ProgressSignal
		 */
		function get onProgress() : ProgressSignal

		/**
		 * Dispatches when the loading operations has completed.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>, data:<strong>RelatedType</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>		 *	 <li><strong>data</strong> - This will be a strongly typed value of what the ILoader has loaded. See list below.</li>
		 * </ul>
		 * 
		 * <p>This is the list of ILoader implemetations and their strongly typed return.</p>
		 * <table class="innertable" width="100%">
		 * <tr>
		 *	 	<th>Implementation:</th>		 * 		<th>Type:</th>		 * </tr>
		 * <tr>
		 * 		<td>AssetLoader</td>
		 * 		<td>Dictionary</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>BinaryLoader</td>		 * 		<td>ByteArray</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>CSSLoader</td>
		 * 		<td>StyleSheet</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>DisplayObjectLoader</td>
		 * 		<td>DisplayObject</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>ImageLoader</td>
		 * 		<td>Bitmap</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>JSONLoader</td>
		 * 		<td>Object</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>SoundLoader</td>
		 * 		<td>Sound</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>SWFLoader</td>
		 * 		<td>Sprite</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>TextLoader</td>
		 * 		<td>String</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>VideoLoader</td>
		 * 		<td>NetStream</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>XMLLoader</td>
		 * 		<td>XML</td>
		 * 	</tr>
		 * </table>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		function get onComplete() : LoaderSignal

		/**
		 * Dispatches when an ILoader is added to an IAssetLoader's queue.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>, parent:<strong>IAssetLoader</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 *	 <li><strong>parent</strong> - IAssetLoader in question.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		function get onAddedToParent() : LoaderSignal

		/**
		 * Dispatches when an ILoader is removed from an IAssetLoader's queue.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>, parent:<strong>IAssetLoader</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 *	 <li><strong>parent</strong> - IAssetLoader in question.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		function get onRemovedFromParent() : LoaderSignal
		
		/**
		 * Dispatches when an ILoader's start method is called. NOTE: This is dispatched just BEFORE
		 * the actual loading operation starts.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		function get onStart() : LoaderSignal

		/**
		 * Dispatches when an ILoader's stop method is called.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		function get onStop() : LoaderSignal
	}
}
