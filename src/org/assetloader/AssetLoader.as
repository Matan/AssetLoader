package org.assetloader
{
	import org.assetloader.base.AssetLoaderBase;
	import org.assetloader.base.AssetLoaderError;
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	import org.assetloader.parsers.URLParser;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;

	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class AssetLoader extends AssetLoaderBase implements IAssetLoader
	{
		/**
		 * @private
		 */
		protected var _onChildOpen : LoaderSignal;
		/**
		 * @private
		 */
		protected var _onChildError : ErrorSignal;
		/**
		 * @private
		 */
		protected var _onChildComplete : LoaderSignal;

		public function AssetLoader(id : String = "PrimaryGroup")
		{
			super(id);
		}

		/**
		 * @private
		 */
		override protected function initSignals() : void
		{
			super.initSignals();
			_onChildOpen = new LoaderSignal(ILoader);
			_onChildError = new ErrorSignal(ILoader);
			_onChildComplete = new LoaderSignal(ILoader);
		}

		/**
		 * @inheritDoc
		 */
		public function addConfig(config : String) : void
		{
			var urlParser : URLParser = new URLParser(config);
			if(urlParser.isValid)
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
					throw new AssetLoaderError(AssetLoaderError.COULD_NOT_PARSE_CONFIG(_id, error.message), error.errorID);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function start() : void
		{
			_data = _assets;
			_invoked = true;
			_stopped = false;

			sortIdsByPriority();

			if(numConnections == 0)
				numConnections = _numLoaders;

			super.start();

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

		// --------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED FUNCTIONS
		// --------------------------------------------------------------------------------------------------------------------------------//
		/**
		 * @private
		 */
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

		/**
		 * @private
		 */
		protected function startNextLoader() : void
		{
			if(_invoked)
			{
				var loader : ILoader;
				var ON_DEMAND : String = Param.ON_DEMAND;
				for(var i : int = 0;i < _numLoaders;i++)
				{
					loader = getLoader(_ids[i]);

					if(!loader.loaded && !loader.failed && !loader.getParam(ON_DEMAND))
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

		/**
		 * @private
		 */
		protected function checkForComplete(signal : LoaderSignal) : void
		{
			var sum : int = _failOnError ? _numLoaded : _numLoaded + _numFailed;
			if(sum == _numLoaders)
				super.complete_handler(signal, _assets);
			else
				startNextLoader();
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED HANDLERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		/**
		 * @private
		 */
		override protected function open_handler(signal : LoaderSignal) : void
		{
			_inProgress = true;
			_onChildOpen.dispatch(this, signal.loader);
			super.open_handler(signal);
		}

		/**
		 * @private
		 */
		override protected function error_handler(signal : ErrorSignal) : void
		{
			var loader : ILoader = signal.loader;

			_failedIds.push(loader.id);
			_numFailed = _failedIds.length;

			_onChildError.dispatch(this, signal.type, signal.message, loader);
			super.error_handler(signal);

			if(!_failOnError)
				checkForComplete(signal);
			else
				startNextLoader();
		}

		/**
		 * @private
		 */
		override protected function complete_handler(signal : LoaderSignal, data : * = null) : void
		{
			var loader : ILoader = signal.loader;

			removeListeners(loader);

			_assets[loader.id] = loader.data;
			_loadedIds.push(loader.id);
			_numLoaded = _loadedIds.length;

			_onChildComplete.dispatch(this, signal.loader);

			checkForComplete(signal);
		}

		/**
		 * @private
		 */
		protected function configLoader_complete_handler(signal : LoaderSignal, data : *) : void
		{
			var loader : ILoader = signal.loader;
			loader.onComplete.remove(configLoader_complete_handler);
			loader.onError.remove(error_handler);

			if(!configParser.isValid(loader.data))
				_onError.dispatch(this, "config-error", "Could not parse config after it has been loaded.");
			else
			{
				addConfig(loader.data);
				_onConfigLoaded.dispatch(this);
			}

			loader.destroy();
		}

		/**
		 * @inheritDoc
		 */
		public function get onChildOpen() : LoaderSignal
		{
			return _onChildOpen;
		}

		/**
		 * @inheritDoc
		 */
		public function get onChildError() : ErrorSignal
		{
			return _onChildError;
		}

		/**
		 * @inheritDoc
		 */
		public function get onChildComplete() : LoaderSignal
		{
			return _onChildComplete;
		}
	}
}