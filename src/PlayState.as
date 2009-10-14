package {
	import com.adamatomic.flixel.*;
	public class PlayState extends FlxState {
		private var text:FlxText;
		public var player:Tank;
		
		public var bullets:FlxArray = new FlxArray();
		public var curBullet:uint;
		
		public var tilemap:FlxTilemap;
		public var tanks:FlxArray = new FlxArray();
		
		[Embed(source="./data/top.png")] private var ImgTop:Class;
		
		
		[Embed(source="./data/map1.txt",mimeType="application/octet-stream")] private var TxtMap1:Class;
		[Embed(source="./data/map2.txt",mimeType="application/octet-stream")] private var TxtMap2:Class;
		[Embed(source="./data/walls.png")] private var ImgTiles:Class;
		
		
		public function PlayState():void {
			super();	
			FlxG.log("Version: " + CombatTanks.version);	
		}
		
		public function setupGround():void {
			var i:int;
			for (i=0; i<8; i++)
					this.add(new FlxSprite(CombatTanks.terrains[CombatTanks.currentTerrain][1], (Math.floor(Math.random()*13))*64,(Math.floor(Math.random()*10))*64));
			for (i=0; i<8; i++)
					this.add(new FlxSprite(CombatTanks.terrains[CombatTanks.currentTerrain][2], (Math.floor(Math.random()*13))*64,(Math.floor(Math.random()*10))*64));
		}
		
		public function setupBullets(num:int):void {
			for(var i:int = 0; i < num; i++)
				this.bullets.add(this.add(new Bullet()));
			this.curBullet = 0;	
		}
		
		public function setupWalls():void {
			this.tilemap = new FlxTilemap(new TxtMap2,ImgTiles);
			this.add(this.tilemap);
		}
		
		public function setupHud():void {
			this.add(new FlxSprite(ImgTop,0,0));
			this.text = new FlxText(10, 5, 200, 20, "Combat Tanks",0xffffffff, null, 16);
			this.add(text);
		}
		
		override public function update():void {
			super.update();
			
			FlxG.collideArray2(this.tilemap, this.bullets);
			FlxG.collideArray2(this.tilemap, this.tanks);
			
			FlxG.overlapArrays(this.bullets,this.tanks,bulletHitBot);
			
			for each (var tank:Tank in this.tanks) {
				var tanks:FlxArray = new FlxArray();
				for each (var otherTank:Tank in this.tanks) {
					if (otherTank != tank)
						tanks.add(otherTank);
				}
				FlxG.collideArray(tanks, tank);
			}
			
		}
		
		private function bulletHitBot(bullet:Bullet,bot:FlxSprite):void
		{
			if (bullet.owner != bot) {
				bullet.hurt(0);
				bot.hurt(0.1);
			}
		}
		
		public function getBullet(owner:Tank):Bullet {
			var bullet:Bullet = this.bullets[this.curBullet];
			bullet.owner = owner;
			if(++this.curBullet >= this.bullets.length)
				this.curBullet = 0;
			return bullet;
		}
		
	}
}