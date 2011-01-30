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
		private var mTimer:Number = 1;
		
		override public function create():void
		{
			trace("Creating ice level");
			
			var i:int;
			_playerStart = new FlxPoint(29*32, 37*32);
			_goalPos = new FlxPoint(200, 100);
			super.create();
			activatePlayers(1);
			addDino(1230, 960);
			addDino(750, 800);
			addWater(39, 38, 5, 11);
			addWater(45, 31, 3, 17);
			addWater(6, 27, 9, 16);
			addWater(1, 10, 4, 33);
			addWater(6, 10, 12, 6);
			addWater(30, 12, 1, 0);
			addWater(44, 12, 0, 0);
			addShark(406,1160);
			addShark(285, 1199);
			addShark(61, 1336);
			addShark(48, 1070);
			addShark(167, 845);
			addShark(167, 675);
			addShark(74, 473);
			addShark(238, 395);
			addShark(463, 489);
			addShark(566,393);
			addTree(100, 100);
			addTree(874, 352);
			addTree(902, 352);
			addTree(930, 352);
			addTree(909, 352);
			addTree(1031, 352);
			addTree(1069, 352);
			addTree(1097, 352);
			addTree(1149, 352);
			addTree(1165, 352);
			addTree(1195, 352);
			addTree(1262, 352);
			
			
			loadMap(map);
		}
		
		override public function update():void
		{
			if (mTimer > 0)
			{
				mTimer -= FlxG.elapsed;
			}
			super.update();
			
			if (((_camMan.x > 500) && (_camMan.y > 0 && _camMan.y < 700)))
			{
				if (mTimer <= 0)
				{
					mTimer = Math.random()*1.5;
					addMeteor(_camMan.x + Math.random() * 200 - 70,-50,Math.random()*200-100);
				}
			}
			if (((_camMan.x > 1000 && _camMan.x < 1180) && (_camMan.y > 200 && _camMan.y < 400)) && (part == 1))
			{
				addQuake(1136, 368);
				addQuake(1165, 368);
				addQuake(1165, 333);
				addQuake(1197, 368);
				addQuake(1197, 333);
				part = 2;
			}
			if (((_camMan.x > 1150 && _camMan.x < 1280) && (_camMan.y > 0 && _camMan.y < 400)) && (part == 2))
			{
				addQuake(1230, 368);
				addQuake(1230, 333);
				part = 3;
			}
			/*
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