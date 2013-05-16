package com.classes {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Enemy1 extends MovieClip {
		private var speedX:int = 15;
		private var speedY:int = 15;
		private var health:int;
		
		public function Enemy1(health:int) {
			this.health = health;
		}
		
		public function hit():Boolean{ //Просчитываем кол-во очков жизни у монстра
			health--;
			return isDead();
		}
		
		public function isDead():Boolean{
			if (health < 1){
				return true;
			}
			else{
				return false;
			}
		}
		
		public function speed(pos:Point = null):Point{
			if (pos){
				speedX = pos.x;
				speedY = pos.y;
			}
			return (new Point(speedX, speedY));
		}
	}
	
}
