package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.signals.NetStatusSignal;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.failOnSignal;
	import org.osflash.signals.utils.handleSignal;

	import flash.net.NetStream;
	import flash.net.URLRequest;

	public class VideoLoaderTest extends BaseLoaderTest
	{
		[Before]
		override public function runBeforeEachTest() : void
		{
			super.runBeforeEachTest();

			_loaderName = "VideoLoader";
			_payloadType = NetStream;
			_payloadTypeName = "NetStream";
			_payloadPropertyName = "netStream";
			// Make sure video is an FLV, flash player does not allow local loading of mp4 file format.
			_path += "testVIDEO.flv";
			_type = AssetType.VIDEO;

			_loader = new VideoLoader(new URLRequest(_path), _id);
		}

		// NON - STANDARD - LOADER - TESTS -------------------------------------------------------------------------------------------//
		[Test]
		override public function signalsReadyOnConstruction() : void
		{
			assertNotNull(_loaderName + "#onNetStatus should NOT be null after construction", VideoLoader(_loader).onNetStatus);
			assertNotNull(_loaderName + "#onReady should NOT be null after construction", VideoLoader(_loader).onReady);
		}

		[Test (async)]
		public function onNetStatusSignal() : void
		{
			handleSignal(this, VideoLoader(_loader).onNetStatus, onNetStatus_handler);
			_loader.start();
		}

		protected function onNetStatus_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is NetStatusSignal));

			var signal : NetStatusSignal = values[0];
			assertNotNull("NetStatusSignal#loader should NOT be null", signal.loader);
			assertNotNull("NetStatusSignal#info should NOT be null", signal.info);
		}

		[Test (async)]
		public function onReadySignal() : void
		{
			handleSignal(this, VideoLoader(_loader).onReady, onReady_handler);
			_loader.start();
		}

		protected function onReady_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));

			var signal : LoaderSignal = values[0];
			assertNotNull("LoaderSignal#loader should NOT be null", signal.loader);
		}

		override protected function assertPostDestroy() : void
		{
			super.assertPostDestroy();
			assertEquals(_loaderName + "#onNetStatus#numListeners should be equal to 0", VideoLoader(_loader).onNetStatus.numListeners, 0);
			assertEquals(_loaderName + "#onReady#numListeners should be equal to 0", VideoLoader(_loader).onReady.numListeners, 0);
		}

		// VIDEO LOADER DOES NOT DISPATCH HTTP STATUS SIGNAL
		[Test (async)]
		override public function onHttpStatusSignal() : void
		{
			failOnSignal(this, _loader.onHttpStatus);
			_loader.start();
		}

		[Test (async)]
		override public function stop() : void
		{
			super.stop();
			failOnSignal(this, VideoLoader(_loader).onNetStatus);			failOnSignal(this, VideoLoader(_loader).onReady);
		}
	}
}
