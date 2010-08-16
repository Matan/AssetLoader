package org.assetloader.base.config 
{
	import mu.utils.ToStr;

	/**
	 * @author Matan Uberstein
	 */
	public class ConfigVO 
	{
		public var parentId : String;
		public var base : String;
		public var connections : int = 3;

		public var id : String;		public var src : String;		public var type : String = "AUTO";		public var retries : int = 3;		public var weight : uint = 0;		public var priority : int = NaN;		public var onDemand : Boolean = false;		public var preventCache : Boolean = false;

		public function toString() : String 
		{
			return String(new ToStr(this));
		}
	}
}
