package org.assetloader.core 
{

	/**
	 * Holds parameter data for ILoadUnit instances.
	 * <p>Some asset types might require special parameters.</p>
	 * 
	 * @includeExample ../../../sample/AddingAssetParamsSample.as
	 * 
	 * @see org.assetloader.core.ILoadUnit
	 * @see org.assetloader.base.Param
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
