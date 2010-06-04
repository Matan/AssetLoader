package org.assetloader.base
{
	import org.assetloader.core.ILoadGroup;
	import org.assetloader.core.ILoadUnit;
	import org.assetloader.core.ILoader;

	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * @author Matan Uberstein
	 */
	public class GroupLoaderBase extends AbstractLoader
	{
		protected var _group : ILoadGroup;

		protected var _assets : Dictionary;
		protected var _units : Dictionary;
		protected var _ids : Array;

		protected var _numUnits : int;
		protected var _numConnections : int = 3;

		public function GroupLoaderBase()
		{
			_assets = new Dictionary(true);
			_units = new Dictionary(true);
			_ids = [];
			
			super();
		}

		/**
		 * @inheritDoc
		 */
		public function addLazy(id : String, url : String, type : String = "AUTO", ...assetParams) : ILoader
		{
			return add(id, new URLRequest(url), type, assetParams);
		}

		/**
		 * @inheritDoc
		 */
		public function add(id : String, request : URLRequest, type : String = "AUTO", ...assetParams) : ILoader
		{
			return addUnit(new LoadUnit(id, request, type, assetParams));
		}

		/**
		 * @inheritDoc
		 */
		public function addUnit(unit : ILoadUnit) : ILoader
		{
			_units[unit.id] = unit;
			_ids.push(unit.id);
			
			_numUnits = _ids.length;
			
			if(!unit.hasParam(Param.PRIORITY))
				unit.setParam(Param.PRIORITY, -(_numUnits - 1));
			
			return unit.loader;
		}

		/**
		 * @inheritDoc
		 */
		public function remove(id : String) : void
		{
			var loader : ILoader = getLoader(id);
			if(loader)
			{
				_ids.splice(_ids.indexOf(id), 1);
				delete _units[id];
				delete _assets[id];
				
				loader.destroy();
				
				_numUnits = _ids.length;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy() : void
		{
			var id : String;
			while(id = _ids.pop())
			{
				
				var loader : ILoader = getLoader(id);
				delete _units[id];
				delete _assets[id];
				
				loader.destroy();
			}
			_numUnits = 0;
			
			super.destroy();
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// PUBLIC GETTERS/SETTERS
		//--------------------------------------------------------------------------------------------------------------------------------//
		/**
		 * @inheritDoc
		 */
		public function get numConnections() : int
		{
			return _numConnections;
		}

		/**
		 * @inheritDoc
		 */
		public function set numConnections(value : int) : void
		{
			_numConnections = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get group() : ILoadGroup 
		{
			return _group;
		}

		/**
		 * @inheritDoc
		 */
		override public function set unit(value : ILoadUnit) : void 
		{
			_unit = value;
			_group = ILoadGroup(_unit);
		}

		/**
		 * @inheritDoc
		 */
		public function getUnit(id : String) : ILoadUnit
		{
			return _units[id];
		}

		/**
		 * @inheritDoc
		 */
		public function getLoader(id : String) : ILoader
		{
			if(hasUnit(id))
				return getUnit(id).loader;
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function getAsset(id : String) : *
		{
			return _assets[id];
		}

		/**
		 * Gets a Dictionary of the loaded assets.
		 * @return Dictionary
		 */
		override public function get data() : *
		{
			return _assets;
		}

		/**
		 * @inheritDoc
		 */
		public function hasUnit(id : String) : Boolean
		{
			return (_units[id] != undefined);
		}

		/**
		 * @inheritDoc
		 */
		public function hasLoader(id : String) : Boolean
		{
			if(hasUnit(id))
				return (getUnit(id).loader != null);
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function hasAsset(id : String) : Boolean
		{
			return (_assets[id] != undefined);
		}

		/**
		 * @inheritDoc
		 */
		public function get ids() : Array 
		{
			return _ids;
		}

		/**
		 * @inheritDoc
		 */
		public function get numUnits() : int
		{
			return _numUnits;
		}
	}
}