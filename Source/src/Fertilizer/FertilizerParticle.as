package Fertilizer 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author JoeDono
	 */
	public class FertilizerParticle extends FlxParticle 
	{
		
		public function FertilizerParticle() 
		{
			this.makeGraphic(5, 5, 0xFFFF8000);
		}
		
		public override function onEmit():void {
			super.onEmit();
			this.alpha = 1;
		}
		
		public override function update():void {
			super.update();
			this.alpha = this.lifespan * 2;
		}
		
	}

}