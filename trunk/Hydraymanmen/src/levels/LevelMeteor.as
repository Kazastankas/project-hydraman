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
		
		override protected function create():void
		{
			super.create();
			
			//add the top layer of water
			for (i = 5; i <= 8; i++ )
			{
				_waters.add(new Water(i, 6,true));
			}
			//add the rest of the layers
			for (i = 5; i <= 8; i++ )
			{
				for (var j:int = 7; j <= 8; j++ )
				{
					_waters.add(new Water(i, j));
				}
			}
		}
		
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