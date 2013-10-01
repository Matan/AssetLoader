package fl.display {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	/**
	 * This class is provided as example code. Used by SafeLoader to do the bulk of the
	 * heavy lifting of the safe loading of SWF files using TLF with default RSL preloading
	 * settings. This class has been developed to be compatible with Flash Player 10, but
	 * if you are using AIR and you need access to the childSandboxBridge or parentSandboxBridge
	 * properties, you can uncomment them in the code below.
	 */

	public class SafeLoaderInfo extends EventDispatcher{

		private var _safeLoader:SafeLoader;
		private var _loadDoneCallback:Function;
		private var _realLI:LoaderInfo;

		private var _rslPreloaderLoaded:Boolean;
		private var _numAdded:int;

		/**
		 * it is never useful to create a SafeLoaderInfo directly. It should always
		 * be created by the SafeLoader and accessed via the contentLoaderInfo property.
		 */
		public function SafeLoaderInfo(l:SafeLoader, c:Function)
		{
			_rslPreloaderLoaded = false;
			_numAdded = 0;

			_safeLoader = l;
			_loadDoneCallback = c;
			_realLI = l.realLoader.contentLoaderInfo;

			_realLI.addEventListener(Event.COMPLETE, handleLoaderInfoEvent);
			_realLI.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleLoaderInfoEvent);
			_realLI.addEventListener(Event.INIT, handleLoaderInfoEvent);
			_realLI.addEventListener(IOErrorEvent.IO_ERROR, handleLoaderInfoEvent);
			_realLI.addEventListener(Event.OPEN, handleLoaderInfoEvent);
			_realLI.addEventListener(ProgressEvent.PROGRESS, handleProgressEvent);
			_realLI.addEventListener(Event.UNLOAD, handleLoaderInfoEvent);
		}

		public function get actionScriptVersion():uint { return _realLI.actionScriptVersion; }
		public function get applicationDomain():ApplicationDomain { return _realLI.applicationDomain; }
		public function get bytes():ByteArray { return _realLI.bytes; }

		/**
		 * prevent bytesLoaded from equalling bytesTotal until we are certain that everything
		 * is loaded completely correctly. Users should not rely on this to assume that everything
		 * is ready, they should be using the init and complete events, but just in case.
		 */
		public function get bytesLoaded():uint {
			if (_realLI.bytesLoaded >= _realLI.bytesTotal && _safeLoader.content == null) {
				return _realLI.bytesTotal - 1;
			}
			return _realLI.bytesLoaded;
		}

		public function get bytesTotal():uint { return _realLI.bytesTotal; }
		public function get childAllowsParent():Boolean { return _realLI.childAllowsParent; }

		// only for AIR apps.
		public function get childSandboxBridge():Object { return _realLI["childSandboxBridge"]; }

		public function get content():DisplayObject { return _safeLoader.content; }

		public function get contentType():String { return _realLI.contentType; }
		public function get frameRate():Number { return _realLI.frameRate; }
		public function get height():int { return _realLI.height; }
		public function get loader():SafeLoader { return _safeLoader; }
		public function get loaderURL():String { return _realLI.loaderURL; }
		public function get parameters():Object { return _realLI.parameters; }
		public function get parentAllowsChild():Boolean { return _realLI.parentAllowsChild; }

		// only for AIR apps.
		public function get parentSandboxBridge():Object { return _realLI["parentSandboxBridge"]; }

		public function get sameDomain():Boolean { return _realLI.sameDomain; }
		public function get sharedEvents():EventDispatcher { return _realLI.sharedEvents; }
		public function get swfVersion():uint { return _realLI.swfVersion; }
		public function get url():String { return _realLI.url; }
		public function get width():int { return _realLI.width; }

		private function handleLoaderInfoEvent(e:Event):void
		{
			switch (e.type) {
			case HTTPStatusEvent.HTTP_STATUS:
			case IOErrorEvent.IO_ERROR:
			case Event.OPEN:
			case Event.UNLOAD:
				// just forward these events
				dispatchEvent(e);
				break;
			case Event.INIT:
				// check if we have loaded an RSL preloader SWF
				_rslPreloaderLoaded = false;
				var theContent:DisplayObject = _realLI.content;
				try {
					var theName:String = getQualifiedClassName(theContent);
					if (theName.substr(-13) == "__Preloader__") {
						var rslPreloader:Object = theContent["__rslPreloader"];
						if (rslPreloader != null) {
							theName = getQualifiedClassName(rslPreloader);
							if (theName == "fl.rsl::RSLPreloader") {
								_rslPreloaderLoaded = true;
								_numAdded = 0;
								theContent.addEventListener(Event.ADDED, handleAddedEvent);
							}
						}
					}
				} catch (e:Error) {
					_rslPreloaderLoaded = false;
				}
				if (!_rslPreloaderLoaded) {
					_loadDoneCallback(theContent);
					if (_realLI.bytesLoaded >= _realLI.bytesTotal) {
						dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _realLI.bytesLoaded, _realLI.bytesTotal));
					}
					dispatchEvent(e);
				}
				break;
			case Event.COMPLETE:
				if (!_rslPreloaderLoaded) dispatchEvent(e);
				break;
			}
		}

		private function handleProgressEvent(e:ProgressEvent):void
		{
			// don't dispatch event with progress at 100% completion until
			// we have determined whether we need to stall for the RSL preload
			// to complete
			if (e.bytesLoaded < e.bytesTotal || _safeLoader.content != null) {
				dispatchEvent(e);
			}
		}

		private function handleAddedEvent(e:Event):void
		{
			// check to ensure this was actually something added to the Loader.content
			var c:DisplayObject = e.target as DisplayObject;
			var p:DisplayObjectContainer = e.currentTarget as DisplayObjectContainer;
			if (c != null && p != null && c.parent == p) {
				_numAdded++;
			}
			// the first thing added will be the loader animation swf, so ignore that
			if (_numAdded > 1) {
				e.currentTarget.removeEventListener(Event.ADDED, handleAddedEvent);
				// if the load was cancelled, then _loadDoneCallback() will return false
				if (_loadDoneCallback(c)) {
					if (_realLI.bytesLoaded >= _realLI.bytesTotal) {
						dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _realLI.bytesLoaded, _realLI.bytesTotal));
					}
					dispatchEvent(new Event(Event.INIT, false, false));
					dispatchEvent(new Event(Event.COMPLETE, false, false));
				}
			}
		}

	}
}