package com.classes{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.system.fscommand;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	public class Menu extends MovieClip{
		
		private var menuItems:Array = new Array(); //Массив для хранения кнопок меню
		private var texts:Array = ["New game", "About", "Exit"]; //Массив кнопок и текста кнопок
		private var difficulties:Array = ["Easy", "Medium", "Hard"]; //Массив текста сложности игры
		private var menuItemsNumber = texts.length; //Длина массива кнопок меню
		private var currentIndex:int = 0; //Сюда записываем номер меню, выбранного в данный момент
		private var newGameSelected:Boolean = false; //Флаг выбора новой игры
		
		//Настройки эффектов
		private var effectTime:Number = 1;
		private var customSize:Number = 1.2;
		
		public function Menu(){ //Конструктор вызывается при создании объекта класса "Меню"
			if(stage) init(null); //Из-за рассинхронизации добавления объекта на сцену на нужно проверять, добавлен ли этот объект уже на сцену
			else addEventListener(Event.ADDED_TO_STAGE, init); //если да, то просто вызываем функцию init(), в противном случае создаём слушатель событий для
		}														//добавления объекта на сцену и как только это произойдёт, всё равно запускаем функцию init()
		
		private function init(e:Event){
			removeEventListener(Event.ADDED_TO_STAGE, init); //удаляем слушатель событий
			//далее выполняй
			menuBuilder();
			animateLabel();
		}
		
		//Функция для включения/отключения слушателей событий для меню
		public function toggleActions(enable = true){ //Если опциональный парамент enable = true (по умолчанию), то функция включает слушатели событий. Если false - выключает
			if (enable){
				stage.addEventListener(KeyboardEvent.KEY_DOWN, navigateKeyboard); //Слушатель событий нажатия кнопок
				for (var i:int = 0; i < menuItemsNumber; i++){
					menuItems[i].addEventListener(MouseEvent.MOUSE_OVER, navigateMouse); //Слушатель событий, срабатывающий, если пользователь двигает мышь на одну из кнопок
					menuItems[i].addEventListener(MouseEvent.CLICK, menuAction); //Слушатель события клика мыши по одной из кнопок меню
				}
			}
			else{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, navigateKeyboard);
				for (i = 0; i < menuItemsNumber; i++){
					menuItems[i].removeEventListener(MouseEvent.MOUSE_OVER, navigateMouse);
					menuItems[i].removeEventListener(MouseEvent.CLICK, menuAction);
				}
			}
		}
		
		private function animateLabel(){
			TweenLite.delayedCall(Math.random()*5+1, function(){
				gameName.gotoAndPlay('animate');
				animateLabel();
			});
		}
		
		//Динамическое создание меню: проход по массиву кнопок, их отображение на экране, просчёт позиции кнопок и запуск анимации
		private function menuBuilder():void{
			var currentAnimationIndex:int = 0;
			for(var i:int = 0; i < menuItemsNumber; i++){
				menuItems[i] = new MenuButton(); //Создаём новую кнопку
				menuItems[i].name = i; //Даём каждой кнопке имя
				menuItems[i].x = stage.stageWidth/2 - menuItems[i].width/2; //Ставим каждую кнопку на начальную позицию x/y
				menuItems[i].y = 200 + 100 * i;
				menuItems[i].menuLabel.txt.text = texts[i]; //Записываем текст кнопки в объект кнопка.menuLabel.txt
				menuItems[i].menuLabel.txt.mouseEnabled = false; //Отключаем возможность выделения текста
				menuItems[i].buttonMode = true; //Делаем из пункта меню кнопку, чтоб указатель мыши был рукой
				
				//Смена внешнего вида кнопок меню (через одну)
				if (i%2 > 0){ //2%2 = 0, 3%2 = 1, 4%2 = 0
					menuItems[i].gotoAndStop('type1');
				}
				else{
					menuItems[i].gotoAndStop('type2');
				}
				
				//Запуск анимации кнопок меню с небольшой задержкой, чтобы они были несинхронные
				TweenLite.delayedCall(Math.random()*5, function(){
					menuItems[currentAnimationIndex].play();
					currentAnimationIndex++;
			    });
				
				addChild(menuItems[i]);
			}
			toggleActions(true); //Вешаем на кнопки слушатели событий
			addEffect(); //Выделяем первую кнопку
		}
		
		//Функция навигации по меню с помощью клавиатуры
		private function navigateKeyboard(e:KeyboardEvent):void{
			if(e.keyCode == 38){ //Кнопка вверх
				if (currentIndex > 0) //Проверяем, какой пункт меня сейчас выбран, если первый и я нажала вверх, то прыгаем на последний пункт меню
					updateMenu(currentIndex - 1);
				else //Если выбран последний пункт меню - то прыгаем на пункт 0
					updateMenu(menuItemsNumber - 1);
			}
			else if(e.keyCode == 40){ //Кнопка вниз
				if (currentIndex < menuItemsNumber - 1)
					updateMenu(currentIndex + 1);
				else
					updateMenu(0);
			}
			else if(e.keyCode == 13){ //Энтер
				menuAction();
			}
			else if(e.keyCode == 27 && newGameSelected){ //Кнопка Эскейп, если ранее был выбран пункт меню "New game"
				newGameSelected = false; //Сбрасываем флаг
				menuItemsNumber = texts.length; //И ставим обратно переменную общего кол-ва кнопок
				for(var i:int = 0; i < menuItemsNumber; i++){
					menuItems[i].menuLabel.txt.text = texts[i]; //Сбрасываем текст каждой кнопки на начальный
					menuItems[i].alpha = 1; //Снова отображаем все кнопки
				}
			}
		}
		
		//Функция нажатия кнопок меню (как мышью, так и клавиатурой)
		private function menuAction(e:MouseEvent = null){
			//trace(currentIndex + ': ' + texts[currentIndex]);
			var destination:String;
			
			if (newGameSelected){
				destination = "intro"; //Если мы в меню выбора сложности игры, выбор любого пункта запустит игру
				MovieClip(parent).setDifficulty(currentIndex); //Сохраняем выбранный уровень сложности в глобальном объекте Base
			}
			else{
				switch(currentIndex){ //Описываем, что будет происходить по нажатию разных пунктов меню
					case 0: //New Game
						choseDifficulty();
						return;
						//destination = "intro";
						break;
					case 1: //About
						destination = "about";
						break;
					case 2: //Exit
						fscommand("quit");
						break;
					default:
						destination = "menu";
				}
			}
			toggleActions(false);
			MovieClip(parent).gotoAndPlay(destination); //Прыгаем к нужному пункту в Timeline'е
			MovieClip(parent).removeChild(this); //Удаляем меню с экрана
		}
		
		//При выборе пункта меню "New game" даём игроку выбрать уровень сложности
		private function choseDifficulty():void{
			newGameSelected = true; //Меняем флаг выбора сложности
			for(var i:int = 0; i < menuItemsNumber; i++){
				if (i < difficulties.length){ //Сравниваем кол-во кнопок меню с кол-вом заданных уровней сложности
					menuItems[i].menuLabel.txt.text = difficulties[i];
				}
				else{ //Если кнопок меню больше, чем уровеней сложности, скрываем ненужные кнопки
					menuItems[i].alpha = 0;
					menuItems[i].removeEventListener(MouseEvent.MOUSE_OVER, navigateMouse);
					menuItems[i].removeEventListener(MouseEvent.CLICK, menuAction);
				}
			}
			menuItemsNumber = difficulties.length; 	//Даём переменной кол-ва кнопок значение длины массива текста уровней сложности, чтобы с помощью клавиатуры можно было
													//выбирать только между кнопками уровней сложности
		}
		
		//Функция навигации по меню с помощью мыши
		private function navigateMouse(e:MouseEvent):void{
			updateMenu(int(e.currentTarget.name));
		}
		
		//Анимация кнопок меню при их выделении
		private function addEffect():void{
			TweenLite.to(menuItems[currentIndex], effectTime, {scaleX:customSize, scaleY:customSize, ease:Elastic.easeOut});
		}
		
		//Обратная анимация кнопок меню при их выделении
		private function removeEffect():void{
			TweenLite.to(menuItems[currentIndex], effectTime, {scaleX:1, scaleY:1, ease:Elastic.easeOut});
		}
		
		//Функция смены выделенной кнопки
		private function updateMenu(newIndex):void{
			removeEffect();
			currentIndex = newIndex;
			addEffect();
		}
	}
}