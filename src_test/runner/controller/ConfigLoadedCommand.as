package runner.controller 
{
	import runner.view.Canvas;

	import org.robotlegs.mvcs.Command;

	/**
	 * @author Matan Uberstein
	 */
	public class ConfigLoadedCommand extends Command 
	{
		override public function execute() : void 
		{
			contextView.addChild(new Canvas());
		}
	}
}
