package
{
import org.flixel.*;

public class Flammable extends FlxSprite
{
	[Embed(source = "data/fire.png")] protected var FireImg:Class;
	protected var fireTimer:Number = 0;
	public var onFire:Boolean;
	protected var fireSprites:FlxGroup;
	protected var fireSprite:FlxSprite;
	
	public function Flammable(X:int,Y:int,fireSprites:FlxGroup)
	{
		super(X, Y);
		
		this.fireSprites = fireSprites;
		fireTimer = 0;
		onFire = false;
	}
	
	public function fire_time():Number
	{
		
		return fireTimer;
	}
	
	public function ignite():void
	{
		if (!onFire)
		{
			fireSprite = new Fire(x - width / 2, y - height / 2, 5, false);
			fireSprites.add(fireSprite);
		}
		onFire = true;
		color = 0xef3528;
	}
	
	public function deflame():void
	{
		fireTimer = 0;
		onFire = false;
		color = 0xFFFFFF;
		if (fireSprite)
		{
			fireSprite.kill();
		}
	}
	
	override public function update():void
	{		
		// fire processing
		if (onFire)
		{
			fireTimer += FlxG.elapsed;
			fireSprite.x = x - width / 2;
			fireSprite.y = y - height / 2;
			if (fireTimer > 5)
			{
				deflame();
				kill();
			}
		}

		super.update();
	}
}
}