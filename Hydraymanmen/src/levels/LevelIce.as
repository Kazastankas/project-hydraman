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
		[Embed(source = 'map2.txt', mimeType = "application/octet-stream")] private var map:Class;
		
		override public function create():void
		{
			trace("Creating ice level");
			
			var i:int;
			_playerStart = new FlxPoint(100, 100);
			_goalPos = new FlxPoint(200, 100);
			super.create();
			loadMap(map);
			
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
			
			activatePlayers(Math.min(1, PlayState.numHydra));
		}
		
		override protected function resetLevel():void
		{
			super.resetLevel();
			trace("Reset LevelIce");
			FlxG.state = new LevelIce();
		}
		
		override protected function nextLevel():void
		{
			if (!_changingLevel)
			{
				trace("Changing to levelIce");
				_changingLevel = true;
				FlxG.fade.start(0xff000000, 0.4, function():void { _changingLevel = false; FlxG.state = new LevelMeteor(); } );
			}
		}
	}

}