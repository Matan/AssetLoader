package org.assetloader.core 
{

	/**
	 * Calulates download stats.
	 * 
	 * @author Matan Uberstein
	 */
	public interface ILoadStats 
	{
		/**
		 * Records time when invoked. This should be called when you init a loading operation.
		 */
		function start() : void

		/**
		 * Records time difference between start and now to calculated latency.
		 */
		function open() : void

		/**
		 * Invoke when loading is complete.
		 */
		function done() : void
		/**
		 * Invoke when loading progress is made. This will updated the stats.
		 * @param bytesLoaded The amount of bytes loaded.
		 * @param bytesTotal The total amount of bytes for a loading operation.
		 */
		function update(bytesLoaded : uint, bytesTotal : uint) : void

		/**
		 * Resets all the values.
		 */
		function reset() : void

		/**
		 * Time between start and open.
		 * @return Millisecond value.
		 */
		function get latency() : Number

		/**
		 * Current speed of download.
		 * @return Kilobytes per second value.
		 */
		function get speed() : Number

		/**
		 * Average speed of download.
		 * @return Kilobytes per second value.
		 */
		function get averageSpeed() : Number

		/**
		 * Current progress percentage of download.
		 * @return Number between 0 and 100.
		 */
		function get progress() : Number
		
		/**
		 * Total time taken.
		 * @return Number value in milliseconds
		 */
		function get totalTime() : Number

		/**
		 * @return Amount of bytes loaded.
		 */
		function get bytesLoaded() : uint

		/**
		 * @return Total amount of bytes to load.
		 */
		function get bytesTotal() : uint

		/**
		 * @param value The total amount of bytes for a loading operation.
		 */
		function set bytesTotal(value : uint) : void
	}
}
