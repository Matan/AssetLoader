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

		function start() : void
		function stop() : void
		function destroy() : void

		function get progress() : Number

		function get bytesLoaded() : uint

		function get bytesTotal() : uint
		function get invoked() : Boolean
		function get loaded() : Boolean
		function get data() : *
	}
}
