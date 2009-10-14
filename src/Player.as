package
{
	import com.adamatomic.flixel.*;
	import com.progrium.*;

	public class Player extends Tank
	{
		
		public function Player(color:String, X:int,Y:int, angle:int=0) {
			super(color, X, Y, angle); 
		}
		
		override public function update():void {
			if (FlxG.kLeft) {
				this._moveLeft = true;
			}
			if (FlxG.kRight) {
				this._moveRight = true;
			}
			if (FlxG.kUp) {
				this._moveUp = true;
			}
			if (FlxG.kDown) {
				this._moveDown = true;
			}
			if (FlxG.justPressed(FlxG.B)) {
				this._shoot = true;
			}
			super.update();
		}
	}
}