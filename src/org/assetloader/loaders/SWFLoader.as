package org.assetloader.loaders 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author Matan Uberstein
	 */
	public class SWFLoader extends DisplayObjectLoader 
	{
		public function SWFLoader()
		{
		}

		override protected function testData(data : DisplayObject) : String 
		{
			var errMsg : String = "";
			_data = Sprite(data);
			if(!_data)
				errMsg = "Could not cast data into flash.display.Sprite .";
			
			return errMsg;
		}
	}
}
