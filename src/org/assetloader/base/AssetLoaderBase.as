package org.assetloader.base
{
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.IConfigParser;
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

		/**
		 * @private
		 */
		protected var _loadedIds : Array;
		/**
		 * @private
		 */
		protected var _numLoaded : int;

		/**
		 * @private
		 */
		protected var _failedIds : Array;
		/**
		 * @private
		 */
		protected var _numFailed : int;

		/**
		 * @private
		 */
		protected var _failOnError : Boolean = true;

		public function AssetLoaderBase(id : String)
		{
			_loaders = new Dictionary(true);
			_data = _assets = new Dictionary(true);
			_loaderFactory = new LoaderFactory();
			_ids = [];
			_loadedIds = [];
			_failedIds = [];

			super(id, AssetType.GROUP);
		}

		/**
		 * @private
		 */
		override protected function initSignals() : void
		{
			super.initSignals();
			_onConfigLoaded = new LoaderSignal();
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
			if(hasLoader(loader.id))
				throw new AssetLoaderError(AssetLoaderError.ALREADY_CONTAINS_LOADER_WITH_ID(_id, loader.id));

			_loaders[loader.id] = loader;

			_ids.push(loader.id);
			_numLoaders = _ids.length;

			if(loader.loaded)
			{
				_loadedIds.push(loader.id);
				_numLoaded = _loadedIds.length;
				_assets[loader.id] = loader.data;
			}
			else if(loader.failed)
			{
				_failedIds.push(loader.id);
				_numFailed = _failedIds.length;
			}

			_failed = (_numFailed > 0);
			_loaded = (_numLoaders == _numLoaded);

			if(loader.getParam(Param.PRIORITY) == 0)
				loader.setParam(Param.PRIORITY, -(_numLoaders - 1));

			loader.onStart.add(start_handler);

			updateTotalBytes();

			loader.onAddedToParent.dispatch(loader, this);
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
				
				if(loader.loaded)
					_loadedIds.splice(_loadedIds.indexOf(id), 1);
				_numLoaded = _loadedIds.length;

				if(loader.failed)
					_failedIds.splice(_failedIds.indexOf(id), 1);
				_numFailed = _failedIds.length;

				loader.onStart.remove(start_handler);
				removeListeners(loader);

				_numLoaders = _ids.length;
			}

			updateTotalBytes();

			loader.onRemovedFromParent.dispatch(loader, this);

			return loader;
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy() : void
		{
			var idsCopy : Array = _ids.concat();
			var loader : ILoader;

			for each(var id : String in idsCopy)
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

			for each(var loader : ILoader in _loaders)
			{
				if(!loader.getParam(Param.ON_DEMAND))
					bytesTotal += loader.stats.bytesTotal;
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

		/**
		 * @private
		 */
		protected function hasCircularReference(id : String) : Boolean
		{
			for each(var loader : ILoader in _loaders)
			{
				if(loader is AssetLoaderBase)
				{
					var assetloader : AssetLoaderBase = AssetLoaderBase(loader);
					if(assetloader.hasLoader(id) || assetloader.hasCircularReference(id))
						return true;
				}
			}
			return false;
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED HANDLERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		/**
		 * @private
		 */
		override protected function addedToParent_handler(signal : LoaderSignal, parent : IAssetLoader) : void
		{
			if(hasCircularReference(_id))
				throw new AssetLoaderError(AssetLoaderError.CIRCULAR_REFERENCE_FOUND(_id));

			super.addedToParent_handler(signal, parent);
		}

		protected function start_handler(signal : LoaderSignal) : void
		{
			var loader : ILoader = signal.loader;

			loader.onStart.remove(start_handler);
			loader.onStop.add(stop_handler);

			addListeners(loader);
		}

		protected function stop_handler(signal : LoaderSignal) : void
		{
			var loader : ILoader = signal.loader;

			loader.onStart.add(start_handler);
			loader.onStop.remove(stop_handler);

			removeListeners(loader);
		}

		/**
		 * @private
		 */
		protected function error_handler(signal : ErrorSignal) : void
		{
			_failed = true;
			_onError.dispatch(this, signal.type, signal.message);
		}

		/**
		 * @private
		 */
		protected function open_handler(signal : LoaderSignal) : void
		{
			_stats.open();
			_onOpen.dispatch(this);
		}

		/**
		 * @private
		 */
		protected function progress_handler(signal : LoaderSignal) : void
		{
			_inProgress = true;

			var bytesLoaded : uint = 0;
			var bytesTotal : uint = 0;

			for each(var loader : ILoader in _loaders)
			{
				bytesLoaded += loader.stats.bytesLoaded;
				bytesTotal += loader.stats.bytesTotal;
			}

			_stats.update(bytesLoaded, bytesTotal);

			_onProgress.dispatch(this, _stats.latency, _stats.speed, _stats.averageSpeed, _stats.progress, _stats.bytesLoaded, _stats.bytesTotal);
		}

		/**
		 * @private
		 */
		protected function complete_handler(signal : LoaderSignal, data : * = null) : void
		{
			_loaded = (_numLoaders == _numLoaded);
			_inProgress = false;
			_stats.done();

			_onComplete.dispatch(this, data);
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
		public function getAssetLoader(id : String) : IAssetLoader
		{
			if(hasAssetLoader(id))
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
			return _loaders.hasOwnProperty(id);
		}

		/**
		 * @inheritDoc
		 */
		public function hasAssetLoader(id : String) : Boolean
		{
			return (_loaders.hasOwnProperty(id) && _loaders[id] is IAssetLoader);
		}

		/**
		 * @inheritDoc
		 */
		public function hasAsset(id : String) : Boolean
		{
			return _assets.hasOwnProperty(id);
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

		/**
		 * @inheritDoc
		 */
		public function get loadedIds() : Array
		{
			return _loadedIds;
		}

		/**
		 * @inheritDoc
		 */
		public function get numLoaded() : int
		{
			return _numLoaded;
		}

		/**
		 * @inheritDoc
		 */
		public function get failedIds() : Array
		{
			return _failedIds;
		}

		/**
		 * @inheritDoc
		 */
		public function get numFailed() : int
		{
			return _numFailed;
		}

		/**
		 * @inheritDoc
		 */
		public function get failOnError() : Boolean
		{
			return _failOnError;
		}

		/**
		 * @inheritDoc
		 */
		public function set failOnError(value : Boolean) : void
		{
			_failOnError = value;
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