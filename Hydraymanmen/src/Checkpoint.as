package
{
import org.flixel.*;

public class Checkpoint extends FlxSprite
{
	[Embed(source = "data/doom.png")] protected var Img:Class;
	protected var animationTime:Number = -1;
	public var acting:Boolean = false;
	
	public function Checkpoint(X:int,Y:int)
	{
		super(X, Y);
		loadGraphic(Img, true, true);
		
		maxVelocity.x = maxVelocity.y = 200;
		
		addAnimation("start", [0], 5);
		addAnimation("change", [0], 5,false);
		addAnimation("end", [0], 5);
		play("start");
		
	}
	
	public function create(x:Number,y:Number):void
	{
		animationTime = -1;
		reset(x, y);
	}
	
	override public function update():void
	{
		super.update();
		
		if (animationTime > 0)
		{
			animationTime -= FlxG.elapsed;
		}
		
		if (!acting)
		{
			if (animationTime < 0&&animationTime > -1)
			{
				play("end");
				animationTime = -1;
			}
		}
	}
	
	public function activate():void
	{
		animationTime = .5;
		play("change");
		acting = true;
	}
}
}