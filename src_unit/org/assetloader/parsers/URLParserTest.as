package org.assetloader.parsers
{
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
		}

		[Test]
		public function semiSimplePath() : void
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
		}
	}
}
