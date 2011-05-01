package org.assetloader.base
{
	import org.assetloader.core.ILoadStats;
	import org.assetloader.core.ILoader;
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.signals.ProgressSignal;

	/**
	 * @author Matan Uberstein
	 * 
	 * Consolidates multiple ILoader's stats.
	 */
	public class StatsMonitor
	{
		/**
		 * @private
		 */
		protected var _loaders : Array;
		/**
		 * @private
		 */
		protected var _stats : ILoadStats;

		/**
		 * @private
		 */
		protected var _numLoaders : int;
		/**
		 * @private
		 */
		protected var _numComplete : int;
		/**
		 * @private
		 */
		protected var _ids : Array = [];

		/**
		 * @private
		 */
		protected var _onOpen : LoaderSignal;
		/**
		 * @private
		 */
		protected var _onProgress : ProgressSignal;
		/**
		 * @private
		 */
		protected var _onComplete : LoaderSignal;

		public function StatsMonitor()
		{
			_loaders = [];
			_stats = new LoaderStats();

			_onOpen = new LoaderSignal();
			_onProgress = new ProgressSignal();
			_onComplete = new LoaderSignal(ILoadStats);
		}

		/**
		 * Adds ILoader for monitoring.
		 * 
		 * @param loader Instance of ILoader or IAssetLoader.
		 * 
		 * @throws org.assetloader.base.AssetLoaderError ALREADY_CONTAINS_LOADER
		 */
		public function add(loader : ILoader) : void
		{
			if(_loaders.indexOf(loader) == -1)
			{
				loader.onStart.add(start_handler);

				_loaders.push(loader);
				_ids.push(loader.id);
				_numLoaders = _loaders.length;
				if(loader.loaded)
					_numComplete++;
			}
			else
				throw new AssetLoaderError(AssetLoaderError.ALREADY_CONTAINS_LOADER);
		}

		/**
		 * Removes ILoader from monitoring.
		 * 
		 * @param loader An instance of an ILoader already added.
		 * 
		 * @throws org.assetloader.base.AssetLoaderError DOESNT_CONTAIN_LOADER
		 */
		public function remove(loader : ILoader) : void
		{
			var index : int = _loaders.indexOf(loader);
			if(index != -1)
			{
				loader.onStart.remove(start_handler);
				removeListeners(loader);

				if(loader.loaded)
					_numComplete--;

				_loaders.splice(index, 1);
				_ids.splice(index, 1);
				_numLoaders = _loaders.length;
			}
			else
				throw new AssetLoaderError(AssetLoaderError.DOESNT_CONTAIN_LOADER);
		}

		/**
		 * Removes all internal listeners and clears the monitoring list.
		 * 
		 * <p>Note: After calling destroy, this instance of StatsMonitor is still usable.
		 * Simply rebuild your monitor list via the add() method.</p>
		 */
		public function destroy() : void
		{
			for each(var loader : ILoader in _loaders)
			{
				loader.onStart.remove(start_handler);
				removeListeners(loader);
			}

			_loaders = [];
			_numLoaders = 0;
			_numComplete = 0;

			_onOpen.removeAll();
			_onProgress.removeAll();
			_onComplete.removeAll();
		}

		/**
		 * @private
		 */
		protected function addListeners(loader : ILoader) : void
		{
			loader.onOpen.add(open_handler);
			loader.onProgress.add(progress_handler);
			loader.onComplete.add(complete_handler);
		}

		/**
		 * @private
		 */
		protected function removeListeners(loader : ILoader) : void
		{
			loader.onOpen.remove(open_handler);
			loader.onProgress.remove(progress_handler);
			loader.onComplete.remove(complete_handler);
		}

		/**
		 * @private
		 */
		protected function start_handler(signal : LoaderSignal) : void
		{
			for each(var loader : ILoader in _loaders)
			{
				loader.onStart.remove(start_handler);
				addListeners(loader);
			}
			_stats.start();
		}

		/**
		 * @private
		 */
		protected function open_handler(signal : LoaderSignal) : void
		{
			_stats.open();
			_onOpen.dispatch(signal.loader);
		}

		/**
		 * @private
		 */
		protected function progress_handler(signal : ProgressSignal) : void
		{
			var bytesLoaded : uint;
			var bytesTotal : uint;
			for each(var loader : ILoader in _loaders)
			{
				bytesLoaded += loader.stats.bytesLoaded;
				bytesTotal += loader.stats.bytesTotal;
			}
			_stats.update(bytesLoaded, bytesTotal);

			_onProgress.dispatch(signal.loader, _stats.latency, _stats.speed, _stats.averageSpeed, _stats.progress, _stats.bytesLoaded, _stats.bytesTotal);
		}

		/**
		 * @private
		 */
		protected function complete_handler(signal : LoaderSignal, payload : *) : void
		{
			_numComplete++;
			if(_numComplete == _numLoaders)
			{
				_stats.done();
				_onComplete.dispatch(null, _stats);
			}
		}

		/**
		 * Checks whether the StatsMonitor contains an ILoader with id passed.
		 * 
		 * @param id Id for the ILoader.
		 * 
		 * @return Boolean
		 */
		public function hasLoader(id : String) : Boolean
		{
			return (_ids.indexOf(id) != -1);
		}

		/**
		 * Gets the load with id passed.
		 * 
		 * @param id Id for the ILoader.
		 * 
		 * @return ILoader.
		 */
		public function getLoader(id : String) : ILoader
		{
			if(hasLoader(id))
				return _loaders[_ids.indexOf(id)];
			return null;
		}

		/**
		 * All the ids of the ILoaders added to this StatsMonitor.
		 * 
		 * @return Array of Strings
		 */
		public function get ids() : Array
		{
			return _ids;
		}

		/**
		 * Get the overall stats of all the ILoaders in the monitoring list.
		 * 
		 * @return ILoadStats
		 */
		public function get stats() : ILoadStats
		{
			return _stats;
		}

		/**
		 * Dispatches each time a connection has been opend.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		public function get onOpen() : LoaderSignal
		{
			return _onOpen;
		}

		/**
		 * Dispatches when loading progress has been made.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>ProgressSignal</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.ProgressSignal
		 */
		public function get onProgress() : ProgressSignal
		{
			return _onProgress;
		}

		/**
		 * Dispatches when the loading operations has completed.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>, stats:<strong>ILoadStats</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 *	 <li><strong>stats</strong> - Consolidated stats.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		public function get onComplete() : LoaderSignal
		{
			return _onComplete;
		}

		/**
		 * Gets the amount of loaders added to the monitoring queue.
		 * 
		 * @return int
		 */
		public function get numLoaders() : int
		{
			return _numLoaders;
		}

		/**
		 * Gets the amount of loaders that have finished loading.
		 * 
		 * @return int
		 */
		public function get numComplete() : int
		{
			return _numComplete;
		}
	}
}
