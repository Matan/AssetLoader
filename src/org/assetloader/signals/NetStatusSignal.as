package org.assetloader.signals
{

	/**
	 * @author Matan Uberstein
	 */
	public class NetStatusSignal extends LoaderSignal
	{
		/**
		 * @private
		 */
		protected var _info : Object;

		public function NetStatusSignal(...valueClasses)
		{
			_signalType = NetStatusSignal;
			super(valueClasses);
		}

		/**
		 * Dispatches Signal.
		 * 
		 * @param args1 ILoader - ILoader to which the signal belongs.
		 * @param args2 Object - NetStatus Info Object
		 */
		override public function dispatch(...args) : void
		{
			_info = args.splice(1, 1)[0];
			super.dispatch.apply(null, args);
		}

		/**
		 * Gets the NetStatus info object.
		 * 
		 * @return Object
		 */
		public function get info() : Object
		{
			return _info;
		}
	}
}
