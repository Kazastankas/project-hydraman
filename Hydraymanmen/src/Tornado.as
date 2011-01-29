package
{
import org.flixel.*;

public class Tornado extends FlxSprite
{
	[Embed(source = "data/tornado.png")] private var Img:Class;

	public function Tornado(X:int,Y:int)
	{
		super(X, Y);
		loadGraphic(Img, true, true);

		maxVelocity.x = maxVelocity.y = 200;
		
		//animations
		addAnimation("idle", [0],5);
		play("idle");
	}
	
	override public function update():void
	{
		super.update();
	}
	
	public function create(x:Number,y:Number,xdir:Number):void
	{
		velocity.x = velocity.y = 0;
		velocity.x = xdir;
		reset(x, y);
	}
}
}