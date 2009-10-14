package {
	import com.adamatomic.flixel.*;
	import flash.utils.*;
	
	public class NetPlayState extends PlayState {
	
		public var remotePlayers:Object = new Object();
		
		protected var keydownUp:Boolean = false;
		protected var keydownDown:Boolean = false;
		protected var keydownLeft:Boolean = false;
		protected var keydownRight:Boolean = false;
	
		protected var ready:Boolean = false;
		
		protected var moveTimer:Number = 0;
		protected var moving:Boolean = false;
		
		protected var pingTimer:Number = 0;
		protected var ping:FlxText;
		
		protected var playerPositions:Array = [[64,64, 0, 'red'], [680, 462, 180, 'blue']];
		
		public function NetPlayState():void {
			super();
			
			this.setupGround();
			
			
			CombatTanks.connection.on('PLAYER', onPlayer);
			CombatTanks.connection.on('READY', onReady);
			CombatTanks.connection.on('MOVE', onMove);
			CombatTanks.connection.on('STATE', onState);	
			CombatTanks.connection.on('SHOOT', onShoot);
			CombatTanks.connection.on('PONG', onPong);
			
			CombatTanks.connection.send("READY");
			this.sendPing();

		}
		
		override public function setupHud():void {
			super.setupHud();
			this.ping = new FlxText(10, 550, 200, 20, "Ping", 0xffffffff, null, 16);
			this.add(this.ping);
		}
		
		public function onPong(payload:Object):void {
			this.ping.setText((getTimer()-payload['time']).toString());
		}
		
		public function onShoot(payload:Object):void {
			this.remotePlayers[payload['player']].shoot();
		}
		
		public function onPlayer(payload:Object):void {
			var position:Array = playerPositions[payload['player']];
			this.remotePlayers[payload['player']] = new RemotePlayer(position[3], position[0], position[1], position[2]);
		}
		
		public function onReady(payload:Object):void {
			// Player
			var position:Array = playerPositions[CombatTanks.playerNum];	
			this.player = new Player(position[3], position[0], position[1], position[2]);
			this.tanks.add(this.add(this.player));
			
			// Remote Players
			for each (var remotePlayer:Tank in this.remotePlayers)
				this.tanks.add(this.add(remotePlayer));
			
			//this.player = this.remotePlayers[CombatTanks.playerNum];
			
			this.setupBullets(32);
			this.setupWalls();
			this.setupHud();
			
			this.ready = true;
		}
		
		public function onMove(payload:Object):void {
			this.remotePlayers[payload['player']].addMove(payload);
		}
		
		public function sendPing():void {
			CombatTanks.connection.send("PING", {"time": getTimer()});
		}
		
		public function sendState():void {
			CombatTanks.connection.send("STATE", {
				"x": round(this.player.x, 2), 
				"y": round(this.player.y, 2),
				"a": round(this.player.angle, 2)
				//"vx": round(this.player.velocity.x, 2),
				//"vy": round(this.player.velocity.y, 2),
				//"av": round(this.player.angularVelocity, 2),
				//"h": this.player.health
			});
			this.moveTimer = 0;
		}
		
		public function sendMove():void {
			var move:Object = {};
			
			if (FlxG.justPressed(FlxG.UP))
				move['up'] = true;
			if (FlxG.justPressed(FlxG.DOWN))
				move['down'] = true;
			if (FlxG.justPressed(FlxG.LEFT))
				move['left'] = true;
			if (FlxG.justPressed(FlxG.RIGHT))
				move['right'] = true;
			
			if (FlxG.justReleased(FlxG.UP))
				move['up'] = false;
			if (FlxG.justReleased(FlxG.DOWN))
				move['down'] = false;
			if (FlxG.justReleased(FlxG.LEFT))
				move['left'] = false;
			if (FlxG.justReleased(FlxG.RIGHT))
				move['right'] = false;
				
			CombatTanks.connection.send("MOVE", move);
		}
		
		public function onState(payload:Object):void {
			var rp:RemotePlayer = this.remotePlayers[payload['player']];
			payload['latency'] = this.ping;
			//rp.updateState(payload);
			rp.x = payload['x'];
			rp.y = payload['y'];
			rp.angle = payload['a'];
			//rp.velocity.x = payload['vx'];
			//rp.velocity.y = payload['vy'];
			//rp.angularVelocity = payload['av'];
			//rp.health = payload['health'];
		}
		
		override public function update():void {
			super.update();
			
			this.moveTimer += FlxG.elapsed;
			this.pingTimer += FlxG.elapsed;
			
			if (this.ready) {
				
				
				if (FlxG.justPressed(FlxG.RIGHT) ||
					FlxG.justPressed(FlxG.LEFT) ||
					FlxG.justPressed(FlxG.UP) ||
					FlxG.justPressed(FlxG.DOWN)) {
					this.sendMove();	
					this.sendState();
					this.moving = true;
				} else if (FlxG.justReleased(FlxG.RIGHT) ||
					FlxG.justReleased(FlxG.LEFT) ||
					FlxG.justReleased(FlxG.UP) ||
					FlxG.justReleased(FlxG.DOWN)) {
					this.sendMove();
				} else if (!FlxG.kRight &&
					!FlxG.kLeft &&
					!FlxG.kUp &&
					!FlxG.kDown && this.moving) {
					this.sendState();
					this.moving = false;
				} 
				
				if (this.moving) {
					if (this.moveTimer > 1) {
						this.sendState();
					}
				}
				
				if (this.pingTimer > 3) {
					this.sendPing();
					this.pingTimer = 0;
				}
					
				if (FlxG.justPressed(FlxG.B))
					CombatTanks.connection.send("SHOOT");
			}
		}
		
		protected function round(num:Number, precision:Number):Number {
			var decimalPlaces:Number = Math.pow(10, precision);
			return Math.round(decimalPlaces * num) / decimalPlaces;
		}

		
	}
}