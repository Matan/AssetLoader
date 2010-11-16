package org.assetloader.signals
{
	import org.assetloader.core.ILoader;

	/**
	 * @author Matan Uberstein
	 */
	public class NetStatusSignal extends LoaderSignal
	{
		protected var _info : Object;

		public function NetStatusSignal(loader : ILoader, ...valueClasses)
		{
			super(loader, valueClasses);
			_signalType = NetStatusSignal;
		}

		override public function dispatch(...args) : void
		{
			_info = args.shift();
			super.dispatch.apply(null, args);
		}
		
		override protected function clone() : LoaderSignal
		{
			var clone : NetStatusSignal = new NetStatusSignal(_loader, valueClasses);
			clone._info = _info;
			return clone;
		}

		public function get info() : Object
		{
			return _info;
		}
	}
}
