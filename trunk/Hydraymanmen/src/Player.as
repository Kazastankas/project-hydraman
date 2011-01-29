package
{
import org.flixel.*;

public class Player extends FlxSprite
{
	[Embed(source = "data/split4.mp3")] protected var SplitSnd:Class;
	[Embed(source = "data/hydra-all.png")] protected var Img:Class;
	[Embed(source = "data/fire.png")] protected var FireImg:Class;
	protected var runSpeed:Number = 100;
	protected var splitTimer:Number = 0;
	protected var fireTimer:Number = 0;
	protected var onFire:Boolean;
	protected var players:FlxGroup;
	protected var fire_hairs:FlxGroup;
	protected var fireHair:FlxSprite;
	protected var aliveCount:int = 0;
	public var floating:Boolean = false;
	protected var landVelocity:FlxPoint;
	protected var animationTime:Number = 0;
	
	public var pushing:Boolean;

	public function Player(X:int,Y:int,players:FlxGroup,fire_hairs:FlxGroup)
	{
		super(X, Y);
		loadGraphic(Img, true, true);
		
		this.players = players;
		this.fire_hairs = fire_hairs;

		drag.x = runSpeed * 8;
		drag.y = runSpeed * 8;
		acceleration.y = 420;
		landVelocity = new FlxPoint(runSpeed,270+Math.random()*20);
		maxVelocity.x = landVelocity.x;
		maxVelocity.y = landVelocity.y;
		health = 200;
		splitTimer = Math.random() * 3 + 2;
		offset.x = 8;
		offset.y = 6;
		width = 8;
		height = 18;
		
		fireTimer = 0;
		onFire = false;

		//animations
		addAnimation("idle", [4,5,6,7,8,9,10,11],Math.random()*5+5);
		addAnimation("run", [12,13,14,15], 12);
		addAnimation("jump", [16, 17], 8);
		addAnimation("fall", [18,19],8);
		addAnimation("split", [20,21,22,23,24,25],12,false);
		addAnimation("grow", [0, 1, 2, 3],8,false);
		play("idle");
		
	}
	
	public function fire_time():Number
	{
		
		return fireTimer;
	}
	
	public function ignite():void
	{
		if (!onFire)
		{
			fireHair = new Fire(x, y - height / 2, 5, false);
			fire_hairs.add(fireHair);
		}
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
		play("grow");
		animationTime = .5;
	}
	
	protected function makePlayer(x:Number,y:Number):void
	{			
		var s:Player;
		s = (players.getFirstAvail() as Player);
		if (s != null)
		{
			s.create(x,y);
		}
	}
	
	override public function update():void
	{
		if (!onScreen())
			kill();
			
		if (animationTime > 0)
		{
			animationTime -= FlxG.elapsed;
		}
		if (floating)
		{
			if (onFire)
			{
				fireTimer = 0;
				onFire = false;
				color = 0xFFFFFF;
				fireHair.kill();
			}
			maxVelocity.x = 100;
			maxVelocity.y = 100;
			acceleration.y = 0;
			if (FlxG.keys.X)
			{
				acceleration.y -= drag.x;
			}
			else
			{
				acceleration.y += drag.x;
			}
			floating = false;
		}
		else
		{
			acceleration.y = 420;
			maxVelocity.x = landVelocity.x;
			maxVelocity.y = landVelocity.y;
			
			if (FlxG.keys.justPressed("X") && !velocity.y)
			{
				velocity.y = -maxVelocity.y;
			}
		}
		aliveCount++;
		splitTimer -= FlxG.elapsed;
		if (!onFire)
		{
			if (splitTimer < 0)
			{	if (!pushing)
				{
					makePlayer(x - width / 2, y);
					makePlayer(x + width / 2, y);
					kill();
					FlxG.play(SplitSnd);
				}
			}
			else if (splitTimer < .5)
			{
				play("split");
				animationTime = 1;
			}
		}
		else if (onFire)
		{
			fireTimer += FlxG.elapsed;
			fireHair.x = x;
			fireHair.y = y - height / 2;
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
		
		if (animationTime <= 0)
		{
			if (velocity.y > 0)
			{
				play("fall");
			}
			else if (velocity.y < 0)
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