package org.assetloader.events 
{
	import flash.events.Event;
	import flash.net.NetStream;

	/**
	 * @author Matan Uberstein
	 */
	public class VideoAssetEvent extends AbstractAssetEvent 
	{
		public static const READY : String = "READY";
		public static const LOADED : String = "VIDEO_LOADED";

		public static const ON_PLAY_STATUS : String = "ON_PLAY_STATUS";
		public static const ON_CUE_POINT : String = "ON_CUE_POINT";
		public static const ON_TEXT_DATA : String = "ON_TEXT_DATA";
		public static const ON_IMAGE_DATA : String = "ON_IMAGE_DATA";
		public static const ON_META_DATA : String = "ON_META_DATA";
		public static const ON_XMP_DATA : String = "ON_XMP_DATA";

		protected var _netStream : NetStream;

		public var data : Object;

		public function VideoAssetEvent(type : String, id : String, parentId : String, assetType : String, netStream : NetStream)
		{
			super(type, id, parentId, assetType);
			_netStream = netStream;
		}

		public function get netStream() : NetStream
		{
			return _netStream;
		}

		override public function clone() : Event 
		{
			return new VideoAssetEvent(type, id, parentId, assetType, netStream);
		}
	}
}
