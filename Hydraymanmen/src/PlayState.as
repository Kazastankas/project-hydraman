package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source = "data/jump.mp3")] protected var JumpSnd:Class;
		[Embed(source = "data/quake.mp3")] protected var QuakeSnd:Class;
		//[Embed(source = "data/alltiles1.png")] protected var ImgTiles:Class;
		[Embed(source = "grafixxx/alltilesfinal.png")] protected var ImgTiles:Class;
		[Embed(source = "data/caveback.png")] protected var goalBackImg:Class;
		[Embed(source = "data/cavefront.png")] protected var goalFrontImg:Class;
		[Embed(source = "data/fire.png")] protected var fireImg:Class;
		[Embed(source = 'levels/map2.txt', mimeType = "application/octet-stream")] private var Map:Class;
		[Embed(source = "data/cambrian-bg.png")] private var bgImg:Class;
		[Embed(source = "data/icegibs.png")] private var iceGibs:Class;
		[Embed(source = "data/shatter.mp3")] protected var shatterSnd:Class;
		protected var _players:FlxGroup;//the players
		protected var _zombies:FlxGroup;//the zombies
		protected var _camMan:CameraMan;//what the camera centers on
		protected var _tileMap:FlxTilemap;//the tile
		protected var _goal:FlxSprite;//the goal
		protected var _goalBack:FlxSprite; // the goal's back
		protected var _goalFlipped:Boolean = false;
		protected var _doom:FlxSprite;//the doom
		protected var _goalCounter:int = 0;//how many players are on the goal
		protected var _explodes:FlxGroup;
		protected var _meteors:FlxGroup;
		protected var _meteor_fires:FlxGroup;
		protected var _cosmetic_fires:FlxGroup;
		protected var _flammables:FlxGroup;
		protected var _diseases:FlxGroup;
		protected var _waters:FlxGroup;
		protected var _waterSprites:FlxGroup;
		protected var _bubbles:FlxGroup;
		protected var _drunk_bubbles:FlxGroup;
		protected var _dinos:FlxGroup;
		protected var _burrowers:FlxGroup;
		protected var _cavemen:FlxGroup;
		protected var _changes:Array;
		protected var _changeIndex:int;
		protected var _timer:Number = 0;
		protected var _playerStart:FlxPoint;
		protected var _goalPos:FlxPoint;
		protected var _changingLevel:Boolean = false;
		protected var _huts:FlxGroup;
		protected var _resetFlag:Boolean;
		protected var _updateCount:int;
		protected var _trees:FlxGroup;
		protected var _melters:FlxGroup;
		protected var _plagueBots:FlxGroup;
		protected var _walkBots:FlxGroup;
		protected var _checkPoints:FlxGroup;
		static public var _firePlaying:Number = 0;
		static public var _fireSound:FlxSound;
		
		public static var numHydra:int = 1;
		public static var numInGoal:int = 0;
		
		protected var _enemies:FlxGroup;
		protected var _tornados:FlxGroup;
		protected var _sharks:FlxGroup;
		protected var _anglers:FlxGroup;
		protected var _iceGibs:FlxEmitter;
		protected var _gibbing:Number = -1;
		
		override public function PlayState(start:FlxPoint=null):void
		{
			if (start)
			{
				_playerStart = new FlxPoint(start.x,start.y);
			}
			else
			{
				_playerStart = new FlxPoint(0, 0);
			}
			super();
		}
		
		override public function create():void
		{
			FlxG.mouse.show();
			var i:int;
			var s:FlxSprite;
			
			addBackSprites();
			
			_tornados = new FlxGroup();
			for(i = 0; i < 64; i++)
			{
				s = new Tornado( -100, -100);
				s.exists = false;
				_tornados.add(s);
			}
			add(_tornados);
			
			var c:Change;
			_changes = new Array();
			for (i = 0; i < 10000; i++ )
			{
				_changes.push(new Array());
			}
			//_changes[1] = new Change(5, 10, 0);
			//_changes[2] = new Change(5, 11, 0);
			//_changes[3].push(new Change(5, 9, 0));
			_changeIndex = 0;
			
			_explodes = new FlxGroup();
			for(i = 0; i < 64; i++)
			{
				s = new Explode( -100, -100,5,_explodes);
				s.exists = false;
				_explodes.add(s);
			}
			add(_explodes);
			
			_meteor_fires = new FlxGroup();
			for (i = 0; i < 64; i++)
			{
				s = new Fire(-100, -100, 5, true);
				s.exists = false;
				_meteor_fires.add(s);
			}
			add(_meteor_fires);
			
			_meteors = new FlxGroup();
			for(i = 0; i < 32; i++)
			{
				s = new Meteor( -100, -100,_explodes, _meteor_fires);
				s.exists = false;
				_meteors.add(s);
			}
			add(_meteors);
			
			_huts = new FlxGroup();
			add(_huts);
			
			_melters = new FlxGroup();
			
			_trees = new FlxGroup();
			add(_trees);
			
			
			loadMap();
			
			
			_goalBack = new FlxSprite(_goalPos.x, _goalPos.y);
			_goalBack.loadGraphic(goalBackImg, false, true, 79, 41);
			if (!_goalFlipped) {
				_goalBack.facing = FlxSprite.RIGHT;
			} else {
				_goalBack.facing = FlxSprite.LEFT;
			}
			_goalBack.fixed = true;
			add(_goalBack);
			
			_cosmetic_fires = new FlxGroup();
			_drunk_bubbles = new FlxGroup();
			_flammables = new FlxGroup();
			_flammables.add(_trees);
			
			_checkPoints = new FlxGroup();
			add(_checkPoints);
			
			_players = new FlxGroup();
			for(i = 0; i < 32; i++)
			{
				s = new Player(_playerStart.x, _playerStart.y, _players, _cosmetic_fires, _drunk_bubbles);
				s.exists = false;
				_players.add(s);
				_flammables.add(s);
			}
			//activatePlayers(numHydra);
			add(_players);
			
			_camMan = new CameraMan(_players, _playerStart);
			add(_camMan);
			
			FlxG.follow(_camMan, 9);
			
			_zombies = new FlxGroup();
			for (i = 0; i < 64; i++)
			{
				s = new Zombie( -100, -100, _zombies, _cosmetic_fires, _drunk_bubbles, _camMan);
				s.exists = false;
				_zombies.add(s);
				_flammables.add(s)
			}
			add(_zombies);
			
			_goal = new FlxSprite(_goalPos.x + 38, _goalPos.y);
			_goal.loadGraphic(goalFrontImg, false, true, 42, 41);
			if (!_goalFlipped)
			{
				_goal.facing = FlxSprite.RIGHT;
				_goal.offset.x = 0;
			} else {
				_goal.x = _goalPos.x;
				_goal.facing = FlxSprite.LEFT;
				_goal.offset.x = 0;
			}
			_goal.fixed = true;
			add(_goal);
			
			_enemies = new FlxGroup();
			for(i = 0; i < 64; i++)
			{
				s = new Enemy( -100, -100, _cosmetic_fires);
				s.exists = false;
				_enemies.add(s);
				_flammables.add(s);
			}
			add(_enemies);
			
			_dinos = new FlxGroup();
			for(i = 0; i < 32; i++)
			{
				s = new Dino( -100, -100, _cosmetic_fires);
				s.exists = false;
				_dinos.add(s);
				_flammables.add(s);
			}
			add(_dinos);
			
			_burrowers = new FlxGroup();
			for (i = 0; i < 32; i++)
			{
				s = new Burrower( -100, -100);
				s.exists = false;
				_burrowers.add(s);
			}
			add(_burrowers);
			
			add(_cosmetic_fires);
			
			_iceGibs = new FlxEmitter();
			_iceGibs.createSprites(iceGibs, 15, 16, true, 1);
			//_iceGibs.delay = 1.5;
			_iceGibs.setXSpeed( -150, 150);
			_iceGibs.setYSpeed( -150, 50);
			add(_iceGibs);
			_cavemen = new FlxGroup();
			for(i = 0; i < 32; i++)
			{
				s = new Human( -100, -100,_meteor_fires,_camMan, _iceGibs, shatterSnd);
				s.exists = false;
				_cavemen.add(s);
			}
			add(_cavemen);
			
			_anglers = new FlxGroup();
			for (i = 0; i < 32; i++)
			{
				s = new Angler( -100, -100, 10000, _players);
				s.exists = false;
				_anglers.add(s);
			}
			add(_anglers);
			
			_walkBots = new FlxGroup();
			for (i = 0; i < 32; i++)
			{
				s = new WalkBot( -100, -100);
				s.exists = false;
				_walkBots.add(s);
			}
			add(_walkBots);
			
			FlxG.followAdjust(0, 0);
			
			_diseases = new FlxGroup();
			for (i = 0; i < 64; i++)
			{
				s = new Disease(-100, -100);
				s.exists = false;
				_diseases.add(s);
			}
			add(_diseases);
			
			_plagueBots = new FlxGroup();
			for (i = 0; i < 32; i++)
			{
				s = new PlagueBot( -100, -100, _diseases);
				s.exists = false;
				_plagueBots.add(s);
			}
			add(_plagueBots);
			
			_waters = new FlxGroup();
			add(_waters);
			_waterSprites = new FlxGroup();
			add(_waterSprites);
			
			_bubbles = new FlxGroup();
			for(i = 0; i < 32; i++)
			{
				s = new Bubble( -100, -100);
				s.exists = false;
				_bubbles.add(s);
			}
			add(_bubbles);
			
			for(i = 0; i < 64; i++)
			{
				s = new DrunkBubble( -100, -100);
				s.exists = false;
				_drunk_bubbles.add(s);
			}
			add(_drunk_bubbles);
			
			_sharks = new FlxGroup();
			for (i = 0; i < 32; i++)
			{
				s = new Shark( -100, -100, _camMan);
				s.exists = false;
				_sharks.add(s);
			}
			add(_sharks);
			
			_resetFlag = true;
			_updateCount = 0;
		}
		
		protected function addBackSprites():void
		{
			var bg:FlxSprite = new FlxSprite(0, 0, bgImg);
			bg.scrollFactor.x = bg.scrollFactor.y = 0;
			bg.fixed = true;
			add(bg);
		}
		
		protected function loadMap():void
		{
			
		}
		
		protected function activatePlayers(num:int):void
		{
			for(var i:int = 0; i < num; i++)
			{
				var player:Player = _players.getFirstAvail() as Player;
				if (player)
				{
					player.exists = true;
					player.x = _playerStart.x + num * (Math.random() - 0.5);
					player.y = _playerStart.y + 4 * Math.random();
				}
			}
			numInGoal = 0;
		}
		
		protected function playQuake():void
		{
			FlxG.play(QuakeSnd);
			FlxG.quake.start();
		}
		
		override public function update():void
		{
			super.update();
			
			_firePlaying -= FlxG.elapsed;
			if (_fireSound)
				adjustFireVolume();
			
			checkForExtinction();
			
			_timer += FlxG.elapsed;
			if (_changeIndex < int(_timer))
			{
				_changeIndex = _timer;
				if (_changes.length > _changeIndex && _changes[_changeIndex].length > 0)
				{
					for (var i:int = 0; i < _changes[_changeIndex].length; i++ )
					{
						var c:Change = _changes[_changeIndex][i];
						if (c.tile == 0)
						{
							playQuake();
						}
						_tileMap.setTile(c.pos.x, c.pos.y, c.tile, true);
						//FlxG.log("changes");
					}
				}
			}
			_goalCounter = 0;
			FlxU.overlap(_players, _melters, meltBlock);
			FlxU.overlap(_waters, _meteor_fires, douseFire);
			FlxU.overlap(_cavemen, _waters, drownCavemen);
			FlxU.overlap(_players, _goal, hitGoal);
			FlxU.overlap(_players, _diseases, setOnDisease);
			FlxU.overlap(_flammables, _waters, lessFire);
			FlxU.overlap(_flammables, _meteor_fires, setOnFire);
			FlxU.overlap(_trees, _meteor_fires, setOnFire);
			FlxU.overlap(_players, _players, playerContagion);
			FlxU.overlap(_players, _zombies, zombieContagion);
			FlxU.overlap(_flammables, _flammables, fireSharing);
			FlxU.collide(_players, _goal);
			FlxU.collide(_players, _tileMap);
			FlxU.collide(_enemies, _tileMap);
			FlxU.collide(_dinos, _tileMap);
			FlxU.collide(_cavemen, _tileMap);
			FlxU.collide(_players, _players);
			FlxU.collide(_players, _zombies);
			FlxU.collide(_sharks, _tileMap);
			FlxU.collide(_anglers, _tileMap);
			FlxU.collide(_plagueBots, _tileMap);
			FlxU.collide(_walkBots, _tileMap);
			FlxU.collide(_zombies, _tileMap);
			FlxU.overlap(_players, _tornados, blowAway);
			FlxU.overlap(_meteor_fires, _tornados, blowAway);
			
			FlxU.overlap(_players, _waters, playerFloat);
			
			FlxU.collide(_meteors, _tileMap);
			FlxU.collide(_meteor_fires, _tileMap);
			
			//FlxU.overlap(_players, _explodes, playerHit);
			FlxU.overlap(_players, _enemies, playerHit);
			FlxU.overlap(_players, _dinos, playerHit);
			FlxU.overlap(_players, _cavemen, playerHit);
			FlxU.overlap(_players, _burrowers, processBurrower);
			FlxU.overlap(_players, _sharks, playerHit);
			FlxU.overlap(_players, _walkBots, playerHit);
			
			FlxU.overlap(_players, _checkPoints, save);
			//FlxU.overlap(_players, _anglers, playerHit);
			//FlxU.overlap(_players, _plagueBots, playerHit);
			
			/*
			if (FlxG.keys.justPressed('T'))
			{
				addTree(FlxG.mouse.x, FlxG.mouse.y);
			}
			*/
			
			if (FlxG.keys.justPressed('Q'))
			{
				trace("X: " + FlxG.mouse.x + " Y: " + FlxG.mouse.y);
			}
			/*
			
			if (FlxG.keys.justPressed('X'))
			{
				FlxG.play(JumpSnd).volume = Math.sqrt(numHydra) / 6.0;
			}
			
			if (FlxG.keys.justPressed('A'))
			{
				_changes[int(_timer + 1)].push(new Change(Math.floor(FlxG.mouse.x/32), Math.floor(FlxG.mouse.y/32), 0));
			}
			if (FlxG.keys.justPressed('S'))
			{
				addTornado(FlxG.mouse.x, FlxG.mouse.y, Math.random() * 50 - 25);
			}
			if (FlxG.keys.justPressed('D'))
			{
				addEnemy(FlxG.mouse.x, FlxG.mouse.y);
			}
			if (FlxG.keys.justPressed('G'))
			{
				addDino(FlxG.mouse.x, FlxG.mouse.y);
			}
			if (FlxG.keys.justPressed('L'))
			{
				addHuman(FlxG.mouse.x, FlxG.mouse.y,3);
			}
			if (FlxG.keys.justPressed('J'))
			{
				addHuman(FlxG.mouse.x, FlxG.mouse.y,2);
			}
			if (FlxG.keys.justPressed('K'))
			{
				addHuman(FlxG.mouse.x, FlxG.mouse.y,1);
			}
			if (FlxG.keys.justPressed('F'))
			{
				addMeteor(FlxG.mouse.x, FlxG.mouse.y, Math.random() * 50 - 25);
			}
			if (FlxG.keys.justPressed('H'))
			{
				addDisease(FlxG.mouse.x, FlxG.mouse.y);
			}
			if (FlxG.keys.justPressed('W'))
			{
				addBurrower(FlxG.mouse.x, FlxG.mouse.y);
			}
			if (FlxG.keys.justPressed('E'))
			{
				addAngler(FlxG.mouse.x, FlxG.mouse.y);
			}
			if (FlxG.keys.justPressed('M'))
			{
				addShark(FlxG.mouse.x, FlxG.mouse.y);
			}
			if (FlxG.keys.justPressed('U'))
			{
				addPlagueBot(FlxG.mouse.x, FlxG.mouse.y);
			}
			if (FlxG.keys.justPressed('O'))
			{
				addWalkBot(FlxG.mouse.x, FlxG.mouse.y);
			}
			if (FlxG.keys.justPressed('P'))
			{
				addZombie(FlxG.mouse.x, FlxG.mouse.y);
			}
			*/
			if (FlxG.keys.justPressed('CONTROL'))
			{
				var h:Player = _players.getFirstAlive() as Player;
				if (h)
					h.kill();
				addPlayer(FlxG.mouse.x, FlxG.mouse.y);
			}
			if (FlxG.keys.justPressed("RBRACKET"))
			{
				nextLevel();
			}
			
			
			if (_gibbing > 0)
				_gibbing -= FlxG.elapsed;
			if (_gibbing < 0)
				_gibbing = -1;
			
			_updateCount++;
		}
		
		protected function hitGoal(a:FlxObject, b:FlxObject):void
		{
			if (a is Player)
			{
				var hydra:Player = a as Player;
				if (!_goalFlipped && hydra.velocity.x > 0)
				{
					hydra.kill();
					PlayState.numInGoal++;
					trace("Landed in goal: " + numInGoal);
				}
				else if (_goalFlipped && hydra.velocity.x < 0)
				{
					hydra.kill();
					PlayState.numInGoal++;
					trace("Landed in goal: " + numInGoal);
				}
			}
		}
		
		protected function save(a:FlxObject, b:FlxObject):void
		{
			if (!Checkpoint(b).acting)
			{
				FlxG.log("saved");
				_playerStart.x = a.x;
				_playerStart.y = a.y;
				Checkpoint(b).activate();
			}
		}
		
		protected function blowAway(a:FlxObject, b:FlxObject):void
		{
			a.velocity.x += a.velocity.x + Math.random() * 50;
			a.velocity.y = Math.random() * a.maxVelocity.y * 2 - a.maxVelocity.y;
		}
		
		protected function douseFire(a:FlxObject, b:FlxObject):void
		{
			if (a is Fire)
			{
				a.kill();
			}
			else if (b is Fire)
			{
				b.kill();
			}
		}
		
		protected function lessFire(a:FlxObject, b:FlxObject):void
		{
			if (a is Flammable)
			{
				Flammable(a).deflame();
			}
		}
		
		protected function drownCavemen(a:FlxObject, b:FlxObject):void
		{
			if (a is Human)
			{
				Human(a).drown();
			}
		}
		
		protected function fireSharing(a:FlxObject, b:FlxObject):void
		{
			if (a is Flammable && b is Flammable)
			{
				if (Flammable(b).fire_time() > 0.5)
				{
					Flammable(a).ignite();
				}
				if (Flammable(a).fire_time() > 0.5)
				{
					Flammable(b).ignite();
				}
			}
		}
		
		protected function setOnFire(a:FlxObject, b:FlxObject):void
		{
			if (a is Flammable)
			{
				Flammable(a).ignite();
			}
		}
		
		protected function setOnDisease(a:FlxObject, b:FlxObject):void
		{
			if (a is Player && Math.random() < 0.05)
			{
				Player(a).plague();
			}
		}
		
		protected function playerContagion(a:FlxObject, b:FlxObject):void
		{
			if (a is Player && b is Player)
			{
				if (Player(a).on_disease() && Player(b).on_disease())
				{
					Player(a).near_plague();
					Player(b).near_plague();
				}
			}
		}
		
		protected function zombieContagion(a:FlxObject, b:FlxObject):void
		{
			if (a is Player)
			{
				Player(a).near_zombie();
			}
		}
		
		protected function playerFloat(a:FlxObject, b:FlxObject):void
		{
			
			inWater(a, b);
			if (!Player(a).floating)
			{
				Player(a).floating = true;
			}
		}
		
		protected function inWater(a:FlxObject, b:FlxObject):void
		{
			if (Math.random() < .1)
			{
				addBubble(a.x, a.y);
			}
		}
		
		protected function meltBlock(a:FlxObject, b:FlxObject):void
		{
			if (a is Player)
			{
				if (Player(a).onFire)
				{
					_tileMap.setTile(b.x / 32, b.y / 32, 0, true);
					if (_gibbing < 0)
					{
						_iceGibs.at(b);
						_iceGibs.start(true, 0, 0);
						_gibbing = 0.5;
						FlxG.play(shatterSnd);
					}
				}
			}
			else
			{
				_tileMap.setTile(b.x / 32, b.y / 32, 0, true);
			}
		}
		
		protected function calcCenter(group:FlxGroup):FlxPoint
		{
			var avgPos:FlxPoint = new FlxPoint(0, 0);
			var numExists:int = 0;
			for each(var member:FlxObject in group.members)
			{
				var player:Player = member as Player;
				if (player && !player.dead && player.active && player.exists)
				{
					//trace("Player pos: " + member.x + ", " + member.y);
					avgPos.x += member.x;
					avgPos.y += member.y;
					numExists++;
				}
			}
			avgPos.x /= numExists;
			avgPos.y /= numExists;
			//trace("Avg pos: " + avgPos.x + ", " + avgPos.y + ", length: " + group.members.length);
			return avgPos;
		}
		
		protected function processBurrower(a:FlxObject, b:FlxObject):void
		{
			if (a is Burrower) 
			{
				Burrower(a).processSeen(Player(b));
			}
			else
			{
				Burrower(b).processSeen(Player(a));
			}
		}
		
		protected function playerHit(a:FlxObject, b:FlxObject):void
		{
			if (b is Human && Human(b).drowned)
			{
				return;
			}
			else
			{
				Player(a).die();
			}
		}
		
		protected function resetLevel():void
		{
			trace("RESETTING LEVEL");
			_updateCount = 0;
		}
		
		protected function checkForExtinction():void
		{
			var numAlive:int = 0;
			for each(var member:FlxObject in _players.members)
			{
				var player:Player = member as Player;
				if (player && !player.dead && player.active && player.exists && !player.onDisease)
				{
					numAlive++;
				}
			}
			PlayState.numHydra = numAlive;
			if (numAlive == 0 && _resetFlag && PlayState.numInGoal == 0)
			{
				PlayState.numHydra = 1;
				resetLevel();
			}
			else if(numAlive == 0 && PlayState.numInGoal > 0)
			{
				nextLevel();
			}
		}
		
		protected function nextLevel():void
		{
			trace("CALLING PLAYSTATE NEXT LEVEL");
			FlxG.state = new PlayState();
		}
		
		protected function addPlayer(x:Number, y:Number):void
		{
			var s:Player;
			s = (_players.getFirstAvail() as Player);
			if (s != null)
			{
				s.create(x, y);
			}
		}
		
		protected function addQuake(x:Number,y:Number):void
		{
			_changes[int(_timer + 1)].push(new Change(Math.floor(x/32), Math.floor(y/32), 0));
		}
		protected function addTornado(x:Number, y:Number, dir:Number):void
		{
			var s:Tornado;
			s = (_tornados.getFirstAvail() as Tornado);
			if (s != null)
			{
				s.create(x,y,dir);
			}
		}
		protected function addBubble(x:Number, y:Number):void
		{
			var s:Bubble;
			s = (_bubbles.getFirstAvail() as Bubble);
			if (s != null)
			{
				s.create(x,y);
			}
		}
		protected function addEnemy(x:Number, y:Number):void
		{
			var s:Enemy;
			s = (_enemies.getFirstAvail() as Enemy);
			if (s != null)
			{
				s.create(x,y);
			}
		}
		protected function addDino(x:Number, y:Number):void
		{
			var d:Dino;
			d = (_dinos.getFirstAvail() as Dino);
			if (d != null)
			{
				d.create(x,y);
			}
		}
		protected function addHuman(x:Number, y:Number,mode:int):void
		{
			var s:Human;
			s = (_cavemen.getFirstAvail() as Human);
			if (s != null)
			{
				s.create(x,y,mode);
			}
		}
		protected function addMeteor(x:Number, y:Number, dir:Number):void
		{
			var s:Meteor;
			s = (_meteors.getFirstAvail() as Meteor);
			if (s != null)
			{
				s.create(x,y,dir);
			}
		}
		
		protected function addHut(x:Number, y:Number):void
		{
			_huts.add(new Hut(x, y, _cavemen));
		}
		
		protected function addMelter(x:Number, y:Number):void
		{
			_melters.add(new Melter(x, y));
		}
		
		protected function addTree(x:Number, y:Number):void
		{
			_trees.add(new Tree(x, y,_cosmetic_fires));
		}
		
		protected function addWater(x:Number, y:Number, width:Number, height:Number):void
		{
			var i:int;
			var j:int;
			//add the top layer of water
			for (i = x; i <= x+width; i++ )
			{
				_waterSprites.add(new Water(i, y,true));
			}
			//add the rest of the layers
			for (i = x; i <= x+width; i++ )
			{
				for (j = y+1; j <= y+height; j++ )
				{
					_waterSprites.add(new Water(i, j));
				}
			}
			//var waterBody:FlxObject = new FlxObject(x, y, width, height);
			_waters.add(new FlxObject(x*32, y*32, (width+1)*32, (height+1)*32));
		}
		
		protected function addShark(x:Number, y:Number):void
		{
			var s:Shark;
			s = (_sharks.getFirstAvail() as Shark);
			if (s != null)
			{
				s.create(x, y);
			}
		}
		
		protected function addDisease(x:Number, y:Number, life:Number = 3.0):void
		{
			var s:Disease;
			s = (_diseases.getFirstAvail() as Disease);
			if (s != null)
			{
				s.create(x, y, life);
			}
		}
		
		protected function addBurrower(x:Number, y:Number):void
		{
			var s:Burrower;
			s = (_burrowers.getFirstAvail() as Burrower);
			if (s != null)
			{
				s.create(x, y);
			}
		}

		protected function addAngler(x:Number, y:Number, coeff:Number = 1):void
		{
			var s:Angler;
			s = (_anglers.getFirstAvail() as Angler);
			if (s != null)
			{
				s.create(x, y, coeff);
			}
		}
		
		protected function addWalkBot(x:Number, y:Number):void
		{
			var s:WalkBot;
			s = (_walkBots.getFirstAvail() as WalkBot);
			if (s != null)
			{
				s.create(x, y);
			}
		}
		
		protected function addPlagueBot(x:Number, y:Number):void
		{
			var s:PlagueBot;
			s = (_plagueBots.getFirstAvail() as PlagueBot);
			if (s != null)
			{
				s.create(x, y);
			}
		}
		
		protected function addZombie(x:Number, y:Number):void
		{
			var s:Zombie;
			s = (_zombies.getFirstAvail() as Zombie);
			if (s != null)
			{
				s.create(x, y);
			}
		}
		
		public function adjustFireVolume():void
		{
			var maxSndDist:Number = 250000;
			var sndAccum:Number = 0;
			var spos:FlxPoint, xdiff:Number, ydiff:Number, distsq:Number;
			
			var avgDist:FlxPoint = new FlxPoint();
			var numFires:int = 0;
			for each(var cfire:Fire in _cosmetic_fires.members)
			{
				if (cfire.exists)
				{
					spos = cfire.getScreenXY();
					xdiff = Math.abs(spos.x - FlxG.width / 2);
					ydiff = Math.abs(spos.y - FlxG.height / 2);
					distsq = xdiff * xdiff + ydiff * ydiff;
					if (distsq < maxSndDist)
						sndAccum += maxSndDist - distsq;
					numFires++;
				}
			}
			for each(var mfire:Fire in _meteor_fires.members)
			{
				if (mfire.exists)
				{
					spos = mfire.getScreenXY();
					xdiff = Math.abs(spos.x - FlxG.width / 2);
					ydiff = Math.abs(spos.y - FlxG.height / 2);
					distsq = xdiff * xdiff + ydiff * ydiff;
					if (distsq < maxSndDist)
						sndAccum += maxSndDist - distsq;
					numFires++;
				}
			}
			if (PlayState._fireSound)
			{
				if (sndAccum > 2 * maxSndDist)
					sndAccum = 2 * maxSndDist;
				var coeff:Number = sndAccum / (2 * maxSndDist);
				PlayState._fireSound.volume = coeff;
				//trace("Fires: " + numFires + ", vol coeff: " + coeff + ", accum: " + sndAccum);
			}
		}
		
		public function addCheckPoint(x:Number, y:Number):void
		{
			_checkPoints.add(new Checkpoint(x,y));
		}
	}
}

