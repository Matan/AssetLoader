package org.assetloader.base
{
	import org.assetloader.core.ILoadStats;

	import flash.utils.getTimer;

	/**
	 * @author Matan Uberstein
	 */
	public class LoaderStats implements ILoadStats
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
		protected var _totalTime : Number = 0;

		/**
		 * @private
		 */
		protected var _numOpened : int = 0;
		/**
		 * @private
		 */
		protected var _totalLatency : Number = 0;

		/**
		 * @private
		 */
		protected var _bytesLoaded : uint = 0;
		/**
		 * @private
		 */
		protected var _bytesTotal : uint = 0;

		/**
		 * @private
		 */
		protected var _startTime : int;
		/**
		 * @private
		 */
		protected var _openTime : int;
		/**
		 * @private
		 */
		protected var _updateTime : int;

		public function LoaderStats()
		{
		}

		/**
		 * @inheritDoc
		 */
		public function start() : void
		{
			_startTime = getTimer();

			_latency = 0;
			_speed = 0;
			_averageSpeed = 0;
			_progress = 0;
			_totalTime = 0;
		}

		/**
		 * @inheritDoc
		 */
		public function open() : void
		{
			_numOpened++;
			_openTime = getTimer();

			_totalLatency += _openTime - _startTime;
			_latency = _totalLatency / _numOpened;

			update(0, 0);
		}

		/**
		 * @inheritDoc
		 */
		public function done() : void
		{
			update(_bytesTotal, _bytesTotal);

			_totalTime = getTimer() - _startTime;
		}

		/**
		 * @inheritDoc
		 */
		public function update(bytesLoaded : uint, bytesTotal : uint) : void
		{
			_bytesTotal = bytesTotal;

			if(bytesLoaded > 0)
			{
				var bytesDif : uint = bytesLoaded - _bytesLoaded;
				_bytesLoaded = bytesLoaded;

				_progress = (_bytesLoaded / _bytesTotal) * 100;

				var currentTime : int = getTimer();
				var updateTimeDif : int = currentTime - _updateTime;

				if(updateTimeDif > 0)
				{
					_updateTime = currentTime;
					_speed = (bytesDif / 1024) / (updateTimeDif / 1000);

					var totalTimeDif : Number = (_updateTime - _openTime) / 1000;
					_averageSpeed = (_bytesLoaded / 1024) / totalTimeDif;
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function reset() : void
		{
			_startTime = NaN;
			_openTime = NaN;
			_updateTime = NaN;

			_latency = 0;
			_speed = 0;
			_averageSpeed = 0;
			_progress = 0;
			_totalTime = 0;

			_bytesLoaded = 0;
			_bytesTotal = 0;

			_numOpened = 0;
			_totalLatency = 0;
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
		public function get totalTime() : Number
		{
			return _totalTime;
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

		/**
		 * @inheritDoc
		 */
		public function set bytesTotal(bytesTotal : uint) : void
		{
			_bytesTotal = bytesTotal;
		}
	}
}
