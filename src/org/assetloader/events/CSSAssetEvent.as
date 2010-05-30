package org.assetloader.events 
{
	import flash.events.Event;
	import flash.text.StyleSheet;

	/**
	 * @author Matan Uberstein
	 */
	public class CSSAssetEvent extends AbstractAssetEvent 
	{
		public static const LOADED : String = "CSS_LOADED";

		protected var _styleSheet : StyleSheet;

		public function CSSAssetEvent(type : String, id : String, assetType : String, styleSheet : StyleSheet)
		{
			super(type, id, assetType);
			_styleSheet = styleSheet;
		}

		public function get styleSheet() : StyleSheet
		{
			return _styleSheet;
		}

		override public function clone() : Event 
		{
			return new CSSAssetEvent(type, id, assetType, styleSheet);
		}
	}
}
