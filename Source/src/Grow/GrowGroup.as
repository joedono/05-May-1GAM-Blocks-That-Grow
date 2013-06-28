package Grow
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author JoeDono
	 */
	public class GrowGroup extends FlxGroup
	{
		public static const GROWN_TIMER:Number = 1.5;
		
		[Embed(source="../../asset/graphic/growPlatform/GrowUp.png")]
		private static var ImgGrowSourceUp:Class;
		
		[Embed(source="../../asset/graphic/growPlatform/GrowDown.png")]
		private static var ImgGrowSourceDown:Class;
		
		[Embed(source="../../asset/graphic/growPlatform/GrowLeft.png")]
		private static var ImgGrowSourceLeft:Class;
		
		[Embed(source="../../asset/graphic/growPlatform/GrowRight.png")]
		private static var ImgGrowSourceRight:Class;
		
		public var growSource:GrowSource;
		public var growPlatforms:FlxGroup;
		
		private var growDirection:int;
		private var grownTimer:Number;
		private var growLength:int;
		private var isGrowSourceSpaceOpen:Boolean;
		
		public function GrowGroup(x:int, y:int, growDirection:int, growLength:int)
		{
			super();
			this.growDirection = growDirection;
			this.growLength = growLength;
			
			growSource = new GrowSource(x, y);
			growPlatforms = new FlxGroup(32);
			
			for (var i:int = 0; i < 32; i++)
			{
				var newPlatform:GrowPlatform = new GrowPlatform(this);
				newPlatform.kill();
				growPlatforms.add(newPlatform);
			}
			
			switch (growDirection)
			{
				case GrowPlatformState.GROW_DIR_UP: 
					growSource.loadGraphic(ImgGrowSourceUp);
					break;
				case GrowPlatformState.GROW_DIR_DOWN: 
					growSource.loadGraphic(ImgGrowSourceDown);
					break;
				case GrowPlatformState.GROW_DIR_LEFT: 
					growSource.loadGraphic(ImgGrowSourceLeft);
					break;
				case GrowPlatformState.GROW_DIR_RIGHT: 
					growSource.loadGraphic(ImgGrowSourceRight);
					break;
			}
			
			this.add(growSource);
			this.add(growPlatforms);
		}
		
		public override function update():void
		{
			switch (growSource.curState)
			{
				case GrowPlatformState.GROW_INERT: 
					break;
				case GrowPlatformState.GROW_READY_TO_GROW: 
					grownTimer = GROWN_TIMER;
					growSource.curState = GrowPlatformState.GROW_GROWING_OUT;
					break;
				case GrowPlatformState.GROW_GROWING_OUT: 
					updateGrowingOut();
					break;
				case GrowPlatformState.GROW_GROWN: 
					grownTimer -= FlxG.elapsed;
					if (grownTimer <= 0)
					{
						startGrowingIn();
					}
					break;
				case GrowPlatformState.GROW_GROWING_IN: 
					updateGrowingIn();
					break;
			}
			
			super.update();
		}
		
		private function updateGrowingOut():void
		{
			isGrowSourceSpaceOpen = true;
			FlxG.overlap(this.growSource, this.growPlatforms, checkGrowSourceOpen);
			
			if (isGrowSourceSpaceOpen)
			{
				var newPlatform:GrowPlatform = growPlatforms.recycle(GrowPlatform) as GrowPlatform;
				newPlatform.revive();
				newPlatform.x = growSource.x;
				newPlatform.y = growSource.y;
				newPlatform.velocity.x = 0;
				newPlatform.velocity.y = 0;
				newPlatform.setDirection(this.growDirection);
			}
			
			if (growLength <= growPlatforms.countLiving())
			{
				grownTimer = grownTimer;
				growSource.curState = GrowPlatformState.GROW_GROWN;
				
				growPlatforms.callAll("stop");
			}
		}
		
		private function checkGrowSourceOpen(growSource:GrowSource, growPlatform:GrowPlatform):void
		{
			isGrowSourceSpaceOpen = false;
		}
		
		private function startGrowingIn():void
		{
			growSource.curState = GrowPlatformState.GROW_GROWING_IN;
			growPlatforms.callAll("retract");
		}
		
		private function updateGrowingIn():void
		{
			FlxG.overlap(growSource, growPlatforms, platformReturnsToSource);
			
			if (growPlatforms.getFirstAlive() == null) {
				growSource.curState = GrowPlatformState.GROW_INERT;
			}
		}
		
		public override function draw():void
		{
			growPlatforms.draw();
			growSource.draw();
		}
		
		private function platformReturnsToSource(growSource:GrowSource, growPlatform:GrowPlatform):void {
			if (FlxU.getDistance(new FlxPoint(growSource.x, growSource.y), new FlxPoint(growPlatform.x, growPlatform.y)) < 1) {
				growPlatform.kill();
			}
		}
	}
}