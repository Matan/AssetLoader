package org.assetloader.loaders 
{
	import com.adobe.serialization.json.JSON;

	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;

	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class JSONLoader extends TextLoader 
	{
		protected var _jsonObject : Object;
		
		public function JSONLoader(id : String, request : URLRequest) 
		{
			super(id, request);
			_type = AssetType.JSON;
		}

		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(this, Object);
		}

		override public function destroy() : void
		{
			super.destroy();
			_jsonObject = null;
		}
		
		override protected function testData(data : String) : String 
		{
			var errMsg : String = "";
			try
			{
				_data = _jsonObject = JSON.decode(data);
			}
			catch(err : Error)
			{
				errMsg = err.message;
			}
			
			return errMsg;
		}

		public function get jsonObject() : Object
		{
			return _jsonObject;
		}
	}
}
