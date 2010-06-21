package org.assetloader.events 
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * @author Matan Uberstein
	 */
	public class GroupLoaderEvent extends AbstractAssetEvent 
	{
		public static const ASSET_LOADED : String = "ASSET_LOADED";		public static const LOADED : String = "GROUP_LOADED";
		public static const ERROR : String = "GROUP_ERROR";

		protected var _assets : Dictionary;

		public var data : *;

		public var errorType : String;
		public var errorText : String;

		public function GroupLoaderEvent(type : String, id : String, parentId : String, assetType : String, assets : Dictionary)
		{
			super(type, id, parentId, assetType);
			data = _assets = assets;
		}

		public function get assets() : Dictionary
		{
			return _assets;
		}

		override public function clone() : Event 
		{
			var event : GroupLoaderEvent = new GroupLoaderEvent(type, id, parentId, assetType, assets);
			event.data = data;
			return event;
		}
	}
}
