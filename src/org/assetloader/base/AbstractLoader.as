package org.assetloader.base
{
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoadStats;
	import org.assetloader.core.ILoader;
	import org.assetloader.core.IParam;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.HttpStatusSignal;
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.signals.ProgressSignal;

	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class AbstractLoader implements ILoader
	{
		/**
		 * @private
		 */
		protected var _onError : ErrorSignal;
		/**
		 * @private
		 */
		protected var _onHttpStatus : HttpStatusSignal;

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

		/**
		 * @private
		 */
		protected var _onAddedToParent : LoaderSignal;
		/**
		 * @private
		 */
		protected var _onRemovedFromParent : LoaderSignal;

		/**
		 * @private
		 */
		protected var _onStart : LoaderSignal;
		/**
		 * @private
		 */
		protected var _onStop : LoaderSignal;

		/**
		 * @private
		 */
		protected var _id : String;
		/**
		 * @private
		 */
		protected var _type : String;
		/**
		 * @private
		 */
		protected var _parent : ILoader;
		/**
		 * @private
		 */
		protected var _request : URLRequest;

		/**
		 * @private
		 */
		protected var _stats : ILoadStats;

		/**
		 * @private
		 */
		protected var _params : Object;
		/**
		 * @private
		 */
		protected var _retryTally : uint;

		/**
		 * @private
		 */
		protected var _invoked : Boolean;
		/**
		 * @private
		 */
		protected var _inProgress : Boolean;
		/**
		 * @private
		 */
		protected var _stopped : Boolean;
		/**
		 * @private
		 */
		protected var _loaded : Boolean;
		/**
		 * @private
		 */
		protected var _failed : Boolean;

		/**
		 * @private
		 */
		protected var _data : *;

		public function AbstractLoader(id : String, type : String, request : URLRequest = null)
		{
			_id = id;
			_type = type;
			_request = request;

			_stats = new LoaderStats();

			initParams();
			initSignals();
		}

		/**
		 * @private
		 */
		protected function initParams() : void
		{
			_params = {};

			setParam(Param.PRIORITY, 0);
			setParam(Param.RETRIES, 3);
			setParam(Param.ON_DEMAND, false);
			setParam(Param.WEIGHT, 0);
		}

		/**
		 * @private
		 */
		protected function initSignals() : void
		{
			_onError = new ErrorSignal();
			_onHttpStatus = new HttpStatusSignal();

			_onOpen = new LoaderSignal();
			_onProgress = new ProgressSignal();
			_onComplete = new LoaderSignal();

			_onAddedToParent = new LoaderSignal(IAssetLoader);
			_onRemovedFromParent = new LoaderSignal(IAssetLoader);

			_onAddedToParent.add(addedToParent_handler);
			_onRemovedFromParent.add(removedFromParent_handler);

			_onStart = new LoaderSignal();
			_onStop = new LoaderSignal();
		}

		/**
		 * @inheritDoc
		 */
		public function start() : void
		{
			_stats.start();
			_onStart.dispatch(this);
		}

		/**
		 * @inheritDoc
		 */
		public function stop() : void
		{
			_stopped = true;
			_inProgress = false;
			_onStop.dispatch(this);
		}

		/**
		 * @inheritDoc
		 */
		public function destroy() : void
		{
			stop();

			_stats.reset();

			_data = null;

			_invoked = false;
			_inProgress = false;
			_stopped = false;
			_loaded = false;
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED HANDLERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		/**
		 * @private
		 */
		protected function addedToParent_handler(signal : LoaderSignal, parent : IAssetLoader) : void
		{
			if(_parent)
				throw new AssetLoaderError(AssetLoaderError.ALREADY_CONTAINED_BY_OTHER(_id, _parent.id));

			_parent = parent;

			// Inherit prevent cache from parent if undefinded
			if(_params[Param.PREVENT_CACHE] == undefined)
				setParam(Param.PREVENT_CACHE, _parent.getParam(Param.PREVENT_CACHE));

			// Inherit base from parent if undefinded
			if(_params[Param.BASE] == undefined || _params[Param.BASE] == null)
				setParam(Param.BASE, _parent.getParam(Param.BASE));
		}

		/**
		 * @private
		 */
		protected function removedFromParent_handler(signal : LoaderSignal, parent : IAssetLoader) : void
		{
			_parent = null;
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// PUBLIC GETTERS/SETTERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		/**
		 * @inheritDoc
		 */
		public function get parent() : ILoader
		{
			return _parent;
		}

		/**
		 * @inheritDoc
		 */
		public function get stats() : ILoadStats
		{
			return _stats;
		}

		/**
		 * @inheritDoc
		 */
		public function get invoked() : Boolean
		{
			return _invoked;
		}

		/**
		 * @inheritDoc
		 */
		public function get inProgress() : Boolean
		{
			return _inProgress;
		}

		/**
		 * @inheritDoc
		 */
		public function get stopped() : Boolean
		{
			return _stopped;
		}

		/**
		 * @inheritDoc
		 */
		public function get loaded() : Boolean
		{
			return _loaded;
		}

		/**
		 * @inheritDoc
		 */
		public function get data() : *
		{
			return _data;
		}

		/**
		 * @inheritDoc
		 */
		public function hasParam(id : String) : Boolean
		{
			if(_parent)
				return (_params[id] != undefined) || parent.hasParam(id);
			return (_params[id] != undefined);
		}

		/**
		 * @inheritDoc
		 */
		public function setParam(id : String, value : *) : void
		{
			_params[id] = value;

			switch(id)
			{
				case Param.WEIGHT:
					_stats.bytesTotal = value;
					break;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function getParam(id : String) : *
		{
			if(_parent && _params[id] == undefined)
				return parent.getParam(id);
			return _params[id];
		}

		/**
		 * @inheritDoc
		 */
		public function addParam(param : IParam) : void
		{
			setParam(param.id, param.value);
		}

		/**
		 * @inheritDoc
		 */
		public function get id() : String
		{
			return _id;
		}

		/**
		 * @inheritDoc
		 */
		public function get request() : URLRequest
		{
			return _request;
		}

		/**
		 * @inheritDoc
		 */
		public function get type() : String
		{
			return _type;
		}

		/**
		 * @inheritDoc
		 */
		public function get params() : Object
		{
			return _params;
		}

		/**
		 * @inheritDoc
		 */
		public function get retryTally() : uint
		{
			return _retryTally;
		}

		/**
		 * @inheritDoc
		 */
		public function get failed() : Boolean
		{
			return _failed;
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// PUBLIC SIGNALS
		// --------------------------------------------------------------------------------------------------------------------------------//

		/**
		 * @inheritDoc
		 */
		public function get onError() : ErrorSignal
		{
			return _onError;
		}

		/**
		 * @inheritDoc
		 */
		public function get onHttpStatus() : HttpStatusSignal
		{
			return _onHttpStatus;
		}

		/**
		 * @inheritDoc
		 */
		public function get onOpen() : LoaderSignal
		{
			return _onOpen;
		}

		/**
		 * @inheritDoc
		 */
		public function get onProgress() : ProgressSignal
		{
			return _onProgress;
		}

		/**
		 * @inheritDoc
		 */
		public function get onComplete() : LoaderSignal
		{
			return _onComplete;
		}

		/**
		 * @inheritDoc
		 */
		public function get onAddedToParent() : LoaderSignal
		{
			return _onAddedToParent;
		}

		/**
		 * @inheritDoc
		 */
		public function get onRemovedFromParent() : LoaderSignal
		{
			return _onRemovedFromParent;
		}

		/**
		 * @inheritDoc
		 */
		public function get onStart() : LoaderSignal
		{
			return _onStart;
		}

		/**
		 * @inheritDoc
		 */
		public function get onStop() : LoaderSignal
		{
			return _onStop;
		}
	}
}
