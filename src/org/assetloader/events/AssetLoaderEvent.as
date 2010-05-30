package org.assetloader.events 
{
	import mu.utils.ToStr;
	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class AssetLoaderEvent extends Event 
	{
		public static const ASSET_LOADED : String = "ASSET_LOADED";
		public static const COMPLETE : String = "COMPLETE";
		public static const PROGRESS : String = "PROGRESS";		public static const ERROR : String = "ERROR";

		public var id : String;
		public var assetType : String;
		public var data : *;
		
		public var progress : Number;
		public var bytesLoaded : uint;
		public var bytesTotal : uint;
		
		public var errorType : String;		public var errorText : String;

		public function AssetLoaderEvent(type : String)
		{
			super(type);
		}

		override public function clone() : Event 
		{
			var event : AssetLoaderEvent = new AssetLoaderEvent(type);
			
			event.id = id;			event.assetType = assetType;			event.data = data;
						event.progress = progress;			event.bytesLoaded = bytesLoaded;			event.bytesTotal = bytesTotal;
			
			return event;
		}
		
		override public function toString() : String {
			return String(new ToStr(this, false));
		}
	}
}
