package levels 
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Duncan
	 */
	public class LevelMeteor extends PlayState 
	{
		[Embed(source = 'map1-final.txt', mimeType = "application/octet-stream")] private var map:Class;
		[Embed(source = "../data/cambrian-bg.png")] private var bgImg:Class;
		[Embed(source = "../data/rock.png")] private var rockImg:Class;
		[Embed(source = "../data/bigrock.png")] private var bigRockImg:Class;
		[Embed(source = "../data/tribalthing.mp3")] protected var Music:Class;
		protected var part:int = 0;
		protected var spawnTarget:FlxObject;
		protected var bolt:Lightning;
		protected var enemySpawnTarget:FlxObject;
		protected var enemyLightningCount:int = -1;
		protected var spawnedFirstEnemy:Boolean = false;
		
		override public function LevelMeteor(start:FlxPoint=null):void
		{
			super(start);
		}
		
		override public function create():void
		{
			trace("Creating meteor level");
			FlxG.playMusic(Music);
			
			var i:int;
			if (_playerStart.x == 0)
			{
				_playerStart = new FlxPoint(100, 1539);
			}
			_goalPos = new FlxPoint(1010, 663);
			//_goalPos = new FlxPoint(200, 1530);
			spawnTarget = new FlxObject(_playerStart.x, _playerStart.y);
			enemySpawnTarget = new FlxObject(300, 1539);
			
			super.create();
			
			addEnemy(1272, 1412);
			addEnemy(613, 1263);
			addEnemy(1393, 1031);
			addEnemy(1121, 1223);
			addEnemy(999, 1102);
			addTree(120, 1532);
			addTree(220, 1532);
			
			addCheckPoint(396, 1489);
			addCheckPoint(1393, 1294);
			addCheckPoint(1088, 1237);
			addCheckPoint(415, 1167);
			addCheckPoint(1245, 1069);
			addCheckPoint(630,689);
			
			if (_playerStart.x != 100)
			{
				activatePlayers(PlayState.numHydra);
				_updateCount = 100;
			}
			else
			{
				_resetFlag = false;
			}
		}
		
		override protected function addBackSprites():void
		{
			var bg:FlxSprite = new FlxSprite(0, 0, bgImg);
			bg.scrollFactor.x = bg.scrollFactor.y = 0;
			bg.fixed = true;
			add(bg);
			
			var spawnRock:FlxSprite = new FlxSprite(_playerStart.x - 18, _playerStart.y + 8);
			spawnRock.loadGraphic(rockImg , false, false, 36, 22);
			add(spawnRock);
			
			var spawnBigRock:FlxSprite = new FlxSprite(enemySpawnTarget.x - 20, enemySpawnTarget.y + 8);
			spawnBigRock.loadGraphic(bigRockImg , false, false, 68, 37);
			add(spawnBigRock);
			
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
			
			// lightning for either you or enemy
			if (_updateCount >= 30 && _updateCount < 60)
			{
				_resetFlag = false;
				bolt = add(new Lightning()) as Lightning;
				var boltPoint:FlxPoint = spawnTarget.getScreenXY();
				bolt.SetTarget(new FlxPoint(boltPoint.x, boltPoint.y - 400));
				bolt.SetOrigin(boltPoint);
				bolt.strike(boltPoint.x, boltPoint.y - 400);
			}
			if (_updateCount == 60)
			{
				var firstHydra:Player = _players.getFirstAvail() as Player;
				if (firstHydra)
				{
					firstHydra.create(_playerStart.x, _playerStart.y);
					_resetFlag = true;
				}
			}
			
			// initiate lightning enemy spawn
			if ((_camMan.x > 150) && (part == 0) && (enemyLightningCount == -1) && !spawnedFirstEnemy)
			{
				enemyLightningCount = 30;
			}
			if (enemyLightningCount > 0)
			{
				bolt = add(new Lightning()) as Lightning;
				var enemyBoltPoint:FlxPoint = enemySpawnTarget.getScreenXY();
				bolt.SetGlowColor(0xFF3333);
				bolt.SetTarget(new FlxPoint(enemyBoltPoint.x, enemyBoltPoint.y - 400));
				bolt.SetOrigin(enemyBoltPoint);
				bolt.strike(enemyBoltPoint.x, enemyBoltPoint.y - 400);
				enemyLightningCount--;
			}
			if (enemyLightningCount == 0)
			{
				super._enemies.getFirstAvail().reset(enemySpawnTarget.x, enemySpawnTarget.y);
				enemyLightningCount = -1;
				spawnedFirstEnemy = true;
			}
			
			if (((_camMan.x > 850 && _camMan.x <930) && (_camMan.y > 860 && _camMan.y < 1100)) && (part == 0))
			{
				addTornado(850, 900, 1);
				part = 1;
			}
			if (((_camMan.x > 1000 && _camMan.x < 1200) && (_camMan.y > 750 && _camMan.y < 900)) && (part == 1))
			{
				addQuake(1255, 906);
				addQuake(1226, 906);
				addQuake(1189, 906);
				part = 2;
			}
			if (((_camMan.x > 900 && _camMan.x < 1100) && (_camMan.y > 730 && _camMan.y < 900)) && (part == 2))
			{
				addQuake(1093,879);
				addQuake(1069, 875);
				addQuake(1031, 866);
				part = 3;
			}
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
			FlxG.state = new LevelMeteor(_playerStart);
		}
		
		override protected function nextLevel():void
		{
			if (!_changingLevel)
			{
				trace("Changing to levelIce");
				_camMan.fix = true;
				_changingLevel = true;
				FlxG.fade.start(0xff000000, 0.4, function():void { _changingLevel = false; FlxG.state = new LevelIce(); } );
			}
		}
	}

}