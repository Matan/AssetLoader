package org.assetloader.loaders
{

	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;

	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class XMLLoader extends TextLoader
	{
		/**
		 * @private
		 */
		protected var _xml : XML;

		public function XMLLoader(id : String, request : URLRequest)
		{
			super(id, request);
			_type = AssetType.XML;
		}

		/**
		 * @private
		 */
		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(this, XML);
		}

		/**
		 * @private
		 */
		override public function destroy() : void
		{
			super.destroy();
			_xml = null;
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
				_data = _xml = new XML(data);
			}
			catch(err : Error)
			{
				errMsg = err.message;
			}

			if(xml.nodeKind() != "element")
				errMsg = "Not valid XML.";

			return errMsg;
		}

		/**
		 * Gets the resulting XML after loading and parsing is complete.
		 * 
		 * @return XML
		 */
		public function get xml() : XML
		{
			return _xml;
		}
	}
}
