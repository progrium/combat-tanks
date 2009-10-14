package
{
	import com.adamatomic.flixel.*;
	import com.progrium.*;

	public class Bot extends Tank
	{
		protected var _currentMove:Boolean = false;
		protected var _currentTurn:int = 0;
		
		public function Bot(X:int,Y:int) {
			var color:Array = ["red", "blue", "green"];
			super(color[Math.floor(Math.random() * 3)], X, Y); 
			this.angle = Math.floor(Math.random() * 360);
		}
		
		override public function update():void {
			if (this._currentMove) { 
				this._moveUp = true;
				if (this.chanceOf(0.5)) {
					this._currentMove = false;
				}
			} else {
				if (this._currentTurn>0) {
					if (this._currentTurn==1) {
						this._moveLeft = true;	
					} else {
						this._moveRight = true;
					}
					if (this.chanceOf(0.8)) {
						this._currentTurn = 0;
					}
				} else {
					if (this.chanceOf(0.7)) {
						this._currentMove = true;
					}
				}
			}
			if (this.chanceOf(0.5)) {
				this._shoot = true;
			}
			super.update();
		}
		
		override public function hitWall():Boolean { rejigger(); return true; }
		override public function hitFloor():Boolean { rejigger(); return true; }
		override public function hitCeiling():Boolean { rejigger(); return true; }
		public function rejigger():void {
			this._currentMove = false;
			this._currentTurn = Math.floor(Math.random()*2)+1;
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