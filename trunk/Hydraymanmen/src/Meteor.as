package
{
import org.flixel.*;

public class Meteor extends FlxSprite
{
	[Embed(source = "data/meteor.png")] private var Img:Class;
	private var explodes:FlxGroup;
	
	public function Meteor(X:int,Y:int,explodes:FlxGroup)
	{
		super(X, Y);
		loadGraphic(Img, true, true);

		maxVelocity.x = maxVelocity.y = 200;
		acceleration.y = 420;
		velocity.y = 20;
		this.explodes = explodes;
		
		//animations
		addAnimation("idle", [0],5);
		play("idle");
	}
	
	override public function update():void
	{
		super.update();
		FlxG.log(velocity.y);
		if (velocity.y < 20)
		{
			kill();
			for (var i:int = 0; i < 10; i++ )
			{
				makeExplode(x+Math.random()*50-25, y+Math.random()*50-25);
			}
		}
	}
	
	public function create(x:Number,y:Number,xdir:Number):void
	{
		velocity.x = velocity.y = 0;
		velocity.y = 20;
		velocity.x = xdir;
		reset(x, y);
	}
	
	private function makeExplode(x:Number,y:Number):void
	{
		var s:Explode;
		s = (explodes.getFirstAvail() as Explode);
		if (s != null)
		{
			s.create(x, y,5);
		}
	}
}
}