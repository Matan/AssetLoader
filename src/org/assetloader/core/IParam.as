package org.assetloader.core 
{

	/**
	 * Holds parameter data for ILoader instances.
	 * 
	 * @see org.assetloader.core.ILoader
	 * 
	 * @author Matan Uberstein
	 */
	public interface IParam 
	{
		/**
		 * Gets parameter id.
		 * 
		 * @return id of parameter.
		 * @see org.assetloader.base.Param
		 */
		function get id() : String
		/**
		 * Gets value of parameter.
		 * 
		 * @return value
		 */
		function get value() : *
	}
}
