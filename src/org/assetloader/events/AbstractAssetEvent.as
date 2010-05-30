package org.assetloader.events 
{
	import mu.utils.ToStr;

	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class AbstractAssetEvent extends Event 
	{
		protected var _id : String;
		protected var _assetType : String;

		public function AbstractAssetEvent(type : String, id : String, assetType : String)
		{
			super(type);
			_id = id;
			_assetType = assetType;
		}

		public function get id() : String
		{
			return _id;
		}

		public function get assetType() : String
		{
			return _assetType;
		}

		override public function toString() : String 
		{
			return String(new ToStr(this, false));
		}
	}
}
