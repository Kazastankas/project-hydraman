package
{
import org.flixel.*;

public class Fire extends FlxSprite
{
	[Embed(source = "data/fire.png")] private var Img:Class;
	private var fires:FlxGroup;
	
	public function Fire(X:int,Y:int)
	{
		super(X, Y);
		loadGraphic(Img, true, true);
		
		addAnimation("idle", [0,1,2], 5);
		play("idle");
		
	}
	
	public function create(x:Number,y:Number):void
	{
		velocity.x = velocity.y = 0;
		reset(x, y);
	}
}
}