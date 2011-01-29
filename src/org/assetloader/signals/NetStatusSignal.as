package org.assetloader.signals
{
	import org.assetloader.core.ILoader;

	/**
	 * @author Matan Uberstein
	 */
	public class NetStatusSignal extends LoaderSignal
	{
		/**
		 * @private
		 */
		protected var _info : Object;

		public function NetStatusSignal(loader : ILoader, ...valueClasses)
		{
			_signalType = NetStatusSignal;
			super(loader, valueClasses);
		}

		/**
		 * Dispatches Signal.
		 * 
		 * @param args1 Object - NetStatus Object
		 */
		override public function dispatch(...args) : void
		{
			_info = args.shift();
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
