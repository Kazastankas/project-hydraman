package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source = "data/tiles.png")] private var ImgTiles:Class;
		[Embed(source = 'data/map1.txt', mimeType = "application/octet-stream")] private var Map:Class;
		protected var _players:FlxGroup;//the players
		protected var _center:FlxObject;//what the camera centers on
		protected var _tileMap:FlxTilemap;//the tile

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
			
			var s:FlxSprite;
			_players = new FlxGroup();
			for(i = 0; i < 64; i++)
			{
				s = new Player( -100, -100);
				s.exists = false;
				_players.add(s);
			}
			add(_players);
			
			FlxG.follow(_center, 1);
			FlxG.followAdjust(.1, .1);
			FlxG.followBounds(-2000, -2000, 2000,2000);
		}

		override public function update():void
		{
			
			//FlxU.overlap(_players, _floor,canJump);
			FlxU.collide(_players, _tileMap);
			FlxU.collide(_players, _players);
			
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
			
			
			if (FlxG.keys.justPressed('A'))
			{
				makePlayer(_center.x,_center.y);
			}
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
			
			super.update();
		
		}
		
		private function makePlayer(x:Number,y:Number):void
		{
			var i:int;
			var s:Player;
			s = (_players.getFirstAvail() as Player);
			if (s != null)
			{
				s.create(x,y);
			}
		}

	}
}

