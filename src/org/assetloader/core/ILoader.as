package org.assetloader.core 
{
	import flash.events.IEventDispatcher;

	[Event(name="progress", type="flash.events.ProgressEvent")]

	[Event(name="complete", type="flash.events.Event")]

	[Event(name="open", type="flash.events.Event")]

	/**
	 * Instances of ILoader will perform the actual loading of an asset. They only handle one file at a time.
	 * <p>It must dispatch at least these events. <code>Event.OPEN | Event.COMPLETE | ProgressEvent.PROGRESS</code></p>	 * <p>Also maintain it's own instance of ILoadStats</p>
	 * 
	 * @see org.assetloader.loaders.AbstractLoader
	 * 
	 * @author Matan Uberstein
	 */
	public interface ILoader extends IEventDispatcher
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
		 * Gets the loadUnit.
		 * @return ILoadUnit
		 * 
		 * @see org.assetloader.core.ILoadUnit
		 */
		function get unit() : ILoadUnit

		/**
		 * Sets the loadUnit.
		 * @param unit ILoadUnit
		 * 
		 * @see org.assetloader.core.ILoadUnit
		 */
		function set unit(unit : ILoadUnit) : void

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
	}
}
