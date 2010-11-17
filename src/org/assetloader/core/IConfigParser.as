package org.assetloader.core
{

	/**
	 * Parses and builds loading queues from String data.
	 * 
	 * @see org.assetloader.core.ILoader
	 * @see org.assetloader.core.IAssetLoader
	 * 
	 * @author Matan Uberstein
	 */
	public interface IConfigParser
	{
		/**
		 * Test data to see if it can be parsed.
		 * 
		 * @param data String
		 * 
		 * @return Boolean
		 */
		function isValid(data : String) : Boolean;

		/**
		 * Implematation should convert String into respective type and add the parsed
		 * assets into their repective parent IAssetLoader
		 * 
		 * @param assetloader IAssetLoader instance that will contain the parsed assets.
		 * @param data String
		 * 
		 * @see org.assetloader.base.vo.ConfigVO
		 */
		function parse(assetloader : IAssetLoader, data : String) : void
	}
}
