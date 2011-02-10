package org.assetloader.signals
{

	/**
	 * @author Matan Uberstein
	 */
	public class ProgressSignal extends LoaderSignal
	{
		/**
		 * @private
		 */
		protected var _latency : Number = 0;
		/**
		 * @private
		 */
		protected var _speed : Number = 0;
		/**
		 * @private
		 */
		protected var _averageSpeed : Number = 0;
		/**
		 * @private
		 */
		protected var _progress : Number = 0;

		/**
		 * @private
		 */
		protected var _bytesLoaded : uint = 0;
		/**
		 * @private
		 */
		protected var _bytesTotal : uint = 0;

		public function ProgressSignal(...valueClasses)
		{
			_signalType = ProgressSignal;
			super(valueClasses);
		}

		/**
		 * Dispatches Signal.
		 * 
		 * @param args1 ILoader - ILoader to which the signal belongs.
		 * @param args2 Number - Latency		 * @param args3 Number - Speed		 * @param args4 Number - averageSpeed		 * @param args5 Number - progress		 * @param args6 uint - bytesLoaded		 * @param args7 uint - bytesTotal
		 */
		override public function dispatch(...args) : void
		{
			_latency = args[1];
			_speed = args[2];
			_averageSpeed = args[3];
			_progress = args[4];
			_bytesLoaded = args[5];
			_bytesTotal = args[6];
			
			args.splice(1, 6);
			
			super.dispatch.apply(null, args);
		}

		/**
		 * Gets the latency in milliseconds.
		 * 
		 * @return Number.
		 */
		public function get latency() : Number
		{
			return _latency;
		}

		/**
		 * Gets speed in kilobytes per second.
		 * 
		 * @return Number.
		 */
		public function get speed() : Number
		{
			return _speed;
		}

		/**
		 * Gets the average speed in kilobytes per second.
		 */
		public function get averageSpeed() : Number
		{
			return _averageSpeed;
		}

		/**
		 * Gets the progress in percentage value.
		 * 
		 * @return Number between 0 and 100 
		 */
		public function get progress() : Number
		{
			return _progress;
		}

		/**
		 * Gets the bytes loaded.
		 * 
		 * @return uint
		 */
		public function get bytesLoaded() : uint
		{
			return _bytesLoaded;
		}

		/**
		 * Gets the total bytes.
		 * 
		 * @return uint
		 */
		public function get bytesTotal() : uint
		{
			return _bytesTotal;
		}
	}
}
