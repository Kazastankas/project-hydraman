package levels 
{
	import org.flixel.FlxG;
	import PlayState;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Duncan
	 */
	public class LevelDino extends PlayState 
	{
		[Embed(source = 'map3-final.txt', mimeType = "application/octet-stream")] private var map:Class;
		[Embed(source = "../data/thingOnIce.mp3")] protected var Music:Class;
		[Embed(source = "../grafixxx/glacial-bg.png")] protected var bgImg:Class;
		private var part:int = 1;
		
		override public function LevelDino(start:FlxPoint=null):void
		{
			super(start);
		}
		
		override public function create():void
		{
			trace("Creating dino level");
			FlxG.playMusic(Music);
			
			var i:int;
			if (_playerStart.x == 0)
			{
				_playerStart = new FlxPoint(8 * 32, 47 * 32);
			}
			_goalPos = new FlxPoint(1479, 759);
			
			super.create();
			activatePlayers(Math.max(1, PlayState.numInGoal));
			addHuman(690, 1339, 2);
			addHuman(1300, 1380, 1);
			addHut(250, 1150);
			addHuman(330, 1150, 1);
			addHuman(300, 1150, 3);
			addHuman(250, 1150, 2);
			addHuman(115, 1150, 2);
			addWater(25, 45, 4, 3);
			addWater(30, 39, 3, 9);
			addWater(34, 45, 7, 3);
			addWater(17, 26, 5, 1);
			addWater(43, 43, 0, 0);
			addWater(14, 18, 0, 0);
			addWater(19, 19, 1, 0);
			addWater(28, 20, 1, 0);
			addWater(42, 23, 0, 0);
			addWater(21, 39, 0, 0);
			addWater(5,33, 1, 0);
			addHuman(300, 780, 1);
			addHuman(500, 780, 1);
			addHuman(260, 780, 2);
			addHuman(200, 780, 2);
			addHut(370, 800);
			//addHut(450, 800);
			addMelter(24, 37);
			addMelter(25, 37);
			addMelter(24, 38);
			addMelter(25, 38);
			addMelter(42, 40);
			addMelter(42, 41);
			addMelter(42, 42);
			addMelter(17, 26);
			addMelter(18, 26);
			addMelter(19, 26);
			addMelter(20, 26);
			addMelter(21, 26);
			addMelter(22, 26);
			addMelter(38, 17);
			addMelter(38, 18);
			addMelter(38, 19);
			addMelter(38, 20);
			addMelter(38, 21);
			addMelter(38, 22);
			addMelter(39, 17);
			addMelter(39, 18);
			addMelter(39, 19);
			addMelter(39, 20);
			addMelter(39, 21);
			addMelter(39, 22);
			addMelter(16, 22);
			addMelter(16, 23);
			addMelter(16, 24);
			addMelter(16, 25);
			addTree(504, 539);
			addTree(710, 572);
			addTree(981, 603);
			addHuman(79, 515, 1);
			addHuman(143, 526, 1);
			
			addCheckPoint(1388, 1388);
			addCheckPoint(247, 1043);
			addCheckPoint(1178, 719);
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
		}
		
		override protected function resetLevel():void
		{
			super.resetLevel();
			trace("Reset LevelDino");
			FlxG.state = new LevelDino(_playerStart);
		}
		
		override protected function nextLevel():void
		{
			if (!_changingLevel)
			{
				trace("Changing to levelFuture");
				_changingLevel = true;
				FlxG.fade.start(0xff000000, 0.4, function():void { _changingLevel = false; FlxG.state = new LevelFuture(); } );
			}
		}
	}

}