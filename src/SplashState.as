package {
	import com.adamatomic.flixel.*;
	public class SplashState extends FlxState {
		public function SplashState():void {
			super();
			
			this.add(new FlxSprite(null, 0, 0, false, false, 800, 768, 0xff000000));
			this.add(new FlxText(200, 50, 800, 50, "Combat Tanks", 0xffffffff, null, 40));
			this.add(new FlxText(350, 100, 800, 50, "Alpha v"+CombatTanks.version, 0xffffffff, null, 24));
			
			this.add(new FlxText(200, 175, 800, 50, "Controls:", 0xffffffff, null, 24));
			this.add(new FlxText(225, 210, 800, 50, "Up - Forward", 0xffffffff, null, 24));
			this.add(new FlxText(225, 244, 800, 50, "Down - Reverse", 0xffffffff, null, 24));
			this.add(new FlxText(225, 280, 800, 50, "Left - Turn Left", 0xffffffff, null, 24));
			this.add(new FlxText(225, 315, 800, 50, "Right - Turn Right", 0xffffffff, null, 24));
			this.add(new FlxText(225, 350, 800, 50, "Space - Shoot", 0xffffffff, null, 24));
			
			this.add(new FlxText(210, 420, 800, 50, "Click to Start!", 0xffffffff, null, 40));
		}
		
		override public function update():void {
			if (FlxG.kMouse) { 
				CombatTanks.tracker.trackEvent("Sessions", "Started");
				FlxG.switchState(WaitPlayState); 
			}
		}
	}
}