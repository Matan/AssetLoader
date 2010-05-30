package org.assetloader.loaders 
{
	import flash.text.StyleSheet;

	/**
	 * @author Matan Uberstein
	 */
	public class CSSLoader extends TextLoader 
	{
		public function CSSLoader()
		{
		}

		override protected function testData(data : String) : String 
		{
			var errMsg : String = "";
			try
			{
				var css : StyleSheet = new StyleSheet();
				css.parseCSS(data);
				_data = css;
			}
			catch(err : Error)
			{
				errMsg = err.message;
			}
			
			return errMsg;
		}
	}
}
