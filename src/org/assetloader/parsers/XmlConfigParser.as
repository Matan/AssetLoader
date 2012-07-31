package org.assetloader.parsers
{
	import org.assetloader.base.AssetType;
	import org.assetloader.base.LoaderFactory;
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.IConfigParser;
	import org.assetloader.core.ILoader;

	import flash.net.URLRequest;

	/**
	 * @author Matan Uberstein
	 */
	public class XmlConfigParser implements IConfigParser
	{
		/**
		 * @private
		 */
		protected var _assetloader : IAssetLoader;
		/**
		 * @private
		 */
		protected var _loaderFactory : LoaderFactory;

		public function XmlConfigParser()
		{
		}

		/**
		 * @inheritDoc
		 */
		public function isValid(data : String) : Boolean
		{
			var xml : XML;

			try
			{
				xml = new XML(data);
			}
			catch(error : Error)
			{
				return false;
			}

			if(xml.nodeKind() != "element")
				return false;

			return true;
		}

		/**
		 * @inheritDoc
		 */
		public function parse(assetloader : IAssetLoader, data : String) : void
		{
			_assetloader = assetloader;
			_loaderFactory = new LoaderFactory();

			parseXml(new XML(data));

			_assetloader = null;
			_loaderFactory = null;
		}

		/**
		 * @private
		 */
		protected function parseXml(xml : XML, inheritFrom : ConfigVO = null) : void
		{
			var rootVo : ConfigVO = parseVo(xml, inheritFrom);
			var children : XMLList = xml.children();

			var cL : int = children.length();
			for(var i : int = 0;i < cL;i++)
			{
				var vo : ConfigVO = parseVo(children[i], rootVo);

				if(vo.id != "" && vo.src == "")
				{
					var group : IAssetLoader = parseGroup(vo);
					_assetloader.addLoader(group);
					group.addConfig(vo.xml);
				}
				else if(vo.id != "" && vo.src != "")
					_assetloader.addLoader(parseAsset(vo));
				else
					parseXml(children[i], vo);
			}
		}

		/**
		 * @private
		 */
		protected function parseGroup(vo : ConfigVO) : IAssetLoader
		{
			var loader : IAssetLoader = IAssetLoader(_loaderFactory.produce(vo.id, AssetType.GROUP, null, getParams(vo)));
			loader.numConnections = vo.connections;
			return loader;
		}

		/**
		 * @private
		 */
		protected function parseAsset(vo : ConfigVO) : ILoader
		{
			return _loaderFactory.produce(vo.id, vo.type, new URLRequest(vo.src), getParams(vo));
		}

		/**
		 * @private
		 */
		protected function parseVo(xml : XML, inheritFrom : ConfigVO = null) : ConfigVO
		{
			if(!inheritFrom)
				inheritFrom = new ConfigVO();

			var child : ConfigVO = new ConfigVO();

			child.src = xml.@src || "";
			child.id = xml.@id || "";

			child.base = xml.@base || inheritFrom.base;
			child.type = xml.@type || inheritFrom.type;
			child.weight = convertWeight(xml.@weight);
			child.connections = xml.@connections || inheritFrom.connections;
			child.retries = xml.@retries || inheritFrom.retries;
			child.priority = xml.@priority || NaN;
			child.onDemand = toBoolean(xml.@onDemand, inheritFrom.onDemand);
			child.preventCache = toBoolean(xml.@preventCache, inheritFrom.preventCache);
			child.userData = xml.@userData || null;

			child.transparent = toBoolean(xml.@transparent, inheritFrom.transparent);
			child.smoothing = toBoolean(xml.@smoothing, inheritFrom.smoothing);
			child.fillColor = (xml.@fillColor) ? Number(xml.@fillColor) : inheritFrom.fillColor;
			child.blendMode = xml.@blendMode || inheritFrom.blendMode;
			child.pixelSnapping = xml.@pixelSnapping || inheritFrom.pixelSnapping;

			child.type = child.type.toUpperCase();

			child.xml = xml;

			return child;
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// HELPER FUNCTIONS
		// --------------------------------------------------------------------------------------------------------------------------------//
		/**
		 * @private
		 */
		protected function getParams(vo : ConfigVO) : Array
		{
			var params : Array = [];

			if(!isNaN(vo.priority))
				params.push(new Param(Param.PRIORITY, vo.priority));

			if(vo.base && vo.base != "")
				params.push(new Param(Param.BASE, vo.base));

			params.push(new Param(Param.WEIGHT, vo.weight));
			params.push(new Param(Param.RETRIES, vo.retries));
			params.push(new Param(Param.ON_DEMAND, vo.onDemand));
			params.push(new Param(Param.PREVENT_CACHE, vo.preventCache));
			params.push(new Param(Param.USER_DATA, vo.userData));

			params.push(new Param(Param.TRANSPARENT, vo.transparent));
			params.push(new Param(Param.SMOOTHING, vo.smoothing));
			params.push(new Param(Param.FILL_COLOR, vo.fillColor));
			params.push(new Param(Param.BLEND_MODE, vo.blendMode));
			params.push(new Param(Param.PIXEL_SNAPPING, vo.pixelSnapping));

			return params;
		}

		/**
		 * @private
		 */
		protected function convertWeight(str : String) : uint
		{
			if(!str)
				return 0;

			str = str.replace(new RegExp(" ", "g"), "");

			var mbExp : RegExp = new RegExp("mb", "gi");
			if(mbExp.test(str))
				return Number(str.replace(mbExp, "")) * 1024 * 1024;

			var kbExp : RegExp = new RegExp("kb", "gi");
			if(kbExp.test(str))
				return Number(str.replace(kbExp, "")) * 1024;

			return Number(str);
		}

		/**
		 * @private
		 */
		protected function toBoolean(value : String, defaultReturn : Boolean) : Boolean
		{
			value = value.toLowerCase();

			if(value == "1" || value == "yes" || value == "true")
				return true;

			if(value == "0" || value == "no" || value == "false")
				return false;

			return defaultReturn;
		}
	}
}

class ConfigVO
{
	// Internal
	public var xml : XML;

	// IAssetLoader
	public var connections : int = 3;

	// Mixed, but mostly for ILoaders
	public var base : String = null;
	public var id : String;
	public var src : String;
	public var type : String = "AUTO";
	public var retries : int = 3;
	public var weight : uint = 0;
	public var priority : int = NaN;
	public var onDemand : Boolean = false;
	public var preventCache : Boolean = false;
	public var userData : String;

	// ImageLoader

	public var transparent : Boolean = true;
	public var fillColor : uint = 4.294967295E9;
	public var blendMode : String = null;
	public var smoothing : Boolean = false;
	public var pixelSnapping : String = "auto";
}