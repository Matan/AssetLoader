package  
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import runner.RunnerContext;

	import flash.display.Sprite;

	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="900", height="500")]

	/**
	 * @author Matan Uberstein
	 */
	public class TestRunner extends Sprite 
	{
		protected var _context : RunnerContext;

		public function TestRunner()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_context = new RunnerContext(this);
		}
	}
}
