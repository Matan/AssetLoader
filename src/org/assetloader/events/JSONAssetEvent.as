package org.assetloader.events 
{
	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class JSONAssetEvent extends AbstractAssetEvent 
	{
		public static const LOADED : String = "JSON_LOADED";

		protected var _data : Object;

		public function JSONAssetEvent(type : String, id : String, parentId : String, assetType : String, data : Object)
		{
			super(type, id, parentId, assetType);
			_data = data;
		}

		public function get data() : Object
		{
			return _data;
		}

		override public function clone() : Event 
		{
			return new JSONAssetEvent(type, id, parentId, assetType, data);
		}
	}
}
