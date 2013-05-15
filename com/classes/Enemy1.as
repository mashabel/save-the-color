package com.classes {
	
	import flash.display.MovieClip;
	
	public class Enemy1 extends MovieClip {
		private var speedX:int = 15;
		private var speedY:int = 15;
		private var health:int;
		
		public function Enemy1(health:int) {
			this.health = health;
		}
		
		public function dies():Boolean{ //Просчитываем кол-во очков жизни у монстра
			health--;
			if (health < 1){
				return true;
			}
			else{
				return false;
			}
		}
	}
	
}
