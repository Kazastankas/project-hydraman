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
			addPlagueBot(900, 1400);
			addPlagueBot(930, 1400);
			addPlagueBot(960, 1400);
			addPlagueBot(412, 1218);
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