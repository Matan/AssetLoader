package org.assetloader.base
{
	import org.assetloader.core.ILoadUnit;
	import org.assetloader.core.ILoader;

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

		protected var _numUnits : int;

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
			
			_numUnits = _ids.length;
			
			if(!unit.hasParam(AssetParam.PRIORITY))
				unit.setParam(AssetParam.PRIORITY, -(_numUnits - 1));
			
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
				delete _units[id];				delete _assets[id];
				
				loader.destroy();
				
				_numUnits = _ids.length;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function destroy() : void
		{
			var id:String;
			while(id = _ids.pop()){
				
				var loader : ILoader = getLoader(id);
				delete _units[id];
				delete _assets[id];
				
				loader.destroy();
			}
			_numUnits = 0;
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