package org.assetloader.loaders 
{
	import org.assetloader.base.AssetParam;
	import org.assetloader.core.ILoadUnit;
	import org.assetloader.core.ILoader;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;

	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]

	[Event(name="progress", type="flash.events.ProgressEvent")]

	[Event(name="complete", type="flash.events.Event")]

	[Event(name="open", type="flash.events.Event")]

	[Event(name="id3", type="flash.events.Event")]

	[Event(name="sampleData", type="flash.events.SampleDataEvent")]

	/**
	 * @author Matan Uberstein
	 */
	public class SoundLoader extends EventDispatcher implements ILoader
	{

		protected var _loadUnit : ILoadUnit;

		protected var _request : URLRequest;
		protected var _sound : Sound;

		protected var _progress : Number;
		protected var _invoked : Boolean;
		protected var _loaded : Boolean;

		protected var _data : *;

		public function SoundLoader() 
		{
		}

		public function start() : void
		{
			if(!_invoked)
			{
				_invoked = true;
				_request = _loadUnit.request;
				
				if(_loadUnit.hasParam(AssetParam.HEADERS))
					_request.requestHeaders = _loadUnit.getParam(AssetParam.HEADERS);
			
				_sound = new Sound();
			
				_sound.addEventListener(Event.COMPLETE, loader_complete_handler);
				_sound.addEventListener(IOErrorEvent.IO_ERROR, loader_ioError_handler);
				_sound.addEventListener(ProgressEvent.PROGRESS, loader_progress_handler);
				_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, dispatchEvent);				_sound.addEventListener(Event.ID3, dispatchEvent);				_sound.addEventListener(Event.OPEN, dispatchEvent);
				
				try
				{
					_sound.load(_request, _loadUnit.getParam(AssetParam.SOUND_LOADER_CONTEXT));
				}catch(error : SecurityError)
				{
					dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR, false, false, error.message));
				}
			}
			else
			{
				destroy();
				start();
			}
		}

		public function stop() : void
		{
			if(_invoked)
			{
				try
				{
					_sound.close();	
				}catch(error : Error)
				{
				}
			}
		}

		public function destroy() : void
		{
			removeLoaderListener();
			stop();
			
			_request = null;
			_sound = null;
			_data = null;
			_loaded = false;
			_invoked = false;
		}

		protected function loader_ioError_handler(event : IOErrorEvent) : void 
		{
			removeLoaderListener();
			
			dispatchEvent(event);
		}

		protected function loader_securityError_handler(event : SecurityErrorEvent) : void 
		{
			removeLoaderListener();
			
			dispatchEvent(event);
		}

		protected function loader_complete_handler(event : Event) : void 
		{
			removeLoaderListener();
			
			_data = _sound;
			
			_loaded = true;
			dispatchEvent(event);
		}

		protected function loader_progress_handler(event : ProgressEvent) : void
		{
			_progress = (event.bytesLoaded / event.bytesTotal) * 100;
			
			dispatchEvent(event);
		}

		protected function removeLoaderListener() : void
		{
			if(_sound)
			{
				_sound.removeEventListener(Event.COMPLETE, loader_complete_handler);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, loader_ioError_handler);
				_sound.removeEventListener(ProgressEvent.PROGRESS, loader_progress_handler);
				_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, dispatchEvent);
				_sound.removeEventListener(Event.ID3, dispatchEvent);
				_sound.removeEventListener(Event.OPEN, dispatchEvent);
			}
		}

		public function get loadUnit() : ILoadUnit
		{
			return _loadUnit;
		}

		public function set loadUnit(loadUnit : ILoadUnit) : void
		{
			_loadUnit = loadUnit;
		}

		public function get progress() : Number
		{
			return _progress;
		}

		public function get bytesLoaded() : uint
		{
			if(_sound)
				return _sound.bytesLoaded;
			return 0;
		}

		public function get bytesTotal() : uint
		{
			if(_sound)
				return _sound.bytesTotal;
			return 0;
		}

		public function get invoked() : Boolean
		{
			return _invoked;
		}

		public function get loaded() : Boolean
		{
			return _loaded;
		}

		public function get data() : *
		{
			return _data;
		}
	}
}
