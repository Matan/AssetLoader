package org.assetloader.signals
{

	/**
	 * @author Matan Uberstein
	 */
	public class HttpStatusSignal extends LoaderSignal
	{
		/**
		 * @private
		 */
		protected var _status : int;

		public function HttpStatusSignal(...valueClasses)
		{
			_signalType = HttpStatusSignal;
			super(valueClasses);
		}

		/**
		 * Dispatches Signal.
		 * 
		 * @param args1 ILoader - ILoader to which the signal belongs.
		 * @param args2 int - Status code
		 */
		override public function dispatch(...args) : void
		{
			_status = args.splice(1, 1)[0];
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
