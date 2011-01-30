package levels 
{
	import org.flixel.FlxG;
	import PlayState;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Duncan
	 */
	public class LevelFuture extends PlayState 
	{
		[Embed(source = 'map4.txt', mimeType = "application/octet-stream")] private var map:Class;
		private var part:int = 1;
		
		override public function create():void
		{
			trace("Creating future level");
			
			var i:int;
			_playerStart = new FlxPoint(48*32, 44*32);
			_goalPos = new FlxPoint(200, 100);
			super.create();
			activatePlayers(Math.max(1, PlayState.numInGoal));
			addPlagueBot(980, 1400);
			addPlagueBot(930, 1400);
			addPlagueBot(960, 1400);
			addPlagueBot(412, 1218);
			addPlagueBot(780, 740);
			addAngler(1380, 876);
			addAngler(350, 855);
			
			for (i = 0; i < 10; i++)
			{
				addPlagueBot((2 * i + 9) * 32, 18 * 32);
			}
			addAngler(18 * 32, 12 * 32, 2.0);
			addAngler(21 * 32, 12 * 32, 2.0);
			
			addAngler(32 * 32, 17 * 32, -2.0);
			addAngler(36 * 32, 17 * 32, -2.0);
			
			loadMap(map);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override protected function resetLevel():void
		{
			super.resetLevel();
			trace("Reset LevelFuture");
			FlxG.state = new LevelFuture();
		}
		
		override protected function nextLevel():void
		{
			if (!_changingLevel)
			{
				trace("Changing to levelFuture");
				_changingLevel = true;
				FlxG.fade.start(0xff000000, 0.4, function():void { _changingLevel = false; FlxG.state = new LevelDino(); } );
			}
		}
	}

}