package com.classes {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import com.senocular.KeyObject;
	import com.classes.Menu;
	import flash.display.Stage;
	import flash.text.TextField;
	
	public class Base extends MovieClip {
		//глобальные переменные
		private var difficulty:int = 0;
		
		//---------------------
		public function Base() {
			addChild(new Menu());
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function keyDownHandler(e:KeyboardEvent){
			 /*if(e.keyCode == 27){
				this.addChild(menu);
				menu.toggleActions(); 
			 }*/
		}
		
		public function setDifficulty(difficulty):void{ //Даём возможность сохранять глобальную переменную, обозначающую сложность игры
			this.difficulty = difficulty;
			//trace('difficulty set to: ' + difficulty);
		}
		
		public function getDifficulty():int{ //Даём возможность считывать глобальную переменную, обозначающую сложность игры
			//trace('here your difficulty: ' + this.difficulty);
			return this.difficulty;
		}
	}
}