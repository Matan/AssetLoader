package org.assetloader.loaders
{
	import org.assetloader.base.AssetType;
	import org.assetloader.signals.LoaderSignal;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	/**
	 * @author Matan Uberstein
	 */
	public class BinaryLoader extends BaseLoader
	{
		protected var _bytes : ByteArray;

		protected var _loader : URLStream;

		public function BinaryLoader(id : String, request : URLRequest)
		{
			super(id, request, AssetType.BINARY);
		}

		override protected function initSignals() : void
		{
			super.initSignals();
			_onComplete = new LoaderSignal(this, ByteArray);
		}

		override protected function constructLoader() : IEventDispatcher
		{
			_loader = new URLStream();
			return _loader;
		}

		override protected function invokeLoading() : void
		{
			_loader.load(request);
		}

		override public function stop() : void
		{
			if(_invoked)
			{
				try
				{
					_loader.close();
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
			_loader = null;
			_bytes = null;
		}

		override protected function complete_handler(event : Event) : void
		{
			_bytes = new ByteArray();
			_loader.readBytes(_bytes);

			_data = _bytes;

			super.complete_handler(event);
		}

		public function get bytes() : ByteArray
		{
			return _bytes;
		}
	}
}
