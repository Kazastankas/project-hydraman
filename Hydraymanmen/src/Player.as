package
{
import org.flixel.*;

public class Player extends FlxSprite
{
	[Embed(source = "data/hydra.png")] private var Img:Class;
	private var runSpeed:Number = 100;
	private var splitTimer:Number = 0;
	private var players:FlxGroup;
	
	public function Player(X:int,Y:int,players:FlxGroup)
	{
		super(X, Y);
		loadGraphic(Img, true, true);
		
		this.players = players;

		drag.x = runSpeed * 8;
		drag.y = runSpeed * 8;
		acceleration.y = 420;
		maxVelocity.x = runSpeed;
		maxVelocity.y = 200;
		health = 200;
		splitTimer = Math.random() * 3 + 2;
		offset.x = 5;
		offset.y = 5;
		width = 12;

		//animations
		addAnimation("idle", [0,1,2,3,4,5,6,7],5);
		addAnimation("run", [0,1], 12);
		addAnimation("jump", [0]);
		addAnimation("split", [0]);
		play("idle");
		
	}
	
	override public function update():void
	{
		splitTimer -= FlxG.elapsed;
		if (splitTimer < 0)
		{
			makePlayer(x - width / 2, y);
			makePlayer(x + width / 2, y);
			kill();
		}
		else if (splitTimer < .2)
		{
			play("split");
		}
		if (splitTimer )
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
	
	override public function preCollide(Object:FlxObject):void 
	{
		if (Object is Player)
			collideTop = false
		else
			collideTop = true;

	}
		
	public function create(x:Number,y:Number):void
	{
		velocity.x = velocity.y = 0;
		health = 200;
		splitTimer = Math.random() * 3+2;
		reset(x, y);
	}
	
	private function makePlayer(x:Number,y:Number):void
	{
		var i:int;
		var s:Player;
		s = (players.getFirstAvail() as Player);
		if (s != null)
		{
			s.create(x,y);
		}
		
	}
	

	
	
}
}