package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.handleSignal;

	import flash.display.Sprite;
	import flash.net.URLRequest;

	public class SWFLoaderTest extends BaseLoaderTest
	{
		[Before]
		override public function runBeforeEachTest() : void
		{
			super.runBeforeEachTest();

			_loaderName = "SWFLoader";
			_payloadType = Sprite;
			_payloadTypeName = "Sprite";
			_payloadPropertyName = "swf";
			_path += "testSWF.swf";
			_type = AssetType.SWF;

			_loader = new SWFLoader(new URLRequest(_path), _id);
		}
		
		// NON - STANDARD - LOADER - TESTS -------------------------------------------------------------------------------------------//
		[Test]
		override public function signalsReadyOnConstruction() : void
		{
			super.signalsReadyOnConstruction();
			assertNotNull(_loaderName + "#onInit should NOT be null after construction", SWFLoader(_loader).onInit);
		}

		[Test (async)]
		public function onInitSignal() : void
		{
			// Make sure that the mp3 loaded has ID3 data, otherwise this test will fail.
			handleSignal(this, SWFLoader(_loader).onInit, onInit_handler);
			_loader.start();
		}

		protected function onInit_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));

			var signal : LoaderSignal = values[0];
			assertNotNull("LoaderSignal#loader should NOT be null", signal.loader);
		}
		
		override protected function assertPostDestroy() : void
		{
			super.assertPostDestroy();
			assertEquals(_loaderName + "#onInit#numListeners should be equal to 0", SWFLoader(_loader).onInit.numListeners, 0);
		}
	}
}
