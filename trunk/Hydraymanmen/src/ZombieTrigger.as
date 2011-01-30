package  
{
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author Duncan
	 */
	public class ZombieTrigger extends FlxObject 
	{
		public var delay:Number;
		public var num:int;
		public var spawnX:Number;
		public var spawnY:Number;
		
		public function ZombieTrigger(x:Number, y:Number, spawnX:Number, spawnY:Number, num:int, delay:Number = 0.0) 
		{
			super(x * 32, y * 32, 32, 64);
			this.spawnX = 32 * spawnX;
			this.spawnY = 32 * spawnY;
			this.delay = delay;
			this.num = num;
		}
		
		
		
	}

}