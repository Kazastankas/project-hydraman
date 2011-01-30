package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	
	public class PlagueBot extends FlxSprite
	{
		[Embed(source = "grafixxx/plaguebot.png")] protected var myImage:Class;
		public var AImode:int;
		public var AItimer:Number;
		public var moving:uint;
		protected var runSpeed:Number = 50;
		public var diseases:FlxGroup;
		
		public function PlagueBot(X:Number, Y:Number, diseases:FlxGroup)
		{
			super(X, Y);
			loadGraphic(myImage,true,true);
			addAnimation("idle", [0], 5, true);
			addAnimation("go", [0,1,2,3], 10, true);
			play("idle");
			
			this.diseases = diseases;
			drag.x = runSpeed;
			drag.y = runSpeed;
			acceleration.y = 420;
			maxVelocity.x = runSpeed / 2;
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
					AItimer = 1 * (1 + 0.3*(Math.random()-0.5));
					if (moving == 1)
					{
						moving = 2;
					}
					else
					{
						moving = 1;
					}
					
					if (Math.random() < 0.6)
					{
						var s:Disease;
						s = (diseases.getFirstAvail() as Disease);
						if (s != null)
						{
							s.create(this.x, this.y-8);
						}
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