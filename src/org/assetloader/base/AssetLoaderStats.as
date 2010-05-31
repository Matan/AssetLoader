package org.assetloader.base 
{
	import org.assetloader.core.ILoadStats;

	import flash.utils.getTimer;

	/**
	 * @author Matan Uberstein
	 */
	public class AssetLoaderStats extends LoaderStats implements ILoadStats
	{
		protected var _numOpened : int = 0;
		protected var _totalLatency : Number = 0;

		public function AssetLoaderStats()
		{
		}

		/**
		 * @inheritDoc
		 */
		override public function open() : void 
		{
			_numOpened++;
			_openTime = getTimer();
			
			_totalLatency += _openTime - _startTime;
			_latency = _totalLatency / _numOpened;
			
			update(0, 0);
		}

		/**
		 * Average latency.
		 * @return Millisecond value.
		 */
		override public function get latency() : Number 
		{
			return super.latency;
		}
	}
}
