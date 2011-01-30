package
{
import org.flixel.*;

public class Tree extends Flammable
{
	[Embed(source = "data/doom.png")] protected var Img:Class;
	
	public function Tree(X:int,Y:int,fireHairs:FlxGroup)
	{
		super(X, Y, fireHairs);
		loadGraphic(Img, true, true);
		
		addAnimation("idle", [0,1,2,3], Math.random()*5+5,true);
		play("idle");
	}
	
	override public function update():void
	{
		super.update();
	}
	
	public function create(x:Number,y:Number):void
	{
		deflame();
		reset(x, y);
	}	
}
}