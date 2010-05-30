package org.assetloader.core 
{
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public interface IAssetLoader extends IEventDispatcher 
	{
		function addLazy(id : String, url : String, type : String = "AUTO", ...assetParams) : ILoader

		function add(id : String, request : URLRequest, type : String = "AUTO", ...assetParams) : ILoader

		function start(numConnections : uint = 3) : void

		function stop() : void

		function destroy() : void

		function getLoadUnit(id : String) : ILoadUnit

		function getLoader(id : String) : ILoader

		function getAsset(id : String) : *

		function get progress() : Number 

		function get bytesLoaded() : uint

		function get bytesTotal() : uint

		function get numLoaded() : int
	}
}
