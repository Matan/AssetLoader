package org.assetloader.events 
{
	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class XMLAssetEvent extends AbstractAssetEvent 
	{
		public static const LOADED : String = "XML_LOADED";

		protected var _xml : XML;

		public function XMLAssetEvent(type : String, id : String, groupId : String, assetType : String, xml : XML)
		{
			super(type, id, groupId, assetType);
			_xml = xml;
		}

		public function get xml() : XML
		{
			return _xml;
		}

		override public function clone() : Event 
		{
			return new XMLAssetEvent(type, id, groupId, assetType, xml);
		}
	}
}
