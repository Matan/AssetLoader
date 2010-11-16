package org.assetloader.signals
{
	import org.assetloader.core.ILoader;

	/**
	 * @author Matan Uberstein
	 */
	public class ErrorSignal extends LoaderSignal
	{
		protected var _type : String;
		protected var _message : String;

		public function ErrorSignal(loader : ILoader, ...valueClasses)
		{
			super(loader, valueClasses);
			_signalType = ErrorSignal;
		}

		override public function dispatch(...args) : void
		{
			_type = args.shift();
			_message = args.shift();
			super.dispatch.apply(null, args);
		}

		override protected function clone() : LoaderSignal
		{
			var clone : ErrorSignal = new ErrorSignal(_loader, valueClasses);
			clone._type = _type;
			clone._message = _message;
			return clone;
		}

		public function get type() : String
		{
			return _type;
		}

		public function get message() : String
		{
			return _message;
		}
	}
}
