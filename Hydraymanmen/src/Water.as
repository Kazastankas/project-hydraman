package
{
import org.flixel.*;

public class Water extends FlxSprite
{
	[Embed(source = "data/watertop.png")] protected var Img:Class;
	[Embed(source = "data/waterstill.png")] protected var Img2:Class;
	public var isTop:Boolean;
	
	public function Water(X:int,Y:int,top:Boolean=false)
	{
		super(X * 32, Y * 32);
		if (top)
		{
			this.isTop = true;
			loadGraphic(Img, true, true);
			addAnimation("idle", [0, 1, 2, 3, 4, 5, 6, 7], 5);
		}
		else
		{
			this.isTop = false;
			loadGraphic(Img2, true, true);
			addAnimation("idle", [0], 5);
		}
		alpha = 0.5;
		fixed = true;
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