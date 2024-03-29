package
{
import org.flixel.*;

public class Meteor extends FlxSprite
{
	[Embed(source = "data/Explosion.mp3")] protected var ExpSnd:Class;
	[Embed(source = "data/hydra-meteor.png")] protected var Img:Class;
	protected var explodes:FlxGroup;
	protected var meteorFires:FlxGroup;
	
	public function Meteor(X:int,Y:int,explodes:FlxGroup, meteorFires:FlxGroup)
	{
		super(X, Y);
		loadGraphic(Img, true, true);

		maxVelocity.x = maxVelocity.y = 200;
		acceleration.y = 420;
		velocity.y = 20;
		this.explodes = explodes;
		this.meteorFires = meteorFires;
		
		//animations
		addAnimation("idle", [0],5);
		play("idle");
	}
	
	override public function update():void
	{
		super.update();
		if (velocity.y < 20)
		{
			FlxG.play(ExpSnd);
			kill();
			for (var i:int = 0; i < 10; i++)
			{
				makeExplode(x+Math.random()*50-25, y+Math.random()*50-25);
				makeFire(x+Math.random()*50-25, y+Math.random()*50-25);
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
	
	protected function makeExplode(x:Number,y:Number):void
	{
		var s:Explode;
		s = (explodes.getFirstAvail() as Explode);
		if (s != null)
		{
			s.create(x, y,4);
		}
	}
	
	protected function makeFire(x:Number,y:Number):void
	{
		var s:Fire;
		s = (meteorFires.getFirstAvail() as Fire);
		if (s != null)
		{
			s.create(x, y, 2);
			s.velocity.y = -200;
			s.velocity.x = Math.random() * 120 - 60;
		}
	}
}
}