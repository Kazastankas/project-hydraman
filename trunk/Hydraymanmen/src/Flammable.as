package
{
import org.flixel.*;

public class Flammable extends FlxSprite
{
	protected var fireTimer:Number = 0;
	public var onFire:Boolean;
	protected var fireSprites:FlxGroup;
	protected var fireSprite:Vector.<FlxSprite>;
	protected var killable:Boolean = true;
	
	public function Flammable(X:int,Y:int,fireSprites:FlxGroup)
	{
		super(X, Y);
		
		this.fireSprites = fireSprites;
		fireSprite = new Vector.<FlxSprite>();
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
			fireSprite.push(new Fire(x + (width / 2) - 12, y + (height / 2) - 12, 5, false));
			fireSprites.add(fireSprite[0]);
			
			var center_x:Number = x + (width / 2) - 12;
			var center_y:Number = y + (height / 2) - 12;
			
			for (var i:Number = 0; i < width / 24; i++)
			{
				for (var j:Number = 0; j < height / 24; j++)
				{
					fireSprite.push(new Fire(center_x + (i - int(width / 48)) * 10, center_y + (j - int(height / 48)) * 10, 5, false));
					fireSprites.add(fireSprite[1 + (i * int(height / 24) + j)]);
				}
			}
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
			for (var i:Number = 0; i < fireSprite.length; i++)
			{
				fireSprite[i].kill();
			}
		}
	}
	
	override public function update():void
	{		
		// fire processing
		if (onFire)
		{
			fireTimer += FlxG.elapsed;
			var center_x:Number = x + (width / 2) - 12;
			var center_y:Number = y + (height / 2) - 12;
			fireSprite[0].x = center_x;
			fireSprite[0].y = center_y;
			
			for (var i:Number = 0; i < width / 24; i++)
			{
				for (var j:Number = 0; j < height / 24; j++)
				{
					fireSprite[1 + (i * int(height / 24) + j)].x = center_x + (i - int(width / 48)) * 10;
					fireSprite[1 + (i * int(height / 24) + j)].y = center_y + (j - int(height / 48)) * 10;
				}
			}
			
			if (fireTimer > 5)
			{
				deflame();
				if (killable)
				{
					kill();
				}
			}
		}

		super.update();
	}
}
}