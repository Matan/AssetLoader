package org.assetloader.events 
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class DisplayObjectAssetEvent extends AbstractAssetEvent 
	{
		public static const LOADED : String = "DISPLAY_OBJECT_LOADED";

		protected var _displayObject : DisplayObject;

		public function DisplayObjectAssetEvent(type : String, id : String, assetType : String, displayObject : DisplayObject)
		{
			super(type, id, assetType);
			_displayObject = displayObject;
		}

		public function get displayObject() : DisplayObject
		{
			return _displayObject;
		}

		override public function clone() : Event 
		{
			return new DisplayObjectAssetEvent(type, id, assetType, displayObject);
		}
	}
}
