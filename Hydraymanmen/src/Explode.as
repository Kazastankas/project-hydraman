package
{
import org.flixel.*;

public class Explode extends FlxSprite
{
	[Embed(source = "data/hydra-explosion.png")] protected var Img:Class;
	protected var timer:Number = 0;
	protected var likeliness:Number = 0;
	protected var explodes:FlxGroup;
	
	public function Explode(X:int,Y:int,likely:Number,explodes:FlxGroup)
	{
		super(X, Y);
		loadGraphic(Img, true, true,33,31);

		maxVelocity.x = maxVelocity.y = 200;
		likeliness = likely;
		timer = Math.random() * .20;
		this.explodes = explodes;
		
		//animations
		addAnimation("idle", [0,1,2,3,4,5],10);
		play("idle");
	}

	override public function update():void
	{
		timer -= FlxG.elapsed;
		if (timer < 0)
		{
			while (Math.random() * likeliness > .25)
			{
				makeExplode(x+Math.random()*50-25,y+Math.random()*50-25);
			}
			
			kill();
		}

		super.update();
	}
	
	public function create(x:Number,y:Number,likely:Number):void
	{
		likeliness = likely;
		velocity.x = velocity.y = 0;
		health = 200;
		timer = Math.random() * .20;
		reset(x, y);
	}
	
	protected function makeExplode(x:Number,y:Number):void
	{
		var s:Explode;
		s = (explodes.getFirstAvail() as Explode);
		if (s != null)
		{
			s.create(x, y,likeliness-1);
		}
	}
}
}