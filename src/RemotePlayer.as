package
{
	import com.adamatomic.flixel.*;
	import com.progrium.*;

	public class RemotePlayer extends Tank
	{
		protected var move:Object = new Object();
		protected var stateUpdate:Object = new Object();
		
		public function RemotePlayer(number:int, color:String, X:int,Y:int, angle:int) {
			super(number, color, X, Y, angle); 
		}
		
		public function addMove(move:Object):void {
			for (var k:Object in move) {
				this.move[k] = move[k];
			}
		}
		
		public function updateState(update:Object):void {
			this.health = update['h'];
			this.angle = update['a'] + angularVelocity*update['latency'];
			this.x = update['x'] + velocity.x*update['latency'];
			this.y = update['y'] + velocity.y*update['latency'];
		}
		
		override public function update():void {
			if (this.move['left']) {
				this._moveLeft = true;
			}
			if (this.move['right']) {
				this._moveRight = true;
			}
			if (this.move['up']) {
				this._moveUp = true;
			}
			if (this.move['down']) {
				this._moveDown = true;
			}
		
			super.update();
			
			/*if (this.stateUpdate['latency'] > 0) {
				if (this.move['left'] || this.move['right'] || this.move['up'] || this.move['down']) {
					this.angle = stateUpdate['a'] + (this.angularVelocity = FlxG.computeVelocity(angularVelocity,angularAcceleration,angularDrag,maxAngular))*this.stateUpdate['latency'];
					this.x = stateUpdate['x'] + (this.velocity.x = FlxG.computeVelocity(velocity.x,acceleration.x,drag.x,maxVelocity.x))*this.stateUpdate['latency'];
					this.y = stateUpdate['y'] + (this.velocity.y = FlxG.computeVelocity(velocity.y,acceleration.y,drag.y,maxVelocity.y))*this.stateUpdate['latency'];
				} else {
					this.angle = stateUpdate['a'];
					this.x = stateUpdate['x'];
					this.y = stateUpdate['y'];
				}
				this.stateUpdate['latency'] = 0;
			}*/
		}
		
		override public function hitWall():Boolean { rejigger(); return true; }
		override public function hitFloor():Boolean { rejigger(); return true; }
		override public function hitCeiling():Boolean { rejigger(); return true; }
		public function rejigger():void {
			
		}
		
		private function chanceOf(percent:Number):Boolean {
			var chance:Number = percent / (1/FlxG.elapsed);
			if (Math.random() < chance) {
				return true;
			} else {
				return false;
			}
		}
	}
	
}