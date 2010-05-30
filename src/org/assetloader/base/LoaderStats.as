package org.assetloader.base 
{
	import mu.utils.ToStr;

	import org.assetloader.core.ILoadStats;

	import flash.utils.getTimer;

	/**
	 * @author Matan Uberstein
	 */
	public class LoaderStats implements ILoadStats
	{
		protected var _latency : Number;		protected var _speed : Number;		protected var _averageSpeed : Number;
		protected var _progress : Number;

		protected var _bytesLoaded : uint = 0;		protected var _bytesTotal : uint = 0;

		protected var _startTime : int;
		protected var _openTime : int;
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
			
			_bytesLoaded = 0;			_progress = 0;
		}

		/**
		 * @inheritDoc
		 */
		public function open(bytesTotal : uint) : void
		{
			_openTime = getTimer();
			
			_latency = _openTime - _startTime;
			_bytesTotal = bytesTotal;
			
			update(0);
		}

		/**
		 * @inheritDoc
		 */
		public function done() : void
		{
			update(_bytesTotal);
		}

		/**
		 * @inheritDoc
		 */
		public function update(bytesLoaded : uint) : void
		{
			if(bytesLoaded > 0)
			{
				_progress = (_bytesLoaded / _bytesTotal) * 100;
				
				var currentTime : int = getTimer();
				
				var updateTimeDif : int = currentTime - _updateTime;
				_updateTime = currentTime;
				
				if(updateTimeDif > 0)
				{
					var bytesDif : uint = bytesLoaded - _bytesLoaded;
					_bytesLoaded = bytesLoaded;
					
					_speed = (bytesDif / 1024) / (updateTimeDif / 1000);
					
					var totalTimeDif : int = (_updateTime - _openTime) / 1000;
					_averageSpeed = (_bytesLoaded / 1024) / totalTimeDif;
				}
			}
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

		public function toString() : String 
		{
			return String(new ToStr(this, false));
		}
	}
}
