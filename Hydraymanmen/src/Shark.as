package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Kyle
	 */
	public class Shark extends FlxSprite
	{
		[Embed(source = "data/shark.png")] protected var myImage:Class;
		
		
		protected var moveTimer:Number;
		protected var moveIndex:uint;
		protected var move:uint;
		protected var playerCenter:FlxObject;
		protected var lungeVector:FlxPoint;
		
		protected var runSpeed:Number = 100;
		
		private const moveArray:Array = [1, 1, 2, 3, 3, 0, 0, 2, 3, 3];
		
		public function Shark(X:Number, Y:Number, PlayerCenter:FlxObject) 
		{
			super(X, Y);
			loadGraphic(myImage, true, true);
			addAnimation("idle", [0,1,2,3], Math.random()*5+3, true);
			
			play("idle");
			
			//drag.x = runSpeed * 8;
			//drag.y = runSpeed * 8;
			acceleration.y = 200;
			maxVelocity.x = runSpeed;
			maxVelocity.y = runSpeed;
			offset.y = 10;
			height -= 10;
			playerCenter = PlayerCenter;
			lungeVector = new FlxPoint();
			
			moveTimer = 0;
			moveIndex = 0;

			
			
		}
		
		override public function update():void 
		{
			moveTimer -= FlxG.elapsed;
			
			if (moveTimer <= 0)
			{
				moveTimer = 1;
				move = moveArray[moveIndex++]
				if (moveIndex >= moveArray.length)
					moveIndex = 0;
			}
			
			if (velocity.x > 0)
			{
				facing = RIGHT;
			}
			else if (velocity.x < 0)
			{
				facing = LEFT;
			}
			
			switch(move)
			{
				case 0:
					velocity.x = maxVelocity.x;
					velocity.y = -20;
				break;
				
				case 1:
					velocity.x = -maxVelocity.x;
					velocity.y = -20;
				break;
				
				case 2:
					if (onScreen())
					{
						var factor:Number;
						lungeVector.x = playerCenter.x - x;
						lungeVector.y = playerCenter.y - y;
						factor = Math.max(lungeVector.x, lungeVector.y);
						if (factor == 0)
							factor = .001;
						lungeVector.x = lungeVector.x / factor;
						lungeVector.y = lungeVector.y / factor;
						lungeVector.x *= maxVelocity.x - (Math.random() * 20);
						lungeVector.y *= maxVelocity.y + (Math.random() * 40);
						moveIndex++;
					}

				break;
				
				case 3:
					velocity = lungeVector;				
				break;
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