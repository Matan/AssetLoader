package org.assetloader.events 
{
	import mu.utils.ToStr;

	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class AssetLoaderEvent extends AbstractAssetEvent 
	{
		public static const ERROR : String = "ERROR";
		public static const CONNECTION_OPENED : String = "CONNECTION_OPENED";
		public static const PROGRESS : String = "PROGRESS";		public static const COMPLETE : String = "COMPLETE";
		public static const ASSET_LOADED : String = "ASSET_LOADED";

		public var data : *;

		public var progress : Number;
		public var bytesLoaded : uint;
		public var bytesTotal : uint;

		public var errorType : String;		public var errorText : String;

		public function AssetLoaderEvent(type : String, id : String = null, parentId : String = null, assetType : String = null)
		{
			super(type, id, parentId, assetType);
		}

		override public function clone() : Event 
		{
			var event : AssetLoaderEvent = new AssetLoaderEvent(type, id, parentId, assetType);
			
			event.data = data;
						event.progress = progress;			event.bytesLoaded = bytesLoaded;			event.bytesTotal = bytesTotal;
			
			return event;
		}

		override public function toString() : String 
		{
			return String(new ToStr(this, false));
		}
	}
}
