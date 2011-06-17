package org.assetloader
{
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	import org.assetloader.loaders.BaseLoaderTest;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.failOnSignal;
	import org.osflash.signals.utils.handleSignal;

	import flash.utils.Dictionary;

	/**
	 * @author Matan Uberstein
	 */
	public class AssetLoaderTest extends BaseLoaderTest
	{
		protected var _assetloader : IAssetLoader;

		[Before]
		override public function runBeforeEachTest() : void
		{
			_loaderName = "AssetLoader";
			_payloadType = Dictionary;
			_payloadTypeName = "Dictionary";
			_payloadPropertyName = "data";
			_type = AssetType.GROUP;

			_id = "PrimaryLoaderGroup";

			_loader = _assetloader = new AssetLoader(_id);
			_assetloader.setParam(Param.BASE, _path);

			_assetloader.addLazy("id-01", "testCSS.css");
			_assetloader.addLazy("id-02", "testIMAGE.png");
			_assetloader.addLazy("id-03", "testJSON.json");
			_assetloader.addLazy("id-04", "testSOUND.mp3");
			_assetloader.addLazy("id-05", "testSWF.swf");
			_assetloader.addLazy("id-06", "testTXT.txt");
			_assetloader.addLazy("id-07", "testVIDEO.flv");
			_assetloader.addLazy("id-08", "testXML.xml");
			_assetloader.addLazy("id-09", "testZIP.zip");
		}

		[Test]
		override public function implementing() : void
		{
			super.implementing();
			assertTrue("AssetLoader should implement IAssetLoader", _loader is IAssetLoader);
		}

		[Test]
		override public function signalsReadyOnConstruction() : void
		{
			super.signalsReadyOnConstruction();
			assertNotNull(_loaderName + "#onChildOpen be should NOT be null after construction", _assetloader.onChildOpen);
			assertNotNull(_loaderName + "#onChildComplete be should NOT be null after construction", _assetloader.onChildComplete);
			assertNotNull(_loaderName + "#onChildError be should NOT be null after construction", _assetloader.onChildError);
			assertNotNull(_loaderName + "#onConfigLoaded be should NOT be null after construction", _assetloader.onConfigLoaded);
		}
		
		[Test (async)]
		override public function booleanStateAfterError() : void
		{
			// Change url to force error signal.
			_assetloader.getLoader("id-01").request.url = _path + "DOES-NOT-EXIST.file";
			
			handleSignal(this, _loader.onError, onError_booleanStateAfterError_handler);
			_loader.start();
		}
		
		override protected function onError_booleanStateAfterError_handler(event : SignalAsyncEvent, data : Object) : void
		{
			assertEquals(_loaderName + "#invoked state after loading error", true, _loader.invoked);
			// inProgress will be true for this IAssetLoader, because it will still continue loader the other assets.
			assertEquals(_loaderName + "#inProgress state after loading error", true, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after loading error", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after loading error", false, _loader.loaded);
			// although the not all the child loader have failed, failed is flaged is true. Loosing one asset should be seen as failure.
			assertEquals(_loaderName + "#failed state after loading error", true, _loader.failed);
		}

		[Test (async)]
		public function onChildCompleteSignal() : void
		{
			handleSignal(this, _assetloader.onChildComplete, onChildCompleteSignal_handler);
			_assetloader.start();
		}

		protected function onChildCompleteSignal_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));
			assertTrue("Argument 2 should be ILoader", (values[1] is ILoader));

			var signal : LoaderSignal = values[0];

			assertNotNull("LoaderSignal#loader should NOT be null", signal.loader);
		}

		[Test (async)]
		public function onChildOpenSignal() : void
		{
			handleSignal(this, _assetloader.onChildOpen, onChildOpen_handler);
			_loader.start();
		}

		protected function onChildOpen_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));
			assertTrue("Argument 2 should be ILoader", (values[1] is ILoader));

			var signal : LoaderSignal = values[0];
			assertNotNull("LoaderSignal#loader should NOT be null", signal.loader);
		}

		[Test (async)]
		override public function onErrorSignalIntended() : void
		{
			// Change url to force error signal.
			_assetloader.getLoader("id-01").request.url = _path + "DOES-NOT-EXIST.file";

			handleSignal(this, _assetloader.onError, onErrorIntended_handler);

			_loader.start();
		}

		override protected function onErrorIntended_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be ErrorSignal", (values[0] is ErrorSignal));
			var signal : ErrorSignal = values[0];
			assertNotNull("ErrorSignal#loader should NOT be null", signal.loader);
			assertNotNull("ErrorSignal#type should NOT be null", signal.type);
			assertNotNull("ErrorSignal#message should NOT be null", signal.message);
		}

		[Test (async)]
		public function onChildErrorSignal() : void
		{
			_assetloader.onChildError.add(onChildErrorSignal_handler);
			failOnSignal(this, _assetloader.onChildError);
			_assetloader.start();
		}

		protected function onChildErrorSignal_handler(signal : ErrorSignal, data : *) : void
		{
			fail("Error [type: " + signal.type + "] | [message: " + signal.message + "]");
		}

		[Test (async)]
		public function onChildErrorSignalIntended() : void
		{
			// Change url to force error signal.
			_assetloader.getLoader("id-01").request.url = _path + "DOES-NOT-EXIST.file";

			handleSignal(this, _assetloader.onChildError, onChildErrorSignalIntended_handler);

			_assetloader.start();
		}

		protected function onChildErrorSignalIntended_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be ErrorSignal", (values[0] is ErrorSignal));
			assertTrue("Argument 2 should be ILoader", (values[1] is ILoader));

			var signal : ErrorSignal = values[0];
			assertNotNull("ErrorSignal#loader should NOT be null", signal.loader);
			assertNotNull("ErrorSignal#type should NOT be null", signal.type);
			assertNotNull("ErrorSignal#message should NOT be null", signal.message);
		}

		[Test (async)]
		override public function onHttpStatusSignal() : void
		{
			failOnSignal(this, _loader.onHttpStatus);
			_loader.start();
		}

		[Test (async)]
		public function onConfigLoadedSignal() : void
		{
			handleSignal(this, _assetloader.onConfigLoaded, onConfigLoadedSignal_handler);
			_assetloader.addConfig(_path + "testXML.xml");
		}

		protected function onConfigLoadedSignal_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));

			var signal : LoaderSignal = values[0];
			assertNotNull("LoaderSignal#loader should NOT be null", signal.loader);
		}
		
		[Test (async)]
		public function onCompleteSignalWithError() : void
		{
			// Change url to force error signal.
			_assetloader.getLoader("id-01").request.url = _path + "DOES-NOT-EXIST.file";
			
			// onComplete must dispatch regardless of child error
			handleSignal(this, _loader.onComplete, onComplete_handler);
			_loader.start();
		}

		protected function onCompleteWithError_handler(event : SignalAsyncEvent, data : Object) : void
		{
			super.onComplete_handler(event, data);
			assertEquals(_loaderName + "#loaded state after loading complete with error", true, _loader.loaded);
			assertEquals(_loaderName + "#failed state after loading complete with error", true, _loader.failed);
		}
		
		[Test (async)]
		public function onCompleteSignalWithErrorAndFailOnErrorSetToTrue() : void
		{
			// Change url to force error signal.
			_assetloader.getLoader("id-01").request.url = _path + "DOES-NOT-EXIST.file";
			
			_assetloader.failOnError = true;
			
			// onComplete must NOT dispatch, because flag is set to true.
			failOnSignal(this, _loader.onComplete);
			_loader.start();
		}
	}
}
