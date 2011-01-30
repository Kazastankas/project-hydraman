package
{
import org.flixel.*;

public class Zombie extends Flammable
{
	[Embed(source = "data/split4.mp3")] protected var SplitSnd:Class;
	[Embed(source = "data/hydra-all.png")] protected var Img:Class;
	public var AItimer:Number;
	public var AImode:int;
	public var moving:uint;
	protected var runSpeed:Number = 100;
	protected var splitTimer:Number = 0;
	protected var diseaseTimer:Number = 0;
	protected var onDisease:Boolean;
	protected var zombies:FlxGroup;
	protected var drunkBubbles:FlxGroup;
	public var floating:Boolean = false;
	protected var landVelocity:FlxPoint;
	protected var animationTime:Number = 0;
	protected var target:FlxObject;
	
	public var pushing:Boolean;
	
	public function Zombie(X:int,Y:int,zombies:FlxGroup,fireHairs:FlxGroup,drunkBubbles:FlxGroup,target:FlxObject)
	{
		super(X, Y, fireHairs);
		loadGraphic(Img, true, true);
		
		this.zombies = zombies;
		this.drunkBubbles = drunkBubbles;
		this.target = target;
		
		drag.x = runSpeed * 2;
		drag.y = runSpeed * 2;
		acceleration.y = 420;
		landVelocity = new FlxPoint(runSpeed,270+Math.random()*20);
		maxVelocity.x = landVelocity.x / 4;
		maxVelocity.y = landVelocity.y / 4;
		health = 200;
		setSplitTimer();
		offset.x = 8;
		offset.y = 6;
		width = 8;
		height = 18;
		AImode = 1;
		AItimer = 2;

		diseaseTimer = 0;
		onDisease = false;

		//animations
		addAnimation("idle", [4,5,6,7,8,9,10,11],Math.random()*5+5);
		addAnimation("run", [12,13,14,15], 12);
		addAnimation("jump", [16, 17], 8);
		addAnimation("fall", [18,19],8);
		addAnimation("split", [20, 21, 22, 23, 24, 25], 12, false);
		addAnimation("die", [26, 27, 28, 29], 8, false);
		addAnimation("grow", [0, 1, 2, 3],8,false);
		play("idle");
		
		plague();
	}
	
	protected function setSplitTimer():void
	{
		splitTimer = Math.random() * 6 + 4;
	}
	
	public function on_disease():Boolean
	{
		return onDisease;
	}
	
	public function plague():void
	{		
		onDisease = true;
		color = 0x557700;
	}
	
	public function create(x:Number,y:Number):void
	{
		deflame();
		velocity.x = velocity.y = 0;
		health = 200;
		setSplitTimer();
		diseaseTimer = 0;
		onDisease = false;
		color = 0xFFFFFF;
		AImode = 1;
		AItimer = 2;
		reset(x, y);
		play("grow");
		animationTime = .5;
		plague();
	}
	
	protected function makeZombie(x:Number,y:Number):void
	{			
		var s:Zombie;
		s = (zombies.getFirstAvail() as Zombie);
		if (s != null)
		{
			s.create(x, y);
		}
	}
	
	public function die():void
	{
		if (health > 0)
		{
			splitTimer = 5;
			animationTime = .5;
			play("die");
			health = 0;
		}
	}
	
	override public function update():void
	{		
		getScreenXY(_point);
		if ((_point.x + width < -(FlxG.width / 2)) || (_point.x > (FlxG.width * 1.5)) || (_point.y + height < -(FlxG.height / 2)) || (_point.y > (FlxG.height * 1.5)))
		{
			kill();
		}
		
		acceleration.x = 0;
		maxVelocity.x = runSpeed;
		
		// dealing with death animation
		if (animationTime < .05 && health <= 0)
		{
			deflame();
			kill();
		}
		
		// all other special animations
		if (animationTime > 0)
		{
			animationTime -= FlxG.elapsed;
		}
		AItimer -= FlxG.elapsed;
		
		if (AItimer < 0)
		{
			AItimer = 2;
			if (moving == 1)
			{
				moving = 2;
			}
			else
			{
				moving = 1;
			}
		}
		if (target.y - y > -50 && target.y -y < 50)
		{
			if (target.x - x > 50 && target.x - x < 150 )
			{
				moving = 1;
			}
			else if (target.x - x < -50 && target.x - x > -150 )
			{
				moving = 2;
			}
		}
		
		// dealing with floating
		if (floating)
		{
			maxVelocity.x = 100;
			maxVelocity.y = 100;
			acceleration.y = 0;
			floating = false;
		}
		else
		{
			acceleration.y = 420;
			maxVelocity.x = landVelocity.x;
			maxVelocity.y = landVelocity.y;
		}
		
		// split processing - not when on fire or moving vertically
		if (!onFire && !velocity.y)
		{
			splitTimer -= FlxG.elapsed;
			if (splitTimer < 0)
			{	if (!pushing)
				{
					makeZombie(x - width / 2, y);
					makeZombie(x + width / 2, y);
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
		
		// disease processing
		if (onDisease)
		{
			diseaseTimer += FlxG.elapsed;
			
			if (Math.random() < 0.2)
			{
				var s:DrunkBubble;
				s = (drunkBubbles.getFirstAvail() as DrunkBubble);
				if (s != null)
				{
					s.create(x + Math.random() * width, y);
				}
			}
		
			if (animationTime <= 0)
			{
				// after 1 seconds, start spazzing
				if (diseaseTimer > 1.0)
				{
					if (moving == 2)
					{
						facing = LEFT;
						acceleration.x -= drag.x;
					}
					if (moving == 1)
					{
						facing = RIGHT;
						acceleration.x += drag.x;
					}
				}
				
				// after 2 seconds, start jumping
				if (diseaseTimer > 2.0 && !velocity.y && Math.random() <= 0.001)
				{
					velocity.y = -maxVelocity.y * (1.0 + (Math.random() - 0.5) * 0.2);
				}
			}
		}
		
		// no movement when performing special animation (death, YES splitting)
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
}
}