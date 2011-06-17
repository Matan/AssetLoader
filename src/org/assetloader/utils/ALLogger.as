package org.assetloader.utils
{
	import org.assetloader.base.AssetType;
	import org.assetloader.core.ILoadStats;
	import org.osflash.signals.Signal;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.HttpStatusSignal;
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.signals.ProgressSignal;

	/**
	 * ALLogger aka AssetLoaderLogger, this class will generate useful debugging information from any IAssetLoader and/or ILoader instances. <strong>Note:</strong> Only use this for debugging,
	 * it is highly advised to remove any ALLogger instances when releasing your app/whatever.
	 * <p>
	 * ALLogger also comes packed with a onLog signal, this will allow to to handle the resulting output in your own manner.
	 * </p>
	 * <p>
	 * Why the weird name you ask? Well, I don't want this logger to conflict with any other "Logger" you might have, also expanding
	 * the name to AssetLoaderLogger will hinder your auto-completing while coding. A simple "thanks" will do ;-)
	 * </p>
	 * 
	 * @author Matan Uberstein
	 */
	public class ALLogger
	{
		/**
		 * Signal is fired once logging occured.
		 * arg1 - String - The output genereged.
		 */
		public var onLog : Signal = new Signal(String);

		/**
		 * If true the trace function will be called.
		 * @default true
		 */
		public var autoTrace : Boolean;

		/**
		 * Charchacter used for indentation.
		 * 
		 * @default \t;
		 */
		public var indentChar : String = "\t";

		/**
		 * Constructor, creates a new instance for outputting information.
		 * 
		 * @param autoTrace If true, ALLogger will automatically call the trace function.
		 */
		public function ALLogger(autoTrace : Boolean = true)
		{
			this.autoTrace = autoTrace;
		}

		/**
		 * Attach any ILoader/IAssetLoader to the Logger. This will cause the logger to log all the signal activity.
		 * 
		 * @param loader Any implementation of ILoader, includes IAssetLoader.
		 * @param verbosity The level of detail you'd like, max value 4.
		 * @param recurse Recusion depth, setting -1 will cause infinite recusion.
		 */
		public function attach(loader : ILoader, verbosity : int = 0, recurse : int = -1) : void
		{
			_attachDetach("add", loader, verbosity, recurse);
		}

		/**
		 * Detach any attached ILoader/IAssetLoader from the Logger. This will cause the logger to remove any signal listeners.
		 * 
		 * @param loader Any implementation of ILoader, includes IAssetLoader.
		 * @param verbosity The level of detail you'd like to remove, max value 4, setting -1 will remove all.
		 * @param recurse Recusion depth, setting -1 will cause infinite recusion.
		 */
		public function detach(loader : ILoader, verbosity : int = -1, recurse : int = -1) : void
		{
			_attachDetach("remove", loader, verbosity, recurse);
		}

		/**
		 * This will instantly produce a snapshot of the current ILoader/IAssetLoader state.
		 * 
		 * @param loader Any implementation of ILoader, includes IAssetLoader.
		 * @param verbosity The level of detail you'd like, max value 4.
		 * @param recurse Recusion depth, setting -1 will cause infinite recusion.
		 */
		public function explode(loader : ILoader, verbosity : int = 0, recurse : int = -1) : void
		{
			var str : String = "";

			var indentBy : int = 0;
			var parent : ILoader = loader.parent;
			while(parent)
			{
				indentBy++;
				parent = parent.parent;
			}
			var tbs : String = rptStr(indentChar, indentBy);

			if(loader is IAssetLoader)
			{
				var assetloader : IAssetLoader = IAssetLoader(loader);

				str += tbs + "[IASSETLOADER | id=" + assetloader.id + " | type=" + assetloader.type + "]\n";
				if(verbosity >= 2)
				{
					str += tbs + " [ids = " + assetloader.ids + "]\n";
					str += tbs + " [loadedIds = " + assetloader.loadedIds + "]\n";
				}
				if(verbosity >= 1)
				{
					str += tbs + " [numLoaders = " + assetloader.numLoaders + "]\n";
					str += tbs + " [numLoaded = " + assetloader.numLoaded + "]\n";
					str += tbs + " [numConnections = " + assetloader.numConnections + "]\n";
					str += tbs + " [failOnError = " + assetloader.failOnError + "]\n";
				}
				if(verbosity >= 3)
				{
					str += tbs + " [numFailed = " + assetloader.numFailed + "]\n";
					str += tbs + " [failedIds = " + assetloader.failedIds + "]\n";
				}
			}
			else
			{
				str += tbs + "[ILOADER | id=" + loader.id + " | type=" + loader.type + "]\n";
				if(verbosity >= 1)
				{
					str += tbs + " [request.url = " + loader.request.url + "]\n";
					if(loader.parent)
						str += tbs + " [parent.id = " + loader.parent.id + "]\n";
					str += tbs + " [invoked = " + loader.invoked + "]\n";
					str += tbs + " [loaded = " + loader.loaded + "]\n";
					str += tbs + " [failed = " + loader.failed + "]\n";
				}
				if(verbosity >= 2)
				{
					str += tbs + " [inProgress = " + loader.inProgress + "]\n";
					str += tbs + " [stopped = " + loader.stopped + "]\n";
					str += tbs + " [retryTally = " + loader.retryTally + "]\n";
				}
			}

			if(verbosity >= 3)
			{
				var paramsStr : String = " [params = {";
				var paramProps : Array = [];
				for(var param : String in loader.params)
				{
					paramProps.push(param);
				}
				paramProps.sort();
				var pL : int = paramProps.length;
				for(var p : int = 0;p < pL;p++)
				{
					paramsStr += ((p == 0) ? "" : " | ") + paramProps[p] + "=" + loader.getParam(paramProps[p]);
				}
				paramsStr += "}]\n";

				str += tbs + paramsStr;
			}

			if(verbosity >= 4)
			{
				str += _explodeStats(loader.stats, tbs);
			}

			str = str.slice(0, -1);

			log(str);

			if(loader is IAssetLoader)
			{
				if(recurse != 0)
				{
					recurse--;
					var ids : Array = assetloader.ids;
					var iL : int = ids.length;
					for(var i : int = 0; i < iL; i++)
					{
						explode(assetloader.getLoader(ids[i]), verbosity, recurse);
					}
				}
			}
		}

		/**
		 * This will instantly produce a snapshot of the current ILoader/IAssetLoader's ILoadStats.
		 * 
		 * @param loader Any implementation of ILoader, includes IAssetLoader.
		 * @param recurse Recusion depth, setting -1 will cause infinite recusion.
		 */
		public function explodeStats(loader : ILoader, recurse : int = -1) : void
		{
			var str : String;

			var indentBy : int = 0;
			var parent : ILoader = loader.parent;
			while(parent)
			{
				indentBy++;
				parent = parent.parent;
			}
			var tbs : String = rptStr(indentChar, indentBy);

			if(loader is IAssetLoader)
				str = tbs + "[IASSETLOADER";
			else
				str = tbs + "[ILOADER";

			str += " | id=" + loader.id + " | type=" + loader.type + "]\n";

			str += _explodeStats(loader.stats, tbs);

			str = str.slice(0, -1);

			log(str);

			if(loader is IAssetLoader)
			{
				if(recurse != 0)
				{
					var assetloader : IAssetLoader = IAssetLoader(loader);
					recurse--;
					var ids : Array = assetloader.ids;
					var iL : int = ids.length;
					for(var i : int = 0; i < iL; i++)
					{
						explodeStats(assetloader.getLoader(ids[i]), recurse);
					}
				}
			}
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// INTERNAL
		// --------------------------------------------------------------------------------------------------------------------------------//
		/**
		 * @private
		 */
		protected function rptStr(input : String, count : int = 1) : String
		{
			var output : String = "";
			for(var i : int = 0; i < count; i++)
			{
				output += input;
			}
			return output;
		}

		/**
		 * @private
		 */
		protected function _explodeStats(stats : ILoadStats, tbs : String = "") : String
		{
			var str : String = tbs + " [ILOADSTATS]\n";
			str += tbs + "  [Total Time: " + stats.totalTime + " ms]\n";
			str += tbs + "  [Latency: " + Math.floor(stats.latency) + " ms]\n";
			str += tbs + "  [Current Speed: " + Math.floor(stats.speed) + " kbps]\n";
			str += tbs + "  [Average Speed: " + Math.floor(stats.averageSpeed) + " kbps]\n";
			str += tbs + "  [Loaded Bytes: " + stats.bytesLoaded + "]\n";
			str += tbs + "  [Total Bytes: " + stats.bytesTotal + "]\n";
			str += tbs + "  [Progress: " + stats.progress + "%]\n";

			return str;
		}

		/**
		 * @private
		 * 
		 * So nice and dirty! But, this IS better than copy and paste.
		 */
		protected function _attachDetach(addRem : String, loader : ILoader, verbosity : int = 0, recurse : int = -1) : void
		{
			if(verbosity < 0) verbosity = int.MAX_VALUE;

			if(loader is IAssetLoader)
			{
				var assetloader : IAssetLoader = IAssetLoader(loader);

				if(recurse != 0)
				{
					recurse--;
					var ids : Array = assetloader.ids;
					var iL : int = ids.length;
					for(var i : int = 0; i < iL; i++)
					{
						_attachDetach(addRem, assetloader.getLoader(ids[i]), verbosity, recurse);
					}
				}

				assetloader.onConfigLoaded[addRem](assetloader_onConfigLoaded);
				assetloader.onChildComplete[addRem](assetloader_onChildComplete);
				assetloader.onChildError[addRem](assetloader_onChildError);

				if(verbosity >= 1)
					assetloader.onChildOpen[addRem](assetloader_onChildOpen);
			}

			loader.onComplete[addRem](loader_onComplete);
			loader.onError[addRem](loader_onError);

			if(verbosity >= 1)
			{
				loader.onOpen[addRem](loader_onOpen);
				loader.onHttpStatus[addRem](loader_onHttpStatus);
			}
			if(verbosity >= 2)
			{
				loader.onStop[addRem](loader_onStop);
				loader.onStart[addRem](loader_onStart);
			}
			if(verbosity >= 3)
			{
				loader.onAddedToParent[addRem](loader_onAddedToParent);
				loader.onRemovedFromParent[addRem](loader_onRemovedFromParent);
			}
			if(verbosity >= 4)
				loader.onProgress[addRem](loader_onProgress);
		}

		/**
		 * @private
		 */
		protected function logPacket(packet : Packet) : void
		{
			var interfaceName : String = packet.type == AssetType.GROUP ? "IASSETLOADER" : "ILOADER";
			var tbs : String = rptStr(indentChar, packet.indentBy);
			var str : String = tbs + "[" + interfaceName + "] | id=" + packet.id + " | type=" + packet.type + ((packet.parentId) ? " | parent.id=" + packet.parentId : "") + "]\n";

			str += tbs + " " + packet.signal + ": [";

			var properties : Array = packet.properties;
			var pL : int = properties.length;
			for(var i : int = 0;i < pL;i++)
			{
				str += ((i == 0) ? "" : " | ") + properties[i] + "=" + packet[properties[i]];
			}
			str += "]";

			log(str);
		}

		/**
		 * @private
		 */
		protected function log(str : String) : void
		{
			if(autoTrace)
				trace(str);
			onLog.dispatch(str);
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// ASSETLOADER HANDLERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		/**
		 * @private
		 */
		protected function assetloader_onConfigLoaded(signal : LoaderSignal) : void
		{
			logPacket(new Packet(signal, "onConfigLoaded"));
		}

		/**
		 * @private
		 */
		protected function assetloader_onChildOpen(signal : LoaderSignal, child : ILoader) : void
		{
			logPacket(new Packet(signal, "onChildOpen"));
		}

		/**
		 * @private
		 */
		protected function assetloader_onChildError(signal : ErrorSignal, child : ILoader) : void
		{
			logPacket(new Packet(signal, "onChildError"));
		}

		/**
		 * @private
		 */
		protected function assetloader_onChildComplete(signal : LoaderSignal, child : ILoader) : void
		{
			logPacket(new Packet(signal, "onChildComplete"));
		}

		// --------------------------------------------------------------------------------------------------------------------------------//
		// LOADER HANDLERS
		// --------------------------------------------------------------------------------------------------------------------------------//
		/**
		 * @private
		 */
		protected function loader_onAddedToParent(signal : LoaderSignal, parent : IAssetLoader) : void
		{
			logPacket(new Packet(signal, "onAddedToParent"));
		}

		/**
		 * @private
		 */
		protected function loader_onRemovedFromParent(signal : LoaderSignal, parent : IAssetLoader) : void
		{
			logPacket(new Packet(signal, "onRemovedFromParent"));
		}

		/**
		 * @private
		 */
		protected function loader_onStart(signal : LoaderSignal) : void
		{
			logPacket(new Packet(signal, "onStart"));
		}

		/**
		 * @private
		 */
		protected function loader_onStop(signal : LoaderSignal) : void
		{
			logPacket(new Packet(signal, "onStop"));
		}

		/**
		 * @private
		 */
		protected function loader_onHttpStatus(signal : HttpStatusSignal) : void
		{
			logPacket(new Packet(signal, "onHttpStatus"));
		}

		/**
		 * @private
		 */
		protected function loader_onOpen(signal : LoaderSignal) : void
		{
			logPacket(new Packet(signal, "onOpen"));
		}

		/**
		 * @private
		 */
		protected function loader_onProgress(signal : ProgressSignal) : void
		{
			logPacket(new Packet(signal, "onProgress"));
		}

		/**
		 * @private
		 */
		protected function loader_onError(signal : ErrorSignal) : void
		{
			logPacket(new Packet(signal, "onError"));
		}

		/**
		 * @private
		 */
		protected function loader_onComplete(signal : LoaderSignal, data : *) : void
		{
			logPacket(new Packet(signal, "onComplete"));
		}
	}
}
import org.assetloader.core.ILoader;
import org.assetloader.signals.LoaderSignal;

import flash.utils.describeType;

dynamic class Packet
{
	protected var _properties : Array = [];

	public var target : ILoader;
	public var signal : String;
	public var indentBy : int = 0;

	public var id : String;
	public var type : String;
	public var parentId : String;

	public function Packet(signal : LoaderSignal, signalName : String)
	{
		target = signal.loader;
		this.signal = signalName;
		id = target.id;
		type = target.type;

		if(target.parent)
			parentId = target.parent.id;

		var parent : ILoader = target.parent;
		while(parent)
		{
			indentBy++;
			parent = parent.parent;
		}

		// Get the description of the class
		var description : XML = describeType(signal);

		// Get accessors from description
		for each(var a:XML in description.accessor)
		{
			_properties.push(String(a.@name));
		}

		// Get variables from description
		for each(var v:XML in description.variable)
		{
			_properties.push(String(v.@name));
		}

		_properties.splice(_properties.indexOf("loader"), 1);
		_properties.splice(_properties.indexOf("valueClasses"), 1);

		var pL : int = _properties.length;
		for(var i : int = 0; i < pL; i++)
		{
			this[_properties[i]] = signal[_properties[i]];
		}

		_properties.sort();
	}

	public function get properties() : Array
	{
		return _properties;
	}
}
