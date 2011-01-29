package
{
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Hydramanmen extends FlxGame
	{
		public function Hydramanmen()
		{
			super(320,240,PlayState);
			//showLogo = false;
		}
	}
}