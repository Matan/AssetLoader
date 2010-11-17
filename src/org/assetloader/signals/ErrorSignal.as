package org.assetloader.signals
{
	import org.assetloader.core.ILoader;

	/**
	 * @author Matan Uberstein
	 */
	public class ErrorSignal extends LoaderSignal
	{
		/**
		 * @private
		 */
		protected var _type : String;
		/**
		 * @private
		 */
		protected var _message : String;

		public function ErrorSignal(loader : ILoader, ...valueClasses)
		{
			super(loader, valueClasses);
			_signalType = ErrorSignal;
		}

		/**
		 * Dispatches Signal.
		 * 
		 * @param args1 String - Error type
		 * @param args2 String - Error message
		 */
		override public function dispatch(...args) : void
		{
			_type = args.shift();
			_message = args.shift();
			super.dispatch.apply(null, args);
		}

		/**
		 * @private
		 */
		override protected function clone() : LoaderSignal
		{
			var clone : ErrorSignal = new ErrorSignal(_loader, valueClasses);
			clone._type = _type;
			clone._message = _message;
			return clone;
		}

		/**
		 * Gets the error type.
		 * 
		 * @return String
		 */
		public function get type() : String
		{
			return _type;
		}

		/**
		 * Gets the error message.
		 * 
		 * @return String
		 */
		public function get message() : String
		{
			return _message;
		}
	}
}
