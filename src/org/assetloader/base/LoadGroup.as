package org.assetloader.base 
{
	import org.assetloader.core.IGroupLoader;
	import org.assetloader.core.ILoadGroup;
	import org.assetloader.core.ILoadUnit;
	import org.assetloader.events.GroupLoaderEvent;

	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class LoadGroup extends LoadUnit implements ILoadGroup
	{
		protected var _groupLoader : IGroupLoader;

		public function LoadGroup(id : String, units : Array = null, params : Array = null)
		{
			super(id, null, AssetType.GROUP, params);
			if(units)
				processUnits(units);
		}

		override protected function init(id : String, request : URLRequest, type : String, params : Array = null) : void 
		{
			_id = id;
			_type = type;
			_request = request;
			_params = {};
			_retryTally = 0;
			
			if(params)
				processParams(params);
			
			processType();
			
			setParamDefault(Param.RETRIES, 0);
			setParamDefault(Param.ON_DEMAND, false);
			
			_loader.unit = this;
		}

		protected function processUnits(units : Array) : void
		{
			var uL : int = units.length;
			for(var i : int = 0;i < uL;i++) 
			{
				_groupLoader.addUnit(units[i]);
			}
		}

		override protected function processType() : void 
		{
			_loader = _groupLoader = new GroupLoader();
			_eventClass = GroupLoaderEvent;
		}

		/**
		 * @inheritDoc
		 */
		override public function setParam(id : String, value : *) : void
		{
			super.setParam(id, value);
			
			//Child units must inherit certain params
			if(id != Param.WEIGHT && id != Param.PRIORITY)
			{
				for each(var unitId : String in _groupLoader.ids) 
				{
					var unit : ILoadUnit = _groupLoader.getUnit(unitId);
					unit.setParam(id, value);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get groupLoader() : IGroupLoader 
		{
			return _groupLoader;
		}
	}
}
