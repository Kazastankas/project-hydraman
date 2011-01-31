package
{
import org.flixel.*;

public class oldcave extends FlxSprite
{
	[Embed(source = "data/oldcaveback.png")] protected var Img:Class;
	protected var animationTime:Number = .5;
	
	public function oldcave(X:int,Y:int, humanGroup:FlxGroup, spawnRate:int = 180)
	{
		super(X, Y);
		loadGraphic(Img, true, true, 41, 32);
	}
	
	override public function update():void
	{
		super.update();
	}
	
	public function create(x:Number,y:Number):void
	{
		reset(x, y);
	}
	
}
}