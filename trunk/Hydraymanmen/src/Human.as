package
{
	import org.flixel.*;
	
	public class Human extends FlxSprite
	{
		[Embed(source = "data/dino.png")] protected var myImage:Class;
		[Embed(source = "data/dino.png")] protected var myImage1:Class;
		[Embed(source = "data/dino.png")] protected var myImage2:Class;
		public var AItimer:Number;
		public var fireTimer:Number;
		public var AImode:int;
		public var moving:uint;
		protected var runSpeed:Number = 50;
		private var animationTime:Number;
		protected var fires:FlxGroup;
		
		public function Human(X:Number, Y:Number,fires:FlxGroup)
		{
			super(X, Y);
			loadGraphic(myImage,true,true);
			addAnimation("idle", [0], 5, true);
			addAnimation("go", [0, 1, 2, 3], 10, true);
			addAnimation("fire", [4], 20, false);
			addAnimation("jump", [4, 5, 6, 7], 20, false);
			play("idle");
			drag.x = runSpeed * 8;
			drag.y = runSpeed * 8;
			acceleration.y = 300;
			maxVelocity.x = runSpeed;
			maxVelocity.y = 200;
			offset.y = 10;
			height -= 10;
			AImode = 1;
			fireTimer = 2;
			AItimer = 2;
			health = 10;
			this.fires = fires;
		}
		
		override public function update():void
		{
			if (animationTime > 0)
			{
				animationTime -= FlxG.elapsed;
			}
			fireTimer -= FlxG.elapsed;
			AItimer -= FlxG.elapsed;
			if (AImode == 1)
			{
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
				if (fireTimer < 0)
				{
					fireTimer = Math.random() * 1+.5;
					play("fire");
					makeFire(x,y,velocity.x*3+Math.random()*20-10);
					animationTime = .5;
					velocity.y = -50;
				}
			}
			else if (AImode == 2)
			{
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
			}
			else if (AImode == 3)
			{
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
					if (velocity.y == 0)
					{
						velocity.y = - maxVelocity.y;
					}
				}
			}
			
			if (animationTime <= 0)
			{
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
					play("go");
				}
			}

			acceleration.x = 0;
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
			
			super.update();
		}
		
		public function create(x:Number,y:Number,mode:Number = 1):void
		{
			AImode = mode;
			if (AImode == 1)
			{
				loadGraphic(myImage,true,true);
			}
			else if (AImode == 2)
			{
				loadGraphic(myImage1,true,true);
			}
			else if (AImode == 3)
			{
				loadGraphic(myImage2,true,true);
			}
			velocity.x = velocity.y = 0;
			health = 20;
			reset(x, y);
		}
		
		protected function makeFire(x:Number,y:Number,dir:Number):void
		{
			var s:Fire;
			s = (fires.getFirstAvail() as Fire);
			if (s != null)
			{
				s.create(x, y, 2);
				s.velocity.y = -Math.random()*75-50;
				s.velocity.x = dir;
			}
		}
	}
}