package org.assetloader
{
	import org.assetloader.base.AssetType;
	import org.assetloader.base.GroupLoader;
	import org.assetloader.base.LoadGroup;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.IGroupLoader;
	import org.assetloader.core.ILoadGroup;
	import org.assetloader.core.ILoadUnit;
	import org.assetloader.core.ILoader;
	import org.assetloader.events.AssetLoaderEvent;
	import org.assetloader.events.GroupLoaderEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	[Event(name="ASSET_LOADED", type="org.assetloader.events.AssetLoaderEvent")]

	[Event(name="COMPLETE", type="org.assetloader.events.AssetLoaderEvent")]

	[Event(name="PROGRESS", type="org.assetloader.events.AssetLoaderEvent")]

	[Event(name="ERROR", type="org.assetloader.events.AssetLoaderEvent")]

	[Event(name="BINARY_LOADED", type="org.assetloader.events.BinaryAssetEvent")]
	[Event(name="CSS_LOADED", type="org.assetloader.events.CSSAssetEvent")]
	[Event(name="DISPLAY_OBJECT_LOADED", type="org.assetloader.events.DisplayObjectAssetEvent")]
	[Event(name="IMAGE_LOADED", type="org.assetloader.events.ImageAssetEvent")]
	[Event(name="JSON_LOADED", type="org.assetloader.events.JSONAssetEvent")]
	[Event(name="SOUND_LOADED", type="org.assetloader.events.SoundAssetEvent")]
	[Event(name="SWF_LOADED", type="org.assetloader.events.SWFAssetEvent")]
	[Event(name="TEXT_LOADED", type="org.assetloader.events.TextAssetEvent")]
	[Event(name="VIDEO_LOADED", type="org.assetloader.events.VideoAssetEvent")]
	[Event(name="XML_LOADED", type="org.assetloader.events.XMLAssetEvent")]

	[Event(name="GROUP_LOADED", type="org.assetloader.events.GroupLoaderEvent")]

	/**
	 * @author Matan Uberstein
	 */
	public class AssetLoader extends GroupLoader implements IAssetLoader
	{

		[Inject]

		public function AssetLoader(eventDispatcher : IEventDispatcher = null)
		{
			super();
			_eventDispatcher = eventDispatcher || new EventDispatcher();
		}

		/**
		 * @inheritDoc
		 */
		public function addGroup(id : String, units : Array = null, ...params) : IGroupLoader
		{
			var group : ILoadGroup = new LoadGroup(id, units, params);
			
			addUnit(group);
			
			return group.groupLoader;
		}	

		/**
		 * @inheritDoc
		 */
		override public function addUnit(unit : ILoadUnit) : ILoader 
		{
			if(unit.type != AssetType.GROUP)
				return super.addUnit(unit);
			
			var groupLoader : IGroupLoader = IGroupLoader(super.addUnit(unit));
			var group : ILoadGroup = groupLoader.group;
			var globalParams : Object = group.globalParams;
			
			for each(var id : String in globalParams) 
			{
				unit.setParam(id, globalParams[id]);
			}
			
			return groupLoader;
		}

		/**
		 * @inheritDoc
		 */
		public function startAsset(id : String) : void
		{
			startUnit(id);
		}

		/**
		 * @inheritDoc
		 */
		public function hasGroup(id : String) : Boolean
		{
			return (_units[id] is ILoadGroup);
		}

		/**
		 * @inheritDoc
		 */
		public function getGroup(id : String) : ILoadGroup
		{
			if(hasGroup(id))
				return _units[id];
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function getGroupLoader(id : String) : IGroupLoader
		{
			if(hasUnit(id))
				return getGroup(id).groupLoader;
			return null;
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED FUNCTIONS
		//--------------------------------------------------------------------------------------------------------------------------------//
		override protected function dispatchError(unit : ILoadUnit, errorType : String, errorText : String) : void 
		{
			dispatchAssetLoaderEvent(AssetLoaderEvent.ERROR, unit, errorType, errorText);
		}

		override protected function dispatchOpen(unit : ILoadUnit) : void 
		{
			dispatchAssetLoaderEvent(AssetLoaderEvent.CONNECTION_OPENED, unit);
		}

		override protected function dispatchProgress() : void 
		{
			dispatchAssetLoaderEvent(AssetLoaderEvent.PROGRESS);
		}

		override protected function dispatchComplete() : void 
		{
			dispatchAssetLoaderEvent(AssetLoaderEvent.COMPLETE);
		}

		override protected function dispatchAssetLoaded(unit : ILoadUnit) : void 
		{
			var loader : ILoader = unit.loader;
			
			dispatchAssetLoaderEvent(AssetLoaderEvent.ASSET_LOADED, unit);
		}

		protected function dispatchAssetLoaderEvent(type : String, unit : ILoadUnit = null, errorType : String = null, errorText : String = null) : Boolean
		{
			var event : AssetLoaderEvent = new AssetLoaderEvent(type);
			
			if(unit)
			{
				var loader : ILoader = unit.loader;
				
				event.id = unit.id;
				event.assetType = unit.type;			
				if(loader.loaded)
					event.data = loader.data;
			}
			else
				event.data = data;
			
			event.progress = _stats.progress;
			event.bytesLoaded = _stats.bytesLoaded;
			event.bytesTotal = _stats.bytesTotal;
			
			event.errorType = errorType;
			event.errorText = errorText;
				
			return dispatchEvent(event);
		}

		
		override protected function addListeners(dispatcher : IEventDispatcher) : void 
		{
			super.addListeners(dispatcher);
			dispatcher.addEventListener(GroupLoaderEvent.ASSET_LOADED, assetLoaded_handler);
		}

		override protected function removeListeners(dispatcher : IEventDispatcher) : void 
		{
			super.removeListeners(dispatcher);
			dispatcher.removeEventListener(GroupLoaderEvent.ASSET_LOADED, assetLoaded_handler);
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED HANDLERS
		//--------------------------------------------------------------------------------------------------------------------------------//
		protected function assetLoaded_handler(event : GroupLoaderEvent) : void 
		{
			var groupLoader : IGroupLoader = IGroupLoader(event.currentTarget);
			var unit : ILoadUnit = groupLoader.getUnit(event.id);
			var group : ILoadGroup = groupLoader.group;
			var eventClass : Class = unit.eventClass;
			
			dispatchEvent(new eventClass(eventClass.LOADED, unit.id, group.id, unit.type, event.data));
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// IEventDispatcher
		//--------------------------------------------------------------------------------------------------------------------------------//
		override public function dispatchEvent(event : Event) : Boolean
		{
			if(_eventDispatcher.hasEventListener(event.type))
				return _eventDispatcher.dispatchEvent(event);
			return false;
		}

		override public function hasEventListener(type : String) : Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}

		override public function willTrigger(type : String) : Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}

		override public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}
}