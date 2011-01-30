package
{
	import levels.*;
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		[Embed(source = "data/page1.png")] protected var Img1:Class;
		[Embed(source = "data/page2.png")] protected var Img2:Class;
		[Embed(source = "data/page3.png")] protected var Img3:Class;
		[Embed(source = "data/page4.png")] protected var Img4:Class;
		[Embed(source = "data/thing2_adapted.mp3")] protected var Music:Class;
		
		[Embed(source = "grafixxx/hydraman.png")] protected var ImgHydraman:Class;
		[Embed(source = "grafixxx/hydramen.png")] protected var ImgHydramen:Class;
		[Embed(source = "grafixxx/hydramzn.png")] protected var ImgHydramzn:Class;
		[Embed(source = "grafixxx/p1.png")] protected var ImgP1:Class;
		[Embed(source = "grafixxx/p2.png")] protected var ImgP2:Class;
		
		protected var Hydraman:FlxSprite;
		protected var Hydramen:FlxSprite;
		protected var Hydramzn:FlxSprite;
		protected var P1:FlxSprite;
		protected var P2:FlxSprite;
		
		protected var timeToSwitch:Number;
		protected var hydramentimer:Number;
		protected var hydramzntimer:Number;
		protected var transToMan:Boolean;
		
		private var page:FlxSprite = new FlxSprite(0, 0, Img1);
		private var time:Number = 0;
		private var part:int = 0;
		
		override public function create():void
		{
			
			Hydraman = new FlxSprite();
			Hydramen = new FlxSprite();
			Hydramzn = new FlxSprite();
			
			P1 = new FlxSprite(25, 170);
			P2 = new FlxSprite(320-47-25,170);
			
			Hydraman.loadGraphic(ImgHydraman);
			Hydramen.loadGraphic(ImgHydramen);
			Hydramzn.loadGraphic(ImgHydramzn);
			P1.loadGraphic(ImgP1, true);
			P2.loadGraphic(ImgP2, true);
			
			Hydramen.exists = false;
			Hydraman.exists = false;
			Hydramzn.exists = false;
			P1.exists = false;
			P2.exists = false;
			
			timeToSwitch = (Math.random() * 2) + 3;
			hydramentimer = 0;
			hydramzntimer = 0;
			transToMan = false;
			
			
			P1.addAnimation("idle", [0, 1, 2], 4, true);
			P1.play("idle");
			P2.addAnimation("idle", [0, 1, 2], 4, true);
			P2.play("idle");
			
			FlxG.playMusic(Music);
			super.create();
			add(page);
			add(Hydraman);
			add(Hydramen);
			add(Hydramzn);
			add(P1);
			add(P2);
			FlxG.flash.start(0xff000000, 1);
		}
		
		override public function update():void
		{
			time += FlxG.elapsed;
			if (time > 3 && part == 0)
			{
				FlxG.flash.start(0xff000000, 1);
				page.loadGraphic(Img2);
				part = 1;
			}
			if (time > 6 && part == 1)
			{
				FlxG.flash.start(0xff000000, 1);
				//page.loadGraphic(Img4);
				Hydraman.exists = true;
				P1.exists = true;
				P2.exists = true;
				part = 2;
			}
			/*if (time > 9 && part == 2)
			{
				FlxG.flash.start(0xff000000, 1);
				//page.loadGraphic(Img4);
				Hydraman.exists = true;
				P1.exists = true;
				P2.exists = true;
				part = 3;
			}*/
			if (FlxG.keys.justPressed('X'))
			{
				FlxG.fade.start(0x000000, 1,changeState);
			}
			
			if (part == 2)
			{
				if (timeToSwitch > 0)
					timeToSwitch -= FlxG.elapsed;
				
				if (hydramentimer > 0)
					hydramentimer -= FlxG.elapsed;
				
				if (hydramzntimer > 0)
					hydramzntimer -= FlxG.elapsed;
			
				if (timeToSwitch <= 0 && Hydraman.exists)
				{
					Hydraman.exists = false;
					Hydramzn.exists = true;
					hydramzntimer = .25;				
				}
				if (hydramzntimer <= 0 && Hydramzn.exists && !transToMan)
				{
					Hydramzn.exists = false;
					Hydramen.exists = true;
					hydramentimer = 1;
					transToMan = true;
				}
				else if (hydramzntimer <= 0 && Hydramzn.exists && transToMan)
				{
					Hydramzn.exists = false;
					Hydraman.exists = true;
					timeToSwitch = (Math.random() * 2) + 3;
					transToMan = false
				}
				if (hydramentimer <= 0 && Hydramen.exists)
				{
					Hydramen.exists = false;
					Hydramzn.exists = true;
					hydramzntimer = .25;
				}				
			}
			
			super.update();
		}
		
		public function changeState():void
		{
			FlxG.state = new LevelMeteor();
		}
	}
}