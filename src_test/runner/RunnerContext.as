package runner 
{
	import runner.controller.AddConfigCommand;
	import runner.controller.BinaryLoadedCommand;
	import runner.controller.CSSLoadedCommand;
	import runner.controller.ConfigLoadedCommand;
	import runner.controller.GroupLoadedCommand;
	import runner.controller.JSONLoadedCommand;
	import runner.controller.LoaderErrorCommand;
	import runner.controller.SoundLoadedCommand;
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
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.events.AssetLoaderEvent;
	import org.assetloader.events.BinaryAssetEvent;
	import org.assetloader.events.CSSAssetEvent;
	import org.assetloader.events.GroupLoaderEvent;
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
			//-----------------------------------------------------//
			//Choose 1 of these groups
			//commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, AddLazySampleCommand, ContextEvent, true);			
			//commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, AddGroupSampleCommand, ContextEvent, true);			
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, AddConfigCommand, ContextEvent, true);
			commandMap.mapEvent(AssetLoaderEvent.CONFIG_LOADED, ConfigLoadedCommand, AssetLoaderEvent, true);
			
			//-----------------------------------------------------//
			
			commandMap.mapEvent(AssetLoaderEvent.ERROR, LoaderErrorCommand, AssetLoaderEvent);
			
			commandMap.mapEvent(GroupLoaderEvent.LOADED, GroupLoadedCommand, GroupLoaderEvent);			commandMap.mapEvent(TextAssetEvent.LOADED, TextLoadedCommand, TextAssetEvent);			commandMap.mapEvent(JSONAssetEvent.LOADED, JSONLoadedCommand, JSONAssetEvent);			commandMap.mapEvent(XMLAssetEvent.LOADED, XMLLoadedCommand, XMLAssetEvent);			commandMap.mapEvent(CSSAssetEvent.LOADED, CSSLoadedCommand, CSSAssetEvent);			commandMap.mapEvent(BinaryAssetEvent.LOADED, BinaryLoadedCommand, BinaryAssetEvent);			commandMap.mapEvent(SoundAssetEvent.LOADED, SoundLoadedCommand, SoundAssetEvent);
			
			injector.mapSingletonOf(IAssetLoader, AssetLoader);
						injector.mapSingleton(ConsoleModel);
						mediatorMap.mapView(Canvas, CanvasMediator);
						mediatorMap.mapView(Console, ConsoleMediator);			mediatorMap.mapView(ImageArea, ImageAreaMediator);
			mediatorMap.mapView(VideoArea, VideoAreaMediator);			mediatorMap.mapView(SWFArea, SWFAreaMediator);						super.startup();
		}
	}
}
