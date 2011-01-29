package levels 
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Duncan
	 */
	public class LevelMeteor extends PlayState 
	{
		[Embed(source = 'map1.txt', mimeType = "application/octet-stream")] private var Map:Class;
		[Embed(source = "../data/cambrian-bg.png")] private var bgImg:Class;
		
		override public function create():void
		{
			trace("Creating meteor level");
			
			var i:int;
			_playerStart = new FlxPoint(100, 100);
			_goalPos = new FlxPoint(200, 100);
			super.create();
			
			/*addWater(5, 6, 4, 3);
			
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
			*/
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