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
		private var part:int = 0;
		
		override public function create():void
		{
			trace("Creating ice level");
			
			var i:int;
			_playerStart = new FlxPoint(29*32, 37*32);
			_goalPos = new FlxPoint(200, 100);
			super.create();
			activatePlayers(1);
			addDino(1230, 960);
			addDino(790, 820);
			addWater(39, 38, 5, 11);
			addWater(45, 31, 3, 16);
			addTree(100, 100);
			loadMap(map);
		}
		
		override public function update():void
		{
			super.update();
			
			/*
			if (((_camMan.x > 850 && _camMan.x <930) && (_camMan.y > 860 && _camMan.y < 1100)) && (part == 0))
			{
				addTornado(850, 900, 1);
				part = 1;
			}
			if (((_camMan.x > 1000 && _camMan.x < 1200) && (_camMan.y > 750 && _camMan.y < 900)) && (part == 1))
			{
				addQuake(1255, 906);
				addQuake(1226, 906);
				addQuake(1189, 906);
				part = 2;
			}
			if (((_camMan.x > 900 && _camMan.x < 1100) && (_camMan.y > 730 && _camMan.y < 900)) && (part == 2))
			{
				addQuake(1093,879);
				addQuake(1069, 875);
				addQuake(1031, 866);
				part = 3;
			}
			if (((_camMan.x > 400 && _camMan.x < 600) && (_camMan.y > 700 && _camMan.y < 900)) && (part == 3))
			{
				addQuake(652,839);
				addQuake(714, 840);
				addQuake(779, 842);
				part = 4;
			}
			if (((_camMan.x > 650 && _camMan.x < 800) && (_camMan.y > 500 && _camMan.y < 750)) && (part == 4))
			{
				addTornado(650, 500, 0.1);
				addQuake(652,716);
				addQuake(690, 717);
				addQuake(824, 717);
				addQuake(850, 717);
				addQuake(880, 717);
				part = 5;
			}
			*/
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