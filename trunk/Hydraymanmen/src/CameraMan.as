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
		public var killDist:Number = 0.75;
		
		public function CameraMan(group:FlxGroup) 
		{
			this.group = group;
		}
		
		override public function update():void
		{
			calcCenter();
			killOutliers();
			
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
			this.x = avgPos.x;
			this.y = avgPos.y;
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
						player.kill();
				}
			}
		}
	}

}