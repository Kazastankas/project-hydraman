package
{
import org.flixel.*;

public class Player extends Flammable
{
	[Embed(source = "data/split4.mp3")] protected var SplitSnd:Class;
	[Embed(source = "data/hydra-all.png")] protected var Img:Class;
	protected var runSpeed:Number = 100;
	protected var splitTimer:Number = 0;
	protected var diseaseTimer:Number = 0;
	protected var onDisease:Boolean;
	protected var nearPlague:Boolean;
	protected var nearZombie:Boolean;
	protected var players:FlxGroup;
	protected var drunkBubbles:FlxGroup;
	protected var aliveCount:int = 0;
	public var floating:Boolean = false;
	protected var landVelocity:FlxPoint;
	protected var animationTime:Number = 0;
	
	public static const EPS:Number = 0.02;
	
	public var pushing:Boolean;
	
	public function Player(X:int,Y:int,players:FlxGroup,fireHairs:FlxGroup,drunkBubbles:FlxGroup)
	{
		super(X, Y, fireHairs);
		loadGraphic(Img, true, true);
		
		this.players = players;
		this.drunkBubbles = drunkBubbles;
		
		drag.x = runSpeed * 8;
		drag.y = runSpeed * 8;
		acceleration.y = 420;
		landVelocity = new FlxPoint(runSpeed,270+Math.random()*20);
		maxVelocity.x = landVelocity.x;
		maxVelocity.y = landVelocity.y;
		health = 200;
		setSplitTimer();
		offset.x = 8;
		offset.y = 6;
		width = 8;
		height = 18;

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
		
	}
	
	protected function setSplitTimer():void
	{
		splitTimer = Math.random() * 3 + 2;
		splitTimer *= 0.3 * Math.sqrt(PlayState.numHydra + 1);
		//trace("splitTimer: " + splitTimer);
	}
	
	public function on_disease():Boolean
	{
		return onDisease;
	}
	
	public function plague():void
	{
		if (!onDisease)
		{
		}
		
		onDisease = true;
		color = 0x557700;
	}
	
	public function near_plague():void
	{
		nearPlague = true;
	}
	
	public function near_zombie():void
	{
		nearZombie = true;
	}
	
	public function create(x:Number,y:Number):void
	{
		deflame();
		velocity.x = velocity.y = 0;
		health = 200;
		setSplitTimer();
		diseaseTimer = 0;
		onDisease = false;
		nearPlague = false;
		nearZombie = false;
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
			s.create(x, y);
			if (onDisease) s.plague();
			else if (nearZombie && Math.random() <= 0.6) s.plague();
			else if (nearPlague && Math.random() <= 0.2) s.plague();
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
		if (!onScreen())
		{
			deflame();
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
		
		// dealing with floating
		if (floating)
		{
			maxVelocity.x = 100;
			maxVelocity.y = 100;
			acceleration.y = 0;
			
			// misplaced jump code lolol
			if (animationTime <= 0 && !onDisease)
			{
				if (FlxG.keys.X)
				{
					acceleration.y -= drag.x;
				}
				else
				{
					acceleration.y += drag.x;
				}
			}
			floating = false;
		}
		else
		{
			acceleration.y = 420;
			maxVelocity.x = landVelocity.x;
			maxVelocity.y = landVelocity.y;
			
			// misplaced jump code lolol
			if (!onDisease)
			{
				if (FlxG.keys.justPressed("X") && !velocity.y)
				{
					velocity.y = -maxVelocity.y * (1.0 + (Math.random() - 0.5) * 0.2);
					if (splitTimer < .5)
					{
						splitTimer += .5;
					}
					play("jump");
				}
			}
		}
		
		// split processing - not when on fire or moving vertically
		if (!onFire && !velocity.y)
		{
			splitTimer -= FlxG.elapsed;
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
					var mod:Number = Math.random() * drag.x - (drag.x / 2);
					if (mod < 0)
					{
						facing = LEFT;
					}
					else
					{
						facing = RIGHT;
					}
					acceleration.x += mod;
				}
				
				// after 2 seconds, start jumping
				if (diseaseTimer > 2.0 && !velocity.y && Math.random() <= 0.01)
				{
					velocity.y = -maxVelocity.y * (1.0 + (Math.random() - 0.5) * 0.2);
				}
			}
		}
		
		// can't control sick dudes
		if (!onDisease)
		{	
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
		}
		
		// no movement when performing special animation (death, YES splitting)
		if (animationTime <= 0)
		{
			
			if (velocity.y > EPS)
			{
				play("fall");
			}
			else if (velocity.y < -EPS)
			{
				play("jump");
			}
			else if (velocity.x > -EPS && velocity.x < EPS)
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