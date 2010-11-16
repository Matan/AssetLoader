package org.assetloader.signals
{
	import org.assetloader.core.ILoader;

	/**
	 * @author Matan Uberstein
	 */
	public class HttpStatusSignal extends LoaderSignal
	{
		protected var _status : int;
		
		public function HttpStatusSignal(loader : ILoader, ...valueClasses)
		{
			super(loader, valueClasses);
			_signalType = HttpStatusSignal;
		}

		override public function dispatch(...args) : void
		{
			_status = args.shift();
			super.dispatch.apply(null, args);
		}
		
		override protected function clone() : LoaderSignal
		{
			var clone : HttpStatusSignal = new HttpStatusSignal(_loader, valueClasses);
			clone._status = _status;
			return clone;
		}

		public function get status() : int
		{
			return _status;
		}
	}
}
