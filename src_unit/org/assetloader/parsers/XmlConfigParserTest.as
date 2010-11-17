package org.assetloader.parsers
{
	import org.assetloader.AssetLoader;
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.IConfigParser;
	import org.assetloader.core.ILoader;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	public class XmlConfigParserTest
	{
		protected var _assetloader : IAssetLoader;
		protected var _parser : XmlConfigParser;
		
		//Make sure that this _base property matches the one in the XML.
		protected var _base : String = "test/";
		protected var _data : XML = <loader connections="3" base="test/" >
	
										<group id="SAMPLE_GROUP_01" connections="1" preventCache="false" >
											
											<group id="SAMPLE_GROUP_02" connections="2" >
												<asset id="SAMPLE_TXT" src="sampleTXT.txt" />
												<asset id="SAMPLE_JSON" src="sampleJSON.json" />
												<asset id="SAMPLE_XML" src="sampleXML.xml" />
												<asset id="SAMPLE_CSS" src="sampleCSS.css" />
											</group>
											
											<asset id="SAMPLE_BINARY" src="sampleZIP.zip" weight="3493" />
											<asset id="SAMPLE_SOUND" src="sampleSOUND.mp3" weight="213 kb" />
											
										</group>
										
										<assets preventCache="true" >
											<asset id="SAMPLE_IMAGE" src="sampleIMAGE.png" weight="5 kb" fillColor="0x0" smoothing="true" transparent="true" />
											<asset id="SAMPLE_VIDEO" src="sampleVIDEO.flv" weight="0.312 mb" onDemand="true" />
											<asset id="SAMPLE_SWF" src="sampleSWF.swf" weight="526" priority="1" />
										</assets>
										
										<asset id="SAMPLE_ERROR" base="/" src="fileThatDoesNotExist.php" type="image" retries="5" />
										
									</loader>;
									
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
			_parser = new XmlConfigParser();
		}

		[After]
		public function runAfterEachTest() : void
		{
			_assetloader.destroy();
			_assetloader = null;
			_parser = null;
		}

		[Test]
		public function implementing() : void
		{
			assertTrue("XmlConfigParser should implement IConfigParser", _parser is IConfigParser);
		}

		[Test]
		public function isValid() : void
		{
			assertTrue("XmlConfigParser#isValid should be true with valid data", _parser.isValid(_data));
		}

		[Test]
		public function isValidBrokenTagAdded() : void
		{
			assertFalse("XmlConfigParser#isValid should be false with a broken tag added", _parser.isValid(_data + "</brokenTag>"));
		}

		[Test]
		public function isValidUrlPassed() : void
		{
			assertFalse("XmlConfigParser#isValid should be false if a relative path is passed", _parser.isValid("test/testXML.xml"));
			assertFalse("XmlConfigParser#isValid should be false if a url is passed", _parser.isValid("http://www.matan.co.za/AssetLoader/test/testXML.xml"));
		}

		[Test]
		public function parseAndTestAllLoaders() : void
		{
			_parser.parse(_assetloader, _data);

			assertTrue("AssetLoader#hasLoader('SAMPLE_GROUP_01') should be true", _assetloader.hasLoader('SAMPLE_GROUP_01'));
			assertTrue("AssetLoader#getLoader('SAMPLE_GROUP_01') should be an IAssetLoader", _assetloader.getLoader('SAMPLE_GROUP_01') is IAssetLoader);
			var group1 : IAssetLoader = IAssetLoader(_assetloader.getLoader('SAMPLE_GROUP_01'));
			assertTrue("group1#hasLoader('SAMPLE_GROUP_02') should be true", group1.hasLoader('SAMPLE_GROUP_02'));
			assertTrue("group1#getLoader('SAMPLE_GROUP_02') should be an IAssetLoader", group1.getLoader('SAMPLE_GROUP_02') is IAssetLoader);

			var group2 : IAssetLoader = IAssetLoader(group1.getLoader('SAMPLE_GROUP_02'));
			assertTrue("group2#hasLoader('SAMPLE_TXT') should be true", group2.hasLoader('SAMPLE_TXT'));
			assertTrue("group2#hasLoader('SAMPLE_JSON') should be true", group2.hasLoader('SAMPLE_JSON'));
			assertTrue("group2#hasLoader('SAMPLE_XML') should be true", group2.hasLoader('SAMPLE_XML'));
			assertTrue("group2#hasLoader('SAMPLE_CSS') should be true", group2.hasLoader('SAMPLE_CSS'));

			assertTrue("AssetLoader#hasLoader('SAMPLE_IMAGE') should be true", _assetloader.hasLoader('SAMPLE_IMAGE'));
			assertTrue("AssetLoader#hasLoader('SAMPLE_VIDEO') should be true", _assetloader.hasLoader('SAMPLE_VIDEO'));
			assertTrue("AssetLoader#hasLoader('SAMPLE_SWF') should be true", _assetloader.hasLoader('SAMPLE_SWF'));

			assertTrue("AssetLoader#hasLoader('SAMPLE_ERROR') should be true", _assetloader.hasLoader('SAMPLE_ERROR'));
		}

		[Test]
		public function parseAndTestAllParams() : void
		{
			_parser.parse(_assetloader, _data);

			var group1 : IAssetLoader = IAssetLoader(_assetloader.getLoader('SAMPLE_GROUP_01'));
			assertEquals("group1 id should be SAMPLE_GROUP_01", 'SAMPLE_GROUP_01', group1.id);
			assertEquals("group1 type should be GROUP", AssetType.GROUP, group1.type);
			assertEquals("group1 preventCache should be false", false, group1.getParam(Param.PREVENT_CACHE));
			assertEquals("group1 numConnections should be 1", 1, group1.numConnections);
			assertEquals("group1 base should be " + _base, _base, group1.getParam(Param.BASE));
			var binary : ILoader = group1.getLoader('SAMPLE_BINARY');
			assertEquals("binary id should be SAMPLE_BINARY", 'SAMPLE_BINARY', binary.id);
			assertEquals("binary type should be BINARY", AssetType.BINARY, binary.type);
			assertEquals("binary preventCache should be false", false, binary.getParam(Param.PREVENT_CACHE));
			assertEquals("binary weight should be 3493", 3493, binary.getParam(Param.WEIGHT));
			assertEquals("binary base should be " + _base, _base, binary.getParam(Param.BASE));

			var sound : ILoader = group1.getLoader('SAMPLE_SOUND');
			assertEquals("sound id should be SAMPLE_SOUND", 'SAMPLE_SOUND', sound.id);
			assertEquals("sound type should be SOUND", AssetType.SOUND, sound.type);
			assertEquals("sound preventCache should be false", false, sound.getParam(Param.PREVENT_CACHE));
			assertEquals("sound weight should be 213 x 1024", uint(213 * 1024), sound.getParam(Param.WEIGHT));
			assertEquals("sound base should be " + _base, _base, sound.getParam(Param.BASE));

			var group2 : IAssetLoader = IAssetLoader(group1.getLoader('SAMPLE_GROUP_02'));
			assertEquals("group2 id should be SAMPLE_GROUP_02", 'SAMPLE_GROUP_02', group2.id);
			assertEquals("group2 type should be GROUP", AssetType.GROUP, group2.type);
			assertEquals("group2 preventCache should be false", false, group2.getParam(Param.PREVENT_CACHE));
			assertEquals("group2 numConnections should be 2", 2, group2.numConnections);
			assertEquals("group2 base should be " + _base, _base, group2.getParam(Param.BASE));

			var text : ILoader = group2.getLoader('SAMPLE_TXT');
			assertEquals("text id should be SAMPLE_TXT", 'SAMPLE_TXT', text.id);
			assertEquals("text type should be TEXT", AssetType.TEXT, text.type);
			assertEquals("text preventCache should be false", false, text.getParam(Param.PREVENT_CACHE));
			assertEquals("text base should be " + _base, _base, text.getParam(Param.BASE));

			var json : ILoader = group2.getLoader('SAMPLE_JSON');
			assertEquals("json id should be SAMPLE_JSON", 'SAMPLE_JSON', json.id);
			assertEquals("json type should be JSON", AssetType.JSON, json.type);
			assertEquals("json preventCache should be false", false, json.getParam(Param.PREVENT_CACHE));
			assertEquals("json base should be " + _base, _base, json.getParam(Param.BASE));

			var xml : ILoader = group2.getLoader('SAMPLE_XML');
			assertEquals("xml id should be SAMPLE_XML", 'SAMPLE_XML', xml.id);
			assertEquals("xml type should be XML", AssetType.XML, xml.type);
			assertEquals("xml preventCache should be false", false, xml.getParam(Param.PREVENT_CACHE));
			assertEquals("xml base should be " + _base, _base, xml.getParam(Param.BASE));

			var css : ILoader = group2.getLoader('SAMPLE_CSS');
			assertEquals("css id should be SAMPLE_CSS", 'SAMPLE_CSS', css.id);
			assertEquals("css type should be CSS", AssetType.CSS, css.type);
			assertEquals("css preventCache should be false", false, css.getParam(Param.PREVENT_CACHE));
			assertEquals("css base should be " + _base, _base, css.getParam(Param.BASE));

			var image : ILoader = _assetloader.getLoader('SAMPLE_IMAGE');
			assertEquals("image id should be SAMPLE_IMAGE", 'SAMPLE_IMAGE', image.id);
			assertEquals("image type should be IMAGE", AssetType.IMAGE, image.type);
			assertEquals("image preventCache should be true", true, image.getParam(Param.PREVENT_CACHE));
			assertEquals("image weight should be 5 x 1024", uint(5 * 1024), image.getParam(Param.WEIGHT));
			assertEquals("image fillColor should be 0 (Black | 0x000000)", 0x0, image.getParam(Param.FILL_COLOR));
			assertEquals("image smoothing should be true", true, image.getParam(Param.SMOOTHING));
			assertEquals("image transparent should be true", true, image.getParam(Param.TRANSPARENT));
			assertEquals("image base should be " + _base, _base, image.getParam(Param.BASE));

			var video : ILoader = _assetloader.getLoader('SAMPLE_VIDEO');
			assertEquals("video id should be SAMPLE_VIDEO", 'SAMPLE_VIDEO', video.id);
			assertEquals("video type should be VIDEO", AssetType.VIDEO, video.type);
			assertEquals("video preventCache should be true", true, video.getParam(Param.PREVENT_CACHE));
			assertEquals("video weight should be 0.312 x 1024 x 1024", uint(0.312 * 1024 * 1024), video.getParam(Param.WEIGHT));
			assertEquals("video onDemand should be true", true, video.getParam(Param.ON_DEMAND));
			assertEquals("video base should be " + _base, _base, video.getParam(Param.BASE));

			var swf : ILoader = _assetloader.getLoader('SAMPLE_SWF');
			assertEquals("swf id should be SAMPLE_SWF", 'SAMPLE_SWF', swf.id);
			assertEquals("swf type should be SWF", AssetType.SWF, swf.type);
			assertEquals("swf preventCache should be true", true, swf.getParam(Param.PREVENT_CACHE));
			assertEquals("swf weight should be 526", 526, swf.getParam(Param.WEIGHT));
			assertEquals("swf priority should be 1", 1, swf.getParam(Param.PRIORITY));
			assertEquals("swf base should be " + _base, _base, swf.getParam(Param.BASE));

			var error : ILoader = _assetloader.getLoader('SAMPLE_ERROR');
			assertEquals("error id should be SAMPLE_ERROR", 'SAMPLE_ERROR', error.id);
			assertEquals("error type should be IMAGE", AssetType.IMAGE, error.type);
			assertEquals("error preventCache should be false", false, error.getParam(Param.PREVENT_CACHE));
			assertEquals("error retries should be 5", 5, error.getParam(Param.RETRIES));
			assertEquals("error base should be /", "/", error.getParam(Param.BASE));
		}
	}
}
