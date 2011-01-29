package
{
import org.flixel.*;

public class Tree extends FlxSprite
{
	[Embed(source = "data/doom.png")] protected var Img:Class;
	protected var animationTime:Number = .5;
	public var onFire:Boolean = false;
	private var fireHairs:FlxGroup;
	private var fireHair:Fire;
	
	public function Tree(X:int,Y:int,fireHairs:FlxGroup)
	{
		super(X, Y);
		this.fireHairs = fireHairs;
		loadGraphic(Img, true, true);
		
		addAnimation("idle", [0,1,2,3], Math.random()*5+5,true);
		play("idle");
	}
	
	public function ignite():void
	{
		if (!onFire)
		{
			fireHair = new Fire(x + width / 2, y + height / 2, -1, false);
			fireHairs.add(fireHair);
		}
		onFire = true;
		color = 0xef3528;
	}
	
	override public function update():void
	{
		// fire processing
		if (onFire)
		{
			fireHair.x = x + width / 2-fireHair.width/2;
			fireHair.y = y + height / 2-fireHair.height/2;
		}
	}
	
	public function create(x:Number,y:Number):void
	{
		onFire = false;
		color = 0xFFFFFF;
		reset(x, y);
	}
	
}
}