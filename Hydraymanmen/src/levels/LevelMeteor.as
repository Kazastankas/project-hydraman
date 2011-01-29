package levels 
{
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Duncan
	 */
	public class LevelMeteor extends PlayState 
	{
		[Embed(source = 'map1.txt', mimeType = "application/octet-stream")] private var Map:Class;
		
		override protected function resetLevel():void
		{
			FlxG.state = new LevelMeteor();
		}
		
		override protected function nextLevel():void
		{
			trace("Changing to levelIce");
			FlxG.state = new LevelIce();
		}
	}

}