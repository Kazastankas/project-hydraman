package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source = "data/tiles.png")] private var ImgTiles:Class;
		[Embed(source = "data/goal.png")] private var goalImg:Class;
		[Embed(source = 'data/map1.txt', mimeType = "application/octet-stream")] private var Map:Class;
		protected var _players:FlxGroup;//the players
		protected var _center:FlxObject;//what the camera centers on
		protected var _tileMap:FlxTilemap;//the tile
		protected var _goal:FlxSprite;//the goal
		protected var _doom:FlxSprite;//the doom
		protected var _goalCounter:int = 0;//how many players are on the goal

		override public function create():void
		{
			FlxG.mouse.hide();
			var i:int;
			_center = new FlxObject(100, 100);
			
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
			
			var s:FlxSprite;
			_players = new FlxGroup();
			for(i = 0; i < 64; i++)
			{
				s = new Player( -100, -100,_players);
				s.exists = false;
				_players.add(s);
			}
			_players.add(new Player( 100, 100,_players));
			add(_players);
			
			_doom = new DeathZone(150, 200);
			_doom.fixed = true;
			add(_doom);
			
			FlxG.follow(_center, 1);
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
			FlxU.collide(_players, _players);
			
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
			
			/*
			if (FlxG.keys.justPressed('S'))
			{
				makeSpheres(3);
			}
			if (FlxG.keys.justPressed('D'))
			{
				makeShips(1);
			}
			*/
			
			var centerPos:FlxPoint = calcCenter(_players);
			_center.x = centerPos.x;
			_center.y = centerPos.y;
			
			super.update();
		
		}
		
		private function hitGoal(a:FlxObject, b:FlxObject):void
		{
			_goalCounter += 1;
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
	}
}

