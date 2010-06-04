package runner.view 
{
	import runner.model.AssetId;

	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoadUnit;
	import org.assetloader.events.ImageAssetEvent;
	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Matan Uberstein
	 */
	public class ImageAreaMediator extends Mediator 
	{

		[Inject]
		public var view : ImageArea;

		[Inject]
		public var loader : IAssetLoader;

		override public function onRegister() : void 
		{
			eventMap.mapListener(eventDispatcher, ImageAssetEvent.LOADED, imageLoaded_handler, ImageAssetEvent);
			
			var unit:ILoadUnit = loader.getUnit(AssetId.SAMPLE_IMAGE);
			view.bar.source = unit.loader;
		}

		protected function imageLoaded_handler(event : ImageAssetEvent) : void 
		{
			view.bitmap = event.bitmap;
		}
	}
}
