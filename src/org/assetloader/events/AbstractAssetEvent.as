package org.assetloader.events 
{
	import mu.utils.ToStr;

	import flash.events.Event;

	/**
	 * @author Matan Uberstein
	 */
	public class AbstractAssetEvent extends Event 
	{
		public var id : String;		public var parentId : String;		public var assetType : String;

		public function AbstractAssetEvent(type : String, id : String = null, parentId : String = null, assetType : String = null)
		{
			super(type);
			this.id = id;			this.parentId = parentId;			this.assetType = assetType;
		}

		override public function clone() : Event 
		{
			return new AbstractAssetEvent(type, id, parentId, assetType);
		}

		override public function toString() : String 
		{
			return String(new ToStr(this, false));
		}
	}
}
