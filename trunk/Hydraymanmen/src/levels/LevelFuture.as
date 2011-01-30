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
		private var part:int = 0;
		
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
			var i:int;
			if (((_camMan.x > 400 && _camMan.x <500) && (_camMan.y > 1350 && _camMan.y < 1600)) && (part == 0))
			{
				for (i = 0; i < 7; i++ )
				{
					addZombie(600+Math.random()*100,1400+Math.random()*30);
				}
				for (i = 0; i < 7; i++ )
				{
					addZombie(200+Math.random()*100,1500+Math.random()*30);
				}
				part = 1;
				addQuake(300, 1518);
				addQuake(300, 1550);
			}
			if (((_camMan.x > 30 && _camMan.x <200) && (_camMan.y > 1250 && _camMan.y < 1300)) && (part == 1))
			{
				for (i = 0; i < 7; i++ )
				{
					addZombie(43+Math.random()*100,1220+Math.random()*30);
				}
				part = 2;
			}
			if (((_camMan.x > 400 && _camMan.x <450) && (_camMan.y > 900 && _camMan.y < 1150)) && (part == 2))
			{
				for (i = 0; i < 7; i++ )
				{
					addZombie(480+Math.random()*100,998+Math.random()*30);
				}
				addQuake(466, 1040)
				addQuake(485, 1040);
				addQuake(525, 1040);
				addQuake(555, 1040);
				part = 3;
			}
			if (((_camMan.x > 1050 && _camMan.x <1100) && (_camMan.y > 500 && _camMan.y < 800)) && (part == 3))
			{
				for (i = 0; i < 7; i++ )
				{
					addZombie(1214+Math.random()*100,700+Math.random()*30);
				}
				addQuake(1190, 670)
				addQuake(1210, 670);
				addQuake(1240, 670);
				part = 4;
			}
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