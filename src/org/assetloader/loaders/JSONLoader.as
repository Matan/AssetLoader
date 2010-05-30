package org.assetloader.loaders 
{
	import com.adobe.serialization.json.JSON;

	/**
	 * @author Matan Uberstein
	 */
	public class JSONLoader extends TextLoader 
	{
		public function JSONLoader()
		{
		}

		override protected function testData(data : String) : String 
		{
			var errMsg : String = "";
			try
			{
				_data = JSON.decode(data);
			}
			catch(err : Error)
			{
				errMsg = err.message;
			}
			
			return errMsg;
		}
	}
}
