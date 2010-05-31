package org.assetloader.base
{
	import org.assetloader.core.ILoader;
	import org.assetloader.core.ILoadUnit;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * @author Matan Uberstein
	 */
	public class AssetLoaderBase implements IEventDispatcher
	{
		protected var _eventDispatcher : IEventDispatcher;

		protected var _assets : Dictionary;
		protected var _units : Dictionary;
		protected var _ids : Array;

		public function AssetLoaderBase(eventDispatcher : IEventDispatcher = null)
		{
			_eventDispatcher = eventDispatcher || new EventDispatcher();
			
			_assets = new Dictionary(true);
			_units = new Dictionary(true);
			_ids = [];
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
			var unit : ILoadUnit = new LoadUnit(id, request, type, assetParams);
			
			_units[id] = unit;
			_ids.push(id);
			
			return unit.loader;
		}

		/**
		 * @inheritDoc
		 */
		public function destroy() : void
		{
			_assets = new Dictionary(true);
			_units = new Dictionary(true);
			_ids = [];
		}

		/**
		 * @inheritDoc
		 */
		public function getLoadUnit(id : String) : ILoadUnit
		{
			return _units[id];
		}

		/**
		 * @inheritDoc
		 */
		public function getLoader(id : String) : ILoader
		{
			return getLoadUnit(id).loader;
		}

		/**
		 * @inheritDoc
		 */
		public function getAsset(id : String) : *
		{
			return _assets[id];
		}

		/**
		 * @inheritDoc
		 */
		public function hasLoadUnit(id : String) : Boolean
		{
			return (_units[id] != undefined);
		}

		/**
		 * @inheritDoc
		 */
		public function hasLoader(id : String) : Boolean
		{
			if(hasLoadUnit(id))
				return (getLoadUnit(id).loader != null);
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function hasAsset(id : String) : Boolean
		{
			return (_assets[id] != undefined);
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// IEventDispatcher
		//--------------------------------------------------------------------------------------------------------------------------------//
		public function dispatchEvent(event : Event) : Boolean
		{
			if(_eventDispatcher.hasEventListener(event.type))
				return _eventDispatcher.dispatchEvent(event);
			return false;
		}

		public function hasEventListener(type : String) : Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}

		public function willTrigger(type : String) : Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}

		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}
}