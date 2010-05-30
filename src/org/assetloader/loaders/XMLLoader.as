package org.assetloader.loaders 
{

	/**
	 * @author Matan Uberstein
	 */
	public class XMLLoader extends TextLoader 
	{
		public function XMLLoader()
		{
		}

		override protected function testData(data : String) : String 
		{
			var errMsg : String = "";
			try
			{
				_data = new XML(data);
			}
			catch(err : Error)
			{
				errMsg = err.message;
			}
			
			return errMsg;
		}
	}
}
