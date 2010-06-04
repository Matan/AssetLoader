package org.assetloader.base 
{
	import mu.utils.ToStr;

	import org.assetloader.core.IParam;
	import org.assetloader.core.ILoadUnit;
	import org.assetloader.core.ILoader;
	import org.assetloader.events.BinaryAssetEvent;
	import org.assetloader.events.CSSAssetEvent;
	import org.assetloader.events.DisplayObjectAssetEvent;
	import org.assetloader.events.ImageAssetEvent;
	import org.assetloader.events.JSONAssetEvent;
	import org.assetloader.events.SWFAssetEvent;
	import org.assetloader.events.SoundAssetEvent;
	import org.assetloader.events.TextAssetEvent;
	import org.assetloader.events.VideoAssetEvent;
	import org.assetloader.events.XMLAssetEvent;
	import org.assetloader.loaders.BinaryLoader;
	import org.assetloader.loaders.CSSLoader;
	import org.assetloader.loaders.DisplayObjectLoader;
	import org.assetloader.loaders.ImageLoader;
	import org.assetloader.loaders.JSONLoader;
	import org.assetloader.loaders.SWFLoader;
	import org.assetloader.loaders.SoundLoader;
	import org.assetloader.loaders.TextLoader;
	import org.assetloader.loaders.VideoLoader;
	import org.assetloader.loaders.XMLLoader;

	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class LoadUnit implements ILoadUnit
	{
		protected var _id : String;
		protected var _loader : ILoader;
		protected var _request : URLRequest;		protected var _type : String;		protected var _smartUrl : SmartURL;		protected var _params : Object;
		protected var _eventClass : Class;
		protected var _retryTally : uint;

		public function LoadUnit(id : String, request : URLRequest, type : String, params : Array = null) 
		{
			init(id, request, type, params);
		}

		protected function init(id : String, request : URLRequest, type : String, params : Array = null) : void
		{
			_id = id;
			_request = request;
			_type = type;
			_params = {};
			_retryTally = 0;
			
			if(params)
				processParams(params);
			
			setParamDefault(Param.RETRIES, 3);
			setParamDefault(Param.ON_DEMAND, false);
			setParamDefault(Param.PREVENT_CACHE, false);
			
			if(getParam(Param.PREVENT_CACHE))
				_request.url += ((_request.url.indexOf("?") == -1) ? "?" : "&") + "ck=" + new Date().time;
			
			try
			{
				_smartUrl = new SmartURL(_request.url);
			}catch(error : ArgumentError)
			{
				throw new AssetLoaderError(AssetLoaderError.INVALID_URL);
			}
			
			if(_type == AssetType.AUTO)
				_type = getTypeFromExtension(_smartUrl.fileExtension);
			
			processType();
			
			_loader.unit = this;
		}

		protected function processParams(assetParams : Array) : void
		{
			var pL : int = assetParams.length;
			for(var i : int = 0;i < pL;i++) 
			{
				if(assetParams[i] is IParam)
				{
					var param : IParam = assetParams[i];
					setParam(param.id, param.value);
				}
				
				else if(assetParams[i] is Array)
					processParams(assetParams[i]);
			}
		}

		protected function setParamDefault(id : String, value : *) : void
		{
			if(!hasParam(id))
				setParam(id, value);
		}

		protected function getTypeFromExtension(extension : String) : String
		{
			extension = extension.toLowerCase();
			
			var textExt : Array = ["txt", "js", "html", "htm", "php", "asp", "aspx", "jsp", "cfm"];			var imageExt : Array = ["jpg", "jpeg", "png", "gif"];			var videoExt : Array = ["flv", "f4v", "f4p", "mp4", "mov"];
			
			if(testExtenstion(textExt, extension))
				return AssetType.TEXT;
			
			if(extension == "json")
				return AssetType.JSON;
				
			if(extension == "xml")
				return AssetType.XML;
				
			if(extension == "css")
				return AssetType.CSS;
				
			if(extension == "zip")
				return AssetType.BINARY;
				
			if(extension == "swf")
				return AssetType.SWF;
				
			if(testExtenstion(imageExt, extension))
				return AssetType.IMAGE;
				
			if(extension == "mp3")
				return AssetType.SOUND;
				
			if(testExtenstion(videoExt, extension))
				return AssetType.VIDEO;
			
			throw new AssetLoaderError(AssetLoaderError.ASSET_AUTO_TYPE_NOT_FOUND);
			
			return "";
		}

		protected function testExtenstion(extensions : Array, extension : String) : Boolean
		{
			if(extensions.indexOf(extension) != -1)
				return true;
			return false;
		}

		protected function processType() : void
		{
			switch(_type)
			{
				case AssetType.TEXT:
					_loader = new TextLoader();
					_eventClass = TextAssetEvent;
					break;
					
				case AssetType.JSON:
					_loader = new JSONLoader();
					_eventClass = JSONAssetEvent;
					break;
					
				case AssetType.XML:
					_loader = new XMLLoader();
					_eventClass = XMLAssetEvent;
					break;
					
				case AssetType.CSS:
					_loader = new CSSLoader();
					_eventClass = CSSAssetEvent;
					break;
					
				case AssetType.BINARY:
					_loader = new BinaryLoader();
					_eventClass = BinaryAssetEvent;
					break;
					
				case AssetType.DISPLAY_OBJECT:
					setParam(Param.LOADER_CONTEXT, null);
				
					_loader = new DisplayObjectLoader();
					_eventClass = DisplayObjectAssetEvent;
					break;
					
				case AssetType.SWF:
					setParam(Param.LOADER_CONTEXT, null);
				
					_loader = new SWFLoader();
					_eventClass = SWFAssetEvent;
					break;
					
				case AssetType.IMAGE:
				
					setParam(Param.LOADER_CONTEXT, null);
					
					setParam(Param.TRANSPARENT, true);
					setParam(Param.FILL_COLOR, 4.294967295E9);
					setParam(Param.MATRIX, null);
					setParam(Param.COLOR_TRANSFROM, null);
					setParam(Param.BLEND_MODE, null);
					setParam(Param.CLIP_RECTANGLE, null);
					setParam(Param.SMOOTHING, false);
					setParam(Param.PIXEL_SNAPPING, "auto");
					
					_loader = new ImageLoader();
					_eventClass = ImageAssetEvent;
					break;
					
				case AssetType.SOUND:
					setParam(Param.SOUND_LOADER_CONTEXT, null);
				
					_loader = new SoundLoader();
					_eventClass = SoundAssetEvent;
					break;
					
				case AssetType.VIDEO:
					setParam(Param.CHECK_POLICY_FILE, true);
				
					_loader = new VideoLoader();
					_eventClass = VideoAssetEvent;
					break;
					
				default:
					throw new AssetLoaderError(AssetLoaderError.ASSET_TYPE_NOT_RECOGNIZED);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function hasParam(id : String) : Boolean
		{
			return (_params[id] != undefined);
		}

		/**
		 * @inheritDoc
		 */
		public function setParam(id : String, value : *) : void
		{
			_params[id] = value;
		}

		/**
		 * @inheritDoc
		 */
		public function getParam(id : String) : *
		{
			return _params[id];
		}

		/**
		 * @inheritDoc
		 */
		public function addParam(param : IParam) : void
		{
			setParam(param.id, param.value);
		}

		/**
		 * @inheritDoc
		 */
		public function get id() : String
		{
			return _id;
		}

		/**
		 * @inheritDoc
		 */
		public function get loader() : ILoader
		{
			return _loader;
		}

		/**
		 * @inheritDoc
		 */
		public function get request() : URLRequest
		{
			return _request;
		}

		/**
		 * @inheritDoc
		 */
		public function get type() : String
		{
			return _type;
		}

		/**
		 * @inheritDoc
		 */
		public function get url() : String
		{
			return _request.url;
		}

		/**
		 * @inheritDoc
		 */
		public function get smartUrl() : SmartURL
		{
			return _smartUrl;
		}

		/**
		 * @inheritDoc
		 */
		public function get params() : Object
		{
			return _params;
		}

		/**
		 * @inheritDoc
		 */
		public function get eventClass() : Class
		{
			return _eventClass;
		}

		/**
		 * @inheritDoc
		 */
		public function get retryTally() : uint
		{
			return _retryTally;
		}

		/**
		 * @inheritDoc
		 */
		public function set retryTally(retryTally : uint) : void
		{
			_retryTally = retryTally;
		}

		public function toString() : String 
		{
			return String(new ToStr(this));
		}
	}
}
