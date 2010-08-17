package org.assetloader.base
{
	import org.assetloader.base.config.ConfigVO;
	import org.assetloader.base.config.XmlConfigParser;
	import org.assetloader.core.IConfigParser;
	import org.assetloader.core.ILoadGroup;
	import org.assetloader.core.ILoadStats;
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
		protected var _configParserClass : Class = XmlConfigParser;
		protected var _configParser : IConfigParser;
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
			return addUnit(new LoadUnit(id, request, type, assetParams, unit));
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

			var loader : ILoader = unit.loader;

			addListeners(loader);

			updateTotalBytes();

			return loader;
		}

		/**
		 * @inheritDoc
		 */
		public function addConfig(config : String) : void
		{
			try
			{
				var configVos : Array = configParser.parse(config);
			}
			catch(error : Error)
			{
				throw new AssetLoaderError(AssetLoaderError.COULD_NOT_PARSE_CONFIG + error.message, error.errorID);
			}
			
			if(configVos)
			{
				var aL : int = configVos.length;
				for(var i : int = 0;i < aL;i++)
				{
					var configVo : ConfigVO = configVos[i];

					var params : Array = [];

					if(!isNaN(configVo.priority))
						params.push(new Param(Param.PRIORITY, configVo.priority));

					params.push(new Param(Param.WEIGHT, configVo.weight));
					params.push(new Param(Param.RETRIES, configVo.retries));
					params.push(new Param(Param.ON_DEMAND, configVo.onDemand));
					params.push(new Param(Param.PREVENT_CACHE, configVo.preventCache));

					addConfigVo(configVo, params);
				}
			}
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

			updateTotalBytes();
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

		// --------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED
		// --------------------------------------------------------------------------------------------------------------------------------//
		protected function updateTotalBytes() : void
		{
			var bytesTotal : uint = 0;

			var unit : ILoadUnit;
			var loader : ILoader;
			var stats : ILoadStats;

			for(var i : int = 0;i < _numUnits;i++)
			{
				unit = getUnit(_ids[i]);

				if(!unit.getParam(Param.ON_DEMAND))
				{
					loader = unit.loader;
					stats = loader.stats;

					bytesTotal += stats.bytesTotal;
				}
			}

			_stats.bytesTotal = bytesTotal;
		}

		protected function addConfigVo(configVo : ConfigVO, params : Array) : void
		{
			addLazy(configVo.id, configVo.base + configVo.src, configVo.type, params);
		}

		protected function get configParser() : IConfigParser
		{
			if(_configParser)
				return _configParser;

			_configParser = new _configParserClass();
			return _configParser;
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// PUBLIC GETTERS/SETTERS
		// --------------------------------------------------------------------------------------------------------------------------------//
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
			super.unit = value;
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

		/**
		 * @inheritDoc
		 */
		public function get configParserClass() : Class
		{
			return _configParserClass;
		}

		/**
		 * @inheritDoc
		 */
		public function set configParserClass(value : Class) : void
		{
			_configParserClass = value;
		}
	}
}