package org.assetloader.loaders 
{
	import org.assetloader.base.AbstractLoader;
	import org.assetloader.base.Param;
	import org.assetloader.core.ILoader;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;

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
	public class SoundLoader extends AbstractLoader implements ILoader
	{
		protected var _sound : Sound;

		public function SoundLoader() 
		{
			super();
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
				_sound.load(_request, _unit.getParam(Param.SOUND_LOADER_CONTEXT));
			}catch(error : SecurityError)
			{
				dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR, false, false, error.message));
			}
		}

		override public function stop() : void
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
			{
				dispatcher.addEventListener(Event.ID3, dispatchEvent);				dispatcher.addEventListener(SampleDataEvent.SAMPLE_DATA, dispatchEvent);
			}
		}

		override protected function removeListeners(dispatcher : IEventDispatcher) : void 
		{
			super.removeListeners(dispatcher);
			if(dispatcher)
			{
				dispatcher.removeEventListener(Event.ID3, dispatchEvent);
				dispatcher.removeEventListener(SampleDataEvent.SAMPLE_DATA, dispatchEvent);
			}
		}
	}
}
