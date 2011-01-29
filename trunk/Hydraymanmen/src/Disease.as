package
{
import org.flixel.*;

public class Disease extends FlxSprite
{
	[Embed(source = "data/disease.png")] protected var Img:Class;
	
	public function Disease(X:int,Y:int)
	{
		super(X, Y);
		loadGraphic(Img, true, true);
				
		addAnimation("idle", [0], 5);
		play("idle");
		
	}
	
	public function create(x:Number,y:Number):void
	{
		velocity.x = velocity.y = 0;
		reset(x, y);
	}
	
	override public function update():void
	{
		super.update();
	}
}
}