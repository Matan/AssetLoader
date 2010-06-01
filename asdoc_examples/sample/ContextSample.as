/**
 * @exampleText Setting up implementation with Robotlegs MVCS AS3 framework. In your Context startup function. PLEASE NOTE: This class is complete UNRELATED to the other samples.
 */
package sample
{
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.AssetLoader;
	import org.robotlegs.mvcs.Context;

	import flash.display.DisplayObjectContainer;

	public class ContextSample extends Context 
	{
		public function ContextSample(contextView : DisplayObjectContainer = null, autoStartup : Boolean = true)
		{
			super(contextView, autoStartup);
		}

		override public function startup() : void 
		{
			injector.mapSingletonOf(IAssetLoader, AssetLoader);
			
			super.startup();
		}
	}
}
