package
{
import org.flixel.*;

public class DeathZone extends FlxSprite
{
	[Embed(source = "data/doom.png")] private var Img:Class;
	
	public function DeathZone(X:int,Y:int)
	{
		super(X, Y);
		loadGraphic(Img, true, true);
	}
	
	public function splatty_death(o:FlxObject):void
	{
		if (o is Player) {
			o.kill();
		}
	}

	override public function hitLeft(o:FlxObject, v:Number):void
	{
		splatty_death(o);
	}

	override public function hitRight(o:FlxObject, v:Number):void
	{
		splatty_death(o);
	}

	override public function hitBottom(o:FlxObject, v:Number):void
	{
		splatty_death(o);
	}

	override public function hitTop(o:FlxObject, v:Number):void
	{
		splatty_death(o);
	}
	
	override public function update():void
	{
		super.update();
	}
	
	public function create(x:Number,y:Number):void
	{
		velocity.x = velocity.y = 0;
		reset(x, y);
	}
}
}