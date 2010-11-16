package org.assetloader
{
	import flash.net.URLRequest;

	import org.assetloader.base.AssetLoaderBase;
	import org.assetloader.base.AssetLoaderError;
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;

	/**
	 * @author Matan Uberstein
	 */
	public class AssetLoader extends AssetLoaderBase implements IAssetLoader
	{
		protected var _onChildOpen : LoaderSignal;
		protected var _onChildError : ErrorSignal;
		protected var _onChildComplete : LoaderSignal;

		protected var _loadedIds : Array;
		protected var _numLoaded : int;

		public function AssetLoader(id : String = "PrimaryGroup")
		{
			super(id);
			_loadedIds = [];
		}

		override protected function initSignals() : void
		{
			super.initSignals();
			_onChildOpen = new LoaderSignal(this, ILoader);
			_onChildError = new ErrorSignal(this, ILoader);
			_onChildComplete = new LoaderSignal(this, ILoader);
		}

		/**
		 * @inheritDoc
		 */
		public function addConfig(config : String) : void
		{
			if(!configParser.isValid(config))
			{
				var loader : ILoader = _loaderFactory.produce("config", AssetType.TEXT, new URLRequest(config));
				loader.setParam(Param.PREVENT_CACHE, true);

				loader.onError.add(error_handler);
				loader.onComplete.add(configLoader_complete_handler);
				loader.start();
			}
			else
			{
				try
				{
					configParser.parse(this, config);
				}
				catch(error : Error)
				{
					throw new AssetLoaderError(AssetLoaderError.COULD_NOT_PARSE_CONFIG + error.message, error.errorID);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function remove(id : String) : ILoader
		{
			var loader : ILoader = super.remove(id);
			if(loader)
			{
				if(loader.loaded)
					_loadedIds.splice(_loadedIds.indexOf(id), 1);

				_numLoaded = _loadedIds.length;
			}

			return loader;
		}

		/**
		 * @inheritDoc
		 */
		override public function start() : void
		{
			_data = _assets;
			_invoked = true;
			_stopped = false;
			_inProgress = true;

			sortIdsByPriority();

			_stats.start();

			if(numConnections == 0)
				numConnections = _numLoaders;

			for(var k : int = 0;k < numConnections;k++)
			{
				startNextLoader();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function startLoader(id : String) : void
		{
			var loader : ILoader = getLoader(id);
			if(loader)
				loader.start();

			updateTotalBytes();
		}

		/**
		 * @inheritDoc
		 */
		override public function stop() : void
		{
			var loader : ILoader;

			for(var i : int = 0;i < _numLoaders;i++)
			{
				loader = getLoader(_ids[i]);

				if(!loader.loaded)
					loader.stop();
			}

			super.stop();
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy() : void
		{
			/*_onChildComplete.removeAll();
			_onChildError.removeAll();*/

			super.destroy();
		}

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

		// --------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED FUNCTIONS
		// --------------------------------------------------------------------------------------------------------------------------------//

		protected function sortIdsByPriority() : void
		{
			var priorities : Array = [];
			for(var i : int = 0;i < _numLoaders;i++)
			{
				var loader : ILoader = getLoader(_ids[i]);
				priorities.push(loader.getParam(Param.PRIORITY));
			}

			var sortedIndexs : Array = priorities.sort(Array.NUMERIC | Array.DESCENDING | Array.RETURNINDEXEDARRAY);
			var idsCopy : Array = _ids.concat();

			for(var j : int = 0;j < _numLoaders;j++)
			{
				_ids[j] = idsCopy[sortedIndexs[j]];
			}
		}

		protected function startNextLoader() : void
		{
			if(_invoked)
			{
				for(var i : int = 0;i < _numLoaders;i++)
				{
					var loader : ILoader = getLoader(_ids[i]);

					if(!loader.loaded && loader.retryTally <= loader.getParam(Param.RETRIES) && !loader.getParam(Param.ON_DEMAND))
					{
						if(!loader.invoked || (loader.invoked && loader.stopped))
						{
							startLoader(loader.id);
							return;
						}
					}
				}
			}
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED HANDLERS
		// --------------------------------------------------------------------------------------------------------------------------------//

		override protected function open_handler(signal : LoaderSignal) : void
		{
			_onChildOpen.dispatch(signal.loader);
			super.open_handler(signal);
		}

		override protected function error_handler(signal : ErrorSignal) : void
		{
			var loader : ILoader = signal.loader;

			if(loader.retryTally < loader.getParam(Param.RETRIES))
			{
				loader.retryTally++;
				startLoader(loader.id);
			}
			else
			{
				_onChildError.dispatch(signal.type, signal.message, signal.loader);
				super.error_handler(signal);

				startNextLoader();
			}
		}

		override protected function complete_handler(signal : LoaderSignal, data : * = null) : void
		{
			var loader : ILoader = signal.loader;

			removeListeners(loader);

			_assets[loader.id] = loader.data;
			_loadedIds.push(loader.id);
			_numLoaded = _loadedIds.length;

			_onChildComplete.dispatch(signal.loader);

			if(_numLoaded == _numLoaders)
				super.complete_handler(signal, _assets);
			else
				startNextLoader();
		}

		protected function configLoader_complete_handler(signal : LoaderSignal, data : *) : void
		{
			var loader : ILoader = signal.loader;
			loader.onComplete.remove(configLoader_complete_handler);
			loader.onError.remove(error_handler);

			if(!configParser.isValid(loader.data))
				throw new AssetLoaderError(AssetLoaderError.COULD_NOT_VALIDATE_CONFIG);
			else
			{
				addConfig(loader.data);
				_onConfigLoaded.dispatch();
			}

			loader.destroy();
		}

		public function get onChildOpen() : LoaderSignal
		{
			return _onChildOpen;
		}

		public function get onChildError() : ErrorSignal
		{
			return _onChildError;
		}

		public function get onChildComplete() : LoaderSignal
		{
			return _onChildComplete;
		}
	}
}