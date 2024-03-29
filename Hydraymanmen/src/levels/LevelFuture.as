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
		[Embed(source = 'map4-final.txt', mimeType = "application/octet-stream")] private var map:Class;
		[Embed(source = "../data/thingViolin.mp3")] protected var Music:Class;
		[Embed(source = "../grafixxx/postapoc-bg.png")] protected var bgImg:Class;
		[Embed(source = "../grafixxx/alltilesfinal.png")] protected var tiles:Class;
		[Embed(source = "../data/rock.png")] private var rockImg:Class;
		protected var zTriggers:FlxGroup;
		
		protected var bolt:Lightning;
		protected var lightningCount:int;
		protected var boltOrigin:FlxObject;
		
		protected var finaleTrigger:FlxObject;
		protected var finalSpawnTimer:Number;
		protected var finaleCountingDown:Boolean;
		protected var finalSpawnCount:int;
		
		protected var postFinaleTimer:Number;
		protected var postFinale:Boolean;
		
		override public function LevelFuture(start:FlxPoint=null):void
		{
			super(start);
		}
		
		override public function create():void
		{
			trace("Creating future level");
			FlxG.playMusic(Music);
			
			var i:int;
			if (_playerStart.x == 0)
			{
				_playerStart = new FlxPoint(48 * 32, 44 * 32);
			}
			_goalPos = new FlxPoint(200, 100);
			lightningCount = -1;
			super.create();
			activatePlayers(Math.max(1, PlayState.numInGoal));
			
			zTriggers = new FlxGroup();
			add(zTriggers);
			
			addPlagueBot(980, 1400);
			//addPlagueBot(930, 1400);
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
			
			addCheckPoint(593, 758);
			addCheckPoint(940, 534);
			addCheckPoint(1509,464);
			
			
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
			
			finaleTrigger = new FlxObject(7 * 32, 10 * 32, 32, 64);
			finalSpawnTimer = -1;
			finaleCountingDown = false;
			finalSpawnCount = 0;
			boltOrigin = new FlxObject(32 * 8, 32 * 8, 32, 32);
			postFinaleTimer = -1.0;
			postFinale = false;
		}
		
		override protected function addBackSprites():void
		{
			var bg:FlxSprite = new FlxSprite(0, 0, bgImg);
			bg.scrollFactor.x = bg.scrollFactor.y = 0;
			bg.fixed = true;
			add(bg);
			
			_tileMap = new FlxTilemap();
			_tileMap.loadMap(new map, ImgTiles, 32, 32);
			_tileMap.collideIndex = 57;
			_tileMap.follow();
			add(_tileMap);
			FlxG.followBounds( -32, -32, _tileMap.width + 32, _tileMap.height + 32);
		}
		
		override public function update():void
		{
			super.update();
			
			FlxU.overlap(_players, zTriggers, triggerZombies);
			FlxU.overlap(_players, finaleTrigger, triggerFinale);
			
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
			
			/*if (lightningCount > 0)
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
				
				for (var j:Number = 0; j < bolts.members.length; j++) {
					bolts.members[j].kill();
				}
				
				if (_players.members.length == 1) {
					var spawnRock:FlxSprite = new FlxSprite(_players.members[0].x - 18, _players.members[0].y + 8);
					spawnRock.loadGraphic(rockImg , false, false, 36, 22);
					add(spawnRock);
					_players.members.pop();
				}
				nextLevel();
			}*/
			
			if (finaleCountingDown)
			{
				var lhydra:Player;
				if (finalSpawnTimer > 0)
				{
					finalSpawnTimer -= FlxG.elapsed;
				}
				else
				{
					// begin the spawn
					if (finalSpawnCount < 50)
					{
						// 13,8 and 1,8
						if (Math.random() < 0.5)
						{
							addWalkBot(1 * 32, 8 * 32);
							addZombie(13 * 32, 8 * 32);
						}
						else
						{
							addWalkBot(13 * 32, 8 * 32);
							addZombie(1 * 32, 8 * 32);
						}
					}
				}
				
				// finale
				if (finalSpawnTimer < 0 && PlayState.numHydra < 2 && lightningCount == -1)
				{
					var hydra:Player = _players.getFirstAlive() as Player;
					if (hydra)
					{
						hydra.invincible = true;
						lightningCount = 60;
					}
				}
			}
			
			if (lightningCount > 0)
			{
				lhydra = _players.getFirstAlive() as Player;
				if (lhydra)
				{
					var hpos:FlxPoint = lhydra.getScreenXY();
					var bpos:FlxPoint = boltOrigin.getScreenXY();
					bolt = add(new Lightning()) as Lightning;
					bolt.SetTarget(bpos);
					bolt.SetOrigin(hpos);
					bolt.strike(bpos.x, bpos.y);
				}
				lightningCount--;
			}
			
			if (lightningCount == 0)
			{
				if (!postFinale)
				{
					FlxG.flash.start();
					lhydra = _players.getFirstAlive() as Player;
					if (lhydra)
					{
						lhydra.invincible = false;
						lhydra.die();
						postFinaleTimer = 3.0;
					}
					postFinale = true;
					_resetFlag = false;
				}
				else
				{
					postFinaleTimer -= FlxG.elapsed;
					if (postFinaleTimer < 0)
					{
						FlxG.fade.start(0xff000000, 1.4, function():void { _changingLevel = false; FlxG.state = new LevelLast(); } );
					}
				}
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
		
		protected function triggerFinale(a:FlxObject, b:FlxObject):void
		{
			if (!finaleCountingDown)
			{
				_camMan.x = finaleTrigger.x;
				_camMan.y = finaleTrigger.y;
				_camMan.fix = true;
				playQuake();
				finalSpawnTimer = 3.0;
				finaleCountingDown = true;
			}
		}
		
		override protected function resetLevel():void
		{
			super.resetLevel();
			trace("Reset LevelFuture");
			FlxG.state = new LevelFuture(_playerStart);
		}
		
		override protected function nextLevel():void
		{
			if (!_changingLevel)
			{
				trace("Changing to end state");
				_changingLevel = true;
				FlxG.fade.start(0xff000000, 0.4, function():void { _changingLevel = false; FlxG.state = new LevelLast(); } );
			}
		}
	}

}