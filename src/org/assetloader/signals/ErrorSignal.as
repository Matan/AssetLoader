package org.assetloader.signals
{

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

		public function ErrorSignal(...valueClasses)
		{
			_signalType = ErrorSignal;
			super(valueClasses);
		}

		/**
		 * Dispatches Signal.
		 * 
		 * @param args1 ILoader - ILoader to which the signal belongs.
		 * @param args2 String - Error type
		 * @param args3 String - Error message
		 */
		override public function dispatch(...args) : void
		{
			_type = args[1];
			_message = args[2];
			
			args.splice(1, 2);

			super.dispatch.apply(null, args);
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
