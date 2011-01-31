package
{
import org.flixel.*;

public class Checkpoint extends FlxSprite
{
	[Embed(source = "data/checkpoint.png")] protected var Img:Class;
	protected var animationTime:Number = .5;
	
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
		animationTime = .5;
		reset(x, y);
	}
	
	override public function update():void
	{
		super.update();
		
		animationTime -= FlxG.elapsed;
		
		if (animationTime < 0&& animationTime > -1)
		{
			play("end");
		}
	}
}
}