package org.assetloader.loaders 
{
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.base.AssetType;
	import org.assetloader.core.ILoader;

	import flash.net.URLRequest;
	import flash.text.StyleSheet;

	/**
	 * @author Matan Uberstein
	 */
	public class CSSLoader extends TextLoader 
	{
		protected var _styleSheet : StyleSheet;
		
		public function CSSLoader(id : String, request : URLRequest, parent : ILoader = null) 
		{
			super(id, request, parent);
			_type = AssetType.CSS;
		}

		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(this, StyleSheet);
		}
		
		override public function destroy() : void
		{
			super.destroy();
			_styleSheet = null;
		}
		
		override protected function testData(data : String) : String 
		{
			var errMsg : String = "";
			try
			{
				_styleSheet = new StyleSheet();
				_styleSheet.parseCSS(data);
				_data = _styleSheet;
			}
			catch(err : Error)
			{
				errMsg = err.message;
			}
			
			return errMsg;
		}

		public function get styleSheet() : StyleSheet
		{
			return _styleSheet;
		}
	}
}
