package org.assetloader.base
{
	import org.assetloader.core.IParam;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	import flash.system.LoaderContext;

	public class ParamTest
	{
		protected var _param : Param;
		protected var _id : String = "test-id";
		protected var _value : LoaderContext = new LoaderContext();

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
			_param = new Param(_id, _value);
		}

		[After]
		public function runAfterEachTest() : void
		{
			_param = null;
		}

		[Test]
		public function implementsIParam() : void
		{
			assertTrue("Param should implement IParam", _param is IParam);
		}

		[Test]
		public function retainsId() : void
		{
			assertEquals("Param should retain id passed", _param.id, _id);
		}

		[Test]
		public function retainsValue() : void
		{
			assertEquals("Param should retain value passed", _param.value, _value);
		}
	}
}
