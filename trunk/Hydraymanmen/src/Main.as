package
{
	import org.flixel.*;
	import levels.*;
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Main extends FlxGame
	{
		public function Main()
		{
			super(320,240,LevelMeteor);
			//showLogo = false;
		}
	}
}