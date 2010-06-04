package org.assetloader.events 
{
	import flash.display.Bitmap;
	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class ImageAssetEvent extends AbstractAssetEvent 
	{
		public static const LOADED : String = "IMAGE_LOADED";

		protected var _bitmap : Bitmap;

		public function ImageAssetEvent(type : String, id : String, groupId : String, assetType : String, bitmap : Bitmap)
		{
			super(type, id, groupId, assetType);
			_bitmap = bitmap;
		}

		public function get bitmap() : Bitmap
		{
			return _bitmap;
		}

		override public function clone() : Event 
		{
			return new ImageAssetEvent(type, id, groupId, assetType, bitmap);
		}
	}
}
