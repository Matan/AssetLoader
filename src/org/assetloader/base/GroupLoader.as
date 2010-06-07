package org.assetloader.base
{
	import org.assetloader.core.IGroupLoader;
	import org.assetloader.core.ILoadStats;
	import org.assetloader.core.ILoadUnit;
	import org.assetloader.core.ILoader;
	import org.assetloader.events.GroupLoaderEvent;

	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;

	[Event(name="ASSET_LOADED", type="org.assetloader.events.GroupLoaderEvent")]

	[Event(name="ERROR", type="org.assetloader.events.GroupLoaderEvent")]

	[Event(name="progress", type="flash.events.ProgressEvent")]

	[Event(name="complete", type="flash.events.Event")]

	[Event(name="open", type="flash.events.Event")]

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

	/**
	 * @author Matan Uberstein
	 */
	public class GroupLoader extends GroupLoaderBase implements IGroupLoader
	{
		protected var _loadedIds : Array;

		protected var _numLoaded : int;

		public function GroupLoader()
		{
			super();
			_loadedIds = [];
			_stats = new MultiLoaderStats();
		}

		override public function addUnit(unit : ILoadUnit) : ILoader 
		{
			var loader : ILoader = super.addUnit(unit);
			
			if(group)
			{
				var params : Object = group.params;
			
				//Apply params when unit is added. Incase unit is added after param was set.
				for(var id : String in params) 
				{
					group.setParam(id, params[id]);
				}
			}
			
			return loader;
		}

		/**
		 * @inheritDoc
		 */
		override public function remove(id : String) : void 
		{
			var loader : ILoader = getLoader(id);
			if(loader)
			{
				removeListeners(loader);
				
				if(loader.loaded)
					_loadedIds.splice(_loadedIds.indexOf(id), 1);
					
				_numLoaded = _loadedIds.length;
				
				super.remove(id);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function start() : void
		{
			_invoked = true;
			_stopped = false;
			
			sortIdsByPriority();
			
			_stats.start();
			
			if(numConnections == 0)
				numConnections = _numUnits;
			
			for(var k : int = 0;k < numConnections;k++) 
			{
				startNextUnit();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function startUnit(id : String) : void
		{
			var unit : ILoadUnit = getUnit(id);
			if(unit)
			{
				var loader : ILoader = unit.loader;
				loader.start();
			}
			
			updateTotalBytes();
		}

		/**
		 * @inheritDoc
		 */
		override public function stop() : void
		{
			var loader : ILoader;
			
			for(var i : int = 0;i < _numUnits;i++) 
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
			var loader : ILoader;
			
			for(var i : int = 0;i < _numUnits;i++) 
			{
				loader = getLoader(_ids[i]);
				
				removeListeners(loader);
				
				loader.destroy();
			}
			
			_stats.reset();
			
			_loadedIds.splice(0, _loadedIds.length);
			_numLoaded = 0;
			
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

		//--------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED FUNCTIONS
		//--------------------------------------------------------------------------------------------------------------------------------//

		protected function sortIdsByPriority() : void
		{
			var priorities : Array = [];
			for(var i : int = 0;i < _numUnits;i++) 
			{
				var unit : ILoadUnit = getUnit(_ids[i]);
				priorities.push(unit.getParam(Param.PRIORITY));
			}
			
			var sortedIndexs : Array = priorities.sort(Array.NUMERIC | Array.DESCENDING | Array.RETURNINDEXEDARRAY);
			var idsCopy : Array = _ids.concat();
			
			for(var j : int = 0;j < _numUnits;j++) 
			{
				_ids[j] = idsCopy[sortedIndexs[j]];
			}
		}

		protected function startNextUnit() : void
		{
			for(var i : int = 0;i < _numUnits;i++) 
			{
				var unit : ILoadUnit = getUnit(_ids[i]);
				var loader : ILoader = unit.loader;
				
				if(!loader.loaded && unit.retryTally <= unit.getParam(Param.RETRIES) && !unit.getParam(Param.ON_DEMAND))
				{
					if(!loader.invoked || (loader.invoked && loader.stopped))
					{
						startUnit(unit.id);
						return;
					}
				}
			}
		}

		protected function retryUnit(loader : ILoader, errorType : String, errorText : String) : void
		{
			var unit : ILoadUnit = loader.unit;
			
			if(unit.retryTally < unit.getParam(Param.RETRIES))
			{
				unit.retryTally++;
				startUnit(unit.id);
			}
			else
			{
				dispatchError(unit, errorType, errorText);
				
				startNextUnit();
			}
		}

		protected function dispatchError(unit : ILoadUnit, errorType : String, errorText : String) : void
		{
			var event : GroupLoaderEvent = new GroupLoaderEvent(GroupLoaderEvent.ERROR, unit.id, group.id, unit.type, _assets);
			event.errorType = errorType;			event.errorText = errorText;
			
			dispatchEvent(event);
		}

		protected function dispatchOpen(unit : ILoadUnit) : void
		{
			unit;
			dispatchEvent(new Event(Event.OPEN));
		}

		protected function dispatchProgress() : void
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _stats.bytesLoaded, _stats.bytesTotal));
		}

		protected function dispatchAssetLoaded(unit : ILoadUnit) : void
		{
			var event : GroupLoaderEvent = new GroupLoaderEvent(GroupLoaderEvent.ASSET_LOADED, unit.id, group.id, unit.type, _assets);
			event.data = unit.loader.data;
			dispatchEvent(event);
		}

		protected function dispatchComplete() : void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}

		override protected function addListeners(dispatcher : IEventDispatcher) : void
		{
			dispatcher.addEventListener(Event.OPEN, open_handler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progress_handler);
			dispatcher.addEventListener(Event.COMPLETE, complete_handler);
			
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, error_handler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error_handler);
			dispatcher.addEventListener(AsyncErrorEvent.ASYNC_ERROR, error_handler);
			dispatcher.addEventListener(ErrorEvent.ERROR, error_handler);
		}

		override protected function removeListeners(dispatcher : IEventDispatcher) : void
		{
			dispatcher.removeEventListener(Event.OPEN, open_handler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, progress_handler);
			dispatcher.removeEventListener(Event.COMPLETE, complete_handler);
			
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, error_handler);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, error_handler);
			dispatcher.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, error_handler);
			dispatcher.removeEventListener(ErrorEvent.ERROR, error_handler);
		}

		//--------------------------------------------------------------------------------------------------------------------------------//
		// PROTECTED HANDLERS
		//--------------------------------------------------------------------------------------------------------------------------------//
		override protected function error_handler(event : ErrorEvent) : void 
		{
			retryUnit(ILoader(event.target), event.type, event.text);
		}

		override protected function open_handler(event : Event) : void 
		{
			_stats.open();
			
			dispatchOpen(ILoader(event.target).unit);
		}

		override protected function progress_handler(event : ProgressEvent) : void 
		{
			_inProgress = true;
			
			var bytesLoaded : uint = 0;
			var bytesTotal : uint = 0;
			
			var unit : ILoadUnit;
			var loader : ILoader;
			var stats : ILoadStats;
			
			for(var i : int = 0;i < _numUnits;i++) 
			{
				unit = getUnit(_ids[i]);
				loader = unit.loader;
				stats = loader.stats;
				
				bytesLoaded += stats.bytesLoaded;
				bytesTotal += stats.bytesTotal;
			}
			
			_stats.update(bytesLoaded, bytesTotal);
			
			dispatchProgress();
		}

		override protected function complete_handler(event : Event) : void 
		{
			var loader : ILoader = ILoader(event.target);
			var unit : ILoadUnit = loader.unit;
			var eventClass : Class = unit.eventClass;
			
			removeListeners(loader);
			
			_assets[unit.id] = loader.data;
			_loadedIds.push(unit.id);
			_numLoaded = _loadedIds.length;
			
			dispatchAssetLoaded(unit);
			
			var groupId : String;
			if(group)
				groupId = group.id;
			
			dispatchEvent(new eventClass(eventClass.LOADED, unit.id, groupId, unit.type, loader.data));
			
			if(_numLoaded == _numUnits)
			{
				_loaded = true;
				_inProgress = false;
				_stats.done();
				
				dispatchComplete();
			}
			else
				startNextUnit();
		}
	}
}