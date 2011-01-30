package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Kyle
	 */
	public class Shark extends FlxSprite
	{
		[Embed(source = "data/dino.png")] protected var myImage:Class;
		
		
		protected var moveTimer:Number;
		protected var moveIndex:uint;
		protected var move:uint;
		
		protected var runSpeed:Number = 50;
		
		private const moveArray:Array = [ 1, 1, 1, 0, 0, 0];
		
		public function Shark(X:Number, Y:Number) 
		{
			super(X, Y);
			loadGraphic(myImage, true, true);
			addAnimation("idle", [0], 5, true);
			
			play("idle");
			
			drag.x = runSpeed * 8;
			drag.y = runSpeed * 8;
			//acceleration.y = 300;
			maxVelocity.x = runSpeed;
			maxVelocity.y = 200;
			offset.y = 10;
			height -= 10;
			
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
			
			switch(move)
			{
				case 0:
					velocity.x = maxVelocity.x;
				break;
				
				case 1:
					velocity.x = -maxVelocity.x;
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