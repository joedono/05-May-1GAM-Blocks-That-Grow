package State
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author JoeDono
	 */
	public class GameEndState extends FlxState
	{
		[Embed(source="../../asset/graphic/screen/GameBeatenScreen.png")]
		private var ImgGameBeatenScreen:Class;
		
		private var img:FlxSprite;
		
		public override function create():void
		{
			FlxG.bgColor = 0xFFFFFFC2;
			img = new FlxSprite(0, 0, ImgGameBeatenScreen);
			
			this.add(img);
		}
		
		public override function update():void
		{
			if (FlxG.keys.any())
			{
				FlxG.switchState(new TitleState());
			}
		}
	
	}

}