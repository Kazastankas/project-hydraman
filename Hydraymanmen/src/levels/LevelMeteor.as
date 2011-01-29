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
		
		override public function create():void
		{
			trace("Creating meteor level");
			
			var i:int;
			_playerStart = new FlxPoint(100, 100);
			_goalPos = new FlxPoint(200, 100);
			super.create();
			
			/*addWater(5, 6, 4, 3);
			
			*/
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