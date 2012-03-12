package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.signals.LoaderSignal;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.Timer;

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
		protected var _onReady : LoaderSignal;

		/**
		 * @private
		 */
		protected var _sound : Sound;

		/**
		 * @private
		 */
		protected var _readyTimer : Timer;
		
		/**
		 * @private
		 */
		protected var _isReady : Boolean;

		public function SoundLoader(request : URLRequest, id : String = null)
		{
			super(request, AssetType.SOUND, id);
		}

		/**
		 * @private
		 */
		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(Sound);
			_onReady = new LoaderSignal(Sound);
			_onId3 = new LoaderSignal();
		}

		/**
		 * @private
		 */
		override protected function constructLoader() : IEventDispatcher
		{
			_sound = _data = new Sound();

			if(!_readyTimer)
			{
				_readyTimer = new Timer(50);
				_readyTimer.addEventListener(TimerEvent.TIMER, readyTimer_handler);
			}
			else
				_readyTimer.reset();

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
				_onError.dispatch(this, error.name, error.message);
			}
			_readyTimer.start();
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
				_readyTimer.stop();
			}
			super.stop();
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy() : void
		{
			super.destroy();

			if(_readyTimer)
				_readyTimer.removeEventListener(TimerEvent.TIMER, readyTimer_handler);

			_sound = null;
			_readyTimer = null;
			_isReady = false;
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
		override protected function complete_handler(event : Event) : void
		{
			if(!_isReady)
			{
				_isReady = true;
				_onReady.dispatch(this, _sound);
				_readyTimer.stop();
			}
			super.complete_handler(event);
		}

		/**
		 * @private
		 */
		protected function readyTimer_handler(event : TimerEvent) : void
		{
			if(!_isReady && !_sound.isBuffering)
			{
				_onReady.dispatch(this, _sound);
				_isReady = true;
				_readyTimer.stop();
			}
		}

		/**
		 * @private
		 */
		protected function id3_handler(event : Event) : void
		{
			_onId3.dispatch(this);
		}

		/**
		 * Dispatches when the Sound instance is ready to be played e.g. streamed while still loading.
		 * <p>The SoundLoader closely monitors the isBuffering property of the Sound instance, the first
		 * time isBuffering is false, onReady will dispatch. It could happen that the sound file is finished 
		 * loading loading before the isBuffering monitor detected it, so another check occurs onComplete.
		 * Thus onReady will always fire before onComplete, but only once.</p>
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>, sound:<strong>Sound</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
		 *	 <li><strong>sound</strong> - The Sound instance.</li>
		 * </ul>
		 * 
		 * @see org.assetloader.signals.LoaderSignal
		 */
		public function get onReady() : LoaderSignal
		{
			return _onReady;
		}

		/**
		 * Dispatches when the SoundLoader has loaded the ID3 information of
		 * the sound clip.
		 * <p>Note: Not all sound files have ID3 properties, thus this Signal will
		 * only dispatch if such data exists.</p>
		 * 
		 * <p>HANDLER ARGUMENTS: (signal:<strong>LoaderSignal</strong>)</p>
		 * <ul>
		 *	 <li><strong>signal</strong> - The signal that dispatched.</li>
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

		/**
		 * Gets whether the Sound instance is ready to be streamed or not.
		 * 
		 * @see #onReady
		 */
		public function get isReady() : Boolean
		{
			return _isReady;
		}
	}
}
