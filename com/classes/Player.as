package com.classes {
	
	import flash.display.MovieClip;
	
	public class Player extends MovieClip {
		private var health:int;
		
		public function Player(health) {
			trace('player created!');
			this.health = health;
		}
		
		public function getHealth():int{
			return health;
		}
		
		public function hit():Boolean{
			health--;
			if (health < 1){
				trace('player is dying!')
				return true;
			}
			else{
				return false;
			}
		}
	}
	
}
