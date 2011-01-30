package
{
	import flash.utils.SetIntervalTimer;
	import org.flixel.*;
	
	public class Burrower extends FlxSprite
	{
		[Embed(source = "data/burrower_stalk.png")] protected var stalkImage:Class;
		[Embed(source = "data/burrower.png")] protected var mainImage:Class;
		public var angerTime:Number;
		public var angry:Boolean;
		public var angering:Boolean;
		
		public function Burrower(X:Number, Y:Number)
		{
			super(X, Y);
			loadGraphic(stalkImage, true, true, 4, 112);
			
			angry = false;
			angering = false;
			angerTime = 0;
		}
		
		override public function update():void
		{
			if (!angry && angering)
			{
				angerTime += FlxG.elapsed;
				if (angerTime > 1.0)
				{
					y += height;
					loadGraphic(mainImage, true, true);
					y -= height;
					angry = true;
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
			reset(x, y - height);
		}
	}
}