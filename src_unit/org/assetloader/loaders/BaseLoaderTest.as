package org.assetloader.loaders
{
	import org.assetloader.AssetLoader;
	import org.assetloader.base.AbstractLoaderTest;
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.HttpStatusSignal;
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.signals.ProgressSignal;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.failOnSignal;
	import org.osflash.signals.utils.handleSignal;
	import org.osflash.signals.utils.proceedOnSignal;

	public class BaseLoaderTest extends AbstractLoaderTest
	{
		protected var _payloadType : Class ;
		protected var _payloadTypeName : String;
		protected var _payloadPropertyName : String;

		protected var _path : String = "assets/test/";

		protected var _hadParent : Boolean = false;

		[BeforeClass]
		public static function runBeforeEntireSuite() : void
		{
		}

		[AfterClass]
		public static function runAfterEntireSuite() : void
		{
		}

		[Before]
		override public function runBeforeEachTest() : void
		{
			_hadRequest = true;
		}

		[After]
		override public function runAfterEachTest() : void
		{
			super.runBeforeEachTest();
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// BOOLEAN STATES
		// --------------------------------------------------------------------------------------------------------------------------------//

		[Test]
		public function booleanStateBeforeLoad() : void
		{
			assertEquals(_loaderName + "#invoked state before loading starts", false, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state before loading starts", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state before loading starts", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state before loading starts", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state before loading starts", false, _loader.failed);
		}

		[Test (async)]
		public function booleanStateDuringLoad() : void
		{
			handleSignal(this, _loader.onOpen, onOpen_booleanStateDuringLoad_handler);
			_loader.start();
		}

		protected function onOpen_booleanStateDuringLoad_handler(event : SignalAsyncEvent, data : Object) : void
		{
			assertEquals(_loaderName + "#invoked state during loading", true, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state during loading", true, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state during loading", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state during loading", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state during loading", false, _loader.failed);
		}

		[Test]
		public function booleanStateAfterStoppedLoad() : void
		{
			_loader.start();
			_loader.stop();
			assertEquals(_loaderName + "#invoked state after loading stopped", true, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state after loading stopped", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after loading stopped", true, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after loading stopped", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state after loading stopped", false, _loader.failed);
		}

		[Test (async)]
		public function booleanStateAfterLoad() : void
		{
			handleSignal(this, _loader.onComplete, onComplete_booleanStateAfterLoad_handler);
			_loader.start();
		}

		protected function onComplete_booleanStateAfterLoad_handler(event : SignalAsyncEvent, data : Object) : void
		{
			assertEquals(_loaderName + "#invoked state after loading completed", true, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state after loading completed", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after loading completed", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after loading completed", true, _loader.loaded);
			assertEquals(_loaderName + "#failed state after loading completed", false, _loader.failed);
		}

		[Test (async)]
		public function booleanStateAfterError() : void
		{
			// Change url to force error signal.
			_loader.request.url = _path + "DOES-NOT-EXIST.file";

			handleSignal(this, _loader.onError, onError_booleanStateAfterError_handler);
			_loader.start();
		}

		protected function onError_booleanStateAfterError_handler(event : SignalAsyncEvent, data : Object) : void
		{
			assertEquals(_loaderName + "#invoked state after loading error", true, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state after loading error", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after loading error", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after loading error", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state after loading error", true, _loader.failed);
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// SPECIAL PARAMS
		// --------------------------------------------------------------------------------------------------------------------------------//
		[Test]
		public function baseParamAdd() : void
		{
			var base : String = "http://www.matanuberstein.co.za/";
			_loader.setParam(Param.BASE, base);

			if(_hadRequest)
				assertEquals(_loaderName + "#request#url should be equal to BASE + _path", base + _path, _loader.request.url);

			assertEquals(_loaderName + " should retain the BASE value", base, _loader.getParam(Param.BASE));
		}

		[Test]
		public function preventCacheParamAdd() : void
		{
			_loader.setParam(Param.PREVENT_CACHE, true);

			if(_hadRequest)
				assertTrue(_loaderName + "#request#url should have the 'ck' url var added.", (_loader.request.url.indexOf("ck=") != -1));

			assertEquals(_loaderName + " should retain the PREVENT_CACHE value", true, _loader.getParam(Param.PREVENT_CACHE));
		}

		[Test]
		public function preventCacheParamRemove() : void
		{
			_loader.setParam(Param.PREVENT_CACHE, true);
			_loader.setParam(Param.PREVENT_CACHE, false);

			if(_hadRequest)
				assertEquals(_loaderName + "#request#url should equal to the original url", _path, _loader.request.url);

			assertEquals(_loaderName + " should retain the PREVENT_CACHE value", false, _loader.getParam(Param.PREVENT_CACHE));
		}

		[Test]
		public function weightParamAdd() : void
		{
			_loader.setParam(Param.WEIGHT, 1024);

			assertEquals(_loaderName + "#stats#bytesTotal should be equal to param value.", 1024, _loader.stats.bytesTotal);
			assertEquals(_loaderName + " should retain the WEIGHT value", 1024, _loader.getParam(Param.WEIGHT));
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// DESTROYING
		// --------------------------------------------------------------------------------------------------------------------------------//
		[Test]
		public function destroyBeforeLoad() : void
		{
			_loader.destroy();

			assertPostDestroy();
		}

		[Test (async)]
		public function destroyDuringLoad() : void
		{
			handleSignal(this, _loader.onOpen, onOpen_destroyDuringLoad_handler);
			_loader.start();
		}

		protected function onOpen_destroyDuringLoad_handler(event : SignalAsyncEvent, data : Object) : void
		{
			_loader.destroy();

			assertPostDestroy();
		}

		[Test (async)]
		public function destroyAfterLoad() : void
		{
			handleSignal(this, _loader.onComplete, onComplete_destroyAfterLoad_handler);
			_loader.start();
		}

		protected function onComplete_destroyAfterLoad_handler(event : SignalAsyncEvent, data : Object) : void
		{
			_loader.destroy();

			assertPostDestroy();
		}

		protected function assertPostDestroy() : void
		{
			/*assertEquals(_loaderName + "#onComplete#numListeners should be equal to 0", _loader.onComplete.numListeners, 0);
			assertEquals(_loaderName + "#onError#numListeners should be equal to 0", _loader.onError.numListeners, 0);
			assertEquals(_loaderName + "#onHttpStatus#numListeners should be equal to 0", _loader.onHttpStatus.numListeners, 0);
			assertEquals(_loaderName + "#onOpen#numListeners should be equal to 0", _loader.onOpen.numListeners, 0);
			assertEquals(_loaderName + "#onProgress#numListeners should be equal to 0", _loader.onProgress.numListeners, 0);*/

			assertNotNull(_loaderName + "#type should NOT be null after destroy", _loader.type);
			assertNotNull(_loaderName + "#params should NOT be null after destroy", _loader.params);

			assertNotNull(_loaderName + "#id should be NOT null after destroy", _loader.id);

			if(_hadRequest)
				assertNotNull(_loaderName + "#request should NOT be null after destroy", _loader.request);
			if(_hadParent)
				assertNotNull(_loaderName + "#parent should NOT be null after destroy", _loader.parent);

			assertNull(_loaderName + "#data should be null after destroy", _loader.data);
			assertNull(_loaderName + "#" + _payloadPropertyName + " should be null after destroy", _loader[_payloadPropertyName]);

			assertFalse(_loaderName + "#invoked should be false after destroy", _loader.invoked);
			assertFalse(_loaderName + "#inProgress should be false after destroy", _loader.inProgress);
			assertFalse(_loaderName + "#stopped should be false after destroy", _loader.stopped);
			assertFalse(_loaderName + "#loaded should be false after destroy", _loader.loaded);
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// STOPPING AND STARTING
		// --------------------------------------------------------------------------------------------------------------------------------//
		[Test (async)]
		public function stop() : void
		{
			_loader.start();
			_loader.stop();
			failOnSignal(this, _loader.onComplete);
			failOnSignal(this, _loader.onOpen);
			failOnSignal(this, _loader.onProgress);
			failOnSignal(this, _loader.onError);
		}

		[Test (async)]
		public function restartAfterStop() : void
		{
			handleSignal(this, _loader.onOpen, onOpen_restartAfterStop_handler);
			_loader.start();
		}

		protected function onOpen_restartAfterStop_handler(event : SignalAsyncEvent, data : Object) : void
		{
			_loader.stop();
			proceedOnSignal(this, _loader.onComplete);
			_loader.start();
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// SIGNALS
		// --------------------------------------------------------------------------------------------------------------------------------//

		[Test (async)]
		public function onCompleteSignal() : void
		{
			handleSignal(this, _loader.onComplete, onComplete_handler);
			_loader.start();
		}

		protected function onComplete_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));
			assertTrue("Argument 2 should be " + _payloadTypeName, (values[1] is _payloadType));

			var signal : LoaderSignal = values[0];

			assertNotNull("LoaderSignal#loader should NOT be null", signal.loader);
			assertNotNull("Second argument should NOT be null", values[1]);
			assertTrue("Second argument should be " + _payloadTypeName, (values[1] is _payloadType));

			assertNotNull(_loaderName + "#data should NOT be null", _loader.data);
			assertTrue(_loaderName + "#data should be " + _payloadTypeName, (_loader.data is _payloadType));

			assertNotNull(_loaderName + "#" + _payloadPropertyName + " should NOT be null", _loader[_payloadPropertyName]);
			assertTrue(_loaderName + "#" + _payloadPropertyName + " should be " + _payloadTypeName, (_loader[_payloadPropertyName] is _payloadType));

			assertEquals(_loaderName + "#data should be equal to " + _loaderName + "#" + _payloadPropertyName, _loader.data, _loader[_payloadPropertyName]);
		}
		
		[Test (async)]
		public function onStartSignal() : void
		{
			handleSignal(this, _loader.onStart, onStart_handler);
			_loader.start();
		}

		protected function onStart_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));

			var signal : LoaderSignal = values[0];
			assertNotNull("LoaderSignal#loader should NOT be null", signal.loader);
			
			assertEquals(_loaderName + "#invoked state within onStart handler", true, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state within onStart handler", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state within onStart handler", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state within onStart handler", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state within onStart handler", false, _loader.failed);
		}
		
		[Test (async)]
		public function onStoptSignal() : void
		{
			handleSignal(this, _loader.onStop, onStop_handler);
			_loader.start();
			_loader.stop();
		}

		protected function onStop_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));

			var signal : LoaderSignal = values[0];
			assertNotNull("LoaderSignal#loader should NOT be null", signal.loader);
			
			assertEquals(_loaderName + "#invoked state within onStop handler", true, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state within onStop handler", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state within onStop handler", true, _loader.stopped);
			assertEquals(_loaderName + "#loaded state within onStop handler", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state within onStop handler", false, _loader.failed);
		}

		[Test (async)]
		public function onAddedToParentSignal() : void
		{
			var assetloader : IAssetLoader = new AssetLoader();
			handleSignal(this, _loader.onAddedToParent, onAddedToParent_handler);
			assetloader.addLoader(_loader);
		}

		protected function onAddedToParent_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));
			assertTrue("Argument 2 should be IAssetLoader", (values[1] is IAssetLoader));

			var signal : LoaderSignal = values[0];
			assertNotNull("LoaderSignal#loader should NOT be null", signal.loader);

			assertNotNull(_loaderName + "#parent should NOT be null", _loader.parent);
		}

		[Test (async)]
		public function onRemovedFromParentSignal() : void
		{
			var assetloader : IAssetLoader = new AssetLoader();
			assetloader.addLoader(_loader);
			handleSignal(this, _loader.onRemovedFromParent, onRemovedFromParent_handler);
			assetloader.remove(_id);
		}

		protected function onRemovedFromParent_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));
			assertTrue("Argument 2 should be IAssetLoader", (values[1] is IAssetLoader));

			var signal : LoaderSignal = values[0];
			assertNotNull("LoaderSignal#loader should NOT be null", signal.loader);

			assertNull(_loaderName + "#parent should be null", _loader.parent);
		}

		[Test (async)]
		public function onHttpStatusSignal() : void
		{
			handleSignal(this, _loader.onHttpStatus, onHttpStatus_handler);
			_loader.start();
		}

		protected function onHttpStatus_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be HttpStatusSignal", (values[0] is HttpStatusSignal));

			var signal : HttpStatusSignal = values[0];
			assertNotNull("HttpStatusSignal#loader should NOT be null", signal.loader);
			assertNotNull("HttpStatusSignal#status should NOT be null", signal.status);
		}

		[Test (async)]
		public function onOpenSignal() : void
		{
			handleSignal(this, _loader.onOpen, onOpen_handler);
			_loader.start();
		}

		protected function onOpen_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));

			var signal : LoaderSignal = values[0];
			assertNotNull("LoaderSignal#loader should NOT be null", signal.loader);
		}

		[Test (async)]
		public function onProgressSignal() : void
		{
			handleSignal(this, _loader.onProgress, onProgress_handler);
			_loader.start();
		}

		protected function onProgress_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be ProgressSignal", (values[0] is ProgressSignal));

			var signal : ProgressSignal = values[0];
			assertNotNull("ProgressSignal#loader should NOT be null", signal.loader);

			assertTrue("ProgressSignal#latency should be more or equal than 0", signal.latency >= 0);
			assertTrue("ProgressSignal#speed should be more or equal than 0", signal.speed >= 0);
			assertTrue("ProgressSignal#averageSpeed should be more or equal than 0", signal.averageSpeed >= 0);

			assertTrue("ProgressSignal#progress should be more or equal than 0", signal.progress >= 0);
			assertTrue("ProgressSignal#bytesLoaded should be more or equal than 0", signal.bytesLoaded >= 0);
			assertTrue("ProgressSignal#bytesTotal should be more than 0", signal.bytesTotal);
		}

		[Test (async)]
		public function onErrorSignalIntended() : void
		{
			// Change url to force error signal.
			_loader.request.url = _path + "DOES-NOT-EXIST.file";

			handleSignal(this, _loader.onError, onErrorIntended_handler);

			_loader.start();
		}

		protected function onErrorIntended_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be ErrorSignal", (values[0] is ErrorSignal));

			var signal : ErrorSignal = values[0];
			assertNotNull("ErrorSignal#loader should NOT be null", signal.loader);
			assertNotNull("ErrorSignal#type should NOT be null", signal.type);
			assertNotNull("ErrorSignal#message should NOT be null", signal.message);
		}

		[Test (async)]
		public function onErrorSignal() : void
		{
			_loader.onError.add(onError_handler);
			failOnSignal(this, _loader.onError);
			_loader.start();
		}

		protected function onError_handler(signal : ErrorSignal) : void
		{
			fail("Error [type: " + signal.type + "] | [message: " + signal.message + "]");
		}
	}
}
