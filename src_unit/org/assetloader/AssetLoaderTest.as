package org.assetloader
{
	import org.assetloader.base.AssetType;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	import org.assetloader.loaders.BaseLoaderTest;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
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

			_hadId = false;

			_loader = _assetloader = new AssetLoader();
			_assetloader.base = _path;

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
			assertNotNull(_loaderName + "#onChildComplete be should NOT be null after construction", _assetloader.onChildComplete);
			assertNotNull(_loaderName + "#onChildError be should NOT be null after construction", _assetloader.onChildError);
			assertNotNull(_loaderName + "#onConfigLoaded be should NOT be null after construction", _assetloader.onConfigLoaded);
		}

		[Test]
		public function idShouldBeNullIfPrimary() : void
		{
			assertNull(_loaderName + "#id should be null, if it's the primary loader", _assetloader.id);
			assertNull(_loaderName + "#parent should be null, if it's the primary loader", _assetloader.parent);
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
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));			assertTrue("Argument 2 should be ILoader", (values[1] is ILoader));

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

			handleSignal(this, _assetloader.onChildError, onErrorIntended_handler);

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
	}
}
