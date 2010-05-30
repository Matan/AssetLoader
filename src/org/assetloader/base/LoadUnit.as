package org.assetloader.base 
{
	import mu.utils.ToStr;

	import org.assetloader.core.IAssetParam;
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

		public function LoadUnit(id : String = null, request : URLRequest = null, type : String = null,  assetParams : Array = null) 
		{
			if(id && request && type && assetParams)
				init(id, request, type, assetParams);
		}

		public function init(id : String, request : URLRequest, type : String, assetParams : Array) : void
		{
			_id = id;
			_request = request;
			_type = type;
			_params = {};
			_retryTally = 0;
			
			var pL : int = assetParams.length;
			for(var i : int = 0;i < pL;i++) 
			{
				var ap : IAssetParam = assetParams[i];
				if(!ap)
					throw new Error("Parameter given does not implement org.assetloader.core.IAssetParam .");
				setParam(ap.id, ap.value);
			}
			
			if(!hasParam(AssetParam.RETRIES))
				setParam(AssetParam.RETRIES, 3);
			
			if(getParam(AssetParam.PREVENT_CACHE))
					_request.url += ((_request.url.indexOf("?") == -1) ? "?" : "&") + "ck=" + new Date().time;
			
			_smartUrl = new SmartURL(_request.url);
			
			if(_type == AssetType.AUTO)
				_type = getTypeFromExtension(_smartUrl.fileExtension);
			
			processType();
			
			_loader.loadUnit = this;
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
				
			if(extension == "swf")
				return AssetType.SWF;
				
			if(testExtenstion(imageExt, extension))
				return AssetType.IMAGE;
				
			if(extension == "mp3")
				return AssetType.SOUND;
				
			if(testExtenstion(videoExt, extension))
				return AssetType.VIDEO;
			
			return AssetType.BINARY;
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
					setParam(AssetParam.LOADER_CONTEXT, null);
				
					_loader = new DisplayObjectLoader();
					_eventClass = DisplayObjectAssetEvent;
					break;
					
				case AssetType.SWF:
					setParam(AssetParam.LOADER_CONTEXT, null);
				
					_loader = new SWFLoader();
					_eventClass = SWFAssetEvent;
					break;
					
				case AssetType.IMAGE:
				
					setParam(AssetParam.LOADER_CONTEXT, null);
					
					setParam(AssetParam.TRANSPARENT, true);
					setParam(AssetParam.FILL_COLOR, 4.294967295E9);
					setParam(AssetParam.MATRIX, null);
					setParam(AssetParam.COLOR_TRANSFROM, null);
					setParam(AssetParam.BLEND_MODE, null);
					setParam(AssetParam.CLIP_RECTANGLE, null);
					setParam(AssetParam.SMOOTHING, false);
					setParam(AssetParam.PIXEL_SNAPPING, "auto");
					
					_loader = new ImageLoader();
					_eventClass = ImageAssetEvent;
					break;
					
				case AssetType.SOUND:
					setParam(AssetParam.SOUND_LOADER_CONTEXT, null);
				
					_loader = new SoundLoader();
					_eventClass = SoundAssetEvent;
					break;
					
				case AssetType.VIDEO:
					setParam(AssetParam.CHECK_POLICY_FILE, true);
				
					_loader = new VideoLoader();
					_eventClass = VideoAssetEvent;
					break;
					
				default:
					throw new Error("Asset Type not recognized.");
			}
		}

		public function hasParam(id : String) : Boolean
		{
			return (_params[id] != undefined);
		}

		public function setParam(id : String, value : *) : void
		{
			_params[id] = value;
		}

		public function getParam(id : String) : *
		{
			return _params[id];
		}

		public function get id() : String
		{
			return _id;
		}

		public function get loader() : ILoader
		{
			return _loader;
		}

		public function get request() : URLRequest
		{
			return _request;
		}

		public function get type() : String
		{
			return _type;
		}

		public function get url() : String
		{
			return _request.url;
		}

		public function get smartUrl() : SmartURL
		{
			return _smartUrl;
		}

		public function get params() : Object
		{
			return _params;
		}

		public function get eventClass() : Class
		{
			return _eventClass;
		}

		public function get retryTally() : uint
		{
			return _retryTally;
		}

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
