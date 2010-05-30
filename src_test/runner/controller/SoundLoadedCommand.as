package runner.controller 
{
	import runner.model.ConsoleModel;

	import org.assetloader.events.SoundAssetEvent;
	import org.robotlegs.mvcs.Command;

	import flash.media.SoundTransform;

	/**
	 * @author Matan Uberstein
	 */
	public class SoundLoadedCommand extends Command 
	{
		
		[Inject]
		public var consoleModel : ConsoleModel;

		[Inject]
		public var event : SoundAssetEvent;

		override public function execute() : void 
		{
			event.sound.play(0, 2, new SoundTransform(.3));
			
			consoleModel.append(event.id + ": LOADED");
			consoleModel.append("Sound length: " + event.sound.length);
			consoleModel.append("---------------------------------------------------------------------------------------------------------");
		}
	}
}
