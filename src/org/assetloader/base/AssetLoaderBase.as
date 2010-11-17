package org.assetloader.base
{
	import org.assetloader.core.IConfigParser;
	import org.assetloader.core.ILoadStats;
	import org.assetloader.core.ILoader;
	import org.assetloader.parsers.XmlConfigParser;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;

	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * @author Matan Uberstein
	 */
	public class AssetLoaderBase extends AbstractLoader
	{
		/**
		 * @private
		 */
		protected var _onConfigLoaded : LoaderSignal;

		/**
		 * @private
		 */
		protected var _loaders : Dictionary;
		/**
		 * @private
		 */
		protected var _assets : Dictionary;
		/**
		 * @private
		 */
		protected var _ids : Array;

		/**
		 * @private
		 */
		protected var _loaderFactory : LoaderFactory;
		/**
		 * @private
		 */
		protected var _configParser : IConfigParser;

		/**
		 * @private
		 */
		protected var _numLoaders : int;
		/**
		 * @private
		 */
		protected var _numConnections : int = 3;

		public function AssetLoaderBase(id : String)
		{
			_loaders = new Dictionary(true);
			_data = _assets = new Dictionary(true);
			_loaderFactory = new LoaderFactory();
			_ids = [];

			super(id, AssetType.GROUP);
		}

		/**
		 * @private
		 */
		override protected function initSignals() : void
		{
			super.initSignals();
			_onConfigLoaded = new LoaderSignal(this);
		}

		/**
		 * @inheritDoc
		 */
		public function addLazy(id : String, url : String, type : String = "AUTO", ...params) : ILoader
		{
			return add(id, new URLRequest(url), type, params);
		}

		/**
		 * @inheritDoc
		 */
		public function add(id : String, request : URLRequest, type : String = "AUTO", ...params) : ILoader
		{
			var loader : ILoader = _loaderFactory.produce(id, type, request, params);
			addLoader(loader);
			return loader;
		}

		/**
		 * @inheritDoc
		 */
		public function addLoader(loader : ILoader) : void
		{
			_loaders[loader.id] = loader;
			_ids.push(loader.id);

			_numLoaders = _ids.length;

			if(loader.getParam(Param.PRIORITY) == 0)
				loader.setParam(Param.PRIORITY, -(_numLoaders - 1));

			addListeners(loader);

			updateTotalBytes();

			loader.onAddedToParent.dispatch(this);
		}

		/**
		 * @inheritDoc
		 */
		public function remove(id : String) : ILoader
		{
			var loader : ILoader = getLoader(id);
			if(loader)
			{
				_ids.splice(_ids.indexOf(id), 1);
				delete _loaders[id];
				delete _assets[id];

				removeListeners(loader);

				_numLoaders = _ids.length;
			}

			updateTotalBytes();

			loader.onRemovedFromParent.dispatch(this);

			return loader;
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy() : void
		{
			var loader : ILoader;

			for each(var id : String in _ids)
			{
				loader = remove(id);
				loader.destroy();
			}

			super.destroy();
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED
		// --------------------------------------------------------------------------------------------------------------------------------//
		/**
		 * @private
		 */
		protected function updateTotalBytes() : void
		{
			var bytesTotal : uint = 0;

			var loader : ILoader;
			var stats : ILoadStats;

			for(var i : int = 0;i < _numLoaders;i++)
			{
				loader = getLoader(_ids[i]);

				if(!loader.getParam(Param.ON_DEMAND))
				{
					stats = loader.stats;
					bytesTotal += stats.bytesTotal;
				}
			}

			_stats.bytesTotal = bytesTotal;
		}

		/**
		 * @private
		 */
		protected function get configParser() : IConfigParser
		{
			if(_configParser)
				return _configParser;

			_configParser = new XmlConfigParser();
			return _configParser;
		}

		/**
		 * @private
		 */
		protected function addListeners(loader : ILoader) : void
		{
			if(loader)
			{
				loader.onError.add(error_handler);
				loader.onOpen.add(open_handler);
				loader.onProgress.add(progress_handler);
				loader.onComplete.add(complete_handler);
			}
		}

		/**
		 * @private
		 */
		protected function removeListeners(loader : ILoader) : void
		{
			if(loader)
			{
				loader.onError.remove(error_handler);
				loader.onOpen.remove(open_handler);
				loader.onProgress.remove(progress_handler);
				loader.onComplete.remove(complete_handler);
			}
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED HANDLERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		/**
		 * @private
		 */
		protected function error_handler(signal : ErrorSignal) : void
		{
			_onError.dispatch(signal.type, signal.message);
		}

		/**
		 * @private
		 */
		protected function open_handler(signal : LoaderSignal) : void
		{
			_stats.open();
			_onOpen.dispatch();
		}

		/**
		 * @private
		 */
		protected function progress_handler(signal : LoaderSignal) : void
		{
			_inProgress = true;

			var bytesLoaded : uint = 0;
			var bytesTotal : uint = 0;

			var loader : ILoader;
			var stats : ILoadStats;

			for(var i : int = 0;i < _numLoaders;i++)
			{
				loader = getLoader(_ids[i]);
				stats = loader.stats;

				bytesLoaded += stats.bytesLoaded;
				bytesTotal += stats.bytesTotal;
			}

			_stats.update(bytesLoaded, bytesTotal);

			_onProgress.dispatch(_stats.latency, _stats.speed, _stats.averageSpeed, _stats.progress, _stats.bytesLoaded, _stats.bytesTotal);
		}

		/**
		 * @private
		 */
		protected function complete_handler(signal : LoaderSignal, data : * = null) : void
		{
			_loaded = true;
			_inProgress = false;
			_stats.done();

			_onComplete.dispatch(data);
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
		public function getLoader(id : String) : ILoader
		{
			if(hasLoader(id))
				return _loaders[id];
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
			return _data;
		}

		/**
		 * @inheritDoc
		 */
		public function hasLoader(id : String) : Boolean
		{
			return (_loaders[id] != undefined);
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
		public function get numLoaders() : int
		{
			return _numLoaders;
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// PUBLIC SIGNALS
		// --------------------------------------------------------------------------------------------------------------------------------//

		/**
		 * @inheritDoc
		 */
		public function get onConfigLoaded() : LoaderSignal
		{
			return _onConfigLoaded;
		}
	}
}