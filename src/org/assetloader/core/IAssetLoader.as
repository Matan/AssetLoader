package org.assetloader.core 
{

	/**
	 * Implemetation of IAssetLoader should manage and maintain connections, ILoadUnits and consolidate stats via ILoadStats.
	 * 
	 * @includeExample ../../../sample/ContextSample.as
	 * @includeExample ../../../sample/StandardSample.as	 * @includeExample ../../../sample/SingletonSample.as
	 * 
	 * @author Matan Uberstein
	 */
	public interface IAssetLoader extends IGroupLoader 
	{
		/**
		 * Creates an IGroupLoader instance and adds it to the queue.
		 * 
		 * @param id Unique group id.
		 * @param units Array of ILoadUnits
		 * @param params Rest arguments for group's parameters. Two acceptable params <code>AssetParam.RETRIES | AssetParam.ON_DEMAND</code>.
		 * 
		 * @return IGroupLoader that was created.
		 * 
		 * @see org.assetloader.core.ILoadUnit
		 * @see org.assetloader.base.GroupParam
		 */
		function addGroup(id : String, units : Array = null, ...params) : IGroupLoader

		/**
		 * Starts the asset with id passed. Same as calling startUnit.
		 * @param id Asset id.
		 */
		function startAsset(id : String) : void

		/**
		 * Checks if unit at "id" is an instance of ILoadGroup.
		 * 
		 * @param id String id of the group.
		 * @return Boolean
		 * @see org.assetloader.core.ILoadGroup
		 */
		function hasGroup(id : String) : Boolean

		/**
		 * Gets the ILoadGroup created when adding a group to the queue.
		 * 
		 * @param id String id of the group.
		 * @return ILoadGroup created on adding of group.
		 * @see org.assetloader.core.ILoadGroup
		 */
		function getGroup(id : String) : ILoadGroup

		/**
		 * Gets the IGroupLoader created when adding a group to the queue.
		 * 
		 * @param id String id of the group.
		 * @return IGroupLoader created on adding of group.
		 * @see org.assetloader.core.IGroupLoader
		 */
		function getGroupLoader(id : String) : IGroupLoader
	}
}
