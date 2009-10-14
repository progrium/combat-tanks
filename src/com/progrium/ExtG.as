package com.progrium
{
	import com.adamatomic.flixel.*;
	
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	 
	//@desc		This is a global helper class full of useful functions for audio, input, basic info, and the camera system
	public class ExtG
	{
		static private var _loopSounds:Dictionary = new Dictionary;
		
		//@desc		Plays a sound effect once
		//@param	SoundEffect		The sound you want to play
		//@param	Volume			How loud to play it (0 to 1)
		static public function playLoop(name:String, SoundEffect:Class,Volume:Number=1):void
		{
			if (!_loopSounds.hasOwnProperty(name)) {
				_loopSounds[name] = (new SoundEffect).play(0,128,new SoundTransform(Volume)); //*FlxG._muted*FlxG._volume*FlxG._masterVolume));
			}
		}
		
		static public function stopLoop(name:String):void
		{
			if (_loopSounds.hasOwnProperty(name)) {
				_loopSounds[name].stop();
				delete _loopSounds[name];
			}
		}

	}
}