﻿package com.wastedpotential {	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.KeyboardEvent;	import flash.text.TextField;	import flash.utils.setTimeout;	import flash.ui.ContextMenu;	import flash.ui.ContextMenuItem;	import flash.events.ContextMenuEvent;		public class Main extends MovieClip {		private var testingConsole:TestingGUI = new TestingGUI();		private static var contextItem:ContextMenuItem;				private var _currentKeys:Array = [];		private var _currentKey:int = 0;		private var _nextKey:int = 0;		private var _currentPosition:int = 0;		private var lives:int = 0;		private var score:int = 0;		private var level:int = 1;		private var babies:Array = [];		private var nStart:Number;		private var millisElapsed:Number;		private var isFirst:Boolean = true;		private var isStarted:Boolean = false;		private var bounceXs:Array = [];				private var listenForKeys:Array = [];				private const livesText:String = "LIVES REMAINING: ";		private const scoreText:String = "SCORE: ";		public static const LEFT:int = 37;		public static const RIGHT:int = 39;		public static const Z_KEY:int = 90;		public static const X_KEY:int = 88;		public static const C_KEY:int = 67;				//stage instances:		public var placer1_mc:MovieClip;		public var placer2_mc:MovieClip;		public var placer3_mc:MovieClip;		public var floor_mc:MovieClip;		public var bouncer_mc:MovieClip;		public var lives_txt:TextField;		public var score_txt:TextField;		public var oops_mc:MovieClip;		public var startBu_mc:MovieClip;		//- constructor		public function Main() {			trace("Main :: CONSTRUCTOR");						oops_mc.visible = false;			bounceXs = [placer1_mc.x, placer2_mc.x, placer3_mc.x];						_currentPosition = 1; //bouncer current position						listenForKeys = [LEFT, RIGHT, Z_KEY, X_KEY, C_KEY]; 									startBu_mc.mouseEnabled = true;			startBu_mc.addEventListener(MouseEvent.CLICK, onStartGame);			isStarted = false;			addEventListener(Event.ADDED_TO_STAGE, onAdded);		}				private function onAdded(e:Event=null):void {			removeEventListener(Event.ADDED_TO_STAGE, onAdded);			stage.addChild(testingConsole); //add the minimal comps testing panel.			testingConsole.visible = false; //hide the testing panel						//add the testing panel to the flash context menu:			var contextMenu:ContextMenu = new ContextMenu();			contextMenu.hideBuiltInItems();			contextItem = new ContextMenuItem("Show Testing Console", true);			contextMenu.customItems = [contextItem];			this.contextMenu = contextMenu;			contextItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, toggleTestConsole);					}				//- shows or hides the minimal comps testing console:		private function toggleTestConsole(e:ContextMenuEvent):void{			//trace("Main :: toggleTestConsole");			if (testingConsole.visible) { //hide the console:				if (isStarted) {					addGameListeners();				}				testingConsole.visible = false; 				contextItem.caption = "Show Testing Console";			}			else { //show the console:				removeGameListeners();				testingConsole.visible = true; 				contextItem.caption = "Hide Testing Console";			}		}					private function onStartGame(e:MouseEvent=null):void {			startBu_mc.removeEventListener(MouseEvent.CLICK, onStart);			startBu_mc.visible = false;			isStarted = true;			resetGame();			resetLevel();		}				private function resetLevel():void {			addBaby();		}				private function resetGame():void {			updateLives(5);			updateScore(0);			addGameListeners();		}				private function addBaby():void {			var newBaby:MovieClip = new Baby();			newBaby.init(bouncer_mc);			babies.push(newBaby);			addChild(newBaby);		}				private function onStart(e:Event=null):void {			nStart = new Date().time;		}				private function onBabyDie(e:Event=null):void {							//stop keyboard input			removeGameListeners();				setTimeout(postDie, 2000);			oops_mc.visible = true;		}				private function onBabyScore(e:Event=null):void {			//trace("Main :: onBabyScore");			millisElapsed = new Date().time - nStart;			trace(millisElapsed);			isFirst = false;			for (var i:int=0; i<babies.length; i++) {				if (babies[i].isScore) {					removeChild(babies[i]);					babies[i] = null;					babies.splice(i, 1);					break;				}			}			updateScore(1);			addBaby();		}				private function postDie():void {			//remove dead baby			for (var i:int=0; i<babies.length; i++) {				if (babies[i].isDead) {					removeChild(babies[i]);					babies[i] = null;					babies.splice(i, 1);					break;				}			}			//update lives			updateLives(-1);			if (lives <= 0) {				gameOver();			}			else {				//unpause game and restart keyboard input				addGameListeners();				if (level == 1) {					addBaby();				}			}						oops_mc.visible = false;		}				private function updateLives(numToAdd:int):void {			lives += numToAdd;			lives_txt.text = livesText + lives;		}				private function updateScore(numToAdd:int):void {			//trace("Main :: updateScore: "+ score + " + 1");			score += numToAdd;			score_txt.text = scoreText + score;		}				private function gameOver():void {			trace("game over!!!");			removeGameListeners();			startBu_mc.addEventListener(MouseEvent.CLICK, onStartGame);			startBu_mc.visible = true;			isStarted = false;					}				private function handleKeyDown(e:KeyboardEvent=null):void {			//trace("down: "+e.keyCode);			var keyCode:int = e.keyCode;			if (listenForKeys.indexOf(keyCode) >= 0) {				//trace("i'm listening for it!");				var found:int = _currentKeys.indexOf(keyCode);				//trace(found);				if (found < 0) {					keyPressed(keyCode);					_currentKeys.push(keyCode);				}			}		}				private function handleKeyUp(e:KeyboardEvent=null):void {			//trace("up: "+e.keyCode);			var found:int = _currentKeys.indexOf(e.keyCode);			/*if (_currentKey == e.keyCode) {				_currentKey = null;			}*/			if (found >= 0) {				//trace(found);				_currentKeys.splice(found, 1);			}		}				private function keyPressed(keyCode:int):void {			_nextKey = keyCode;		}				private function onFrame(e:Event=null):void {									//handle key input:			if (_nextKey != _currentKey) {				//trace("moveMe "+ _nextKey);				if (_nextKey == LEFT) {					//trace("LEFT");					if (_currentPosition > 0) {						_currentPosition--;														}				}				else if(_nextKey == RIGHT) {					//trace("RIGHT");					if (_currentPosition < 2) {						_currentPosition++;														}				}				else if(_nextKey == Z_KEY) {					//trace("Z");					_currentPosition = 0;				}				else if (_nextKey == X_KEY) {					//trace("X");					_currentPosition = 1;				}				else if (_nextKey == C_KEY) {					//trace("C");					_currentPosition = 2;				}				_currentKey = _nextKey;				_nextKey = 0; //this allows arrow keys to be pressed again!						}						bouncer_mc.x = bounceXs[_currentPosition];									for(var i:int=0; i<babies.length; i++) {				babies[i].update();			}					}		private function addGameListeners():void {			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);        	stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);									addEventListener(Event.ENTER_FRAME, onFrame);			addEventListener("die", onBabyDie);			addEventListener("start", onStart);			addEventListener("score", onBabyScore);		}				private function removeGameListeners():void {			stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);        	stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);									removeEventListener(Event.ENTER_FRAME, onFrame);			removeEventListener("die", onBabyDie);			removeEventListener("start", onStart);			removeEventListener("score", onBabyScore);		}	}	}