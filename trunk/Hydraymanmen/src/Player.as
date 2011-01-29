package
{
import org.flixel.*;

public class Player extends FlxSprite
{
	[Embed(source = "data/hydra.png")] private var Img:Class;
	private var runSpeed:Number = 100;
	
	public function Player(X:int,Y:int)
	{
		super(X, Y);
		loadGraphic(Img);

		drag.x = runSpeed * 8;
		drag.y = runSpeed*8;
		acceleration.y = 420;
		maxVelocity.x = runSpeed;
		maxVelocity.y = 200;
		health = 200;

		//animations
		addAnimation("idle", [0,1,2,3,4,5,6,7],5);
		addAnimation("run", [0,1], 12);
		addAnimation("jump", [0]);

	}

	override public function update():void
	{
		acceleration.x = 0;
		maxVelocity.x = runSpeed;
		if(FlxG.keys.LEFT)
		{
			facing = LEFT;
			acceleration.x -= drag.x;
		}
		else if(FlxG.keys.RIGHT)
		{
			facing = RIGHT;
			acceleration.x += drag.x;
		}
		
		if(FlxG.keys.justPressed("X") && !velocity.y)
		{
			velocity.y = -maxVelocity.y;
		}

		if(velocity.y != 0)
		{
			play("jump");
		}
		else if(velocity.x == 0)
		{
			play("idle");
		}
		else
		{
			play("run");
		}

		super.update();

	}
	
	public function create(x:Number,y:Number):void
	{
		velocity.x = velocity.y = 0;
		reset(x, y);
	}
}
}