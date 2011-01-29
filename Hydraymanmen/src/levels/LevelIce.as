package levels 
{
	import org.flixel.FlxG;
	import PlayState;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Duncan
	 */
	public class LevelIce extends PlayState 
	{
		[Embed(source = 'map1.txt', mimeType = "application/octet-stream")] private var Map:Class;
		
		override protected function resetLevel():void
		{
			trace("Reset LevelIce");
			FlxG.state = new LevelIce();
		}
	}

}