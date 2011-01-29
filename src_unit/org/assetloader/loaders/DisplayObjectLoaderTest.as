package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;

	import flash.display.DisplayObject;
	import flash.net.URLRequest;

	public class DisplayObjectLoaderTest extends BaseLoaderTest
	{
		[Before]
		override public function runBeforeEachTest() : void
		{
			super.runBeforeEachTest();
			
			_loaderName = "DisplayObjectLoader";
			_payloadType = DisplayObject;
			_payloadTypeName = "DisplayObject";
			_payloadPropertyName = "displayObject";
			_path += "testSWF.swf";
			_type = AssetType.DISPLAY_OBJECT;

			_loader = new DisplayObjectLoader(new URLRequest(_path), _id);
		}
	}
}
