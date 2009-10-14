package
{
	import com.adamatomic.flixel.*;
	import com.progrium.*;

	public class RemotePlayer extends Tank
	{
		protected var move:Object = new Object();
		protected var stateUpdate:Object = new Object();
		
		public function RemotePlayer(color:String, X:int,Y:int, angle:int) {
			super(color, X, Y, angle); 
		}
		
		public function addMove(move:Object):void {
			for (var k:Object in move) {
				this.move[k] = move[k];
			}
		}
		
		public function updateState(update:Object):void {
			stateUpdate = update;
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
			
			if (stateUpdate['latency'] > 0) {
				angle = stateUpdate['a'] + (angularVelocity = FlxG.computeVelocity(angularVelocity,angularAcceleration,angularDrag,maxAngular))*stateUpdate['latency'];
				x = stateUpdate['x'] + (velocity.x = FlxG.computeVelocity(velocity.x,acceleration.x,drag.x,maxVelocity.x))*stateUpdate['latency'];
				y = stateUpdate['y'] + (velocity.y = FlxG.computeVelocity(velocity.y,acceleration.y,drag.y,maxVelocity.y))*stateUpdate['latency'];
				stateUpdate['latency'] = 0;
			}
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