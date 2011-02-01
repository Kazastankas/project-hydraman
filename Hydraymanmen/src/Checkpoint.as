package
{
import org.flixel.*;

public class Checkpoint extends FlxSprite
{
	[Embed(source = "data/checkpoint.png")] protected var Img:Class;
	protected var animationTime:Number = -1;
	public var acting:Boolean = false;
	
	public function Checkpoint(X:int,Y:int)
	{
		super(int(Math.floor(X/32))*32+4, int(Math.floor(Y/32))*32+4);
		loadGraphic(Img, true, true);
		
		maxVelocity.x = maxVelocity.y = 200;
		
		addAnimation("start", [0], 5);
		addAnimation("change", [1,2,3,4,5], 5,false);
		addAnimation("end", [6,7,6,7,6,5,4,5], 5);
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
		
		if (animationTime <= 0&&animationTime > -1)
		{
			play("end");
			animationTime = -1;
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