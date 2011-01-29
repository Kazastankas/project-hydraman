package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	import Math;
	
	/**
	 * ...
	 * @author Duncan
	 */
	public class CameraMan extends FlxObject 
	{
		protected var group:FlxGroup;
		public var killDist:Number = 1.5;
		public var averagePos:FlxPoint;
		public var offset:FlxPoint;
		public var maxOffsetX:Number = 0.5;
		public var maxOffsetY:Number = 0.5;
		
		public function CameraMan(group:FlxGroup) 
		{
			this.group = group;
			offset = new FlxPoint(0, 0);
		}
		
		override public function update():void
		{
			calcCenter();
			killOutliers();
			handleInput();
		}
		
		protected function calcCenter():void
		{
			var avgPos:FlxPoint = new FlxPoint(0, 0);
			var numExists:int = 0;
			for each(var member:FlxObject in group.members)
			{
				var player:Player = member as Player;
				if (player && !player.dead && player.active && player.exists)
				{
					avgPos.x += member.x;
					avgPos.y += member.y;
					numExists++;
				}
			}
			avgPos.x /= numExists;
			avgPos.y /= numExists;
			this.averagePos = avgPos;
			this.x = avgPos.x + (offset.x * maxOffsetX * FlxG.width);
			this.y = avgPos.y + (offset.y * maxOffsetY * FlxG.height);
		}
		
		protected function killOutliers():void
		{
			for each(var member:FlxObject in group.members)
			{
				var player:Player = member as Player;
				if (player && !player.dead && player.active && player.exists)
				{
					var xdiff:Number = Math.abs(player.x - this.x);
					var ydiff:Number = Math.abs(player.y - this.y);
					if (xdiff > killDist * FlxG.width || ydiff > killDist * FlxG.height)
					{
						trace("Kill player");
						player.kill();
					}
				}
			}
		}
		
		protected function handleInput():void
		{
			if (FlxG.keys.W) {
				offset.y += 0.1 * (-maxOffsetY - offset.y);
			}
			else if (FlxG.keys.S) {
				offset.y += 0.1 * (maxOffsetY - offset.y);
			}
			else
				offset.y *= 0.9;
				
			if (FlxG.keys.A) {
				offset.x += 0.1 * (-maxOffsetX - offset.x);
			}
			else if (FlxG.keys.D) {
				offset.x += 0.1 * (maxOffsetX - offset.x);
			}
			else
				offset.x *= 0.9;
		}
	}

}