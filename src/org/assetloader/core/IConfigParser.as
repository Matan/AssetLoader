package org.assetloader.core 
{

	/**
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
		 * Implematation should convert String into respected type and return
		 * an Array of ConfigVOs.
		 * 
		 * @param data String
		 * 
		 * @see org.assetloader.base.vo.ConfigVO
		 */
		function parse(data : String) : Array
	}
}
