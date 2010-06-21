package org.assetloader.events 
{
	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class TextAssetEvent extends AbstractAssetEvent 
	{
		public static const LOADED : String = "TEXT_LOADED";

		protected var _data : String;

		public function TextAssetEvent(type : String, id : String, parentId : String, assetType : String, data : String)
		{
			super(type, id, parentId, assetType);
			_data = data;
		}

		public function get data() : String
		{
			return _data;
		}

		override public function clone() : Event 
		{
			return new TextAssetEvent(type, id, parentId, assetType, data);
		}
	}
}
