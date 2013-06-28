package Grow
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author JoeDono
	 */
	public class GrowSource extends FlxSprite
	{
		public var curState:int;
		
		public function GrowSource(x:int, y:int)
		{
			super(x, y);
			this.immovable = true;
			
			curState = GrowPlatformState.GROW_INERT;
		}
		
		public function hitWithFertilizer():void
		{
			if (curState == GrowPlatformState.GROW_INERT)
			{
				curState = GrowPlatformState.GROW_READY_TO_GROW;
			}
		}
	
	}

}