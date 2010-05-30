package runner 
{
	import org.assetloader.core.IAssetLoader;
	import runner.controller.LoaderErrorCommand;

	import org.assetloader.events.AssetLoaderEvent;
	import runner.controller.BinaryLoadedCommand;
	import runner.controller.CSSLoadedCommand;
	import runner.controller.JSONLoadedCommand;
	import runner.controller.SoundLoadedCommand;
	import runner.controller.StartupCompleteCommand;
	import runner.controller.TextLoadedCommand;
	import runner.controller.XMLLoadedCommand;
	import runner.model.ConsoleModel;
	import runner.view.Canvas;
	import runner.view.CanvasMediator;
	import runner.view.Console;
	import runner.view.ConsoleMediator;
	import runner.view.ImageArea;
	import runner.view.ImageAreaMediator;
	import runner.view.SWFArea;
	import runner.view.SWFAreaMediator;
	import runner.view.VideoArea;
	import runner.view.VideoAreaMediator;

	import org.assetloader.AssetLoader;
	import org.assetloader.events.BinaryAssetEvent;
	import org.assetloader.events.CSSAssetEvent;
	import org.assetloader.events.JSONAssetEvent;
	import org.assetloader.events.SoundAssetEvent;
	import org.assetloader.events.TextAssetEvent;
	import org.assetloader.events.XMLAssetEvent;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Matan Uberstein
	 */
	public class RunnerContext extends Context 
	{
		public function RunnerContext(contextView : DisplayObjectContainer = null, autoStartup : Boolean = true)
		{
			super(contextView, autoStartup);
		}

		override public function startup() : void 
		{
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartupCompleteCommand, ContextEvent);
			
			commandMap.mapEvent(AssetLoaderEvent.ERROR, LoaderErrorCommand, AssetLoaderEvent);
			
			commandMap.mapEvent(TextAssetEvent.LOADED, TextLoadedCommand, TextAssetEvent);			commandMap.mapEvent(JSONAssetEvent.LOADED, JSONLoadedCommand, JSONAssetEvent);			commandMap.mapEvent(XMLAssetEvent.LOADED, XMLLoadedCommand, XMLAssetEvent);			commandMap.mapEvent(CSSAssetEvent.LOADED, CSSLoadedCommand, CSSAssetEvent);			commandMap.mapEvent(BinaryAssetEvent.LOADED, BinaryLoadedCommand, BinaryAssetEvent);			commandMap.mapEvent(SoundAssetEvent.LOADED, SoundLoadedCommand, SoundAssetEvent);
			
			injector.mapSingletonOf(IAssetLoader, AssetLoader);
						injector.mapSingleton(ConsoleModel);
						mediatorMap.mapView(Canvas, CanvasMediator);
						mediatorMap.mapView(Console, ConsoleMediator);			mediatorMap.mapView(ImageArea, ImageAreaMediator);
			mediatorMap.mapView(VideoArea, VideoAreaMediator);			mediatorMap.mapView(SWFArea, SWFAreaMediator);						super.startup();
		}
	}
}
