package
{
	import com.adamatomic.flixel.*;
	import com.progrium.*;

	public class Tank extends FlxSprite
	{
		[Embed(source="./data/tank_red.png")] private var ImgRedTank:Class;
		[Embed(source="./data/tank_white.png")] private var ImgWhiteTank:Class;
		[Embed(source="./data/tank_blue.png")] private var ImgBlueTank:Class;
		[Embed(source="./data/tank_green.png")] private var ImgGreenTank:Class;
		
		[Embed(source="./data/tank_loop.mp3")] private var SndEngine:Class;
		[Embed(source="./data/explode.mp3")] private var SndExplode:Class;
		[Embed(source="./data/hit.mp3")] private var SndHit:Class;
		
		public var bullets:FlxArray;
		private var curBullet:uint;
		
		protected var state:FlxState;
		
		protected var _moveUp:Boolean = false;
		protected var _moveDown:Boolean = false;
		protected var _moveLeft:Boolean = false;
		protected var _moveRight:Boolean = false;
		protected var _shoot:Boolean = false;
		
		
		public function Tank(color:String, X:int,Y:int, angle:int = 0)
		{
			var tanks:Object = {
				"red": ImgRedTank,
				"white": ImgWhiteTank,
				"blue": ImgBlueTank,
				"green": ImgGreenTank
			};
			super(tanks[color],X,Y,true,true,60);
			
			this.angle = angle;
			
			//bounding box tweaks
			this.width = 50;
			this.height = 40;
			this.offset.x = 5;
			this.offset.y = 5;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("moving", [0,1], 20, true);
		
		}
		
		public function shoot():void {
			this._shoot = true;
		}
		
		
		override public function hurt(Damage:Number):void
		{
			//FlxG.play(SndHit);
			flicker(0.2);
			//FlxG.score += 50;
			super.hurt(Damage);
		}
		
		override public function kill():void
		{
			//ExtG.stopLoop(this._id.toString()+'tank');
			FlxG.play(SndExplode);
			super.kill();
		}
		
		override public function update():void
		{
			
			//MOVEMENT
			this.angularVelocity = 0;
			this.velocity.x = 0;
			this.velocity.y = 0;
			
			if(this._moveLeft)
			{
				this.angularVelocity = -100;
				this.play('moving');
				//ExtG.playLoop(this._id.toString()+'tank', SndEngine);
			}
			else if(this._moveRight)
			{
				this.angularVelocity = 100;
				this.play('moving');
				//ExtG.playLoop(this._id.toString()+'tank', SndEngine);
			}
			if(this._moveUp) 
			{
				this.play('moving');
				//ExtG.playLoop(this._id.toString()+'tank', SndEngine);
				this.velocity.x = Math.cos(this.angle * (Math.PI / 180)) * 60;
				this.velocity.y = Math.sin(this.angle * (Math.PI / 180)) * 60;
			} else if (this._moveDown) {
				this.play('moving');
				//ExtG.playLoop(this._id.toString()+'tank', SndEngine);
				this.velocity.x = Math.cos(this.angle * (Math.PI / 180)) * -50;
				this.velocity.y = Math.sin(this.angle * (Math.PI / 180)) * -50;
			} else {
				if (this.angularVelocity == 0) {
					//ExtG.stopLoop(this._id.toString()+'tank');
					this.play('idle');
				}
			}
			

			//UPDATE POSITION AND ANIMATION
			super.update();
			
			
			// shooting
			if(this._shoot)
			{
				var bXVel:int = 0;
				var bYVel:int = 0;
				var bX:int = x;
				var bY:int = y;
				bX = this.x+24 + Math.cos(this.angle * (Math.PI / 180)) * 25;
				bY = this.y+18 + Math.sin(this.angle * (Math.PI / 180)) * 25;
				bXVel = Math.cos(this.angle * (Math.PI / 180)) * 360;
				bYVel = Math.sin(this.angle * (Math.PI / 180)) * 360;
				(FlxG.state as PlayState).getBullet(this).shoot(bX,bY,bXVel,bYVel);
			}
			
			this._moveDown = false;
			this._moveUp = false;
			this._moveLeft = false;
			this._moveRight = false;
			this._shoot = false;
		
		
		}
		
		
	}
}