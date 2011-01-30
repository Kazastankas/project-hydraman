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
		[Embed(source = "../data/tribalthing.mp3")] protected var Music:Class;
		[Embed(source = "../grafixxx/postapoc-bg.png")] protected var bgImg:Class;
		[Embed(source = "../data/rock.png")] private var rockImg:Class;
		protected var zTriggers:FlxGroup;
		protected var bolts:FlxGroup;
		protected var bolt:Lightning;
		protected var lightningCount:int;
		
		override public function create():void
		{
			trace("Creating future level");
			FlxG.playMusic(Music);
			
			var i:int;
			_playerStart = new FlxPoint(48*32, 44*32);
			_goalPos = new FlxPoint(200, 100);
			lightningCount = -1;
			bolts = new FlxGroup();
			super.create();
			activatePlayers(Math.max(1, PlayState.numInGoal));
			
			zTriggers = new FlxGroup();
			add(zTriggers);
			
			addPlagueBot(980, 1400);
			addPlagueBot(930, 1400);
			addPlagueBot(830, 1400);
			addPlagueBot(412, 1218);
			addPlagueBot(780, 740);
			addPlagueBot(430, 1094);
			addPlagueBot(348, 997);
			addPlagueBot(516, 1002);
			
			addAngler(1380, 876);
			addAngler(350, 855);
			
			for (i = 0; i < 40; i++)
			{
				addDisease((i*0.5 + 9) * 32, 18 * 32, 0.0);
			}
			//for (i = 0; i < 20; i++)
			//{
			//	addDisease((30.0 + (i * 0.5)) * 32, 20.0 * 32, 0.0);
			//}
			
			addAngler(32 * 32, 17 * 32, -2.0);
			addAngler(36 * 32, 17 * 32, -2.0);
			
			
			zTriggers.add(new ZombieTrigger(42, 42, 44, 42, 10));
			zTriggers.add(new ZombieTrigger(16, 48, 18, 48, 10));
			zTriggers.add(new ZombieTrigger(6, 44, 9, 44, 10));
			zTriggers.add(new ZombieTrigger(7, 40, 3, 39, 10));
			zTriggers.add(new ZombieTrigger(21, 38, 19, 40, 10));
			zTriggers.add(new ZombieTrigger(14, 34, 17, 34, 10));
			zTriggers.add(new ZombieTrigger(4, 34, 7, 34, 10));
			zTriggers.add(new ZombieTrigger(12, 31, 8, 31, 10));
			zTriggers.add(new ZombieTrigger(24, 31, 20, 31, 10));
			zTriggers.add(new ZombieTrigger(39, 28, 35, 28, 10));
			zTriggers.add(new ZombieTrigger(37, 23, 41, 23, 10));
			zTriggers.add(new ZombieTrigger(29, 23, 33, 23, 10));
			zTriggers.add(new ZombieTrigger(19, 23, 25, 23, 10));
			zTriggers.add(new ZombieTrigger(1, 19, 5, 21, 10));
			zTriggers.add(new ZombieTrigger(25, 23, 29, 23, 10));
			zTriggers.add(new ZombieTrigger(38, 12, 42, 12, 10));
			zTriggers.add(new ZombieTrigger(32, 11, 35, 11, 10));
			zTriggers.add(new ZombieTrigger(23, 10, 28, 10, 10));
			
			
			loadMap(map);
		}
		
		override protected function addBackSprites():void
		{
			var bg:FlxSprite = new FlxSprite(0, 0, bgImg);
			bg.scrollFactor.x = bg.scrollFactor.y = 0;
			bg.fixed = true;
			add(bg);
		}
		
		override public function update():void
		{
			super.update();
			
			FlxU.overlap(_players, zTriggers, triggerZombies);
			
			if ((_camMan.x > 520 && _camMan.x <700) && (_camMan.y > 300 && _camMan.y < 350))
			{
				addQuake(500, 332);
				addQuake(470, 332);
			}
			
			
			if ((_camMan.x > 100 && _camMan.x < 200) && (_camMan.y > 300 && _camMan.y < 350) && (lightningCount == -1))
			{
				_resetFlag = false;
				lightningCount = 30;
			}
			
			if (lightningCount > 0)
			{
				for (var i:Number = 0; i < _players.members.length; i++) {
					bolt = add(new Lightning()) as Lightning;
					bolts.add(bolt);
					var boltPoint:FlxPoint = _players.members[i].getScreenXY();
					bolt.SetTarget(new FlxPoint(boltPoint.x, boltPoint.y - 400));
					bolt.SetOrigin(boltPoint);
					bolt.strike(boltPoint.x, boltPoint.y - 400);
				}
				lightningCount--;
			}
			else if (lightningCount == 0)
			{
				while (_players.members.length > 1) {
					var hydra:Player = _players.members.pop();
					hydra.kill();
				}
				
				for (var i:Number = 0; i < bolts.members.length; i++) {
					bolts.members[i].kill();
				}
				
				if (_players.members.length == 1) {
					var spawnRock:FlxSprite = new FlxSprite(_players.members[0].x - 18, _players.members[0].y + 8);
					spawnRock.loadGraphic(rockImg , false, false, 36, 22);
					add(spawnRock);
					_players.members.pop();
				}
				nextLevel();
			}
			/*var i:int;
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
				part = 2;
			}
			if (((_camMan.x > 400 && _camMan.x <450) && (_camMan.y > 900 && _camMan.y < 1150)) && (part == 2))
			{
				for (i = 0; i < 7; i++ )
				{
					addZombie(480+Math.random()*100,998+Math.random()*30);
				}
				addQuake(466, 1040);
				//addQuake(485, 1040);
				//addQuake(525, 1040);
				addQuake(555, 1040);
				part = 3;
			}
			if (((_camMan.x > 1050 && _camMan.x <1100) && (_camMan.y > 500 && _camMan.y < 800)) && (part == 3))
			{
				for (i = 0; i < 7; i++ )
				{
					addZombie(1200+Math.random()*100,700+Math.random()*30);
				}
				addQuake(1190, 670);
				addQuake(1210, 670);
				addQuake(1240, 670);
				part = 4;
			}*/
		}
		
		protected function triggerZombies(a:FlxObject, b:FlxObject):void
		{
			var trigger:ZombieTrigger;
			if (a is Player && b is ZombieTrigger)
				trigger = b as ZombieTrigger;
			else if (b is Player && a is ZombieTrigger)
				trigger = a as ZombieTrigger;
			
			if (trigger)
			{
				playQuake();
				for (var i:int = 0; i < trigger.num; i++)
				{
					addZombie(trigger.spawnX + 32 * (Math.random()-0.5), trigger.spawnY + 16 * (Math.random()-0.5));
				}
				zTriggers.remove(trigger);
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
				trace("Changing to end state");
				_changingLevel = true;
				FlxG.fade.start(0xff000000, 0.4, function():void { _changingLevel = false; FlxG.state = new EndState(); } );
			}
		}
	}

}