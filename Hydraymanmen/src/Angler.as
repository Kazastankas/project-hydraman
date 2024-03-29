package
{
	import org.flixel.*;
	
	public class Angler extends FlxSprite
	{
		[Embed(source = "data/fanbot2.png")] protected var myImage:Class;
		public var AItimer:Number;
		public var AImode:int;
		public var moving:uint;
		protected var runSpeed:Number = 0;
		public var players:FlxGroup;
		public var power:uint;
		protected var coeff:Number;
		
		public function Angler(X:Number, Y:Number, power:uint, players:FlxGroup, coeff:Number = 1.0)
		{
			super(X, Y);
			loadGraphic(myImage,true,true);
			addAnimation("idle", [0], 5, true);
			addAnimation("go", [0,1,2,3], 10, true);
			play("idle");
			
			this.players = players;
			this.power = power;
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
			this.coeff = coeff;
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
			
			for (var i:Number = 0; i < players.members.length; i++) {
				if (Player(players.members[i]).health <= 0) continue;
				var dist:Number = Math.sqrt(Math.pow(Player(players.members[i]).x - x, 2) +
											Math.pow(Player(players.members[i]).y - y, 2));
				Player(players.members[i]).velocity.x += coeff * (x - Player(players.members[i]).x) * power / Math.pow(dist, 3);
				Player(players.members[i]).velocity.y += coeff * (y - Player(players.members[i]).y) * power / Math.pow(dist, 3);
			}
			
			super.update();
		}
		
		public function create(x:Number,y:Number, coeff:Number = 1.0):void
		{
			velocity.x = velocity.y = 0;
			health = 20;
			reset(x, y);
			this.coeff = coeff;
		}
	}
}