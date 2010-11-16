package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;
	import org.assetloader.base.Param;
	import org.assetloader.core.ILoader;
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
		protected var _onId3 : LoaderSignal;

		protected var _sound : Sound;

		public function SoundLoader(id : String, request : URLRequest, parent : ILoader = null) 
		{
			super(id, request, AssetType.SOUND, parent);
		}
		
		override protected function initParams() : void
		{
			super.initParams();
			setParam(Param.SOUND_LOADER_CONTEXT, null);
		}

		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(this, Sound);
			_onId3 = new LoaderSignal(this);
		}

		override protected function constructLoader() : IEventDispatcher
		{
			_sound = _data = new Sound();
			return _sound;
		}

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

		override public function destroy() : void
		{
			super.destroy();
			_sound = null;
		}

		override protected function addListeners(dispatcher : IEventDispatcher) : void
		{
			super.addListeners(dispatcher);
			if(dispatcher)
				dispatcher.addEventListener(Event.ID3, id3_handler);
		}

		override protected function removeListeners(dispatcher : IEventDispatcher) : void
		{
			super.removeListeners(dispatcher);
			if(dispatcher)
				dispatcher.removeEventListener(Event.ID3, id3_handler);
		}

		protected function id3_handler(event : Event) : void
		{
			_onId3.dispatch();
		}

		public function get onId3() : LoaderSignal
		{
			return _onId3;
		}

		public function get sound() : Sound
		{
			return _sound;
		}
	}
}
