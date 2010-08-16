package org.assetloader.base.config 
{
	import org.assetloader.core.IConfigParser;

	/**
	 * @author Matan Uberstein
	 */
	public class XmlConfigParser implements IConfigParser
	{
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
		public function parse(data : String) : Array
		{
			var xml : XML = new XML(data);
			
			return parseXml(xml, inherit(xml));
		}

		protected function parseXml(xml : XML, parent : ConfigVO) : Array
		{
			var assets : Array = [];
			
			parent = inherit(xml, parent);
			
			var children : XMLList = xml.children();
			
			var cL : int = children.length();
			for(var i : int = 0;i < cL;i++) 
			{
				var node : XML = children[i];
				
				switch(String(node.name())) 
				{
					case "asset" :
						assets.push(parseAssetNode(node, parent));
						break;
					default :
						assets.push.apply(null, parseXml(node, parent));
						break;
				}
			}
			
			return assets;
		}

		protected function parseAssetNode(xml : XML, parent : ConfigVO) : ConfigVO
		{
			var asset : ConfigVO = new ConfigVO();
			
			asset.parentId = parent.id;
			asset.base = (xml.@base || parent.base);			asset.connections = parent.connections;
						asset.id = xml.@id;
			asset.src = (xml.@src || "");
			asset.type = (xml.@type || parent.type);
			asset.retries = xml.@retries || parent.retries;
			asset.weight = parseWeightString(xml.@weight);
			asset.priority = xml.@priority || NaN;
			asset.onDemand = toBoolean(xml.@onDemand, parent.onDemand);
			asset.preventCache = toBoolean(xml.@preventCache, parent.preventCache);
			
			asset.type = asset.type.toUpperCase();
			
			return asset;
		}

		protected function inherit(xml : XML, parent : ConfigVO = null) : ConfigVO
		{
			if(!parent)
				parent = new ConfigVO();
			
			var child : ConfigVO = new ConfigVO();
			
			child.id = xml.@id || parent.id;
			child.base = xml.@base || parent.base;			child.type = xml.@type || parent.type;
			child.connections = xml.@connections || parent.connections;
			child.retries = xml.@retries || parent.retries;
			child.onDemand = toBoolean(xml.@onDemand, parent.onDemand);			child.preventCache = toBoolean(xml.@preventCache, parent.preventCache);
			
			return child;
		}

		protected function parseWeightString(str : String) : uint
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
			
			return 0;
		}

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