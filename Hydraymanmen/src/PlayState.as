package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source = "data/tribalthing.mp3")] protected var Music:Class;
		[Embed(source = "data/jump.mp3")] protected var JumpSnd:Class;
		[Embed(source = "data/icetiles.png")] protected var ImgTiles:Class;
		[Embed(source = "data/goal.png")] protected var goalImg:Class;
		[Embed(source = "data/fire.png")] protected var fireImg:Class;
		[Embed(source = 'levels/map1.txt', mimeType = "application/octet-stream")] private var Map:Class;
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
		protected var _waters:FlxGroup;
		protected var _dinos:FlxGroup;
		protected var _changes:Array;
		protected var _changeIndex:int;
		protected var _timer:Number = 0;
		protected var _playerStart:FlxPoint;
		protected var _goalPos:FlxPoint;
		
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
			for (i = 0; i < 100; i++ )
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
			
			_tileMap = new FlxTilemap();
			_tileMap.loadMap(new Map,ImgTiles,32,32);
			_tileMap.follow();
			add(_tileMap);
			/*
			var bg:FlxSprite = new FlxSprite(0, 0, bgImg);
			bg.scrollFactor.x = bg.scrollFactor.y = 0;
			bg.fixed = true;
			add(bg);
			*/
			
			_goal = new FlxSprite(_goalPos.x,_goalPos.y, goalImg);
			_goal.fixed = true;
			add(_goal);
			
			_waters = new FlxGroup();
			
			_cosmetic_fires = new FlxGroup();
			
			_players = new FlxGroup();
			for(i = 0; i < 32; i++)
			{
				s = new Player(_playerStart.x,_playerStart.y, _players, _cosmetic_fires);
				if (i >= PlayState.numHydra)
					s.exists = false;
				_players.add(s);
			}
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
			
			_camMan = new CameraMan(_players);
			add(_camMan);
			
			FlxG.follow(_camMan, 1);
			_block = new Block(50, 50, 5);
			_players.add(_block);
			
			FlxG.followAdjust(.1, .1);
			FlxG.followBounds(-32, -32, _tileMap.width+32,_tileMap.height+32);
		}

		override public function update():void
		{
			_timer += FlxG.elapsed;
			if (_changeIndex < int(_timer))
			{
				_changeIndex = _timer;
				if (_changes[_changeIndex].length > 0)
				{
					for (var i:int = 0; i < _changes[_changeIndex].length; i++ )
					{
						var c:Change = _changes[_changeIndex][i];
						if (c.tile == 0)
						{
							FlxG.quake.start();
						}
						_tileMap.setTile(c.pos.x, c.pos.y, c.tile, true);
						FlxG.log("changes");
					}
				}
			}
			_goalCounter = 0;
			//FlxU.overlap(_players, _floor,canJump);
			FlxU.overlap(_waters, _meteor_fires, douseFire);
			FlxU.overlap(_players, _waters, playerFloat);
			FlxU.overlap(_players, _goal, hitGoal);
			FlxU.overlap(_players, _meteor_fires, setOnFire);
			FlxU.overlap(_players, _players, playerSetOnFire);
			FlxU.collide(_players, _goal);
			FlxU.collide(_players, _tileMap);
			FlxU.collide(_enemies, _tileMap);
			FlxU.collide(_dinos, _tileMap);
			FlxU.collide(_players, _players);
			FlxU.overlap(_players, _tornados, blowAway);
			FlxU.overlap(_meteor_fires, _tornados, blowAway);
			
			
			FlxU.collide(_meteors, _tileMap);
			FlxU.collide(_meteor_fires, _tileMap);
			
			//FlxU.overlap(_players, _explodes, playerHit);
			FlxU.overlap(_players, _enemies, playerHit);
			FlxU.overlap(_players, _dinos, playerHit);
			
			//end condition
			if (_goalCounter > 1)
			{
				nextLevel();
			}
			
			//FlxU.collide(_players, _floor);
			
			/*
			FlxU.overlap(_bullets, _zombies, solidHit);
			
			FlxU.overlap(_player, _powerUps, getPowerUp);
			
			if (!_player.flickering() && _player.exists)
			{
				FlxU.overlap(_zombies, _player, playerHit);
				
				FlxU.overlap(_blasts, _player, playerHit);
			}
			*/
			
			if (FlxG.keys.justPressed('X'))
			{
				FlxG.play(JumpSnd);
			}
			
			if (FlxG.keys.justPressed('A'))
			{
				_changes[int(_timer + 1)].push(new Change(Math.floor(FlxG.mouse.x/32), Math.floor(FlxG.mouse.y/32), 0));
			}
			if (FlxG.keys.justPressed('S'))
			{
				var s:Tornado;
				s = (_tornados.getFirstAvail() as Tornado);
				if (s != null)
				{
					s.create(FlxG.mouse.x,FlxG.mouse.y,Math.random()*50-25);
				}
			}
			if (FlxG.keys.justPressed('D'))
			{
				var x:Enemy;
				x = (_enemies.getFirstAvail() as Enemy);
				if (x != null)
				{
					x.create(FlxG.mouse.x,FlxG.mouse.y);
				}
			}
			if (FlxG.keys.justPressed('G'))
			{
				var d:Dino;
				d = (_dinos.getFirstAvail() as Dino);
				if (d != null)
				{
					d.create(FlxG.mouse.x,FlxG.mouse.y);
				}
			}
			if (FlxG.keys.justPressed('F'))
			{
				var y:Meteor;
				y = (_meteors.getFirstAvail() as Meteor);
				if (y != null)
				{
					y.create(FlxG.mouse.x,FlxG.mouse.y,Math.random()*50-25);
				}
			}
			/*
			if (FlxG.keys.justPressed('D'))
			{
				makeShips(1);
			}
			*/
			checkForExtinction();
			
			super.update();
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
		}
		
		protected function playerSetOnFire(a:FlxObject, b:FlxObject):void
		{
			if (a is Player && b is Player)
			{
				if (Player(a).fire_time() > 0.5 || Player(b).fire_time() > 0.5)
				{
					Player(a).ignite();
					Player(b).ignite();
				}
			}
		}
		
		protected function playerFloat(a:FlxObject, b:FlxObject):void
		{
			if (!Player(a).floating)
			{
				Player(a).floating = true;
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
			a.kill();
		}
		protected function resetLevel():void
		{
			FlxG.state = new PlayState();
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
			if (numAlive == 0)
				resetLevel();
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
		protected function addMeteor(x:Number, y:Number, dir:Number):void
		{
			var y:Meteor;
			y = (_meteors.getFirstAvail() as Meteor);
			if (y != null)
			{
				y.create(x,y,dir);
			}
		}
	}
}

