package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;

	import flash.net.URLRequest;

	public class TextLoaderTest extends BaseLoaderTest
	{
		[Before]
		override public function runBeforeEachTest() : void
		{
			super.runBeforeEachTest();

			_loaderName = "TextLoader";
			_payloadType = String;
			_payloadTypeName = "String";
			_payloadPropertyName = "text";
			_path += "testTXT.txt";
			_type = AssetType.TEXT;

			_loader = new TextLoader(_id, new URLRequest(_path));
		}
	}
}
