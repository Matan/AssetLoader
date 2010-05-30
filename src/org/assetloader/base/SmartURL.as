package org.assetloader.base 
{
	import mu.utils.ToStr;

	/**
	 * A simple data holder to normalize an URI components.
	 **/
	public class SmartURL  
	{

		public var rawUrl : String;
		public var protocol : String;
		public var port : int;
		public var host : String;
		public var path : String;
		public var queryString : String;
		public var queryObject : Object;
		public var queryLength : int = 0;
		public var fileName : String;		public var fileExtension : String;

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
				throw new ArgumentError("Parameter rawUrl is not a valid url: " + rawUrl);
		}

		public function toString() : String 
		{
			return String(new ToStr(this));
		}
	}
}
