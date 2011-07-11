package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.failOnSignal;
	import org.osflash.signals.utils.handleSignal;

	import flash.media.Sound;
	import flash.net.URLRequest;

	public class SoundLoaderTest extends BaseLoaderTest
	{
		[Before]
		override public function runBeforeEachTest() : void
		{
			super.runBeforeEachTest();

			_loaderName = "SoundLoader";
			_payloadType = Sound;
			_payloadTypeName = "Sound";
			_payloadPropertyName = "sound";
			_path += "testSOUND.mp3";
			_type = AssetType.SOUND;

			_loader = new SoundLoader(new URLRequest(_path), _id);
		}

		// NON - STANDARD - LOADER - TESTS -------------------------------------------------------------------------------------------//
		[Test]
		override public function signalsReadyOnConstruction() : void
		{
			super.signalsReadyOnConstruction();
			assertNotNull(_loaderName + "#onReady should NOT be null after construction", SoundLoader(_loader).onId3);
			assertNotNull(_loaderName + "#onId3 should NOT be null after construction", SoundLoader(_loader).onReady );
		}

		[Test (async)]
		public function onId3Signal() : void
		{
			// Make sure that the mp3 loaded has ID3 data, otherwise this test will fail.
			handleSignal(this, SoundLoader(_loader).onId3, onId3_handler);
			_loader.start();
		}

		protected function onId3_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));

			var signal : LoaderSignal = values[0];
			assertNotNull("LoaderSignal#loader should NOT be null", signal.loader);
		}

		[Test (async)]
		public function onReadySignal() : void
		{
			handleSignal(this, SoundLoader(_loader).onReady, onReady_handler);
			_loader.start();
		}

		protected function onReady_handler(event : SignalAsyncEvent, data : Object) : void
		{
			var values : Array = event.args;
			assertTrue("Argument 1 should be LoaderSignal", (values[0] is LoaderSignal));
			assertTrue("Argument 2 should be Sound", (values[1] is Sound));

			var signal : LoaderSignal = values[0];
			assertNotNull("LoaderSignal#loader should NOT be null", signal.loader);
		}

		override protected function assertPostDestroy() : void
		{
			super.assertPostDestroy();
			assertEquals(_loaderName + "#onId3#numListeners should be equal to 0", SoundLoader(_loader).onId3.numListeners, 0);
		}

		// SOUND LOADER DOES NOT DISPATCH HTTP STATUS SIGNAL
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
			failOnSignal(this, SoundLoader(_loader).onId3);
		}
	}
}
