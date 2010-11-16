package org.assetloader.base
{
	import org.assetloader.core.ILoadStats;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class LoaderStatsTest
	{
		protected var _stats : LoaderStats;

		[BeforeClass]
		public static function runBeforeEntireSuite() : void
		{
		}

		[AfterClass]
		public static function runAfterEntireSuite() : void
		{
		}

		[Before]
		public function runBeforeEachTest() : void
		{
			_stats = new LoaderStats();
		}

		[After]
		public function runAfterEachTest() : void
		{
			_stats = null;
		}

		[Test]
		public function implementsILoadStats() : void
		{
			assertTrue("LoaderStats should implement ILoadStats", _stats is ILoadStats);
		}

		[Test (async)]
		public function delayedOpen() : void
		{
			_stats.start();
			var timer : Timer = new Timer(250, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, Async.asyncHandler(this, open, 500), false, 0, true);
			timer.start();
		}

		protected function open(event : TimerEvent, data : Object) : void
		{
			_stats.open();
			assertTrue("LoaderStats#latency should be more than 250", (_stats.latency > 250));
		}

		[Test]
		public function update() : void
		{
			_stats.start();
			_stats.open();
			_stats.update(100, 1000);
			assertEquals("LoaderStats#bytesLoaded should be equal to 100", _stats.bytesLoaded, 100);
			assertEquals("LoaderStats#bytesTotal should be equal to 1000", _stats.bytesTotal, 1000);
			assertEquals("LoaderStats#progress should be equal to 10%", _stats.progress, 10);

			assertTrue("LoaderStats#speed should be more than 0", (_stats.speed > 0));
			assertTrue("LoaderStats#averageSpeed should be more than 0", (_stats.averageSpeed > 0));
		}

		[Test]
		public function done() : void
		{
			_stats.start();
			_stats.open();
			_stats.update(100, 1000);
			_stats.done();
			assertEquals("LoaderStats#bytesLoaded should be equal to 1000", _stats.bytesLoaded, 1000);
			assertEquals("LoaderStats#bytesTotal should be equal to 1000", _stats.bytesTotal, 1000);
			assertEquals("LoaderStats#progress should be equal to 100%", _stats.progress, 100);
		}

		[Test]
		public function reset() : void
		{
			_stats.start();
			_stats.open();
			_stats.update(100, 1000);
			_stats.done();
			_stats.reset();
			assertEquals("LoaderStats#bytesLoaded should be equal to 0", _stats.bytesLoaded, 0);
			assertEquals("LoaderStats#bytesTotal should be equal to 0", _stats.bytesTotal, 0);
			assertEquals("LoaderStats#progress should be equal to 0%", _stats.progress, 0);
			assertEquals("LoaderStats#latency should be equal to 0", _stats.latency, 0);
			assertEquals("LoaderStats#speed should be equal to 0", _stats.speed, 0);
			assertEquals("LoaderStats#averageSpeed should be equal to 0", _stats.averageSpeed, 0);
		}
	}
}
