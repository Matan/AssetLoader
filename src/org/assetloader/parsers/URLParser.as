package org.assetloader.parsers
{
	import flash.net.URLVariables;

	/**
	 * The URLParser is used to check whether URLs are valid or not, also it extracts useful information from the given url.
	 * 
	 * <p>URLs are parsed according to three groups; Absolute, Relative and Server.</p>
	 * <ul>
	 *	 <li><strong>Absolute</strong></li>
	 *	 <ul>
	 *	 	<li>Recognized by having a protocol. E.g. starts with "http://"</li>	 *	 	<li>Looks for a file extension. E.g. somefile.jpg</li>
	 *	 </ul>
	 *	 <li><strong>Relative</strong></li>
	 *	 <ul>
	 *	 	<li>Recognized by NOT having a protocol. E.g. doesn't start with "http://"</li>
	 *	 	<li>Looks for a file extension. E.g. somefile.jpg</li>
	 *	 </ul>
	 *	 <li><strong>Server</strong></li>
	 *	 <ul>
	 *	 	<li>Recognized by NOT having a file extension.</li>
	 *	 	<li>Can be Absolute or Relative.</li>	 *	 	<li>If Absolute no trailing slash required. E.g. http://www.matan.co.za/getGalleryXML</li>	 *	 	<li>If Relative trailing slash IS required. E.g. getGalleryXML/</li>	 *	 	<li>Note: if relative with multiple pathings the trailing slash isn't required. E.g. scripts/getGalleryXML</li>
	 *	 </ul>
	 * </ul>
	 * 
	 * @author Matan Uberstein
	 */
	public class URLParser
	{
		/**
		 * @private
		 */
		protected var _url : String;
		/**
		 * @private
		 */
		protected var _protocol : String;
		/**
		 * @private
		 */
		protected var _login : String;
		/**
		 * @private
		 */
		protected var _password : String;
		/**
		 * @private
		 */
		protected var _port : int;
		/**
		 * @private
		 */
		protected var _host : String;
		/**
		 * @private
		 */
		protected var _path : String;
		/**
		 * @private
		 */
		protected var _fileName : String;
		/**
		 * @private
		 */
		protected var _fileExtension : String;
		/**
		 * @private
		 */
		protected var _urlVariables : URLVariables;
		/**
		 * @private
		 */
		protected var _anchor : String;
		/**
		 * @private
		 */
		protected var _isValid : Boolean = true;

		/**
		 * Parses url and breaks is down into properties and check whether the url is valid.
		 * @param url String
		 */
		public function URLParser(url : String)
		{
			_url = url;

			if(!_url || _url == "")
			{
				_isValid = false;
				return;
			}

			if(_url.length >= 250)
			{
				_isValid = false;
				return;
			}

			var urlExp : RegExp = /^(?:(?P<scheme>\w+):\/\/)?(?:(?P<login>\w+):(?P<pass>\w+)@)?(?P<host>(?:(?P<subdomain>[\w\.]+)\.)?(?P<domain>\w+\.(?P<extension>\w+)))?(?::(?P<port>\d+))?(?P<path>[\w\W]*\/(?P<file>[^?]+(?:\.\w+)?)?)?(?:\?(?P<arg>[\w=&]+))?(?:#(?P<anchor>\w+))?/;
			var match : * = urlExp.exec(url);

			if(match)
			{
				_protocol = match.scheme || null;

				_host = match.host || null;

				_login = match.login || null;
				_password = match.pass || null;

				_port = match.port ? int(match.port) : 80;

				_path = match.path || null;

				if(match.arg && match.arg != "")
					_urlVariables = new URLVariables(match.arg);

				_anchor = match.anchor || null;

				if(!_protocol && _url.indexOf("/") == -1)
				{
					_path = _host || _url;
					_fileName = _path.slice(-_path.lastIndexOf("/") - 1);
					_host = null;
				}

				if(!_path || _path == "")
				{
					_isValid = false;
					return;
				}

				if(_path.charAt(0) != "/")
					_path = "/" + _path;

				if(!_fileName)
					_fileName = match.file || null;

				if(_fileName)
					if(_fileName.indexOf(".") != -1)
						_fileExtension = _fileName.slice(_fileName.lastIndexOf(".") + 1);

				if(!_fileExtension && !_protocol && _path.charAt(_path.length - 1) != "/")
					_isValid = false;
			}
			else
				_isValid = false;
		}

		/**
		 * Gets the url passes through constructor.
		 * 
		 * @return String
		 */
		public function get url() : String
		{
			return _url;
		}

		/**
		 * Gets the protocol of the url.
		 * @return String
		 */
		public function get protocol() : String
		{
			return _protocol;
		}

		/**
		 * Gets the login/username from the url. E.g. ftp://Matan:Password@some.where.com will return Matan.
		 * @return String
		 */
		public function get login() : String
		{
			return _login;
		}

		/**
		 * Gets the password from the url. E.g. ftp://Matan:Password@some.where.com will return Password.
		 * @return String
		 */
		public function get password() : String
		{
			return _password;
		}

		/**
		 * Gets the port of the url.
		 * @default 80
		 * @return int
		 */
		public function get port() : int
		{
			return _port;
		}

		/**
		 * Gets the host of the url. E.g. www.matanuberstein.co.za
		 * @return String
		 */
		public function get host() : String
		{
			return _host;
		}

		/**
		 * Gets the path of the url. E.g. some/path/to/file/
		 * @return String
		 */
		public function get path() : String
		{
			return _path;
		}

		/**
		 * Gets the file name of the url. E.g. someFileName.ext
		 * @return String
		 */
		public function get fileName() : String
		{
			return _fileName;
		}

		/**
		 * Gets the file extension of the url. E.g. txt, php, etc.
		 * @return String
		 */
		public function get fileExtension() : String
		{
			return _fileExtension;
		}

		/**
		 * Gets the url variables from the url.
		 * @return URLVariables
		 */
		public function get urlVariables() : URLVariables
		{
			return _urlVariables;
		}

		/**
		 * Gets the file hash anchor of the url. E.g. www.matanuberstein.co.za/#hello will return hello.
		 * @return String
		 */
		public function get anchor() : String
		{
			return _anchor;
		}

		/**
		 * Gets whether the url is valid or not. E.g. if a empty path is passed isValid will be false.
		 * @default true
		 * @return Boolean
		 */
		public function get isValid() : Boolean
		{
			return _isValid;
		}
	}
}
