package
{
import org.flixel.*;

public class Hut extends FlxSprite
{
	[Embed(source = "data/hut.png")] protected var Img:Class;
	protected var animationTime:Number = .5;
	protected var spawnCount:int = 0;
	protected var spawnRate:int;
	protected var cavemen:FlxGroup;
	
	public function Hut(X:int,Y:int, humanGroup:FlxGroup, spawnRate:int = 180)
	{
		super(X, Y);
		loadGraphic(Img, true, true, 41, 32);
		
		this.spawnRate = spawnRate;
		this.cavemen = humanGroup;
	}
	
	override public function update():void
	{
		super.update();
		
		if (spawnCount == spawnRate)
		{
			trace("Trying to create caveman...");
			
			var screenPos:FlxPoint = this.getScreenXY();
			trace("Screenpos: " + screenPos.x + ", " + screenPos.y);
			if (screenPos.x > 0 && screenPos.x < FlxG.width && screenPos.y > 0 && screenPos.y < FlxG.height)
			{
				var mode:int = 2;
				var seed:Number = Math.random();
				if (seed < 0.5)
					mode = 2;
				else if (seed < 0.8)
					mode = 3;
				else
					mode = 1;
				
				var s:Human;
				s = (cavemen.getFirstAvail() as Human);
				if (s != null)
				{
					s.create(x, y, mode);
					trace("Creating cave man of mode " + mode);
				}
			}
			spawnCount = 30*(Math.random() - 0.5);
		}
		
		
		spawnCount++;
	}
	
	public function create(x:Number,y:Number):void
	{
		reset(x, y);
	}
	
}
}