package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.signals.LoaderSignal;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class SoundLoader extends BaseLoader
	{
		/**
		 * @private
		 */
		protected var _onId3 : LoaderSignal;

		/**
		 * @private
		 */
		protected var _sound : Sound;

		public function SoundLoader(id : String, request : URLRequest)
		{
			super(id, request, AssetType.SOUND);
		}

		/**
		 * @private
		 */
		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(this, Sound);
			_onId3 = new LoaderSignal(this);
		}

		/**
		 * @private
		 */
		override protected function constructLoader() : IEventDispatcher
		{
			_sound = _data = new Sound();
			return _sound;
		}

		/**
		 * @private
		 */
		override protected function invokeLoading() : void
		{
			try
			{
				_sound.load(request, getParam(Param.SOUND_LOADER_CONTEXT));
			}
			catch(error : SecurityError)
			{
				_onError.dispatch(error.name, error.message);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function stop() : void
		{
			if(_invoked)
			{
				try
				{
					_sound.close();
				}
				catch(error : Error)
				{
				}
			}
			super.stop();
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy() : void
		{
			super.destroy();
			_sound = null;
		}

		/**
		 * @private
		 */
		override protected function addListeners(dispatcher : IEventDispatcher) : void
		{
			super.addListeners(dispatcher);
			if(dispatcher)
				dispatcher.addEventListener(Event.ID3, id3_handler);
		}

		/**
		 * @private
		 */
		override protected function removeListeners(dispatcher : IEventDispatcher) : void
		{
			super.removeListeners(dispatcher);
			if(dispatcher)
				dispatcher.removeEventListener(Event.ID3, id3_handler);
		}

		/**
		 * @private
		 */
		protected function id3_handler(event : Event) : void
		{
			_onId3.dispatch();
		}

		/**
		 * Dispatches when the SoundLoader has loaded the ID3 information of
		 * the sound clip.
		 * <p>Note: Not all sound files have ID3 properties, thus this Signal will
		 * only dispatch if such data exists.</p>
		 * 
		 * <p>HANDLER AREGUMENTS: (signal:<strong>LoaderSignal</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - A clone of the signal that dispatched.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		public function get onId3() : LoaderSignal
		{
			return _onId3;
		}

		/**
		 * Gets the Sound instance.
		 * <p>Note: this instance will be available as soon as the SoundLoader's
		 * start method is invoked.</p>
		 * 
		 * @return Sound
		 */
		public function get sound() : Sound
		{
			return _sound;
		}
	}
}
