package
{
	import levels.*;
	import org.flixel.*;

	public class EndState extends FlxState
	{
		[Embed(source = "data/ending.png")] protected var Img1:Class;
		[Embed(source = "data/thing2_adapted.mp3")] protected var Music:Class;
		
		private var page:FlxSprite = new FlxSprite(0, 0, Img1);
		private var time:Number = 0;
		private var part:int = 0;
		
		override public function create():void
		{
			FlxG.playMusic(Music);
			super.create();
			add(page);
			FlxG.flash.start(0xff000000, 1);
		}
		
		override public function update():void
		{
			time += FlxG.elapsed;
			/*
			if (time > 3 && part == 0)
			{
				FlxG.flash.start(0xff000000, 1);
				page.loadGraphic(Img2);
				part = 1;
			}
			*/
			if (FlxG.keys.justPressed('X'))
			{
				FlxG.fade.start(0x000000, 1,changeState);
			}
			super.update();
		}
		
		public function changeState():void
		{
			FlxG.state = new MenuState();
		}
	}
}