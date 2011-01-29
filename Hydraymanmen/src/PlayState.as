package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source = "data/tiles.png")] private var ImgTiles:Class;
		[Embed(source = "data/goal.png")] private var goalImg:Class;
		[Embed(source = 'data/map1.txt', mimeType = "application/octet-stream")] private var Map:Class;
		protected var _players:FlxGroup;//the players
		protected var _camMan:CameraMan;//what the camera centers on
		protected var _tileMap:FlxTilemap;//the tile
		protected var _goal:FlxSprite;//the goal
		protected var _doom:FlxSprite;//the doom
		protected var _goalCounter:int = 0;//how many players are on the goal
		protected var _explodes:FlxGroup;
		protected var _meteors:FlxGroup;
		protected var _enemies:FlxGroup;

		override public function create():void
		{
			FlxG.mouse.hide();
			var i:int;
			var s:FlxSprite;
			
			_explodes = new FlxGroup();
			for(i = 0; i < 64; i++)
			{
				s = new Explode( -100, -100,5,_explodes);
				s.exists = false;
				_explodes.add(s);
			}
			add(_explodes);
			
			_meteors = new FlxGroup();
			for(i = 0; i < 32; i++)
			{
				s = new Meteor( -100, -100,_explodes);
				s.exists = false;
				_meteors.add(s);
			}
			add(_meteors);
			
			_tileMap = new FlxTilemap();
			_tileMap.loadMap(new Map,ImgTiles,16,16);
			_tileMap.follow();
			add(_tileMap);
			/*
			var bg:FlxSprite = new FlxSprite(0, 0, bgImg);
			bg.scrollFactor.x = bg.scrollFactor.y = 0;
			bg.fixed = true;
			add(bg);
			*/
			
			_goal = new FlxSprite(200, 200, goalImg);
			_goal.fixed = true;
			add(_goal);
			
			_players = new FlxGroup();
			for(i = 0; i < 64; i++)
			{
				s = new Player( -100, -100,_players);
				s.exists = false;
				_players.add(s);
			}
			_players.add(new Player( 100, 100,_players));
			add(_players);
			
			_enemies = new FlxGroup();
			for(i = 0; i < 64; i++)
			{
				s = new Enemy( -100, -100);
				s.exists = false;
				_enemies.add(s);
			}
			add(_enemies);
			
			_camMan = new CameraMan(_players);
			add(_camMan);
			
			FlxG.follow(_camMan, 1);
			_doom = new DeathZone(150, 200);
			_doom.fixed = true;
			add(_doom);
			
			FlxG.followAdjust(.1, .1);
			FlxG.followBounds(-2000, -2000, 2000,2000);
		}

		override public function update():void
		{
			_goalCounter = 0;
			//FlxU.overlap(_players, _floor,canJump);
			FlxU.overlap(_players, _goal, hitGoal);
			FlxU.collide(_players, _goal);
			FlxU.collide(_players, _doom);
			FlxU.collide(_players, _tileMap);
			FlxU.collide(_enemies, _tileMap);
			FlxU.collide(_players, _players);
			
			FlxU.collide(_meteors, _tileMap);
			
			FlxU.overlap(_players, _explodes, playerHit);
			FlxU.overlap(_players, _enemies, playerHit);
			
			//end condition
			if (_goalCounter > 1)
			{
				FlxG.state = new PlayState();
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
			
			
			if (FlxG.keys.justPressed('S'))
			{
				var s:Meteor;
				s = (_meteors.getFirstAvail() as Meteor);
				if (s != null)
				{
					s.create(100,0,Math.random()*50-25);
				}
			}
			if (FlxG.keys.justPressed('D'))
			{
				var x:Enemy;
				x = (_enemies.getFirstAvail() as Enemy);
				if (x != null)
				{
					x.create(100,0);
				}
			}
			/*
			if (FlxG.keys.justPressed('D'))
			{
				makeShips(1);
			}
			*/
			
			
			super.update();
		
		}
		
		private function hitGoal(a:FlxObject, b:FlxObject):void
		{
			_goalCounter += 1;
		}
		
		private function playerHit(a:FlxObject, b:FlxObject):void
		{
			a.kill();
		}
		
	}
}

