package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source = "data/tribalthing.mp3")] protected var Music:Class;
		[Embed(source = "data/jump.mp3")] protected var JumpSnd:Class;
		[Embed(source = "data/quake.mp3")] protected var QuakeSnd:Class;
		[Embed(source = "data/morerocks.png")] protected var ImgTiles:Class;
		[Embed(source = "data/goal.png")] protected var goalImg:Class;
		[Embed(source = "data/fire.png")] protected var fireImg:Class;
		[Embed(source = 'levels/map1.txt', mimeType = "application/octet-stream")] private var Map:Class;
		[Embed(source = "data/cambrian-bg.png")] private var bgImg:Class;
		protected var _players:FlxGroup;//the players
		protected var _camMan:CameraMan;//what the camera centers on
		protected var _tileMap:FlxTilemap;//the tile
		protected var _goal:FlxSprite;//the goal
		protected var _doom:FlxSprite;//the doom
		protected var _goalCounter:int = 0;//how many players are on the goal
		protected var _explodes:FlxGroup;
		protected var _meteors:FlxGroup;
		protected var _meteor_fires:FlxGroup;
		protected var _cosmetic_fires:FlxGroup;
		protected var _diseases:FlxGroup;
		protected var _waters:FlxGroup;
		protected var _bubbles:FlxGroup;
		protected var _dinos:FlxGroup;
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
		static public var _firePlaying:Number = 0;
		static public var _fireSound:FlxSound;
		
		public static var numHydra:int = 1;
		protected var _enemies:FlxGroup;
		protected var _tornados:FlxGroup;
		
		protected var _block:Block;
		
		override public function create():void
		{
			FlxG.playMusic(Music);
			FlxG.mouse.show();
			var i:int;
			var s:FlxSprite;
			
			var bg:FlxSprite = new FlxSprite(0, 0, bgImg);
			bg.scrollFactor.x = bg.scrollFactor.y = 0;
			bg.fixed = true;
			add(bg);
			
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
			
			_diseases = new FlxGroup();
			for (i = 0; i < 64; i++)
			{
				s = new Disease(-100, -100);
				s.exists = false;
				_diseases.add(s);
			}
			add(_diseases);
			
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
			
			_trees = new FlxGroup();
			add(_trees);
			
			_tileMap = new FlxTilemap();
			_tileMap.loadMap(new Map,ImgTiles,32,32);
			_tileMap.follow();
			add(_tileMap);
			
			_goal = new FlxSprite(_goalPos.x,_goalPos.y, goalImg);
			_goal.fixed = true;
			add(_goal);
			
			_waters = new FlxGroup();
			
			_cosmetic_fires = new FlxGroup();
			
			_players = new FlxGroup();
			for(i = 0; i < 32; i++)
			{
				s = new Player(_playerStart.x, _playerStart.y, _players, _cosmetic_fires);
				s.exists = false;
				_players.add(s);
			}
			//activatePlayers(numHydra);
			add(_players);
			add(_cosmetic_fires);
			
			_enemies = new FlxGroup();
			for(i = 0; i < 64; i++)
			{
				s = new Enemy( -100, -100);
				s.exists = false;
				_enemies.add(s);
			}
			add(_enemies);
			
			_dinos = new FlxGroup();
			for(i = 0; i < 32; i++)
			{
				s = new Dino( -100, -100);
				s.exists = false;
				_dinos.add(s);
			}
			add(_dinos);
			
			add(_waters);
			
			_bubbles = new FlxGroup();
			for(i = 0; i < 32; i++)
			{
				s = new Bubble( -100, -100);
				s.exists = false;
				_bubbles.add(s);
			}
			add(_bubbles);
			
			_camMan = new CameraMan(_players, _playerStart);
			add(_camMan);
			
			FlxG.follow(_camMan, 9);
			
			_cavemen = new FlxGroup();
			for(i = 0; i < 32; i++)
			{
				s = new Human( -100, -100,_meteor_fires,_camMan);
				s.exists = false;
				_cavemen.add(s);
			}
			add(_cavemen);
			
			//_block = new Block(50, 50, 5);
			//_players.add(_block);
			
			FlxG.followAdjust(0, 0);
			FlxG.followBounds( -32, -32, _tileMap.width + 32, _tileMap.height + 32);
			
			_resetFlag = true;
			_updateCount = 0;
		}
		
		protected function activatePlayers(num:int):void
		{
			for(var i:int = 0; i < numHydra; i++)
			{
				var player:Player = _players.getFirstAvail() as Player;
				if (player)
				{
					player.exists = true;
					player.x = _playerStart.x + numHydra * (Math.random() - 0.5);
					player.y = _playerStart.y + 4 * Math.random();
				}
			}
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
							FlxG.play(QuakeSnd);
							FlxG.quake.start();
						}
						_tileMap.setTile(c.pos.x, c.pos.y, c.tile, true);
						FlxG.log("changes");
					}
				}
			}
			_goalCounter = 0;
			FlxU.overlap(_waters, _meteor_fires, douseFire);
			FlxU.overlap(_players, _waters, playerFloat);
			FlxU.overlap(_players, _goal, hitGoal);
			FlxU.overlap(_players, _diseases, setOnDisease);
			FlxU.overlap(_players, _meteor_fires, setOnFire);
			FlxU.overlap(_trees, _meteor_fires, setOnFire);
			FlxU.overlap(_players, _players, playerContagion);
			FlxU.collide(_players, _goal);
			FlxU.collide(_players, _tileMap);
			FlxU.collide(_enemies, _tileMap);
			FlxU.collide(_dinos, _tileMap);
			FlxU.collide(_cavemen, _tileMap);
			FlxU.collide(_players, _players);
			FlxU.overlap(_players, _tornados, blowAway);
			FlxU.overlap(_meteor_fires, _tornados, blowAway);
			
			FlxU.overlap(_players, _trees, setOnFireTree);
			FlxU.overlap(_trees, _players, setOnFirePlayer);
			
			FlxU.collide(_meteors, _tileMap);
			FlxU.collide(_meteor_fires, _tileMap);
			
			//FlxU.overlap(_players, _explodes, playerHit);
			FlxU.overlap(_players, _enemies, playerHit);
			FlxU.overlap(_players, _dinos, playerHit);
			FlxU.overlap(_players, _cavemen, playerHit);
			
			//end condition
			if (_goalCounter > 1)
			{
				nextLevel();
			}
			
			if (FlxG.keys.justPressed('L'))
			{
				trace("X: " + FlxG.mouse.x + " Y: " + FlxG.mouse.y);
			}
			
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
			
			_updateCount++;
		}
		
		protected function hitGoal(a:FlxObject, b:FlxObject):void
		{
			_goalCounter += 1;
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
		
		protected function setOnFireTree(a:FlxObject, b:FlxObject):void
		{
			if (a is Player && Tree(b).onFire)
			{
				Player(a).ignite();
			}
			else if (a is Tree && Tree(b).onFire)
			{
				Tree(a).ignite();
			}
		}
		
		protected function setOnFirePlayer(a:FlxObject, b:FlxObject):void
		{
			if (a is Tree && Player(b).onFire)
			{
				Tree(a).ignite();
			}
		}
		
		protected function setOnFire(a:FlxObject, b:FlxObject):void
		{
			if (a is Player)
			{
				Player(a).ignite();
			}
			else if (b is Player)
			{
				Player(b).ignite();
			}
			else if (a is Tree)
			{
				Tree(a).ignite();
			}
		}
		
		protected function setOnDisease(a:FlxObject, b:FlxObject):void
		{
			if (a is Player)
			{
				Player(a).plague();
			}
			else if (b is Player)
			{
				Player(b).plague();
			}
		}
		
		protected function playerContagion(a:FlxObject, b:FlxObject):void
		{
			if (a is Player && b is Player)
			{
				if (Player(a).fire_time() > 0.5 || Player(b).fire_time() > 0.5)
				{
					Player(a).ignite();
					Player(b).ignite();
				}
				if (Player(a).on_disease() || Player(b).on_disease())
				{
					Player(a).near_plague();
					Player(b).near_plague();
				}
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
		
		protected function playerHit(a:FlxObject, b:FlxObject):void
		{
			Player(a).die();
		}
		protected function resetLevel():void
		{
			_updateCount = 0;
		}
		
		protected function checkForExtinction():void
		{
			var numAlive:int = 0;
			for each(var member:FlxObject in _players.members)
			{
				var player:Player = member as Player;
				if (player && !player.dead && player.active && player.exists)
				{
					numAlive++;
				}
			}
			PlayState.numHydra = numAlive;
			if (numAlive == 0 && _resetFlag)
			{
				PlayState.numHydra = 1;
				resetLevel();
			}
		}
		
		protected function nextLevel():void
		{
			FlxG.state = new PlayState();
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
			_huts.add(new Hut(x, y));
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
				_waters.add(new Water(i, y,true));
			}
			//add the rest of the layers
			for (i = x; i <= x+width; i++ )
			{
				for (j = y+1; j <= y+height; j++ )
				{
					_waters.add(new Water(i, j));
				}
			}
		}
		
		protected function addDisease(x:Number, y:Number):void
		{
			var s:Disease;
			s = (_diseases.getFirstAvail() as Disease);
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
	}
}

