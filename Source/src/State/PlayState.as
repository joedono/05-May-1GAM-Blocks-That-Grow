package State
{
	import Fertilizer.*;
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	import Player.Player;
	import Grow.*;
	
	public class PlayState extends FlxState
	{
		[Embed(source="../../asset/graphic/Tileset.png")]
		private var ImgTileset:Class;
		
		[Embed(source="../../asset/level/level1.txt",mimeType="application/octet-stream")]
		private var Level1Config:Class;
		
		[Embed(source="../../asset/level/level2.txt",mimeType="application/octet-stream")]
		private var Level2Config:Class;
		
		[Embed(source="../../asset/level/level3.txt",mimeType="application/octet-stream")]
		private var Level3Config:Class;
		
		[Embed(source="../../asset/level/level4.txt",mimeType="application/octet-stream")]
		private var Level4Config:Class;
		
		[Embed(source="../../asset/level/level5.txt",mimeType="application/octet-stream")]
		private var Level5Config:Class;
		
		private var player:Player;
		private var wallTiles:FlxTilemap;
		private var fertilizerFountains:FlxGroup;
		private var growSources:FlxGroup;
		private var goal:Goal;
		
		private var levelConfigs:Array = new Array();
		
		private var curLevel:int = 0;
		
		public override function create():void
		{
			FlxG.bgColor = 0xFFFFFFC2;
			
			levelConfigs[0] = new Level1Config().toString();
			levelConfigs[1] = new Level2Config().toString();
			levelConfigs[2] = new Level3Config().toString();
			levelConfigs[3] = new Level4Config().toString();
			levelConfigs[4] = new Level5Config().toString();
			
			player = new Player();
			fertilizerFountains = new FlxGroup();
			growSources = new FlxGroup();
			goal = new Goal();
			
			loadLevel(levelConfigs[curLevel]);
			
			add(player);
			add(fertilizerFountains);
			add(growSources);
			add(goal);
		}
		
		private function loadLevel(levelConfig:String):void
		{
			this.remove(wallTiles);
			wallTiles = new FlxTilemap();
			wallTiles.loadMap(levelConfig, ImgTileset, 32, 32);
			this.add(wallTiles);
			
			fertilizerFountains.clear();
			growSources.clear();
			
			var lines:Array = levelConfig.split("\r\n");
			for (var y:int = 0; y < lines.length; y++)
			{
				var line:Array = lines[y].split(",");
				for (var x:int = 0; x < line.length; x++)
				{
					var curChar:String = line[x];
					var xPos:int = x * 32;
					var yPos:int = y * 32;
					var lengthStr:String;
					var length:int;
					
					if (curChar == "P")
					{
						player.x = xPos;
						player.y = yPos;
						player.velocity.x = 0;
						player.velocity.y = 0;
						player.hasFertilizer = false;
					}
					else if (curChar == "F")
					{
						fertilizerFountains.add(new FertilizerEmitter(xPos, yPos));
					}
					else if (curChar.indexOf("U") >= 0)
					{
						lengthStr = curChar.substr(1);
						length = int(lengthStr);
						growSources.add(new GrowGroup(xPos, yPos, GrowPlatformState.GROW_DIR_UP, length));
					}
					else if (curChar.indexOf("D") >= 0)
					{
						lengthStr = curChar.substr(1);
						length = int(lengthStr);
						growSources.add(new GrowGroup(xPos, yPos, GrowPlatformState.GROW_DIR_DOWN, length));
					}
					else if (curChar.indexOf("L") >= 0)
					{
						lengthStr = curChar.substr(1);
						length = int(lengthStr);
						growSources.add(new GrowGroup(xPos, yPos, GrowPlatformState.GROW_DIR_LEFT, length));
					}
					else if (curChar.indexOf("R") >= 0)
					{
						lengthStr = curChar.substr(1);
						length = int(lengthStr);
						growSources.add(new GrowGroup(xPos, yPos, GrowPlatformState.GROW_DIR_RIGHT, length));
					}
					else if (curChar.indexOf("G") >= 0)
					{
						goal.x = xPos + 8;
						goal.y = yPos + 8;
					}
				}
			}
		}
		
		public override function update():void
		{
			super.update();
			
			FlxG.collide(wallTiles, player);
			FlxG.collide(growSources, player);
			FlxG.overlap(fertilizerFountains, player, overlapFertilizerFountainsPlayer);
			FlxG.collide(wallTiles, player.fertilizerBullets, bulletHitWall);
			FlxG.collide(growSources, player.fertilizerBullets, bulletHitFertilizer);
			FlxG.overlap(player, goal, playerHitGoal);
		}
		
		private function overlapFertilizerFountainsPlayer(emitter:FertilizerEmitter, player:Player):void
		{
			player.hasFertilizer = true;
		}
		
		private function bulletHitWall(tile:FlxTilemap, bullet:FertilizerBullet):void
		{
			bullet.kill();
		}
		
		private function bulletHitFertilizer(other:FlxBasic, bullet:FertilizerBullet):void
		{
			bullet.kill();
			if (other is GrowSource)
			{
				var other2:GrowSource = GrowSource(other);
				other2.hitWithFertilizer();
			}
		}
		
		private function playerHitGoal(player:Player, goal:Goal):void
		{
			curLevel++;
			
			if (curLevel < 5)
			{
				this.loadLevel(levelConfigs[curLevel]);
			}
			else
			{
				FlxG.switchState(new GameEndState());
			}
		}
	}
}