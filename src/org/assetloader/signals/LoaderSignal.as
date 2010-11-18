package org.assetloader.signals
{
	import org.assetloader.core.ILoader;
	import org.osflash.signals.Signal;

	/**
	 * @author Matan Uberstein
	 */
	public class LoaderSignal extends Signal
	{
		/**
		 * @private
		 */
		protected var _loader : ILoader;

		/**
		 * @private
		 */
		protected var _signalType : Class;

		/**
		 * @private
		 */
		protected var _extraValueClasses : Array;

		public function LoaderSignal(loader : ILoader, ...valueClasses)
		{
			super();
			_loader = loader;
			_signalType ||= LoaderSignal;

			if(valueClasses.length == 1 && valueClasses[0] is Array)
				_extraValueClasses = valueClasses[0];
			else
				_extraValueClasses = valueClasses;

			this.valueClasses = [_signalType].concat.apply(null, _extraValueClasses);
		}

		/**
		 * @inheritDoc
		 */
		override public function dispatch(...args) : void
		{
			super.dispatch.apply(null, [clone()].concat.apply(null, args));
		}

		/**
		 * @private
		 */
		protected function clone() : LoaderSignal
		{
			return new LoaderSignal(_loader, LoaderSignal, _extraValueClasses);
		}

		/**
		 * Gets the loader that dispatched this signal.
		 * 
		 * @return ILoader
		 */
		public function get loader() : ILoader
		{
			return _loader;
		}
	}
}
