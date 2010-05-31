package org.assetloader.core 
{

	/**
	 * Holds parameter data for ILoadUnit instances.
	 * <p>Some asset types might require special parameters.</p>
	 * 
	 * @includeExample ../../../sample/AddingAssetParamsSample.as
	 * 
	 * @see org.assetloader.core.ILoadUnit
	 * @see org.assetloader.base.AssetParam
	 * 
	 * @author Matan Uberstein
	 */
	public interface IAssetParam 
	{
		/**
		 * Gets parameter id.
		 * 
		 * @return id of parameter.
		 * @see org.assetloader.base.AssetParam
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
