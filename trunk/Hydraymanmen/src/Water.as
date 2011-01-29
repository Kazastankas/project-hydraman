package
{
import org.flixel.*;

public class Water extends FlxSprite
{
	[Embed(source = "data/doom.png")] protected var Img:Class;
	
	public function Water(X:int,Y:int)
	{
		super(X*32, Y*32);
		loadGraphic(Img, true, true);
		alpha = 0.3;
		fixed = true;
		addAnimation("idle", [0], 5);
		play("idle");
		
	}
	
	public function create(x:Number,y:Number,time:Number):void
	{
		reset(x, y);
	}
	
	override public function update():void
	{
		super.update();
	}
}
}