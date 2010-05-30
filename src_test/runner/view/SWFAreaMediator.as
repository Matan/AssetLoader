package runner.view 
{
	import runner.model.AssetId;

	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoadUnit;
	import org.assetloader.events.SWFAssetEvent;
	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author Matan Uberstein
	 */
	public class SWFAreaMediator extends Mediator 
	{

		[Inject]
		public var view : SWFArea;

		[Inject]
		public var loader : IAssetLoader;

		override public function onRegister() : void 
		{
			eventMap.mapListener(eventDispatcher, SWFAssetEvent.LOADED, swfLoaded_handler, SWFAssetEvent);
			
			var unit : ILoadUnit = loader.getLoadUnit(AssetId.SAMPLE_SWF);
			view.bar.source = unit.loader;
		}

		protected function swfLoaded_handler(event : SWFAssetEvent) : void 
		{
			view.swf = event.sprite;
		}
	}
}
