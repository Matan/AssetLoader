package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class SWFLoader extends DisplayObjectLoader
	{
		/**
		 * @private
		 */
		protected var _swf : Sprite;

		/**
		 * @private
		 */
		protected var _onInit : LoaderSignal;

		public function SWFLoader(request : URLRequest, id : String = null)
		{
			super(request, id);
			_type = AssetType.SWF;
		}

		/**
		 * @private
		 */
		override protected function initSignals() : void
		{
			super.initSignals();
			_onInit = new LoaderSignal();
			_onComplete = new LoaderSignal(Sprite);
		}

		protected function init_handler(event : Event) : void
		{
			_data = _displayObject = _loader.content;

			_onInit.dispatch(this, _data);
		}

		/**
		 * @private
		 */
		override protected function addListeners(dispatcher : IEventDispatcher) : void
		{
			super.addListeners(dispatcher);
			if(dispatcher)
				dispatcher.addEventListener(Event.INIT, init_handler);
		}

		/**
		 * @private
		 */
		override protected function removeListeners(dispatcher : IEventDispatcher) : void
		{
			super.removeListeners(dispatcher);
			if(dispatcher)
				dispatcher.removeEventListener(Event.INIT, init_handler);
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy() : void
		{
			super.destroy();
			_swf = null;
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		override protected function testData(data : DisplayObject) : String
		{
			var errMsg : String = "";
			try
			{
				_data = _swf = Sprite(data);
			}
			catch(error : Error)
			{
				errMsg = error.message;
			}
			return errMsg;
		}

		/**
		 * Gets the resulting Sprite after loading is complete.
		 * 
		 * @return Sprite
		 */
		public function get swf() : Sprite
		{
			return _swf;
		}

		/**
		 * Dispatched when the properties and methods of a loaded SWF file are accessible and ready for use.
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		public function get onInit() : LoaderSignal
		{
			return _onInit;
		}
	}
}
