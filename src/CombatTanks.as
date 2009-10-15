package {
	import com.adamatomic.flixel.*;
	import flash.system.*;
	import com.google.analytics.GATracker;
	
	public class CombatTanks extends FlxGame	{
		[Embed(source="./data/grass1.png")] static protected var ImgGrassA:Class;
		[Embed(source="./data/grass2.png")] static protected var ImgGrassB:Class;
		[Embed(source="./data/sand1.png")] static protected var ImgSandA:Class;
		[Embed(source="./data/sand2.png")] static protected var ImgSandB:Class;
		[Embed(source="./data/snow1.png")] static protected var ImgSnowA:Class;
		[Embed(source="./data/snow2.png")] static protected var ImgSnowB:Class;
		
		static public const version:String = "0.5.11";
		
		static public var tracker:GATracker;
		
		static public var terrains:Array = [
				[0xff009900, ImgGrassA, ImgGrassB],
				[0xffede13d, ImgSandA, ImgSandB],
				[0xfffafafa, ImgSnowA, ImgSnowB]
			];
		static public var currentTerrain:int;
		
		// Network multiplayer stuff
		static public var connection:NetSock;
		static public var playerNum:int;
		
		public function CombatTanks():void {
			
			Security.loadPolicyFile("xmlsocket://files.tigsource.com:843");
			currentTerrain = Math.floor(Math.random()*2)
			currentTerrain = 1; // debug
			super(800, 576, SplashState, 1, terrains[currentTerrain][0], false, 0xffffffff);
			tracker = new GATracker(this, "UA-6824126-7", "AS3", false);
			//super(800, 576, PracticePlayState, 1, terrains[currentTerrain][0], false, 0xffffffff);
		}
		
	}
}