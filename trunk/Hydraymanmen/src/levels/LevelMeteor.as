package levels 
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Duncan
	 */
	public class LevelMeteor extends PlayState 
	{
		[Embed(source = 'map1.txt', mimeType = "application/octet-stream")] private var Map:Class;
		[Embed(source = "../data/cambrian-bg.png")] private var bgImg:Class;
		protected var part:int = 0;
		
		override public function create():void
		{
			trace("Creating meteor level");
			
			var i:int;
			_playerStart = new FlxPoint(69, 1539);
			_goalPos = new FlxPoint(200, 100);
			super.create();
			addEnemy(1272, 1412);
			addEnemy(613, 1263);
			addEnemy(1393, 1031);
			addEnemy(1121, 1223);
			addEnemy(999, 1102);
			
			/*addWater(5, 6, 4, 3);
			
			*/
		}
		
		override public function update():void
		{
			super.update();
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
		}
		
		override protected function resetLevel():void
		{
			FlxG.state = new LevelMeteor();
		}
		
		override protected function nextLevel():void
		{
			if (!_changingLevel)
			{
				trace("Changing to levelIce");
				_changingLevel = true;
				FlxG.fade.start(0xff000000, 0.4, function():void { _changingLevel = false; FlxG.state = new LevelIce(); } );
			}
		}
	}

}