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
		protected var _onError : ErrorSignal;
		protected var _onHttpStatus : HttpStatusSignal;

		protected var _onOpen : LoaderSignal;
		protected var _onProgress : ProgressSignal;
		protected var _onComplete : LoaderSignal;

		protected var _onAddedToParent : LoaderSignal;
		protected var _onRemovedFromParent : LoaderSignal;

		protected var _id : String;
		protected var _type : String;
		protected var _parent : ILoader;
		protected var _request : URLRequest;

		protected var _stats : ILoadStats;

		protected var _params : Object;
		protected var _retryTally : uint;

		protected var _invoked : Boolean;
		protected var _inProgress : Boolean;
		protected var _stopped : Boolean;
		protected var _loaded : Boolean;
		protected var _failed : Boolean;

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

		protected function initParams() : void
		{
			_params = {};

			setParam(Param.PRIORITY, 0);
			setParam(Param.RETRIES, 3);
			setParam(Param.ON_DEMAND, false);
			setParam(Param.WEIGHT, 0);
		}

		protected function initSignals() : void
		{
			_onError = new ErrorSignal(this);
			_onHttpStatus = new HttpStatusSignal(this);

			_onOpen = new LoaderSignal(this);
			_onProgress = new ProgressSignal(this);
			_onComplete = new LoaderSignal(this);

			_onAddedToParent = new LoaderSignal(this, IAssetLoader);
			_onRemovedFromParent = new LoaderSignal(this, IAssetLoader);

			_onAddedToParent.add(addedToParent_handler);
			_onRemovedFromParent.add(removedFromParent_handler);
		}

		/**
		 * @inheritDoc
		 */
		public function start() : void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function stop() : void
		{
			_stopped = true;
			_inProgress = false;
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
		protected function addedToParent_handler(signal : LoaderSignal, parent : IAssetLoader) : void
		{
			_parent = parent;

			// Inherit prevent cache from parent if undefinded
			if(_params[Param.PREVENT_CACHE] == undefined)
				setParam(Param.PREVENT_CACHE, _parent.getParam(Param.PREVENT_CACHE));
		}

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
		public function get onError() : ErrorSignal
		{
			return _onError;
		}

		public function get onHttpStatus() : HttpStatusSignal
		{
			return _onHttpStatus;
		}

		public function get onOpen() : LoaderSignal
		{
			return _onOpen;
		}

		public function get onProgress() : ProgressSignal
		{
			return _onProgress;
		}

		public function get onComplete() : LoaderSignal
		{
			return _onComplete;
		}

		public function get onAddedToParent() : LoaderSignal
		{
			return _onAddedToParent;
		}

		public function get onRemovedFromParent() : LoaderSignal
		{
			return _onRemovedFromParent;
		}
	}
}
