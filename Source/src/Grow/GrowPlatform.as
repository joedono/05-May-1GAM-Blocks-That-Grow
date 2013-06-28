package Grow
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author JoeDono
	 */
	public class GrowPlatform extends FlxSprite
	{
		public static const GROW_PLATFORM_SPEED:Number = 50;
		
		[Embed(source="../../asset/graphic/growPlatform/GrowPlatform.png")]
		private static var ImgGrowPlatform:Class;
		
		public var parent:GrowGroup;
		private var dir:int;
		
		public function GrowPlatform(parent:GrowGroup)
		{
			super(0, 0, ImgGrowPlatform);
			this.parent = parent;
			this.immovable = true;
		}
		
		public function stop():void {
			this.velocity.x = 0;
			this.velocity.y = 0;
		}
		
		public function retract():void {
			switch(dir) {
				case GrowPlatformState.GROW_DIR_UP:
					this.velocity.y = GROW_PLATFORM_SPEED;
					break;
				case GrowPlatformState.GROW_DIR_DOWN:
					this.velocity.y = -GROW_PLATFORM_SPEED;
					break;
				case GrowPlatformState.GROW_DIR_LEFT:
					this.velocity.x = GROW_PLATFORM_SPEED;
					break;
				case GrowPlatformState.GROW_DIR_RIGHT:
					this.velocity.x = -GROW_PLATFORM_SPEED;
					break;
			}
		}
		
		public function setDirection(dir:int):void {
			this.dir = dir;
			switch(dir) {
				case GrowPlatformState.GROW_DIR_UP:
					this.velocity.y = -GROW_PLATFORM_SPEED;
					break;
				case GrowPlatformState.GROW_DIR_DOWN:
					this.velocity.y = GROW_PLATFORM_SPEED;
					break;
				case GrowPlatformState.GROW_DIR_LEFT:
					this.velocity.x = -GROW_PLATFORM_SPEED;
					break;
				case GrowPlatformState.GROW_DIR_RIGHT:
					this.velocity.x = GROW_PLATFORM_SPEED;
					break;
			}
		}
	
	}

}