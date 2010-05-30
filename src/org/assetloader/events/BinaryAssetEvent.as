package org.assetloader.events 
{
	import flash.utils.ByteArray;
	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class BinaryAssetEvent extends AbstractAssetEvent 
	{
		public static const LOADED : String = "BINARY_LOADED";

		protected var _byteArray : ByteArray;

		public function BinaryAssetEvent(type : String, id : String, assetType : String, byteArray : ByteArray)
		{
			super(type, id, assetType);
			_byteArray = byteArray;
		}

		public function get byteArray() : ByteArray
		{
			return _byteArray;
		}

		override public function clone() : Event 
		{
			return new BinaryAssetEvent(type, id, assetType, byteArray);
		}
	}
}
