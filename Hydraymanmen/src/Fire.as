package
{
import org.flixel.*;

public class Fire extends FlxSprite
{
	[Embed(source = "data/fire.png")] protected var Img:Class;
	[Embed(source = "data/Fire.mp3")] protected var Snd:Class;
	protected var lifeTime:Number;
	protected var fires:FlxGroup;
	protected var falls:Boolean;
	
	public function Fire(X:int,Y:int,time:Number,falls:Boolean)
	{
		super(X, Y);
		loadGraphic(Img, true, true);
		
		maxVelocity.x = maxVelocity.y = 200;
		
		this.falls = falls;
		lifeTime = time;
		
		addAnimation("idle", [0,1,2], Math.random()*5+5);
		play("idle");
		
	}
	
	public function create(x:Number,y:Number,time:Number):void
	{
		velocity.x = velocity.y = 0;
		lifeTime = time;
		reset(x, y);
	}
	
	override public function update():void
	{
		if (PlayState._firePlaying<0)
		{
			PlayState._firePlaying = 18;
			PlayState._fireSound = FlxG.play(Snd);
		}
		super.update();
		lifeTime -= FlxG.elapsed;
		
		if (falls)
		{
			velocity.y += 294 * FlxG.elapsed;
		}
		
		if (lifeTime < 0 && lifeTime > -1)
		{
			kill();
		}
	}
	
	override public function hitBottom(Contact:FlxObject, Velocity:Number):void 
	{
		velocity.x = 0;
	}
}
}