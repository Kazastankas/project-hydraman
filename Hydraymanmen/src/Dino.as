package
{
	import org.flixel.*;
	
	public class Dino extends FlxSprite
	{
		[Embed(source = "data/hydra-trilobite.png")] protected var myImage:Class;
		public var AItimer:Number;
		public var AImode:int;
		public var moving:uint;
		protected var runSpeed:Number = 50;
		
		public function Dino(X:Number, Y:Number)
		{
			super(X, Y);
			loadGraphic(myImage,true,true);
			addAnimation("idle", [0], 5, true);
			addAnimation("go", [0, 1, 2, 3], 10, true);
			addAnimation("jump", [0], 10, true);
			play("idle");
			drag.x = runSpeed * 8;
			drag.y = runSpeed * 8;
			acceleration.y = 420;
			maxVelocity.x = runSpeed;
			maxVelocity.y = 200;
			offset.y = 10;
			height -= 10;
			AImode = 1;
			AItimer = 1;
			health = 10;
		}
		
		override public function update():void
		{
			AItimer -= FlxG.elapsed;
			if (AImode == 1)
			{
				if (AItimer < 0)
				{
					AItimer = 1;
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
			
			if(velocity.y != 0)
			{
				play("go");
			}
			else if(velocity.x == 0)
			{
				play("idle");
			}
			else
			{
				play("go");
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
		
		public function create(x:Number,y:Number):void
		{
			velocity.x = velocity.y = 0;
			health = 20;
			reset(x, y);
		}
	}
}