package org.assetloader.parsers
{
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertEquals;

	public class URLParserTest
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
		public function complexURL() : void
		{
			var parser : URLParser = new URLParser("https://matan:pswrd@www.matanuberstein.co.za/assets/sample/sampleTXT.txt?var1=value1&var2=value2#comments");

			assertEquals("URLParser#url", "https://matan:pswrd@www.matanuberstein.co.za/assets/sample/sampleTXT.txt?var1=value1&var2=value2#comments", parser.url);
			assertEquals("URLParser#protocol", "https", parser.protocol);
			assertEquals("URLParser#login", "matan", parser.login);
			assertEquals("URLParser#password", "pswrd", parser.password);
			assertEquals("URLParser#host", "www.matanuberstein.co.za", parser.host);
			assertEquals("URLParser#path", "/assets/sample/sampleTXT.txt", parser.path);
			assertEquals("URLParser#fileName", "sampleTXT.txt", parser.fileName);
			assertEquals("URLParser#fileExtension", "txt", parser.fileExtension);
			assertEquals("URLParser#urlVariables#var1", "value1", parser.urlVariables.var1);
			assertEquals("URLParser#urlVariables#var2", "value2", parser.urlVariables.var2);
			assertEquals("URLParser#anchor", "comments", parser.anchor);
			assertTrue("URLParser#isValid should be true", parser.isValid);
		}

		[Test]
		public function complexURLWithComplexName() : void
		{
			var parser : URLParser = new URLParser("https://matan:pswrd@www.matanuberstein.co.za/assets/sample/sam_pl-e%20TXT.txt?var1=value1&var2=value2#comments");

			assertEquals("URLParser#url", "https://matan:pswrd@www.matanuberstein.co.za/assets/sample/sam_pl-e%20TXT.txt?var1=value1&var2=value2#comments", parser.url);
			assertEquals("URLParser#protocol", "https", parser.protocol);
			assertEquals("URLParser#login", "matan", parser.login);
			assertEquals("URLParser#password", "pswrd", parser.password);
			assertEquals("URLParser#host", "www.matanuberstein.co.za", parser.host);
			assertEquals("URLParser#path", "/assets/sample/sam_pl-e%20TXT.txt", parser.path);
			assertEquals("URLParser#fileName", "sam_pl-e%20TXT.txt", parser.fileName);
			assertEquals("URLParser#fileExtension", "txt", parser.fileExtension);
			assertEquals("URLParser#urlVariables#var1", "value1", parser.urlVariables.var1);
			assertEquals("URLParser#urlVariables#var2", "value2", parser.urlVariables.var2);
			assertEquals("URLParser#anchor", "comments", parser.anchor);
			assertTrue("URLParser#isValid should be true", parser.isValid);
		}

		[Test]
		public function complexServerURL() : void
		{
			var parser : URLParser = new URLParser("https://matan:pswrd@www.matanuberstein.co.za/assets/sample/?var1=value1&var2=value2#comments");

			assertEquals("URLParser#url", "https://matan:pswrd@www.matanuberstein.co.za/assets/sample/?var1=value1&var2=value2#comments", parser.url);
			assertEquals("URLParser#protocol", "https", parser.protocol);
			assertEquals("URLParser#login", "matan", parser.login);
			assertEquals("URLParser#password", "pswrd", parser.password);
			assertEquals("URLParser#host", "www.matanuberstein.co.za", parser.host);
			assertEquals("URLParser#path", "/assets/sample/", parser.path);
			assertNull("URLParser#fileName", parser.fileName);
			assertNull("URLParser#fileExtension", parser.fileExtension);
			assertEquals("URLParser#urlVariables#var1", "value1", parser.urlVariables.var1);
			assertEquals("URLParser#urlVariables#var2", "value2", parser.urlVariables.var2);
			assertEquals("URLParser#anchor", "comments", parser.anchor);
			assertTrue("URLParser#isValid should be true", parser.isValid);
		}
		
		[Test]
		public function simpleServerURL() : void
		{
			var parser : URLParser = new URLParser("http://www.matanuberstein.co.za/assets/sample");

			assertEquals("URLParser#url", "http://www.matanuberstein.co.za/assets/sample", parser.url);
			assertEquals("URLParser#protocol", "http", parser.protocol);
			assertNull("URLParser#login", parser.login);
			assertNull("URLParser#password", parser.password);
			assertEquals("URLParser#host", "www.matanuberstein.co.za", parser.host);
			assertEquals("URLParser#path", "/assets/sample", parser.path);
			assertEquals("URLParser#fileName", "sample", parser.fileName);
			assertNull("URLParser#fileExtension", parser.fileExtension);
			assertNull("URLParser#urlVariables", parser.urlVariables);
			assertNull("URLParser#anchor", parser.anchor);
			assertTrue("URLParser#isValid should be true", parser.isValid);
		}

		[Test]
		public function simpleServerPath() : void
		{
			var parser : URLParser = new URLParser("assets/samples/");

			assertEquals("URLParser#url", "assets/samples/", parser.url);
			assertNull("URLParser#protocol", parser.protocol);
			assertNull("URLParser#login", parser.login);
			assertNull("URLParser#password", parser.password);
			assertNull("URLParser#host", parser.host);
			assertEquals("URLParser#path", "/assets/samples/", parser.path);
			assertNull("URLParser#fileName", parser.fileName);
			assertNull("URLParser#fileExtension", parser.fileExtension);
			assertNull("URLParser#urlVariables", parser.urlVariables);
			assertNull("URLParser#anchor", parser.anchor);
			assertTrue("URLParser#isValid should be true", parser.isValid);
		}

		[Test]
		public function simpleServerPathWithOutFollowingSlash() : void
		{
			var parser : URLParser = new URLParser("assets/samples");

			assertEquals("URLParser#url", "assets/samples", parser.url);
			assertNull("URLParser#protocol", parser.protocol);
			assertNull("URLParser#login", parser.login);
			assertNull("URLParser#password", parser.password);
			assertNull("URLParser#host", parser.host);
			assertEquals("URLParser#path", "/assets/samples", parser.path);
			assertEquals("URLParser#fileName", "samples", parser.fileName);
			assertNull("URLParser#fileExtension", parser.fileExtension);
			assertNull("URLParser#urlVariables", parser.urlVariables);
			assertNull("URLParser#anchor", parser.anchor);
			assertFalse("URLParser#isValid should be false", parser.isValid);
		}
		
		[Test]
		public function tooSimpleServerPath() : void
		{
			var parser : URLParser = new URLParser("samples");

			assertEquals("URLParser#url", "samples", parser.url);
			assertNull("URLParser#protocol", parser.protocol);
			assertNull("URLParser#login", parser.login);
			assertNull("URLParser#password", parser.password);
			assertNull("URLParser#host", parser.host);
			assertEquals("URLParser#path", "/samples", parser.path);
			assertEquals("URLParser#fileName", "samples", parser.fileName);
			assertNull("URLParser#fileExtension", parser.fileExtension);
			assertNull("URLParser#urlVariables", parser.urlVariables);
			assertNull("URLParser#anchor", parser.anchor);
			assertFalse("URLParser#isValid should be false", parser.isValid);
		}
		
		[Test]
		public function correctSimpleServerPath() : void
		{
			var parser : URLParser = new URLParser("samples/");

			assertEquals("URLParser#url", "samples/", parser.url);
			assertNull("URLParser#protocol", parser.protocol);
			assertNull("URLParser#login", parser.login);
			assertNull("URLParser#password", parser.password);
			assertNull("URLParser#host", parser.host);
			assertEquals("URLParser#path", "/samples/", parser.path);
			assertNull("URLParser#fileName", parser.fileName);
			assertNull("URLParser#fileExtension", parser.fileExtension);
			assertNull("URLParser#urlVariables", parser.urlVariables);
			assertNull("URLParser#anchor", parser.anchor);
			assertTrue("URLParser#isValid should be true", parser.isValid);
		}

		[Test]
		public function complexPath() : void
		{
			var parser : URLParser = new URLParser("assets/sample/sampleTXT.txt?var1=value1&var2=value2#comments");

			assertEquals("URLParser#url", "assets/sample/sampleTXT.txt?var1=value1&var2=value2#comments", parser.url);
			assertNull("URLParser#protocol", parser.protocol);
			assertNull("URLParser#login", parser.login);
			assertNull("URLParser#password", parser.password);
			assertNull("URLParser#host", parser.host);
			assertEquals("URLParser#path", "/assets/sample/sampleTXT.txt", parser.path);
			assertEquals("URLParser#fileName", "sampleTXT.txt", parser.fileName);
			assertEquals("URLParser#fileExtension", "txt", parser.fileExtension);
			assertEquals("URLParser#urlVariables#var1", "value1", parser.urlVariables.var1);
			assertEquals("URLParser#urlVariables#var2", "value2", parser.urlVariables.var2);
			assertEquals("URLParser#anchor", "comments", parser.anchor);
			assertTrue("URLParser#isValid should be true", parser.isValid);
		}

		[Test]
		public function complexPathWithLeadingSlash() : void
		{
			var parser : URLParser = new URLParser("/assets/sample/sampleTXT.txt?var1=value1&var2=value2#comments");

			assertEquals("URLParser#url", "/assets/sample/sampleTXT.txt?var1=value1&var2=value2#comments", parser.url);
			assertNull("URLParser#protocol", parser.protocol);
			assertNull("URLParser#login", parser.login);
			assertNull("URLParser#password", parser.password);
			assertNull("URLParser#host", parser.host);
			assertEquals("URLParser#path", "/assets/sample/sampleTXT.txt", parser.path);
			assertEquals("URLParser#fileName", "sampleTXT.txt", parser.fileName);
			assertEquals("URLParser#fileExtension", "txt", parser.fileExtension);
			assertEquals("URLParser#urlVariables#var1", "value1", parser.urlVariables.var1);
			assertEquals("URLParser#urlVariables#var2", "value2", parser.urlVariables.var2);
			assertEquals("URLParser#anchor", "comments", parser.anchor);
			assertTrue("URLParser#isValid should be true", parser.isValid);
		}

		[Test]
		public function simplePathWithQueryVars() : void
		{
			var parser : URLParser = new URLParser("sampleTXT.txt?var1=value1&var2=value2#comments");

			assertEquals("URLParser#url", "sampleTXT.txt?var1=value1&var2=value2#comments", parser.url);
			assertNull("URLParser#protocol", parser.protocol);
			assertNull("URLParser#login", parser.login);
			assertNull("URLParser#password", parser.password);
			assertNull("URLParser#host", parser.host);
			assertEquals("URLParser#path", "/sampleTXT.txt", parser.path);
			assertEquals("URLParser#fileName", "sampleTXT.txt", parser.fileName);
			assertEquals("URLParser#fileExtension", "txt", parser.fileExtension);
			assertEquals("URLParser#urlVariables#var1", "value1", parser.urlVariables.var1);
			assertEquals("URLParser#urlVariables#var2", "value2", parser.urlVariables.var2);
			assertEquals("URLParser#anchor", "comments", parser.anchor);
			assertTrue("URLParser#isValid should be true", parser.isValid);
		}

		[Test]
		public function simplePath() : void
		{
			var parser : URLParser = new URLParser("sampleTXT.txt");

			assertEquals("URLParser#url", "sampleTXT.txt", parser.url);
			assertNull("URLParser#protocol", parser.protocol);
			assertNull("URLParser#login", parser.login);
			assertNull("URLParser#password", parser.password);
			assertNull("URLParser#host", parser.host);
			assertEquals("URLParser#path", "/sampleTXT.txt", parser.path);
			assertEquals("URLParser#fileName", "sampleTXT.txt", parser.fileName);
			assertEquals("URLParser#fileExtension", "txt", parser.fileExtension);
			assertNull("URLParser#urlVariables", parser.urlVariables);
			assertNull("URLParser#anchor", parser.anchor);
			assertTrue("URLParser#isValid should be true", parser.isValid);
		}

		[Test]
		public function simplePathWithLeadingSlash() : void
		{
			var parser : URLParser = new URLParser("/sampleTXT.txt");

			assertEquals("URLParser#url", "/sampleTXT.txt", parser.url);
			assertNull("URLParser#protocol", parser.protocol);
			assertNull("URLParser#login", parser.login);
			assertNull("URLParser#password", parser.password);
			assertNull("URLParser#host", parser.host);
			assertEquals("URLParser#path", "/sampleTXT.txt", parser.path);
			assertEquals("URLParser#fileName", "sampleTXT.txt", parser.fileName);
			assertEquals("URLParser#fileExtension", "txt", parser.fileExtension);
			assertNull("URLParser#urlVariables", parser.urlVariables);
			assertNull("URLParser#anchor", parser.anchor);
			assertTrue("URLParser#isValid should be true", parser.isValid);
		}

		[Test]
		public function simplePathWithComplexName() : void
		{
			var parser : URLParser = new URLParser("sam_pl-e%20TXT.txt");

			assertEquals("URLParser#url", "sam_pl-e%20TXT.txt", parser.url);
			assertNull("URLParser#protocol", parser.protocol);
			assertNull("URLParser#login", parser.login);
			assertNull("URLParser#password", parser.password);
			assertNull("URLParser#host", parser.host);
			assertEquals("URLParser#path", "/sam_pl-e%20TXT.txt", parser.path);
			assertEquals("URLParser#fileName", "sam_pl-e%20TXT.txt", parser.fileName);
			assertEquals("URLParser#fileExtension", "txt", parser.fileExtension);
			assertNull("URLParser#urlVariables", parser.urlVariables);
			assertNull("URLParser#anchor", parser.anchor);
			assertTrue("URLParser#isValid should be true", parser.isValid);
		}
		
		[Test]
		public function invalid_00() : void
		{
			var parser : URLParser = new URLParser("asdfasdf");

			assertEquals("URLParser#url", "asdfasdf", parser.url);
			assertNull("URLParser#protocol", parser.protocol);
			assertNull("URLParser#login", parser.login);
			assertNull("URLParser#password", parser.password);
			assertNull("URLParser#host", parser.host);
			assertEquals("URLParser#path", "/asdfasdf", parser.path);
			assertEquals("URLParser#fileName", "asdfasdf", parser.fileName);
			assertNull("URLParser#fileExtension", parser.fileExtension);
			assertNull("URLParser#urlVariables", parser.urlVariables);
			assertNull("URLParser#anchor", parser.anchor);
			assertFalse("URLParser#isValid should be false", parser.isValid);
		}
	}
}
