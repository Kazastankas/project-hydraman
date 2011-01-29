package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Kyle
	 */
	public class Block extends FlxSprite
	{
		[Embed(source = "data/doom.png")] private var Img:Class;
		
		private var collideGroup:FlxGroup;
		private var maxPushers:uint;
		
		public function Block(X:int,Y:int, MaxPushers:uint) 
		{
			super(X, Y);
			loadGraphic(Img, true, true);
			color = 0x00ff0000;
			acceleration.y = 420;
			collideGroup = new FlxGroup();
			drag.x = 100;
			
			maxPushers = MaxPushers;
		}
		
		override public function update():void 
		{
			//FlxG.log(collideGroup.members.length);
			for (var i:uint = 0; i < collideGroup.members.length; i++)
			{
				if (collideGroup.members[i] != null)
				{
					if (!collide(collideGroup.members[i]))
					{
						//FlxG.log("REMOVED");
						Player(collideGroup.members[i]).pushing = false;
						Player(collideGroup.members[i]).velocity.x += (Math.random() * 40) - 20;
						collideGroup.remove(collideGroup.members[i], true);
					}
				}
			}
			
			super.update();
		}
		
		override public function hitLeft(Contact:FlxObject, Velocity:Number):void 
		{
			if (Contact is Player)
			{
				var c:Player = Player(Contact);
				if (collideGroup.members.length < maxPushers)
				{
					collideGroup.remove(c, true);
					collideGroup.add(c);
					velocity.x = 0;
					acceleration.y = 0;
					fixed = true;
					c.pushing = true;
					return;
				}
				else
				{
					fixed = false;
					acceleration.y = 420;
				}
				
			}

			super.hitLeft(Contact, Velocity);
		}
		
		override public function hitRight(Contact:FlxObject, Velocity:Number):void 
		{
			if (Contact is Player)
			{
				var c:Player = Player(Contact);
				if (collideGroup.members.length < maxPushers)
				{
					collideGroup.remove(c, true);
					collideGroup.add(c);
					velocity.x = 0;
					acceleration.y = 0;
					fixed = true;
					c.pushing = true;
					return;
				}
				else
				{
					fixed = false;
					acceleration.y = 420;
				}
				
			}
			
			super.hitRight(Contact, Velocity);
		}
		
		
		
	}
	
}