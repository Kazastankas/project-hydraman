package
{
import org.flixel.*;

public class Player extends FlxSprite
{
	[Embed(source = "data/split4.mp3")] private var SplitSnd:Class;
	[Embed(source = "data/hydra.png")] private var Img:Class;
	private var runSpeed:Number = 100;
	private var splitTimer:Number = 0;
	private var fireTimer:Number = 0;
	private var onFire:Boolean;
	private var players:FlxGroup;
	protected var aliveCount:int = 0;
	
	public var pushing:Boolean;
	
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
		offset.x = 8;
		offset.y = 6;
		width = 8;
		height = 18;
		
		fireTimer = 0;
		onFire = false;

		//animations
		addAnimation("idle", [0,1,2,3,4,5,6,7],Math.random()*5);
		addAnimation("run", [0,1], 12);
		addAnimation("jump", [0]);
		addAnimation("split", [0]);
		play("idle");
		
	}
	
	public function fire_time():Number
	{
		
		return fireTimer;
	}
	
	public function ignite():void
	{
		onFire = true;
		color = 0xef3528;
	}
		
	public function create(x:Number,y:Number):void
	{
		velocity.x = velocity.y = 0;
		health = 200;
		splitTimer = Math.random() * 3 + 2;
		fireTimer = 0;
		onFire = false;
		color = 0xFFFFFF;
		reset(x, y);
	}
	
	private function makePlayer(x:Number,y:Number):void
	{
		if (pushing)
			return;
			
		var s:Player;
		s = (players.getFirstAvail() as Player);
		if (s != null)
		{
			s.create(x,y);
		}
	}
	
	override public function update():void
	{
		aliveCount++;
		splitTimer -= FlxG.elapsed;
		if (!onFire)
		{
			if (splitTimer < 0)
			{
				makePlayer(x - width / 2, y);
				makePlayer(x + width / 2, y);
				kill();
				FlxG.play(SplitSnd);
			}
			else if (splitTimer < .2)
			{
				play("split");
			}
		}
		else
		{
			fireTimer += FlxG.elapsed;
			if (fireTimer > 5)
			{
				kill();
			}
		}
		
		acceleration.x = 0;
		maxVelocity.x = runSpeed;
		
		if (FlxG.keys.LEFT)
		{
			facing = LEFT;
			acceleration.x -= drag.x;
		}
		else if (FlxG.keys.RIGHT)
		{
			facing = RIGHT;
			acceleration.x += drag.x;
		}
		
		if (FlxG.keys.justPressed("X") && !velocity.y)
		{
			velocity.y = -maxVelocity.y;
		}
		
		if (velocity.y != 0)
		{
			play("jump");
		}
		else if (velocity.x == 0)
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
	
	override public function hitRight(Contact:FlxObject, Velocity:Number):void 
	{
		if (Contact is Player)
		{
			if (pushing)
			{
				Contact.x = x;
				return;
			}
		}
		super.hitRight(Contact, Velocity);
	}
	
	override public function hitLeft(Contact:FlxObject, Velocity:Number):void 
	{
		if (Contact is Player)
		{
			if (pushing)
			{
				Contact.x = x;
				return;
			}
		}
		super.hitLeft(Contact, Velocity);
	}
	
	
}
}