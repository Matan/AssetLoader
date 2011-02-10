package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;

	import flash.net.URLRequest;
	import flash.text.StyleSheet;

	/**
	 * @author Matan Uberstein
	 */
	public class CSSLoader extends TextLoader
	{
		/**
		 * @private
		 */
		protected var _styleSheet : StyleSheet;

		public function CSSLoader(request : URLRequest, id : String = null)
		{
			super(request, id);
			_type = AssetType.CSS;
		}

		/**
		 * @private
		 */
		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(StyleSheet);
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy() : void
		{
			super.destroy();
			_styleSheet = null;
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
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

		/**
		 * Gets the resulting StyleSheet after loading is complete.
		 * 
		 * @return StyleSheet
		 */
		public function get styleSheet() : StyleSheet
		{
			return _styleSheet;
		}
	}
}
