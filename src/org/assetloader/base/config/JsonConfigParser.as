package org.assetloader.base.config
{
	import com.adobe.serialization.json.JSON;

	import org.assetloader.core.IConfigParser;

	/**
	 * @author Matan Uberstein
	 */
	public class JsonConfigParser implements IConfigParser
	{
		/**
		 * @inheritDoc
		 */
		public function isValid(data : String) : Boolean
		{
			if(data.charAt(0) == "{" && data.charAt(data.length - 1) == "}")
				return true;

			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function parse(data : String) : Array
		{
			var obj : Object = JSON.decode(data);

			return parseData(obj, inherit(obj));
		}

		protected function parseData(obj : Object, parent : ConfigVO) : Array
		{
			var assets : Array = [];

			if(hasArrayChild(obj))
			{
				parent = inherit(obj, parent);
				
				var children : Array = getArrayChild(obj);

				var cL : int = children.length;
				for(var i : int = 0;i < cL;i++)
				{
					assets.push.apply(null, parseData(children[i], parent));
				}
			}
			else
				assets.push(parseAsset(obj, parent));

			return assets;
		}

		protected function hasArrayChild(obj : Object) : Boolean
		{
			for (var key : String in obj)
			{
				if(obj[key] is Array)
					return true;
			}
			return false;
		}

		protected function getArrayChild(obj : Object) : Array
		{
			for (var key : String in obj)
			{
				if(obj[key] is Array)
					return obj[key];
			}
			return null;
		}

		protected function parseAsset(obj : Object, parent : ConfigVO) : ConfigVO
		{
			var asset : ConfigVO = new ConfigVO();

			asset.parentId = parent.id;
			asset.base = (obj.base || parent.base);
			asset.connections = parent.connections;

			asset.id = obj.id;
			asset.src = (obj.src || "");
			asset.type = (obj.type || parent.type);
			asset.retries = obj.retries || parent.retries;
			asset.weight = convertWeight(obj.weight);
			asset.priority = obj.priority || NaN;
			asset.onDemand = (obj.onDemand || parent.onDemand);
			asset.preventCache = (obj.preventCache || parent.preventCache);

			asset.type = asset.type.toUpperCase();

			return asset;
		}

		protected function inherit(obj : Object, parent : ConfigVO = null) : ConfigVO
		{
			if(!parent)
				parent = new ConfigVO();

			var child : ConfigVO = new ConfigVO();

			child.id = obj.id || parent.id;
			child.base = obj.base || parent.base;
			child.type = obj.type || parent.type;
			child.connections = obj.connections || parent.connections;
			child.retries = obj.retries || parent.retries;
			child.onDemand = (obj.onDemand || parent.onDemand);
			child.preventCache = (obj.preventCache || parent.preventCache);

			return child;
		}

		protected function convertWeight(weight : *) : uint
		{
			if(weight is Number)
				return weight;

			if(weight is String)
			{
				weight = weight.replace(new RegExp(" ", "g"), "");

				var mbExp : RegExp = new RegExp("mb", "gi");
				if(mbExp.test(weight))
					return Number(weight.replace(mbExp, "")) * 1024 * 1024;

				var kbExp : RegExp = new RegExp("kb", "gi");
				if(kbExp.test(weight))
					return Number(weight.replace(kbExp, "")) * 1024;
			}

			return 0;
		}
	}
}
