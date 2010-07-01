package org.assetloader.core 
{

	/**
	 * @author Matan Uberstein
	 */
	public interface ILoadGroup extends ILoadUnit
	{
		/**
		 * @return IGroupLoader - ILoader instance casted only once to IGroupLoader.
		 */
		function get groupLoader() : IGroupLoader 
	}
}
