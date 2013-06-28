package 
{
	import org.flixel.*;
	import State.*;
	
	[SWF(width = "800", height = "608", backgroundColor = "#FFFFFF")]
	[Frame(factoryClass = "Preloader")]
	public class Main extends FlxGame 
	{
		public function Main():void 
		{
			super(800, 608, TitleState, 1);
		}
	}
}