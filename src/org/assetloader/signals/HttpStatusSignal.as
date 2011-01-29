package org.assetloader.signals
{
	import org.assetloader.core.ILoader;

	/**
	 * @author Matan Uberstein
	 */
	public class HttpStatusSignal extends LoaderSignal
	{
		/**
		 * @private
		 */
		protected var _status : int;

		public function HttpStatusSignal(loader : ILoader, ...valueClasses)
		{
			_signalType = HttpStatusSignal;
			super(loader, valueClasses);
		}

		/**
		 * Dispatches Signal.
		 * 
		 * @param args1 int - Status code
		 */
		override public function dispatch(...args) : void
		{
			_status = args.shift();
			super.dispatch.apply(null, args);
		}

		/**
		 * Gets the http status code.
		 * 
		 * @return int
		 */
		public function get status() : int
		{
			return _status;
		}
	}
}
