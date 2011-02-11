package org.assetloader.base
{
	import org.assetloader.AssetLoader;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	import org.assetloader.loaders.ImageLoader;
	import org.assetloader.loaders.TextLoader;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;

	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class AssetLoaderErrorTest
	{
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
		}

		[After]
		public function runAfterEachTest() : void
		{
		}

		[Test]
		public function invalidUrl_EmptyUrl() : void
		{
			var factory : LoaderFactory = new LoaderFactory();
			try
			{
				factory.produce("test-id", AssetType.IMAGE, new URLRequest(""));
			}
			catch(error : AssetLoaderError)
			{
				assertTrue("error is AssetLoaderError", (error is AssetLoaderError));
				assertEquals("error message should be", new AssetLoaderError(AssetLoaderError.INVALID_URL).message, error.message);
				return;
			}
			fail("Error was NOT catched.");
		}

		[Test]
		public function invalidUrl_NullUrl() : void
		{
			var factory : LoaderFactory = new LoaderFactory();
			try
			{
				factory.produce("test-id", AssetType.IMAGE, new URLRequest());
			}
			catch(error : AssetLoaderError)
			{
				assertTrue("error is AssetLoaderError", (error is AssetLoaderError));
				assertEquals("error message", new AssetLoaderError(AssetLoaderError.INVALID_URL).message, error.message);
				return;
			}
			fail("Error was NOT catched.");
		}

		[Test]
		public function assetAutoTypeRecognized() : void
		{
			var factory : LoaderFactory = new LoaderFactory();
			try
			{
				factory.produce("test-id", "HERP-DERP-ASSET-TYPE", new URLRequest("someFile.jpg"));
			}
			catch(error : AssetLoaderError)
			{
				assertTrue("error is AssetLoaderError", (error is AssetLoaderError));
				assertEquals("error message", new AssetLoaderError(AssetLoaderError.ASSET_TYPE_NOT_RECOGNIZED).message, error.message);
				return;
			}
			fail("Error was NOT catched.");
		}

		[Test]
		public function assetAutoTypeNotFound_WeirdExtension() : void
		{
			var factory : LoaderFactory = new LoaderFactory();
			try
			{
				factory.produce("test-id", AssetType.AUTO, new URLRequest("someFileWith.weirdExtension"));
			}
			catch(error : AssetLoaderError)
			{
				assertTrue("error is AssetLoaderError", (error is AssetLoaderError));
				assertEquals("error message", new AssetLoaderError(AssetLoaderError.ASSET_AUTO_TYPE_NOT_FOUND).message, error.message);
				return;
			}
			fail("Error was NOT catched.");
		}

		[Test]
		public function couldNotParseConfig() : void
		{
			var assetloader : IAssetLoader = new AssetLoader();
			try
			{
				assetloader.addConfig("<loader></brokentag></loader>");
			}
			catch(error : AssetLoaderError)
			{
				assertTrue("error is AssetLoaderError", (error is AssetLoaderError));
				assertEquals("error message", new AssetLoaderError(AssetLoaderError.COULD_NOT_PARSE_CONFIG(assetloader.id, 'Error #1085: The element type "loader" must be terminated by the matching end-tag "</loader>".')).message, error.message);
				return;
			}
			fail("Error was NOT catched.");
		}

		[Test]
		public function alreadyContainsLoaderWithId() : void
		{
			var assetloader : IAssetLoader = new AssetLoader();
			try
			{
				assetloader.addLazy("test-id", "sampleTXT.txt");
				assetloader.addLazy("test-id", "sampleTXT2.txt");
			}
			catch(error : AssetLoaderError)
			{
				assertTrue("error is AssetLoaderError", (error is AssetLoaderError));
				assertEquals("error message", new AssetLoaderError(AssetLoaderError.ALREADY_CONTAINS_LOADER_WITH_ID(assetloader.id, "test-id")).message, error.message);
				return;
			}
			fail("Error was NOT catched.");
		}

		[Test]
		public function circularReferenceFound_00() : void
		{
			var g1 : IAssetLoader = new AssetLoader("g1");

			try
			{
				g1.addLoader(g1);
			}
			catch(error : AssetLoaderError)
			{
				assertTrue("error is AssetLoaderError", (error is AssetLoaderError));
				assertEquals("error message", new AssetLoaderError(AssetLoaderError.CIRCULAR_REFERENCE_FOUND(g1.id)).message, error.message);
				return;
			}
			fail("Error was NOT catched.");
		}

		[Test]
		public function circularReferenceFound_01() : void
		{
			var g1 : IAssetLoader = new AssetLoader("g1");
			var g2 : IAssetLoader = new AssetLoader("g2");

			g1.addLoader(g2);

			try
			{
				g2.addLoader(g1);
			}
			catch(error : AssetLoaderError)
			{
				assertTrue("error is AssetLoaderError", (error is AssetLoaderError));
				assertEquals("error message", new AssetLoaderError(AssetLoaderError.CIRCULAR_REFERENCE_FOUND(g1.id)).message, error.message);
				return;
			}
			fail("Error was NOT catched.");
		}

		[Test]
		public function circularReferenceFound_02() : void
		{
			var g1 : IAssetLoader = new AssetLoader("g1");
			var g2 : IAssetLoader = new AssetLoader("g2");
			var g3 : IAssetLoader = new AssetLoader("g3");

			g1.addLoader(g2);
			g2.addLoader(g3);

			try
			{
				g3.addLoader(g1);
			}
			catch(error : AssetLoaderError)
			{
				assertTrue("error is AssetLoaderError", (error is AssetLoaderError));
				assertEquals("error message", new AssetLoaderError(AssetLoaderError.CIRCULAR_REFERENCE_FOUND(g1.id)).message, error.message);
				return;
			}
			fail("Error was NOT catched.");
		}

		[Test]
		public function alreadyContainedByOther() : void
		{
			var g1 : IAssetLoader = new AssetLoader("g1");
			var g2 : IAssetLoader = new AssetLoader("g2");
			var l1 : ILoader = new TextLoader(new URLRequest("sampleTXT.txt"));

			g1.addLoader(l1);

			try
			{
				g2.addLoader(l1);
			}
			catch(error : AssetLoaderError)
			{
				assertTrue("error is AssetLoaderError", (error is AssetLoaderError));
				assertEquals("error message", new AssetLoaderError(AssetLoaderError.ALREADY_CONTAINED_BY_OTHER(l1.id, g1.id)).message, error.message);
				return;
			}
			fail("Error was NOT catched.");
		}

		[Test]
		public function alreadyContainsLoader() : void
		{
			var monitor : StatsMonitor = new StatsMonitor();
			var l1 : ILoader = new TextLoader(new URLRequest("assets/test/testTXT.txt"));
			var l2 : ILoader = new ImageLoader(new URLRequest("assets/test/testIMAGE.png"));
			try
			{
				monitor.add(l1);
				monitor.add(l2);
				// Adding l2 twice to produce error.
				monitor.add(l2);
			}
			catch(error : AssetLoaderError)
			{
				assertTrue("error is AssetLoaderError", (error is AssetLoaderError));
				assertEquals("error message", new AssetLoaderError(AssetLoaderError.ALREADY_CONTAINS_LOADER).message, error.message);
				return;
			}
			fail("Error was NOT catched.");
		}

		[Test]
		public function doesNotContainLoader() : void
		{
			var monitor : StatsMonitor = new StatsMonitor();
			var l1 : ILoader = new TextLoader(new URLRequest("assets/test/testTXT.txt"));
			var l2 : ILoader = new ImageLoader(new URLRequest("assets/test/testIMAGE.png"));
			
			monitor.add(l1);
			try
			{
				//Remove l2 which was never added.
				monitor.remove(l2);
			}
			catch(error : AssetLoaderError)
			{
				assertTrue("error is AssetLoaderError", (error is AssetLoaderError));
				assertEquals("error message", new AssetLoaderError(AssetLoaderError.DOESNT_CONTAIN_LOADER).message, error.message);
				return;
			}
			fail("Error was NOT catched.");
		}
	}
}
