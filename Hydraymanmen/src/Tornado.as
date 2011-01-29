package
{
import org.flixel.*;

public class Tornado extends FlxSprite
{
	[Embed(source = "data/tornado.png")] protected var Img:Class;
	[Embed(source = "data/tornado.mp3")] protected var Snd:Class;
	private var _timer:Number;

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
		_timer -= FlxG.elapsed;
		if (_timer < 0)
		{
			kill();
		}
		super.update();
	}
	
	public function create(x:Number,y:Number,xdir:Number):void
	{
		FlxG.play(Snd);
		_timer = 10;
		velocity.x = velocity.y = 0;
		velocity.x = xdir;
		reset(x, y);
	}
}
}