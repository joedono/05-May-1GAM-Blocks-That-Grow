package Fertilizer
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author JoeDono
	 */
	public class FertilizerEmitter extends FlxSprite
	{
		public var partEmitter:FlxEmitter;
		
		public function FertilizerEmitter(x:Number, y:Number)
		{
			super(x, y);
			this.makeGraphic(32, 32, 0x00000000);
			
			this.partEmitter = new FlxEmitter(x + 16, y + 30, 30);
			initializeEmitter();
			
			partEmitter.start(false, 0.7, 0.05);
		}
		
		private function initializeEmitter():void
		{
			partEmitter.minParticleSpeed.x = -100;
			partEmitter.maxParticleSpeed.x = 100;
			partEmitter.particleDrag.x = 200;
			
			partEmitter.minParticleSpeed.y = -10;
			partEmitter.maxParticleSpeed.y = -30;
			partEmitter.gravity = -200;
			
			var particles:int = 30;
			for (var i:int = 0; i < particles; i++)
			{
				var particle:FertilizerParticle = new FertilizerParticle();
				partEmitter.add(particle);
			}
		}
		
		public override function update():void
		{
			super.update();
			partEmitter.update();
		}
		
		public override function draw():void
		{
			super.draw();
			partEmitter.draw();
		}
	
	}

}