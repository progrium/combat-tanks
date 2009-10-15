package {
	import com.adamatomic.flixel.*;
	
	import flash.events.*;
	
	
	public class WaitPlayState extends PlayState {
		public var status:FlxText = new FlxText(10, 5, 780, 20, "Connecting...", 0xffffffff, null, 16, "right");
	
		public function WaitPlayState():void {
			super();
			
			
			this.setupGround();
			
			// Player			
			this.player = new Player('white', 60,60);
			this.tanks.add(this.add(player));
			
			
			this.setupBullets(32);
			this.setupWalls();
			this.setupHud();
			
			
			this.healthText.visible = false;
			
			this.add(this.status);
			
			
			CombatTanks.connection = new NetSock("files.tigsource.com", 3333);
			//CombatTanks.connection = new NetSock("localhost", 3333);
			CombatTanks.connection.on('WAIT', onWait);
			CombatTanks.connection.on('START', onStart);

		}
		
		public function onWait(payload:Object):void {
			this.status.setText("Waiting for players...");
		}
		
		public function onStart(payload:Object):void {
			CombatTanks.playerNum = payload['player'];
			FlxG.switchState(NetPlayState);
		}
		
		override public function update():void {
			super.update();
			
		}
	}
}