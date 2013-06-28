package Player
{
	import Fertilizer.FertilizerBullet;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author JoeDono
	 */
	public class Player extends FlxSprite
	{
		public const PLAYER_WALK_SPEED:int = 200;
		public const PLAYER_JUMP_SPEED:int = 500;
		public const MAX_PLAYER_FALL_SPEED:int = 500;
		public const PLAYER_FALL_ACCELERATION:int = 1500;
		public const WALK_ANIMATION_SPEED:int = 5;
		public const SHOT_TIMER:Number = 0.2;
		
		[Embed(source="../../asset/graphic/Player.png")]
		private var ImgPlayerSheet:Class;
		
		[Embed(source="../../asset/graphic/FertilizerShot.png")]
		private var ImgHoldingBullet:Class;
		
		private var holdingBullet:FlxSprite;
		private var curPlayerState:int;
		private var facingRight:Boolean;
		private var shotTimer:Number;
		public var hasFertilizer:Boolean;
		
		public var fertilizerBullets:FlxGroup;
		
		public function Player()
		{
			super();
			
			initializeMotions();
			initializeAnimations();
			initializeBullets();
			
			holdingBullet = new FlxSprite(0, 0, ImgHoldingBullet);
			curPlayerState = PlayerState.PLAYER_STAND_RIGHT;
			facingRight = true;
			hasFertilizer = false;
			shotTimer = SHOT_TIMER;
		}
		
		private function initializeMotions():void
		{
			this.maxVelocity.x = PLAYER_WALK_SPEED;
			this.maxVelocity.y = MAX_PLAYER_FALL_SPEED;
			this.acceleration.y = PLAYER_FALL_ACCELERATION;
		}
		
		private function initializeAnimations():void
		{
			this.loadGraphic(ImgPlayerSheet, true, false, 32);
			this.addAnimation("idle-left", [0]);
			this.addAnimation("idle-right", [2]);
			this.addAnimation("walk-left", [1, 0], WALK_ANIMATION_SPEED);
			this.addAnimation("walk-right", [2, 3], WALK_ANIMATION_SPEED);
			this.addAnimation("jump-left", [1]);
			this.addAnimation("jump-right", [3]);
			this.play("idle-left");
		}
		
		private function initializeBullets():void
		{
			fertilizerBullets = new FlxGroup(30);
		}
		
		public override function update():void
		{
			this.velocity.x = 0;
			if (shotTimer > 0)
			{
				shotTimer -= FlxG.elapsed;
			}
			
			updateMovement();
			updateShoot();
			
			fertilizerBullets.update();
			super.update();
		}
		
		private function updateMovement():void
		{
			var onGround:Boolean = this.isTouching(FlxObject.FLOOR);
			var isMoving:Boolean = false;
			
			if (FlxG.keys.LEFT)
			{
				this.velocity.x = -PLAYER_WALK_SPEED;
				facingRight = false;
				isMoving = true;
			}
			
			if (FlxG.keys.RIGHT)
			{
				this.velocity.x = PLAYER_WALK_SPEED;
				facingRight = true;
				isMoving = true;
			}
			
			if (FlxG.keys.Z && onGround)
			{
				this.velocity.y = -PLAYER_JUMP_SPEED;
			}
			
			if (onGround)
			{
				if (facingRight)
				{
					if (isMoving)
					{
						changeState(PlayerState.PLAYER_WALK_RIGHT);
					}
					else
					{
						changeState(PlayerState.PLAYER_STAND_RIGHT);
					}
				}
				else
				{
					if (isMoving)
					{
						changeState(PlayerState.PLAYER_WALK_LEFT);
					}
					else
					{
						changeState(PlayerState.PLAYER_STAND_LEFT);
					}
				}
			}
			else
			{
				if (facingRight)
				{
					changeState(PlayerState.PLAYER_JUMP_RIGHT);
				}
				else
				{
					changeState(PlayerState.PLAYER_JUMP_LEFT);
				}
			}
		}
		
		private function changeState(nextState:int):void
		{
			if (curPlayerState != nextState)
			{
				curPlayerState = nextState;
				switch (curPlayerState)
				{
					case PlayerState.PLAYER_STAND_LEFT: 
						play("idle-left");
						break;
					case PlayerState.PLAYER_STAND_RIGHT: 
						play("idle-right");
						break;
					case PlayerState.PLAYER_WALK_LEFT: 
						play("walk-left");
						break;
					case PlayerState.PLAYER_WALK_RIGHT: 
						play("walk-right");
						break;
					case PlayerState.PLAYER_JUMP_LEFT: 
						play("jump-left");
						break;
					case PlayerState.PLAYER_JUMP_RIGHT: 
						play("jump-right");
						break;
				}
			}
		}
		
		private function updateShoot():void
		{
			if (FlxG.keys.X && hasFertilizer && shotTimer <= 0)
			{
				var bullet:FertilizerBullet = fertilizerBullets.recycle(FertilizerBullet) as FertilizerBullet;
				bullet.revive();
				var hSpeed:Number = 0;
				var vSpeed:Number = 0;
				
				if (FlxG.keys.LEFT)
				{
					hSpeed = -1;
				}
				else if (FlxG.keys.RIGHT)
				{
					hSpeed = 1;
				}
				
				if (FlxG.keys.UP)
				{
					vSpeed = -1;
				}
				else if (FlxG.keys.DOWN)
				{
					vSpeed = 1;
				}
				
				// No keys pressed, use facingRight instead
				if (hSpeed == 0 && vSpeed == 0)
				{
					hSpeed = facingRight ? 1 : -1;
				}
				
				// Normalize speed
				if (hSpeed != 0 && vSpeed != 0)
				{
					hSpeed = hSpeed / Math.sqrt(hSpeed * hSpeed + vSpeed * vSpeed);
					vSpeed = vSpeed / Math.sqrt(hSpeed * hSpeed + vSpeed * vSpeed);
				}
				
				bullet.fireShot(x + 16, y + 16, hSpeed, vSpeed);
				shotTimer = SHOT_TIMER;
				hasFertilizer = false;
			}
		}
		
		public override function draw():void
		{
			fertilizerBullets.draw();
			
			if (hasFertilizer)
			{
				holdingBullet.y = this.y - 2;
				holdingBullet.x = facingRight ? this.x - 2 : this.x + 18;
				holdingBullet.draw();
			}
			
			super.draw();
		}
	
	}

}