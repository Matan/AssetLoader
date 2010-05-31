package org.assetloader.base 
{
	import mu.utils.ToStr;

	/**
	 * Simple data holder to normalize and extract URI components.
	 * <p>Adapted from BulkLoader.</p>
	 **/
	public class SmartURL  
	{
		/**
		 * Raw input url.
		 */
		public var rawUrl : String;

		/**
		 * Protocol of connections. e.g. http://
		 */
		public var protocol : String;

		/**
		 * Port, usually 80 for web connections.
		 */
		public var port : int;

		/**
		 * Host/domain.
		 */
		public var host : String;

		/**
		 * The "business-end" of the url.
		 */
		public var path : String;

		/**
		 * Raw query string. e.g. var1=value1&#38;var2=value2
		 */
		public var queryString : String;

		/**
		 * Query variables parsed into an Object.
		 */
		public var queryObject : Object;

		/**
		 * Amount of query variables found.
		 */
		public var queryLength : int = 0;

		/**
		 * Name of the file found in url.
		 */
		public var fileName : String;

		/**
		 * Extension of file found in url.
		 */		public var fileExtension : String;

		/**
		 * Parses rawUrl and breaks is down into properties.
		 * @param rawUrl String
		 * 
		 * @throws ArgumentError Parameter rawUrl is not a valid url.
		 */
		public function SmartURL(rawUrl : String)
		{
			this.rawUrl = rawUrl;
			var urlExp : RegExp = /((?P<protocol>[a-zA-Z]+: \/\/)   (?P<host>[^:\/]*) (:(?P<port>\d+))?)?  (?P<path>[^?]*)? ((?P<query>.*))? /x; 
			var match : * = urlExp.exec(rawUrl);
			if(match)
			{
				protocol = Boolean(match.protocol) ? match.protocol : "http://";
				protocol = protocol.slice(0, protocol.indexOf("://"));
				host = match.host || null;
				port = match.port ? int(match.port) : 80;
				path = match.path;
				fileName = path.slice(path.lastIndexOf("/"), path.lastIndexOf("."));
				fileExtension = path.slice(path.lastIndexOf(".") + 1);
				queryString = match.query;
				if (queryString)
				{
					queryObject = {};
					queryString = queryString.substr(1);
					var value : String;
					var varName : String;
					for each (var pair : String in queryString.split("&"))
					{
						varName = pair.split("=")[0];
						value = pair.split("=")[1];
						queryObject[varName] = value;
						queryLength++;
					}
				}
			}
			else
				throw new ArgumentError("Parameter rawUrl is not a valid url.");
		}

		public function toString() : String 
		{
			return String(new ToStr(this));
		}
	}
}
