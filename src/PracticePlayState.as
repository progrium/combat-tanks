package {
	import com.adamatomic.flixel.*;
	public class PracticePlayState extends PlayState {
		public function PracticePlayState():void {
			super();
			
			this.setupGround();
			
			// Player			
			this.player = new Player('white', 60,60);
			this.tanks.add(this.add(player));
			
			// Bots
			var i:int, x:int, y:int;
			for (i=0; i<3; i++) {
				x = Math.floor(Math.random()*672)+64;
				y = Math.floor(Math.random()*448)+64;
				var bot:Bot = new Bot(x, y);
				this.tanks.add(this.add(bot));
			}
			
			this.setupBullets(32);
			this.setupWalls();
			this.setupHud();
		}
	}
}