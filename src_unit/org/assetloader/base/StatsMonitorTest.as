package org.assetloader.base
{
	import org.assetloader.core.ILoadStats;
	import org.assetloader.core.ILoader;
	import org.assetloader.loaders.ImageLoader;
	import org.assetloader.loaders.TextLoader;
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.signals.ProgressSignal;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.failOnSignal;
	import org.osflash.signals.utils.handleSignal;

	import flash.net.URLRequest;

	public class StatsMonitorTest
	{
		protected var _monitor : StatsMonitor;
		protected var _className : String = "StatsMonitor";
		protected var _path : String = "assets/test/";

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
			_monitor = new StatsMonitor();
		}

		[After]
		public function runAfterEachTest() : void
		{
			_monitor.destroy();
			_monitor = null;
		}

		[Test]
		public function signalsReadyOnConstruction() : void
		{
			assertNotNull(_className + "#onOpen should NOT be null after construction", _monitor.onOpen);
			assertNotNull(_className + "#onProgress should NOT be null after construction", _monitor.onProgress);
			assertNotNull(_className + "#onComplete should NOT be null after construction", _monitor.onComplete);
		}

		[Test]
		public function adding() : void
		{
			var l1 : ILoader = new TextLoader(new URLRequest(_path + "testTXT.txt"));
			_monitor.add(l1);
			assertEquals(_className + "#numLoaders should equal", 1, _monitor.numLoaders);
			assertEquals(_className + "#numComplete should equal", 0, _monitor.numComplete);

			var l2 : ILoader = new ImageLoader(new URLRequest(_path + "testIMAGE.png"));
			_monitor.add(l2);
			assertEquals(_className + "#numLoaders should equal", 2, _monitor.numLoaders);
			assertEquals(_className + "#numComplete should equal", 0, _monitor.numComplete);
		}

		[Test]
		public function removing() : void
		{
			var l1 : ILoader = new TextLoader(new URLRequest(_path + "testTXT.txt"));
			var l2 : ILoader = new ImageLoader(new URLRequest(_path + "testIMAGE.png"));

			_monitor.add(l1);
			_monitor.add(l2);

			_monitor.remove(l1);
			assertEquals(_className + "#numLoaders should equal", 1, _monitor.numLoaders);
			assertEquals(_className + "#numComplete should equal", 0, _monitor.numComplete);

			_monitor.remove(l2);
			assertEquals(_className + "#numLoaders should equal", 0, _monitor.numLoaders);
			assertEquals(_className + "#numComplete should equal", 0, _monitor.numComplete);
		}

		[Test]
		public function destroying() : void
		{
			var l1 : ILoader = new TextLoader(new URLRequest(_path + "testTXT.txt"));
			var l2 : ILoader = new ImageLoader(new URLRequest(_path + "testIMAGE.png"));

			_monitor.add(l1);
			_monitor.add(l2);

			_monitor.onOpen.add(dummy_onOpen_handler);
			_monitor.onProgress.add(dummy_onProgress_handler);
			_monitor.onComplete.add(dummy_onComplete_handler);

			_monitor.destroy();
			assertEquals(_className + "#numLoaders should equal", 0, _monitor.numLoaders);
			assertEquals(_className + "#numComplete should equal", 0, _monitor.numComplete);

			assertEquals(_className + "#onOpen#numListeners should equal", 0, _monitor.onOpen.numListeners);
			assertEquals(_className + "#onProgress#numListeners should equal", 0, _monitor.onProgress.numListeners);
			assertEquals(_className + "#onComplete#numListeners should equal", 0, _monitor.onComplete.numListeners);

			// Should still be usable, thus test adding again after destroy.

			_monitor.add(l1);
			assertEquals(_className + "#numLoaders should equal", 1, _monitor.numLoaders);
			assertEquals(_className + "#numComplete should equal", 0, _monitor.numComplete);

			_monitor.add(l2);
			assertEquals(_className + "#numLoaders should equal", 2, _monitor.numLoaders);
			assertEquals(_className + "#numComplete should equal", 0, _monitor.numComplete);
		}
		
		[Test (async)]
		public function onOpenSignal() : void
		{
			var l1 : ILoader = new TextLoader(new URLRequest(_path + "testTXT.txt"));
			var l2 : ILoader = new ImageLoader(new URLRequest(_path + "testIMAGE.png"));

			_monitor.add(l1);
			_monitor.add(l2);
			
			handleSignal(this, _monitor.onOpen, onOpen_handler, 500, {l1:l1, l2:l2});
			failOnSignal(this, _monitor.onComplete);
			
			//only tell the one loader to start, because we are checking the passed loader's value within handler.
			l1.start();
		}

		protected function onOpen_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));

			var signal : LoaderSignal = values[0];
			assertNotNull("LoaderSignal#loader should NOT be null", signal.loader);
			assertEquals("LoaderSignal#loader should equal", data.l1, signal.loader);
		}
		
		[Test (async)]
		public function onProgressSignal() : void
		{
			var l1 : ILoader = new TextLoader(new URLRequest(_path + "testTXT.txt"));
			var l2 : ILoader = new ImageLoader(new URLRequest(_path + "testIMAGE.png"));

			_monitor.add(l1);
			_monitor.add(l2);
			
			handleSignal(this, _monitor.onProgress, onProgress_handler, 500, {l1:l1, l2:l2});
			failOnSignal(this, _monitor.onComplete);
			
			//only tell the one loader to start, because we are checking the passed loader's value within handler.
			l1.start();
		}

		protected function onProgress_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be ProgressSignal", (values[0] is ProgressSignal));

			var signal : ProgressSignal = values[0];
			assertNotNull("ProgressSignal#loader should NOT be null", signal.loader);
			assertEquals("ProgressSignal#loader should equal", data.l1, signal.loader);
			
			assertTrue("ProgressSignal#latency should be more or equal than 0", signal.latency >= 0);
			assertTrue("ProgressSignal#speed should be more or equal than 0", signal.speed >= 0);
			assertTrue("ProgressSignal#averageSpeed should be more or equal than 0", signal.averageSpeed >= 0);

			assertTrue("ProgressSignal#progress should be more or equal than 0", signal.progress >= 0);
			assertTrue("ProgressSignal#bytesLoaded should be more or equal than 0", signal.bytesLoaded >= 0);
			assertTrue("ProgressSignal#bytesTotal should be more than 0", signal.bytesTotal);
		}
		
		[Test (async)]
		public function onCompleteSignal() : void
		{
			var l1 : ILoader = new TextLoader(new URLRequest(_path + "testTXT.txt"));
			var l2 : ILoader = new ImageLoader(new URLRequest(_path + "testIMAGE.png"));

			_monitor.add(l1);
			_monitor.add(l2);
			
			handleSignal(this, _monitor.onComplete, onComplete_handler, 500, {l1:l1, l2:l2});
			
			//Tell both to start, otherwise onComplete will not fire.
			l1.start();
			l2.start();
		}

		protected function onComplete_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));

			var signal : LoaderSignal = values[0];
			assertNull("LoaderSignal#loader should be null", signal.loader);
			assertNotNull("Second argument should NOT be null", values[1]);
			assertTrue("Second argument should be ILoadStats", (values[1] is ILoadStats));
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// INTERNAL
		// --------------------------------------------------------------------------------------------------------------------------------//
		protected function dummy_onOpen_handler(signal : LoaderSignal) : void
		{
		}

		protected function dummy_onProgress_handler(signal : ProgressSignal) : void
		{
		}

		protected function dummy_onComplete_handler(signal : LoaderSignal, stats : ILoadStats) : void
		{
		}
	}
}
