package
{
import org.flixel.*;

public class Bubble extends FlxSprite
{
	[Embed(source = "data/fire.png")] protected var Img:Class;
	protected var animationTime:Number = .5;
	
	public function Bubble(X:int,Y:int)
	{
		super(X, Y);
		loadGraphic(Img, true, true);
		
		velocity.y = -20;
		maxVelocity.x = maxVelocity.y = 200;
		
		addAnimation("idle", [0,1,2], Math.random()*5+5,false);
		play("idle");
		
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
		
		if (animationTime < 0)
		{
			kill();
		}
	}
}
}