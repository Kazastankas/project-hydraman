package
{
import org.flixel.*;

public class Hut extends FlxSprite
{
	[Embed(source = "data/bubble.png")] protected var Img:Class;
	protected var animationTime:Number = .5;
	
	public function Hut(X:int,Y:int)
	{
		super(X, Y);
		loadGraphic(Img, true, true);
		
		addAnimation("idle", [0,1,2,3], Math.random()*5+5,true);
		play("idle");
		
	}
	
	public function create(x:Number,y:Number):void
	{
		reset(x, y);
	}
	
}
}