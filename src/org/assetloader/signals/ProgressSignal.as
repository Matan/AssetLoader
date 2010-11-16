package org.assetloader.signals
{
	import org.assetloader.core.ILoader;

	/**
	 * @author Matan Uberstein
	 */
	public class ProgressSignal extends LoaderSignal
	{
		protected var _latency : Number = 0;
		protected var _speed : Number = 0;
		protected var _averageSpeed : Number = 0;
		protected var _progress : Number = 0;

		protected var _bytesLoaded : uint = 0;
		protected var _bytesTotal : uint = 0;

		public function ProgressSignal(loader : ILoader, ...valueClasses)
		{
			super(loader, valueClasses);
			_signalType = ProgressSignal;
		}

		/**
		 * @param args1 Number - Latency		 * @param args2 Number - Speed		 * @param args3 Number - averageSpeed		 * @param args4 Number - progress		 * @param args5 uint - bytesLoaded		 * @param args6 uint - bytesTotal
		 */
		override public function dispatch(...args) : void
		{
			_latency = args.shift();
			_speed = args.shift();
			_averageSpeed = args.shift();
			_progress = args.shift();
			_bytesLoaded = args.shift();
			_bytesTotal = args.shift();
			super.dispatch.apply(null, args);
		}
		
		override protected function clone() : LoaderSignal
		{
			var clone : ProgressSignal = new ProgressSignal(_loader, valueClasses);
			clone._latency = _latency;
			clone._speed = _speed;
			clone._averageSpeed = _averageSpeed;
			clone._progress = _progress;
			clone._bytesLoaded = _bytesLoaded;
			clone._bytesTotal = _bytesTotal;
			return clone;
		}

		/**
		 * @inheritDoc
		 */
		public function get latency() : Number
		{
			return _latency;
		}

		/**
		 * @inheritDoc
		 */
		public function get speed() : Number
		{
			return _speed;
		}

		/**
		 * @inheritDoc
		 */
		public function get averageSpeed() : Number
		{
			return _averageSpeed;
		}

		/**
		 * @inheritDoc
		 */
		public function get progress() : Number
		{
			return _progress;
		}

		/**
		 * @inheritDoc
		 */
		public function get bytesLoaded() : uint
		{
			return _bytesLoaded;
		}

		/**
		 * @inheritDoc
		 */
		public function get bytesTotal() : uint
		{
			return _bytesTotal;
		}
	}
}
