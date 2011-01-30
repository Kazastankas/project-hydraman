package
{
import org.flixel.*;

public class Disease extends FlxSprite
{
	[Embed(source = "data/diseasecloud.png")] protected var Img:Class;
	public var maxLife:Number;
	public var life:Number;
	public var initAlpha:Number;
	
	public function Disease(X:int,Y:int, maxLife:Number = 3)
	{
		super(X, Y);
		loadGraphic(Img, true, true, 25, 25);
				
		//addAnimation("idle", [0], 5);
		//play("idle");
		
		this.maxLife = maxLife;
		this.life = maxLife;
		this.initAlpha = 0.8;
	}
	
	public function create(x:Number,y:Number):void
	{
		velocity.x = velocity.y = 0;
		reset(x, y);
		
		var theta:Number = 2 * Math.PI * Math.random();
		trace("Angle: " + theta);
		var velmag:Number = 8.0 + (Math.random() - 0.5);
		this.velocity.x = velmag * Math.cos(theta);
		this.velocity.y = velmag * Math.sin(theta);
		trace("Vel: " + velocity.x + ", " + velocity.y);
	}
	
	override public function update():void
	{
		super.update();
		
		life -= FlxG.elapsed;
		
		if (life < 0)
			this.kill();
		
		this.alpha = initAlpha * (life / maxLife);
		
		var seed:Number = Math.random();
		if (seed < 0.5)
		{
			this.velocity.x += 0.3 * (seed - 0.5);
			this.velocity.y += 0.3 * (seed - 0.5);
		}
	}
	
	override public function reset(X:Number, Y:Number):void
	{
		super.reset(X, Y);
		this.alpha = initAlpha;
		this.life = maxLife;
	}
}
}