package
{
	import flash.utils.SetIntervalTimer;
	import org.flixel.*;
	
	public class Burrower extends FlxSprite
	{
		[Embed(source = "grafixxx/burrow.png")] protected var mainImage:Class;
		public var angerTime:Number;
		public var angry:Boolean;
		public var angering:Boolean;
		public var animationTime:Number;
		
		public function Burrower(X:Number, Y:Number)
		{
			super(X, Y);
			loadGraphic(mainImage, true, true);
			addAnimation("idle", [0], 5, true);
			addAnimation("noms", [0,1,2,3,4,5,6], 10, true);
			addAnimation("nomming", [5,6], 10, true);
			
			angry = false;
			angering = false;
			angerTime = 0;
			animationTime = 0;
			
			play("idle");
		}
		
		override public function update():void
		{
			if (!angry && angering)
			{
				angerTime += FlxG.elapsed;
				if (angerTime > 1.0)
				{
					angry = true;
					play("noms");
				}
			} else if (!angry && !angering)
			{
				play("idle");
			}
			
			if (angry)
			{
				animationTime += FlxG.elapsed;
				if (animationTime >= 0.7)
				{
					play("nomming");
				}
				else
				{
					play("noms");
				}
			}
			
			super.update();
		}
		
		public function processSeen(o:Player):void
		{
			if (!angry && !angering)
			{
				angering = true;
			}
			else if (angry)
			{
				o.die();
			}
		}
		
		public function create(x:Number,y:Number):void
		{
			velocity.x = velocity.y = 0;
			angry = false;
			angering = false;
			angerTime = 0;
			animationTime = 0;
			
			play("idle");
			reset(x, y);
		}
	}
}