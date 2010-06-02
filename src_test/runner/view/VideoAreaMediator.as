package runner.view 
{
	import flash.events.MouseEvent;

	import runner.model.AssetId;

	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
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
			var vidLoader : ILoader = loader.getLoader(AssetId.SAMPLE_VIDEO);
			
			view.bar.source = vidLoader;
			
			eventMap.mapListener(vidLoader, VideoAssetEvent.READY, videoReady_handler, VideoAssetEvent);
			eventMap.mapListener(view.startBtn, MouseEvent.CLICK, startClick_handler, MouseEvent);
		}

		protected function videoReady_handler(event : VideoAssetEvent) : void 
		{
			view.netStream = event.netStream;
		}

		protected function startClick_handler(event : MouseEvent) : void 
		{
			loader.startAsset(AssetId.SAMPLE_VIDEO);
			view.removeChild(view.startBtn);
		}
	}
}
