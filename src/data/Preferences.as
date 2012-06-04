package data {
	
	public class Preferences extends Object {
		private var _muteEffects:Boolean = false;
		private var _muteSound:Boolean = false;
		private var _volume:Number = 0;
		
		public function get muteEffects():Boolean {return _muteEffects;}
		public function set muteEffects(newMuteEffects:Boolean):void {_muteEffects = newMuteEffects;}
		
		//public function get muteSound():Boolean {return _muteSound;}
		//public function set muteSound(newMuteSound:Boolean) {_muteSound = newMuteSound;}
		
		//public function get volume():Number {return _volume;}
		//public function set volume(newVolume:Boolean) {_volume = newVolume;}
		
		public function Preferences() {
			
		}
	}
}