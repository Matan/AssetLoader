package runner.view 
{
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.events.AssetLoaderEvent;
	import org.robotlegs.mvcs.Mediator;

	import flash.events.MouseEvent;

	/**
	 * @author Matan Uberstein
	 */
	public class CanvasMediator extends Mediator 
	{

		[Inject]
		public var view : Canvas;

		[Inject]
		public var loader : IAssetLoader;

		override public function onRegister() : void 
		{
			eventMap.mapListener(eventDispatcher, AssetLoaderEvent.PROGRESS, loaderProgress_handler, AssetLoaderEvent);
			
			view.init();
			
			eventMap.mapListener(view.startBtn, MouseEvent.CLICK, startClick_handler, MouseEvent);			eventMap.mapListener(view.stopBtn, MouseEvent.CLICK, stopClick_handler, MouseEvent);			eventMap.mapListener(view.destroyBtn, MouseEvent.CLICK, destroyClick_handler, MouseEvent);		}

		protected function loaderProgress_handler(event : AssetLoaderEvent) : void 
		{
			view.setOverallProgress(event.progress);
		}

		protected function startClick_handler(event : MouseEvent) : void 
		{
			loader.start();
		}
		protected function stopClick_handler(event : MouseEvent) : void 
		{
			loader.stop();
		}
		protected function destroyClick_handler(event : MouseEvent) : void 
		{
			loader.destroy();
		}
	}
}
