package org.assetloader.base
{
	import org.assetloader.AssetLoader;
	import org.assetloader.loaders.TextLoader;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;

	import flash.net.URLRequest;

	public class AssetLoaderQueueTest
	{
		protected var _path : String = "test/testTXT.txt";
		protected var _id : String = "test-id-";

		protected var _assetloader : AssetLoader;

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
			_assetloader = new AssetLoader();
		}

		[After]
		public function runAfterEachTest() : void
		{
			_assetloader = null;
		}

		[Test]
		public function addingToQueue() : void
		{
			_assetloader.addLoader(new TextLoader(_id + 1, new URLRequest(_path), _assetloader));

			assertNotNull("AssetLoader#add should return the ILoader produced", _assetloader.add(_id + 2, new URLRequest(_path)));

			assertNotNull("AssetLoader#addLazy should return the ILoader produced", _assetloader.addLazy(_id + 3, _path));

			assertEquals("AssetLoader#numLoaders should be equal to 3", _assetloader.numLoaders, 3);
			assertEquals("AssetLoader#ids length should be equal to 3", _assetloader.ids.length, 3);
			
			assertTrue("AssetLoader#hasLoader should be true", (_assetloader.hasLoader(_id + 1)));			assertTrue("AssetLoader#hasLoader should be true", (_assetloader.hasLoader(_id + 2)));			assertTrue("AssetLoader#hasLoader should be true", (_assetloader.hasLoader(_id + 3)));
			
			assertNotNull("AssetLoader#getLoader should NOT be null", (_assetloader.getLoader(_id + 1)));			assertNotNull("AssetLoader#getLoader should NOT be null", (_assetloader.getLoader(_id + 2)));			assertNotNull("AssetLoader#getLoader should NOT be null", (_assetloader.getLoader(_id + 3)));
		}
		
		[Test]
		public function removingFromQueue() : void
		{
			buildQueue();
			
			assertNotNull("AssetLoader#remove should return the loader removed from the queue", _assetloader.remove(_id + 1));
			assertEquals("AssetLoader#numLoaders should be equal to 2", _assetloader.numLoaders, 2);
			assertEquals("AssetLoader#ids length should be equal to 2", _assetloader.ids.length, 2);
			assertFalse("AssetLoader#hasLoader should be true", (_assetloader.hasLoader(_id + 1)));
			assertNull("AssetLoader#getLoader should be null", (_assetloader.getLoader(_id + 1)));
			
			assertNotNull("AssetLoader#remove should return the loader removed from the queue", _assetloader.remove(_id + 2));
			assertEquals("AssetLoader#numLoaders should be equal to 1", _assetloader.numLoaders, 1);
			assertEquals("AssetLoader#ids length should be equal to 1", _assetloader.ids.length, 1);
			assertFalse("AssetLoader#hasLoader should be true", (_assetloader.hasLoader(_id + 1)));
			assertNull("AssetLoader#getLoader should be null", (_assetloader.getLoader(_id + 1)));
			
			assertNotNull("AssetLoader#remove should return the loader removed from the queue", _assetloader.remove(_id + 3));
			assertEquals("AssetLoader#numLoaders should be equal to 0", _assetloader.numLoaders, 0);
			assertEquals("AssetLoader#ids length should be equal to 0", _assetloader.ids.length, 0);
			assertFalse("AssetLoader#hasLoader should be true", (_assetloader.hasLoader(_id + 3)));
			assertNull("AssetLoader#getLoader should be null", (_assetloader.getLoader(_id + 3)));
		}
		
		[Test]
		public function destroyQueue() : void
		{
			buildQueue();
			
			_assetloader.destroy();
			
			assertFalse("AssetLoader#hasLoader should be true", (_assetloader.hasLoader(_id + 1)));
			assertNull("AssetLoader#getLoader should be null", (_assetloader.getLoader(_id + 1)));
			
			assertFalse("AssetLoader#hasLoader should be true", (_assetloader.hasLoader(_id + 1)));
			assertNull("AssetLoader#getLoader should be null", (_assetloader.getLoader(_id + 1)));
			
			assertFalse("AssetLoader#hasLoader should be true", (_assetloader.hasLoader(_id + 3)));
			assertNull("AssetLoader#getLoader should be null", (_assetloader.getLoader(_id + 3)));
		}
		
		protected function buildQueue() : void
		{
			_assetloader.addLoader(new TextLoader(_id + 1, new URLRequest(_path), _assetloader));
			_assetloader.add(_id + 2, new URLRequest(_path));
			_assetloader.addLazy(_id + 3, _path);
		}
	}
}
