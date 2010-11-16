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
		protected var _xml : XML;

		public function XMLLoader(id : String, request : URLRequest)
		{
			super(id, request);
			_type = AssetType.XML;
		}

		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(this, XML);
		}

		override public function destroy() : void
		{
			super.destroy();
			_xml = null;
		}

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

		public function get xml() : XML
		{
			return _xml;
		}
	}
}
