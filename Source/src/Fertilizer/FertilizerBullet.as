package Fertilizer 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author JoeDono
	 */
	public class FertilizerBullet extends FlxSprite 
	{
		public const FERTILIZER_BULLET_SPEED:Number = 400;
		
		[Embed(source="../../asset/graphic/FertilizerShot.png")]
		private var ImgFertilizerBullet:Class;
		
		public function FertilizerBullet() 
		{
			super(0, 0, ImgFertilizerBullet);
		}
		
		public function fireShot(x:Number, y:Number, hSpeed:Number, vSpeed:Number):void {
			this.x = x - 8;
			this.y = y - 8;
			this.velocity.x = hSpeed * FERTILIZER_BULLET_SPEED;
			this.velocity.y = vSpeed * FERTILIZER_BULLET_SPEED;
		}
		
	}

}