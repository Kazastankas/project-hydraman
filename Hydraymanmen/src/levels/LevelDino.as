package levels 
{
	import org.flixel.FlxG;
	import PlayState;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Duncan
	 */
	public class LevelDino extends PlayState 
	{
		[Embed(source = 'map3.txt', mimeType = "application/octet-stream")] private var map:Class;
		private var part:int = 1;
		
		override public function create():void
		{
			trace("Creating dino level");
			
			var i:int;
			_playerStart = new FlxPoint(8*32, 48*32);
			_goalPos = new FlxPoint(200, 100);
			super.create();
			activatePlayers(Math.max(1, PlayState.numInGoal));
			addHuman(690, 1339, 2);
			addHuman(1300, 1380, 1);
			addHut(250, 1150);
			addHuman(330, 1150, 1);
			addHuman(300, 1150, 3);
			addHuman(250, 1150, 2);
			addHuman(115, 1150, 2);
			addWater(25, 45, 4, 3);
			addWater(30, 39, 3, 9);
			addWater(34, 45, 7, 3);
			addWater(17, 26, 3, 1);
			addWater(43, 43, 0, 0);
			addHuman(300, 780, 1);
			addHuman(380, 780, 3);
			addHuman(260, 780, 2);
			addHuman(200, 780, 2);
			addHut(320, 780);
			addHut(450, 780);
			addMelter(24, 37);
			addMelter(25, 37);
			addMelter(24, 38);
			addMelter(25, 38);
			addMelter(42, 40);
			addMelter(42, 41);
			addMelter(17, 26);
			addMelter(18, 26);
			addMelter(19, 26);
			addMelter(20, 26);
			
			loadMap(map);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override protected function resetLevel():void
		{
			super.resetLevel();
			trace("Reset LevelDino");
			FlxG.state = new LevelDino();
		}
		
		override protected function nextLevel():void
		{
			if (!_changingLevel)
			{
				trace("Changing to levelDino");
				_changingLevel = true;
				FlxG.fade.start(0xff000000, 0.4, function():void { _changingLevel = false; FlxG.state = new LevelIce(); } );
			}
		}
	}

}