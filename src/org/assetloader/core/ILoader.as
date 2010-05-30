package org.assetloader.core 
{
	import flash.events.IEventDispatcher;

	/**
	 * @author Matan Uberstein
	 */
	public interface ILoader extends IEventDispatcher
	{

		function set loadUnit(unit : ILoadUnit) : void
		function get loadUnit() : ILoadUnit
		
		function get stats() : ILoadStats

		function start() : void
		function stop() : void
		function destroy() : void

		function get invoked() : Boolean
		function get loaded() : Boolean
		function get data() : *
	}
}
