package fl.display {

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 * This class is provided as sample code. Loading a SWF with the SafeLoader instead of
	 * flash.display.Loader allows you to load a SWF that uses TLF and the default RSL
	 * preloading options and be able to script the loaded content normally. When you use
	 * the SafeLoader, you will not get the Event.INIT or Event.COMPLETE events until the
	 * RSL preloading is completed and the real content is available and when you access
	 * the content property, you will be accessing the real content. This will allow you
	 * to write script that calls between the loaded SWF that uses TLF and the loading SWF
	 * as you normally would.
	 *
	 * <p>Note that SafeLoader is NOT a subclass of flash.display.Loader, so you will need
	 * to change all type references to be SafeLoader instead of Loader.</p>
	 */

	public class SafeLoader extends Sprite 
	{
		private var _cli:SafeLoaderInfo;
		private var _loader:Loader;
		private var _content:DisplayObject;
		private var _loading:Boolean;

		public function SafeLoader()
		{
			_loading = false;
			_content = null;
			_loader = new Loader();
			_loader.visible = false;
			super.addChild(_loader);
			_cli = new SafeLoaderInfo(this, loadDoneCallback);
		}

		// called by SafeLoaderInfo when the content is ready and before the events
		// are dispatched. Returns false if load was cancelled
		private function loadDoneCallback(d:DisplayObject):Boolean
		{
			if (!_loading) {
				_loader.unload();
				return false;
			}
			_loading = false;
			_content = d;
			if (d != null) {
				super.addChild(d);
				super.removeChild(_loader);
			}
			return true;
		}

		/**
		 * get access to the flash.display.Loader being used by the SafeLoader to do all the work.
		 */
		public function get realLoader():Loader { return _loader; }

		/**
		 * mimic Loader API
		 */
		public function get content():DisplayObject {
			return _content;
		}

		/**
		 * mimic Loader API. Important difference is contentLoaderInfo returns a SafeLoaderInfo,
		 * which is NOT a subclass of LoaderInfo.
		 */
		public function get contentLoaderInfo():SafeLoaderInfo {
			return _cli;
		}

		/**
		 * mimic Loader API
		 */
		public function close():void {
			if (_loading) {
				_loading = false;
				// we may be still acting as though the load is incomplete to allow RSL preloading
				// to finish, so catch any errors
				try { _loader.close(); } catch (e:Error) { }
			} else {
				_loader.close();
			}
		}

		/**
		 * mimic Loader API
		 */
		public function load(request:URLRequest, context:LoaderContext=null):void {
			_loading = true;
			if (_content != null && _content.parent == this) super.removeChild(_content);
			_content = null;
			_loader.load(request, context);
		}

		/**
		 * mimic Loader API
		 */
		public function loadBytes(bytes:ByteArray, context:LoaderContext=null):void {
			_loading = true;
			if (_content != null && _content.parent == this) super.removeChild(_content);
			_content = null;
			_loader.loadBytes(bytes, context);
		}

		/**
		 * mimic Loader API
		 */
		public function unload():void {
			if (_content != null && _content.parent == this) super.removeChild(_content);
			_content = null;
			_loader.unload();
		}

		/**
		 * mimic Loader API. This API only available player 10, AIR 1.5 or higher.
		 */
		public function unloadAndStop(gc:Boolean=true):void {
			if (_content != null && _content.parent == this) super.removeChild(_content);
			_content = null;
			_loader["unloadAndStop"](gc);
		}

		/**
		 * mimic the way flash.display.Loader disallows children to be added, removed
		 * @private
		 */
		public override function addChild(c:DisplayObject):DisplayObject {
			throw new Error("Error #2069: The SafeLoader class does not implement this method.");
		}
		/**
		 * mimic the way flash.display.Loader disallows children to be added, removed
		 * @private
		 */
		public override function addChildAt(c:DisplayObject, i:int):DisplayObject {
			throw new Error("Error #2069: The SafeLoader class does not implement this method.");
		}
		/**
		 * mimic the way flash.display.Loader disallows children to be added, removed
		 * @private
		 */
		public override function removeChild(c:DisplayObject):DisplayObject {
			throw new Error("Error #2069: The SafeLoader class does not implement this method.");
		}
		/**
		 * mimic the way flash.display.Loader disallows children to be added, removed
		 * @private
		 */
		public override function removeChildAt(i:int):DisplayObject {
			throw new Error("Error #2069: The SafeLoader class does not implement this method.");
		}
		/**
		 * mimic the way flash.display.Loader disallows children to be added, removed
		 * @private
		 */
		public override function setChildIndex(c:DisplayObject, i:int):void {
			throw new Error("Error #2069: The SafeLoader class does not implement this method.");
		}

	}
}

