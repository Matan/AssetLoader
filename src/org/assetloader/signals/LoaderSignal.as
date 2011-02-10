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

		public function LoaderSignal(...valueClasses)
		{
			super();
			_signalType ||= LoaderSignal;

			if(valueClasses.length == 1 && valueClasses[0] is Array)
				valueClasses = valueClasses[0];

			this.valueClasses = [_signalType].concat.apply(null, valueClasses);
		}

		/**
		 * First argument must be the loader to which this signal belongs.
		 */
		override public function dispatch(...args) : void
		{
			_loader = args.shift();
			
			super.dispatch.apply(null, [this].concat.apply(null, args));
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
