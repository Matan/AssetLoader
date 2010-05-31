package org.assetloader.core 
{
	import org.assetloader.base.SmartURL;

	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public interface ILoadUnit 
	{
		function hasParam(id : String) : Boolean

		function setParam(id : String, value : *) : void

		function getParam(id : String) : *

		function get id() : String
		function get loader() : ILoader

		function get request() : URLRequest

		function get type() : String

		function get url() : String

		function get smartUrl() : SmartURL

		function get params() : Object
		function get eventClass() : Class

		function get retryTally() : uint

		function set retryTally(value : uint) : void
	}
}
