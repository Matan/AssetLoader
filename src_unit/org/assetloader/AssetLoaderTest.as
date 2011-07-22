package org.assetloader
{
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.base.StatsMonitor;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	import org.assetloader.loaders.BaseLoaderTest;
	import org.assetloader.loaders.TextLoader;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.failOnSignal;
	import org.osflash.signals.utils.handleSignal;
	import org.osflash.signals.utils.proceedOnSignal;

	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * @author Matan Uberstein
	 */
	public class AssetLoaderTest extends BaseLoaderTest
	{
		protected var _assetloader : IAssetLoader;
		protected var _foreignLoader : ILoader;

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

		[After]
		override public function runAfterEachTest() : void
		{
			super.runAfterEachTest();

			if(_foreignLoader)
			{
				_foreignLoader.destroy();
				_foreignLoader = null;
			}
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

		// --------------------------------------------------------------------------------------------------------------------------------//
		// BOOLEAN
		// --------------------------------------------------------------------------------------------------------------------------------//
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

		// --------------------------------------------------------------------------------------------------------------------------------//
		// STATE
		// --------------------------------------------------------------------------------------------------------------------------------//
		[Test]
		public function stateAfterAdd() : void
		{
			assertNotNull(_loaderName + "#ids should not be null", _assetloader.ids);
			assertNotNull(_loaderName + "#loadedIds should not be null", _assetloader.loadedIds);
			assertNotNull(_loaderName + "#failedIds should not be null", _assetloader.failedIds);

			assertEquals(_loaderName + "#ids.length", 9, _assetloader.ids.length);
			assertEquals(_loaderName + "#loadedIds.length", 0, _assetloader.loadedIds.length);
			assertEquals(_loaderName + "#failedIds.length", 0, _assetloader.failedIds.length);

			assertEquals(_loaderName + "#numLoaders", 9, _assetloader.numLoaders);
			assertEquals(_loaderName + "#numLoaded", 0, _assetloader.numLoaded);
			assertEquals(_loaderName + "#numFailed", 0, _assetloader.numFailed);

			for(var i : int = 0; i < 9; i++)
			{
				var id : String = "id-0" + (i + 1);
				assertEquals(_loaderName + "#ids[" + i + "]", id, _assetloader.ids[i]);
				assertNull(_loaderName + "#getAsset(" + id + ")", _assetloader.getAsset(id));
			}
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// STATE - FOREIGN CHILD
		// --------------------------------------------------------------------------------------------------------------------------------//

		[Test]
		public function stateAfterForeignChildAdded() : void
		{
			_foreignLoader = new TextLoader(new URLRequest(_path + "testTXT.txt"), "foreignChild");

			_assetloader.addLoader(_foreignLoader);

			assertEquals(_loaderName + "#invoked state after foreign child added", false, _loader.invoked);
			assertEquals(_loaderName + "#inProgress after foreign child added", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after foreign child added", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after foreign child added", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state after foreign child added", false, _loader.failed);

			assertEquals(_loaderName + "#ids.length", 10, _assetloader.ids.length);
			assertEquals(_loaderName + "#loadedIds.length", 0, _assetloader.loadedIds.length);
			assertEquals(_loaderName + "#failedIds.length", 0, _assetloader.failedIds.length);

			assertEquals(_loaderName + "#numLoaders", 10, _assetloader.numLoaders);
			assertEquals(_loaderName + "#numLoaded", 0, _assetloader.numLoaded);
			assertEquals(_loaderName + "#numFailed", 0, _assetloader.numFailed);

			for(var i : int = 0; i < 9; i++)
			{
				var id : String = "id-0" + (i + 1);
				assertEquals(_loaderName + "#ids[" + i + "]", id, _assetloader.ids[i]);
				assertNull(_loaderName + "#getAsset(" + id + ")", _assetloader.getAsset(id));
			}
			assertEquals(_loaderName + "#ids[9]", "foreignChild", _assetloader.ids[9]);
			assertTrue(_loaderName + "#loadedIds.indexOf(foreignChild)", _assetloader.loadedIds.indexOf("foreignChild") == -1);
			assertTrue(_loaderName + "#failedIds.indexOf(foreignChild)", _assetloader.failedIds.indexOf("foreignChild") == -1);
			assertNull(_loaderName + "#getAsset(foreignChild)", _assetloader.getAsset("foreignChild"));
		}
		
		[Test]
		public function stateAfterForeignChildRemoved() : void
		{
			_foreignLoader = new TextLoader(new URLRequest(_path + "testTXT.txt"), "foreignChild");

			_assetloader.addLoader(_foreignLoader);
			_assetloader.remove("foreignChild");

			assertEquals(_loaderName + "#invoked state after foreign child added", false, _loader.invoked);
			assertEquals(_loaderName + "#inProgress after foreign child added", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after foreign child added", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after foreign child added", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state after foreign child added", false, _loader.failed);

			assertEquals(_loaderName + "#ids.length", 9, _assetloader.ids.length);
			assertEquals(_loaderName + "#loadedIds.length", 0, _assetloader.loadedIds.length);
			assertEquals(_loaderName + "#failedIds.length", 0, _assetloader.failedIds.length);

			assertEquals(_loaderName + "#numLoaders", 9, _assetloader.numLoaders);
			assertEquals(_loaderName + "#numLoaded", 0, _assetloader.numLoaded);
			assertEquals(_loaderName + "#numFailed", 0, _assetloader.numFailed);

			for(var i : int = 0; i < 9; i++)
			{
				var id : String = "id-0" + (i + 1);
				assertEquals(_loaderName + "#ids[" + i + "]", id, _assetloader.ids[i]);
				assertNull(_loaderName + "#getAsset(" + id + ")", _assetloader.getAsset(id));
			}
			assertEquals(_loaderName + "#ids[9]", undefined, _assetloader.ids[9]);
			assertTrue(_loaderName + "#loadedIds.indexOf(foreignChild)", _assetloader.loadedIds.indexOf("foreignChild") == -1);
			assertTrue(_loaderName + "#failedIds.indexOf(foreignChild)", _assetloader.failedIds.indexOf("foreignChild") == -1);
			assertNull(_loaderName + "#getAsset(foreignChild)", _assetloader.getAsset("foreignChild"));
		}

		[Test (async)]
		public function stateAfterForeignLoadedChildAdded() : void
		{
			_foreignLoader = new TextLoader(new URLRequest(_path + "testTXT.txt"), "foreignChild");

			handleSignal(this, _foreignLoader.onComplete, onComplete_stateAfterForeignLoadedChildAdded_handler);
			_foreignLoader.start();
		}

		protected function onComplete_stateAfterForeignLoadedChildAdded_handler(event : SignalAsyncEvent, data : Object) : void
		{
			_assetloader.addLoader(event.args[0].loader);

			assertEquals(_loaderName + "#invoked state after foreign loaded child added", false, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state after foreign loaded child added", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after foreign loaded child added", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after foreign loaded child added", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state after foreign loaded child added", false, _loader.failed);

			assertEquals(_loaderName + "#ids.length", 10, _assetloader.ids.length);
			assertEquals(_loaderName + "#loadedIds.length", 1, _assetloader.loadedIds.length);
			assertEquals(_loaderName + "#failedIds.length", 0, _assetloader.failedIds.length);

			assertEquals(_loaderName + "#numLoaders", 10, _assetloader.numLoaders);
			assertEquals(_loaderName + "#numLoaded", 1, _assetloader.numLoaded);
			assertEquals(_loaderName + "#numFailed", 0, _assetloader.numFailed);

			for(var i : int = 0; i < 9; i++)
			{
				var id : String = "id-0" + (i + 1);
				assertEquals(_loaderName + "#ids[" + i + "]", id, _assetloader.ids[i]);
				assertNull(_loaderName + "#getAsset(" + id + ")", _assetloader.getAsset(id));
			}
			assertEquals(_loaderName + "#ids[9]", "foreignChild", _assetloader.ids[9]);
			assertTrue(_loaderName + "#loadedIds.indexOf(foreignChild)", _assetloader.loadedIds.indexOf("foreignChild") != -1);
			assertTrue(_loaderName + "#failedIds.indexOf(foreignChild)", _assetloader.failedIds.indexOf("foreignChild") == -1);
			assertNotNull(_loaderName + "#getAsset(foreignChild)", _assetloader.getAsset("foreignChild"));
		}
		
		[Test (async)]
		public function stateAfterForeignLoadedChildRemoved() : void
		{
			_foreignLoader = new TextLoader(new URLRequest(_path + "testTXT.txt"), "foreignChild");

			handleSignal(this, _foreignLoader.onComplete, onComplete_stateAfterForeignLoadedChildRemoved_handler);
			_foreignLoader.start();
		}

		protected function onComplete_stateAfterForeignLoadedChildRemoved_handler(event : SignalAsyncEvent, data : Object) : void
		{
			_assetloader.addLoader(event.args[0].loader);
			_assetloader.remove("foreignChild");

			assertEquals(_loaderName + "#invoked state after foreign loaded child added", false, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state after foreign loaded child added", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after foreign loaded child added", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after foreign loaded child added", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state after foreign loaded child added", false, _loader.failed);

			assertEquals(_loaderName + "#ids.length", 9, _assetloader.ids.length);
			assertEquals(_loaderName + "#loadedIds.length", 0, _assetloader.loadedIds.length);
			assertEquals(_loaderName + "#failedIds.length", 0, _assetloader.failedIds.length);

			assertEquals(_loaderName + "#numLoaders", 9, _assetloader.numLoaders);
			assertEquals(_loaderName + "#numLoaded", 0, _assetloader.numLoaded);
			assertEquals(_loaderName + "#numFailed", 0, _assetloader.numFailed);

			for(var i : int = 0; i < 9; i++)
			{
				var id : String = "id-0" + (i + 1);
				assertEquals(_loaderName + "#ids[" + i + "]", id, _assetloader.ids[i]);
				assertNull(_loaderName + "#getAsset(" + id + ")", _assetloader.getAsset(id));
			}
			assertEquals(_loaderName + "#ids[9]", undefined, _assetloader.ids[9]);
			assertTrue(_loaderName + "#loadedIds.indexOf(foreignChild)", _assetloader.loadedIds.indexOf("foreignChild") == -1);
			assertTrue(_loaderName + "#failedIds.indexOf(foreignChild)", _assetloader.failedIds.indexOf("foreignChild") == -1);
			assertNull(_loaderName + "#getAsset(foreignChild)", _assetloader.getAsset("foreignChild"));
		}

		[Test (async)]
		public function stateAfterLoadAndForeignChildAdded() : void
		{
			handleSignal(this, _assetloader.onComplete, onComplete_stateAfterLoadAndForeignChildAdded_handler);

			_assetloader.start();
		}

		protected function onComplete_stateAfterLoadAndForeignChildAdded_handler(event : SignalAsyncEvent, data : Object) : void
		{
			_foreignLoader = new TextLoader(new URLRequest(_path + "testTXT.txt"), "foreignChild");
			_assetloader.addLoader(_foreignLoader);

			assertEquals(_loaderName + "#invoked state after load complete and then foreign child added", true, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state after load complete and then foreign child added", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after load complete and then foreign child added", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after load complete and then foreign child added", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state after load complete and then foreign child added", false, _loader.failed);

			assertEquals(_loaderName + "#ids.length", 10, _assetloader.ids.length);
			assertEquals(_loaderName + "#loadedIds.length", 9, _assetloader.loadedIds.length);
			assertEquals(_loaderName + "#failedIds.length", 0, _assetloader.failedIds.length);

			assertEquals(_loaderName + "#numLoaders", 10, _assetloader.numLoaders);
			assertEquals(_loaderName + "#numLoaded", 9, _assetloader.numLoaded);
			assertEquals(_loaderName + "#numFailed", 0, _assetloader.numFailed);

			for(var i : int = 0; i < 9; i++)
			{
				var id : String = "id-0" + (i + 1);
				assertEquals(_loaderName + "#ids[" + i + "]", id, _assetloader.ids[i]);
				assertNotNull(_loaderName + "#getAsset(" + id + ")", _assetloader.getAsset(id));
			}
			assertEquals(_loaderName + "#ids[9]", "foreignChild", _assetloader.ids[9]);
			assertTrue(_loaderName + "#loadedIds.indexOf(foreignChild)", _assetloader.loadedIds.indexOf("foreignChild") == -1);
			assertTrue(_loaderName + "#failedIds.indexOf(foreignChild)", _assetloader.failedIds.indexOf("foreignChild") == -1);
			assertNull(_loaderName + "#getAsset(foreignChild)", _assetloader.getAsset("foreignChild"));
		}
		
		[Test (async)]
		public function stateAfterLoadAndForeignChildRemoved() : void
		{
			handleSignal(this, _assetloader.onComplete, onComplete_stateAfterLoadAndForeignChildRemoved_handler);

			_assetloader.start();
		}

		protected function onComplete_stateAfterLoadAndForeignChildRemoved_handler(event : SignalAsyncEvent, data : Object) : void
		{
			_foreignLoader = new TextLoader(new URLRequest(_path + "testTXT.txt"), "foreignChild");
			_assetloader.addLoader(_foreignLoader);
			_assetloader.remove("foreignChild");

			assertEquals(_loaderName + "#invoked state after load complete and then foreign child added", true, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state after load complete and then foreign child added", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after load complete and then foreign child added", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after load complete and then foreign child added", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state after load complete and then foreign child added", false, _loader.failed);

			assertEquals(_loaderName + "#ids.length", 9, _assetloader.ids.length);
			assertEquals(_loaderName + "#loadedIds.length", 9, _assetloader.loadedIds.length);
			assertEquals(_loaderName + "#failedIds.length", 0, _assetloader.failedIds.length);

			assertEquals(_loaderName + "#numLoaders", 9, _assetloader.numLoaders);
			assertEquals(_loaderName + "#numLoaded", 9, _assetloader.numLoaded);
			assertEquals(_loaderName + "#numFailed", 0, _assetloader.numFailed);

			for(var i : int = 0; i < 9; i++)
			{
				var id : String = "id-0" + (i + 1);
				assertEquals(_loaderName + "#ids[" + i + "]", id, _assetloader.ids[i]);
				assertNotNull(_loaderName + "#getAsset(" + id + ")", _assetloader.getAsset(id));
			}
			assertEquals(_loaderName + "#ids[9]", undefined, _assetloader.ids[9]);
			assertTrue(_loaderName + "#loadedIds.indexOf(foreignChild)", _assetloader.loadedIds.indexOf("foreignChild") == -1);
			assertTrue(_loaderName + "#failedIds.indexOf(foreignChild)", _assetloader.failedIds.indexOf("foreignChild") == -1);
			assertNull(_loaderName + "#getAsset(foreignChild)", _assetloader.getAsset("foreignChild"));
		}

		[Test (async)]
		public function stateAfterLoadAndForeignLoadedChildAdded() : void
		{
			var monitor : StatsMonitor = new StatsMonitor();

			_foreignLoader = new TextLoader(new URLRequest(_path + "testTXT.txt"), "foreignChild");

			monitor.add(_foreignLoader);
			monitor.add(_assetloader);

			handleSignal(this, monitor.onComplete, onComplete_stateAfterLoadAndForeignLoadedChildAdded_handler);

			_foreignLoader.start();
			_assetloader.start();
		}

		protected function onComplete_stateAfterLoadAndForeignLoadedChildAdded_handler(event : SignalAsyncEvent, data : Object) : void
		{
			_assetloader.addLoader(_foreignLoader);

			assertEquals(_loaderName + "#invoked state after load complete and then foreign loaded child added", true, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state after load complete and then foreign loaded child added", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after load complete and then foreign loaded child added", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after load complete and then foreign loaded child added", true, _loader.loaded);
			assertEquals(_loaderName + "#failed state after load complete and then foreign loaded child added", false, _loader.failed);

			assertEquals(_loaderName + "#ids.length", 10, _assetloader.ids.length);
			assertEquals(_loaderName + "#loadedIds.length", 10, _assetloader.loadedIds.length);
			assertEquals(_loaderName + "#failedIds.length", 0, _assetloader.failedIds.length);

			assertEquals(_loaderName + "#numLoaders", 10, _assetloader.numLoaders);
			assertEquals(_loaderName + "#numLoaded", 10, _assetloader.numLoaded);
			assertEquals(_loaderName + "#numFailed", 0, _assetloader.numFailed);

			for(var i : int = 0; i < 9; i++)
			{
				var id : String = "id-0" + (i + 1);
				assertEquals(_loaderName + "#ids[" + i + "]", id, _assetloader.ids[i]);
				assertNotNull(_loaderName + "#getAsset(" + id + ")", _assetloader.getAsset(id));
			}
			assertEquals(_loaderName + "#ids[9]", "foreignChild", _assetloader.ids[9]);
			assertTrue(_loaderName + "#loadedIds.indexOf(foreignChild)", _assetloader.loadedIds.indexOf("foreignChild") != -1);
			assertTrue(_loaderName + "#failedIds.indexOf(foreignChild)", _assetloader.failedIds.indexOf("foreignChild") == -1);
			assertNotNull(_loaderName + "#getAsset(foreignChild)", _assetloader.getAsset("foreignChild"));
		}
		
		[Test (async)]
		public function stateAfterLoadAndForeignLoadedChildRemoved() : void
		{
			var monitor : StatsMonitor = new StatsMonitor();

			_foreignLoader = new TextLoader(new URLRequest(_path + "testTXT.txt"), "foreignChild");

			monitor.add(_foreignLoader);
			monitor.add(_assetloader);

			handleSignal(this, monitor.onComplete, onComplete_stateAfterLoadAndForeignLoadedChildRemoved_handler);

			_foreignLoader.start();
			_assetloader.start();
		}

		protected function onComplete_stateAfterLoadAndForeignLoadedChildRemoved_handler(event : SignalAsyncEvent, data : Object) : void
		{
			_assetloader.addLoader(_foreignLoader);
			_assetloader.remove("foreignChild");

			assertEquals(_loaderName + "#invoked state after load complete and then foreign loaded child added", true, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state after load complete and then foreign loaded child added", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after load complete and then foreign loaded child added", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after load complete and then foreign loaded child added", true, _loader.loaded);
			assertEquals(_loaderName + "#failed state after load complete and then foreign loaded child added", false, _loader.failed);

			assertEquals(_loaderName + "#ids.length", 9, _assetloader.ids.length);
			assertEquals(_loaderName + "#loadedIds.length", 9, _assetloader.loadedIds.length);
			assertEquals(_loaderName + "#failedIds.length", 0, _assetloader.failedIds.length);

			assertEquals(_loaderName + "#numLoaders", 9, _assetloader.numLoaders);
			assertEquals(_loaderName + "#numLoaded", 9, _assetloader.numLoaded);
			assertEquals(_loaderName + "#numFailed", 0, _assetloader.numFailed);

			for(var i : int = 0; i < 9; i++)
			{
				var id : String = "id-0" + (i + 1);
				assertEquals(_loaderName + "#ids[" + i + "]", id, _assetloader.ids[i]);
				assertNotNull(_loaderName + "#getAsset(" + id + ")", _assetloader.getAsset(id));
			}
			assertEquals(_loaderName + "#ids[9]", undefined, _assetloader.ids[9]);
			assertTrue(_loaderName + "#loadedIds.indexOf(foreignChild)", _assetloader.loadedIds.indexOf("foreignChild") == -1);
			assertTrue(_loaderName + "#failedIds.indexOf(foreignChild)", _assetloader.failedIds.indexOf("foreignChild") == -1);
			assertNull(_loaderName + "#getAsset(foreignChild)", _assetloader.getAsset("foreignChild"));
		}

		[Test (async)]
		public function stateAfterLoadAndForeignFailedChildAdded() : void
		{
			_foreignLoader = new TextLoader(new URLRequest(_path + "DOES-NOT-EXIST.file"), "foreignChild");

			handleSignal(this, _assetloader.onComplete, onComplete_stateAfterLoadAndForeignFailedChildAdded_handler);

			// Foreign Loader should fail before Assetloader dispatches complete.
			_foreignLoader.start();
			_assetloader.start();
		}

		protected function onComplete_stateAfterLoadAndForeignFailedChildAdded_handler(event : SignalAsyncEvent, data : Object) : void
		{
			_assetloader.addLoader(_foreignLoader);

			assertEquals(_loaderName + "#invoked state after load complete and then foreign failed child added", true, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state after load complete and then foreign failed child added", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after load complete and then foreign failed child added", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after load complete and then foreign failed child added", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state after load complete and then foreign failed child added", true, _loader.failed);

			assertEquals(_loaderName + "#ids.length", 10, _assetloader.ids.length);
			assertEquals(_loaderName + "#loadedIds.length", 9, _assetloader.loadedIds.length);
			assertEquals(_loaderName + "#failedIds.length", 1, _assetloader.failedIds.length);

			assertEquals(_loaderName + "#numLoaders", 10, _assetloader.numLoaders);
			assertEquals(_loaderName + "#numLoaded", 9, _assetloader.numLoaded);
			assertEquals(_loaderName + "#numFailed", 1, _assetloader.numFailed);

			for(var i : int = 0; i < 9; i++)
			{
				var id : String = "id-0" + (i + 1);
				assertEquals(_loaderName + "#ids[" + i + "]", id, _assetloader.ids[i]);
				assertNotNull(_loaderName + "#getAsset(" + id + ")", _assetloader.getAsset(id));
			}
			assertEquals(_loaderName + "#ids[9]", "foreignChild", _assetloader.ids[9]);
			assertTrue(_loaderName + "#loadedIds.indexOf(foreignChild)", _assetloader.loadedIds.indexOf("foreignChild") == -1);
			assertTrue(_loaderName + "#failedIds.indexOf(foreignChild)", _assetloader.failedIds.indexOf("foreignChild") != -1);
			assertNull(_loaderName + "#getAsset(foreignChild)", _assetloader.getAsset("foreignChild"));
		}
		
		[Test (async)]
		public function stateAfterLoadAndForeignFailedChildRemoved() : void
		{
			_foreignLoader = new TextLoader(new URLRequest(_path + "DOES-NOT-EXIST.file"), "foreignChild");

			handleSignal(this, _assetloader.onComplete, onComplete_stateAfterLoadAndForeignFailedChildRemoved_handler);

			// Foreign Loader should fail before Assetloader dispatches complete.
			_foreignLoader.start();
			_assetloader.start();
		}

		protected function onComplete_stateAfterLoadAndForeignFailedChildRemoved_handler(event : SignalAsyncEvent, data : Object) : void
		{
			_assetloader.addLoader(_foreignLoader);
			_assetloader.remove("foreignChild");

			assertEquals(_loaderName + "#invoked state after load complete and then foreign failed child added", true, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state after load complete and then foreign failed child added", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after load complete and then foreign failed child added", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after load complete and then foreign failed child added", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state after load complete and then foreign failed child added", true, _loader.failed);

			assertEquals(_loaderName + "#ids.length", 9, _assetloader.ids.length);
			assertEquals(_loaderName + "#loadedIds.length", 9, _assetloader.loadedIds.length);
			assertEquals(_loaderName + "#failedIds.length", 0, _assetloader.failedIds.length);

			assertEquals(_loaderName + "#numLoaders", 9, _assetloader.numLoaders);
			assertEquals(_loaderName + "#numLoaded", 9, _assetloader.numLoaded);
			assertEquals(_loaderName + "#numFailed", 0, _assetloader.numFailed);

			for(var i : int = 0; i < 9; i++)
			{
				var id : String = "id-0" + (i + 1);
				assertEquals(_loaderName + "#ids[" + i + "]", id, _assetloader.ids[i]);
				assertNotNull(_loaderName + "#getAsset(" + id + ")", _assetloader.getAsset(id));
			}
			assertEquals(_loaderName + "#ids[9]", undefined, _assetloader.ids[9]);
			assertTrue(_loaderName + "#loadedIds.indexOf(foreignChild)", _assetloader.loadedIds.indexOf("foreignChild") == -1);
			assertTrue(_loaderName + "#failedIds.indexOf(foreignChild)", _assetloader.failedIds.indexOf("foreignChild") == -1);
			assertNull(_loaderName + "#getAsset(foreignChild)", _assetloader.getAsset("foreignChild"));
		}

		[Test (async)]
		public function stateAfterLoadAndForeignFailedChildAdded2() : void
		{
			_assetloader.failOnError = false;

			_foreignLoader = new TextLoader(new URLRequest(_path + "DOES-NOT-EXIST.file"), "foreignChild");

			handleSignal(this, _assetloader.onComplete, onComplete_stateAfterLoadAndForeignFailedChildAdded2_handler);

			// Foreign Loader should fail before Assetloader dispatches complete.
			_foreignLoader.start();
			_assetloader.start();
		}

		protected function onComplete_stateAfterLoadAndForeignFailedChildAdded2_handler(event : SignalAsyncEvent, data : Object) : void
		{
			_assetloader.addLoader(_foreignLoader);

			assertEquals(_loaderName + "#invoked state after load complete and then foreign failed child added with failOnError=false", true, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state after load complete and then foreign failed child added with failOnError=false", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after load complete and then foreign failed child added with failOnError=false", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after load complete and then foreign failed child added with failOnError=false", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state after load complete and then foreign failed child added with failOnError=false", true, _loader.failed);

			assertEquals(_loaderName + "#ids.length", 10, _assetloader.ids.length);
			assertEquals(_loaderName + "#loadedIds.length", 9, _assetloader.loadedIds.length);
			assertEquals(_loaderName + "#failedIds.length", 1, _assetloader.failedIds.length);

			assertEquals(_loaderName + "#numLoaders", 10, _assetloader.numLoaders);
			assertEquals(_loaderName + "#numLoaded", 9, _assetloader.numLoaded);
			assertEquals(_loaderName + "#numFailed", 1, _assetloader.numFailed);

			for(var i : int = 0; i < 9; i++)
			{
				var id : String = "id-0" + (i + 1);
				assertEquals(_loaderName + "#ids[" + i + "]", id, _assetloader.ids[i]);
				assertNotNull(_loaderName + "#getAsset(" + id + ")", _assetloader.getAsset(id));
			}
			assertEquals(_loaderName + "#ids[9]", "foreignChild", _assetloader.ids[9]);
			assertTrue(_loaderName + "#loadedIds.indexOf(foreignChild)", _assetloader.loadedIds.indexOf("foreignChild") == -1);
			assertTrue(_loaderName + "#failedIds.indexOf(foreignChild)", _assetloader.failedIds.indexOf("foreignChild") != -1);
			assertNull(_loaderName + "#getAsset(foreignChild)", _assetloader.getAsset("foreignChild"));
		}
		
		[Test (async)]
		public function stateAfterLoadAndForeignFailedChildRemoved2() : void
		{
			_assetloader.failOnError = false;

			_foreignLoader = new TextLoader(new URLRequest(_path + "DOES-NOT-EXIST.file"), "foreignChild");

			handleSignal(this, _assetloader.onComplete, onComplete_stateAfterLoadAndForeignFailedChildRemoved2_handler);

			// Foreign Loader should fail before Assetloader dispatches complete.
			_foreignLoader.start();
			_assetloader.start();
		}

		protected function onComplete_stateAfterLoadAndForeignFailedChildRemoved2_handler(event : SignalAsyncEvent, data : Object) : void
		{
			_assetloader.addLoader(_foreignLoader);
			_assetloader.remove("foreignChild");

			assertEquals(_loaderName + "#invoked state after load complete and then foreign failed child added with failOnError=false", true, _loader.invoked);
			assertEquals(_loaderName + "#inProgress state after load complete and then foreign failed child added with failOnError=false", false, _loader.inProgress);
			assertEquals(_loaderName + "#stopped state after load complete and then foreign failed child added with failOnError=false", false, _loader.stopped);
			assertEquals(_loaderName + "#loaded state after load complete and then foreign failed child added with failOnError=false", false, _loader.loaded);
			assertEquals(_loaderName + "#failed state after load complete and then foreign failed child added with failOnError=false", true, _loader.failed);

			assertEquals(_loaderName + "#ids.length", 9, _assetloader.ids.length);
			assertEquals(_loaderName + "#loadedIds.length", 9, _assetloader.loadedIds.length);
			assertEquals(_loaderName + "#failedIds.length", 0, _assetloader.failedIds.length);

			assertEquals(_loaderName + "#numLoaders", 9, _assetloader.numLoaders);
			assertEquals(_loaderName + "#numLoaded", 9, _assetloader.numLoaded);
			assertEquals(_loaderName + "#numFailed", 0, _assetloader.numFailed);

			for(var i : int = 0; i < 9; i++)
			{
				var id : String = "id-0" + (i + 1);
				assertEquals(_loaderName + "#ids[" + i + "]", id, _assetloader.ids[i]);
				assertNotNull(_loaderName + "#getAsset(" + id + ")", _assetloader.getAsset(id));
			}
			assertEquals(_loaderName + "#ids[9]", undefined, _assetloader.ids[9]);
			assertTrue(_loaderName + "#loadedIds.indexOf(foreignChild)", _assetloader.loadedIds.indexOf("foreignChild") == -1);
			assertTrue(_loaderName + "#failedIds.indexOf(foreignChild)", _assetloader.failedIds.indexOf("foreignChild") == -1);
			assertNull(_loaderName + "#getAsset(foreignChild)", _assetloader.getAsset("foreignChild"));
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// SIGNALS
		// --------------------------------------------------------------------------------------------------------------------------------//
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

			_assetloader.failOnError = false;

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

		[Test (async)]
		public function proceedWithQueueWithErrorAndFailOnErrorSetToFalse() : void
		{
			// Change url to force error signal.
			_assetloader.getLoader("id-01").request.url = _path + "DOES-NOT-EXIST.file";

			_assetloader.numConnections = 1;
			_assetloader.failOnError = false;

			proceedOnSignal(this, _assetloader.getLoader("id-02").onComplete);
			_loader.start();
		}

		[Test (async)]
		public function proceedWithQueueWithErrorAndFailOnErrorSetToTrue() : void
		{
			// Change url to force error signal.
			_assetloader.getLoader("id-01").request.url = _path + "DOES-NOT-EXIST.file";

			_assetloader.numConnections = 1;
			_assetloader.failOnError = true;

			proceedOnSignal(this, _assetloader.getLoader("id-02").onComplete);
			_loader.start();
		}
	}
}
