package runner.view 
{
	import runner.model.AssetId;

	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoadUnit;
	import org.assetloader.events.VideoAssetEvent;
	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Matan Uberstein
	 */
	public class VideoAreaMediator extends Mediator 
	{

		[Inject]
		public var view : VideoArea;

		[Inject]
		public var loader : IAssetLoader;

		override public function onRegister() : void 
		{
			var unit : ILoadUnit = loader.getLoadUnit(AssetId.SAMPLE_VIDEO);
			
			view.bar.source = unit.loader;
			
			eventMap.mapListener(unit.loader, VideoAssetEvent.READY, loaderOpen_handler, VideoAssetEvent);
		}

		protected function loaderOpen_handler(event : VideoAssetEvent) : void 
		{
			view.netStream = event.netStream;
		}
	}
}
