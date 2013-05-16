package com.classes {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.system.fscommand;
	
	import flash.display.MovieClip;
	
	
	public class Intro extends MovieClip {
		
		public function Intro() {
			gotoAndPlay(0); //Стартуем анимацию вступительного ролика
			btn_skip.buttonMode = true; //Делаем из мувиклипа с текстом кнопку, чтоб указатель мыши был рукой
			btn_skip.addEventListener(MouseEvent.CLICK, skipIntro); //Слушатель события клика мыши по одной из кнопок. Если игрок кликнул - перескакиваем на следующий кадр
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keydownHandler); //Слушатель событий нажатия кнопок (для пропуска интро с помощью эскейпа
			MovieClip(parent).setChildIndex(MovieClip(parent).soundControl, MovieClip(parent).soundControl.parent.numChildren-1); //Помещаем значок звука на самый верх
		}
		
		private function skipIntro(e:MouseEvent){
			this.gotoAndStop(0);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keydownHandler);
			MovieClip(parent).gotoAndPlay("game");
		}
		
		private function keydownHandler(e:KeyboardEvent){
			if(e.keyCode == 27 || e.keyCode == 13){
				skipIntro(null);
			}
		}
	}
	
}
