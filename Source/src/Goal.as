package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author JoeDono
	 */
	public class Goal extends FlxSprite 
	{
		[Embed(source="../asset/graphic/Goal.png")]
		private var ImgGoalSheet:Class;
		
		public function Goal() 
		{
			super();
			
			this.loadGraphic(ImgGoalSheet, true, false, 16);
			this.addAnimation("pulse", [0, 1, 2, 3], 5);
			this.play("pulse");
		}
		
	}

}