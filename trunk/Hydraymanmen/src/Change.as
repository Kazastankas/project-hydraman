package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author yueran
	 */
	public class Change
	{
		public var pos:FlxPoint;
		public var tile:int;
		public function Change(x:Number,y:Number,t:int) 
		{
			pos = new FlxPoint(x, y);
			tile = t;
		}
		
	}

}