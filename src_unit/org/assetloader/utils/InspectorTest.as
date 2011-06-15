package org.assetloader.utils
{
	import org.assetloader.loaders.SWFLoader;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.handleSignal;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.text.Font;

	public class InspectorTest
	{
		protected var _loader : SWFLoader;
		protected var _inspector : Inspector;
		protected var _basePackage : String = "org.assetloader.assets";

		[BeforeClass]
		public static function runBeforeEntireSuite() : void
		{
		}

		[AfterClass]
		public static function runAfterEntireSuite() : void
		{
		}

		[Before(async)]
		public function runBeforeEachTest() : void
		{
			_loader = new SWFLoader(new URLRequest("assets/InspectorTestAssets.swf"));
			handleSignal(this, _loader.onComplete, loader_onComplete_handler);
			_loader.start();
		}

		protected function loader_onComplete_handler(event : SignalAsyncEvent, data : Object) : void
		{
			_inspector = new Inspector(_loader.data);
			_inspector.basePackage = _basePackage;
		}

		[After]
		public function runAfterEachTest() : void
		{
			_loader.destroy();
			_loader = null;
		}

		[Test]
		public function retainsBasePackage() : void
		{
			assertEquals("Should retain #basePackage", _basePackage, _inspector.basePackage);
		}

		[Test]
		public function getClass() : void
		{
			var data : * = _inspector.getClass("FontAsset");
			assertNotNull(_basePackage + ".FontAsset should not be null.", data);
			assertTrue(_basePackage + ".FontAsset should be of type Class.", data is Class);
		}
		
		[Test]
		public function getClassInvalid() : void
		{
			var data : * = _inspector.getClass("asset.FontAsset");
			assertNull(_basePackage + "assets.FontAsset should be null.", data);
		}
		
		[Test]
		public function getClassOverride() : void
		{
			var data : * = _inspector.getClass("DoesFlashAsset", "com.doesflash.assets");
			assertNotNull("com.doesflash.assets.DoesFlashAsset should not be null.", data);
			assertTrue("com.doesflash.assets.DoesFlashAsset should be of type Sprite.", data is Class);
		}
		
		[Test]
		public function getClassInvalidOverride() : void
		{
			var data : * = _inspector.getClass("assets.DoesFlashAsset", "com.doesflash.assets");
			assertNull("com.doesflash.assets.DoesFlashAsset should be null.", data);
		}

		[Test]
		public function getSprite() : void
		{
			var data : * = _inspector.getSprite("SpriteAsset");
			assertNotNull(_basePackage + ".SpriteAsset should not be null.", data);
			assertTrue(_basePackage + ".SpriteAsset should be of type Sprite.", data is Sprite);
		}

		[Test]
		public function getMovieClip() : void
		{
			var data : * = _inspector.getMovieClip("MovieClipAsset");
			assertNotNull(_basePackage + ".MovieClipAsset should not be null.", data);
			assertTrue(_basePackage + ".MovieClipAsset should be of type MovieClip.", data is MovieClip);
		}

		[Test]
		public function getFont() : void
		{
			var data : * = _inspector.getFont("FontAsset");
			assertNotNull(_basePackage + ".FontAsset should not be null.", data);
			assertTrue(_basePackage + ".FontAsset should be of type Font.", data is Font);
		}

		[Test]
		public function getSound() : void
		{
			var data : * = _inspector.getSound("SoundAsset");
			assertNotNull(_basePackage + ".SoundAsset should not be null.", data);
			assertTrue(_basePackage + ".SoundAsset should be of type Sound.", data is Sound);
		}

		[Test]
		public function getBitmapData() : void
		{
			var data : * = _inspector.getBitmapData("BitmapDataAsset");
			assertNotNull(_basePackage + ".BitmapDataAsset should not be null.", data);
			assertTrue(_basePackage + ".BitmapDataAsset should be of type BitmapData.", data is BitmapData);
		}

		[Test]
		public function getBitmap() : void
		{
			var data : * = _inspector.getBitmap("BitmapDataAsset");
			assertNotNull(_basePackage + ".BitmapDataAsset should not be null.", data);
			assertTrue(_basePackage + ".BitmapDataAsset should be of type Bitmap.", data is Bitmap);
		}
	}
}
