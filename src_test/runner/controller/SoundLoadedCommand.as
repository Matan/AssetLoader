package runner.controller 
{
	import org.assetloader.events.SoundAssetEvent;

	import flash.media.SoundTransform;

	/**
	 * @author Matan Uberstein
	 */
	public class SoundLoadedCommand extends BaseOutputCommand 
	{
		
		[Inject]
		public var event : SoundAssetEvent;

		override public function execute() : void 
		{
			event.sound.play(0, 1, new SoundTransform(.1));
			
			output(event);
		}
	}
}
