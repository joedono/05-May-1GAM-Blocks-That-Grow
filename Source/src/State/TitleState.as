package State
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author JoeDono
	 */
	public class TitleState extends FlxState
	{
		[Embed(source="../../asset/graphic/screen/TitleScreen.png")]
		private var ImgTitleScreen:Class;
		
		private var img:FlxSprite;
		
		public override function create():void
		{
			FlxG.bgColor = 0xFFFFFFC2;
			img = new FlxSprite(0, 0, ImgTitleScreen);
			
			this.add(img);
		}
		
		public override function update():void
		{
			if (FlxG.keys.any())
			{
				FlxG.switchState(new PlayState());
			}
		}
	}

}