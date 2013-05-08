﻿package com.wastedpotential {	import flash.display.MovieClip;	import flash.events.Event;		public class Baby extends MovieClip {		private var bouncer:MovieClip;		private var deathY:Number = 300;		private var currentArc:int = 0;		private var hitTestEnabled:Boolean = true;		private var _isDead:Boolean = false;		private var _isScore:Boolean = false;				private var currentX:Number;		private var currentY:Number;		private var v0:Number = 0.5; //speed that babies move towards launch point:		private var vX:Number = 1;				private var xOffset0:int = 0;		private var A0:Number = 0;		private var B0:Number = 0;		private var C0:Number = 75;		private var maxX0:Number = 32;		 		private var xOffset1:int = -35;		private var A1:Number = 0.04167474316728048;		private var B1:Number = -6.001163016088389;		private var C1:Number = 290;		 		private var xOffset2:int = 109;		private var A2:Number = 0.036658811207122284;		private var B2:Number = -4.5456925896831635;		private var C2:Number = 290;		 		private var xOffset3:int = 233;		private var A3:Number = 0.020049008687903765;		private var B3:Number = -2.6865671641791047;		private var C3:Number = 290;		 		private var xOffset4:int = 367;		private var A4:Number = 0.013366005791935844;		private var B4:Number = -1.791044776119403;		private var C4:Number = 290;						public function Baby() {			// constructor code			this.x = 0;			this.y = C0;		}				public function init(bouncer:MovieClip):void {			this.bouncer = bouncer;		}				public function get isDead():Boolean {			return _isDead;		}				public function get isScore():Boolean {			return _isScore;		}				public function update():void {			if (this.y >= deathY) {				if (currentArc == 4) {					score();				}				else {					die();				}			}			if (hitTestEnabled && bouncer.hitTestObject(this)) {				if (currentArc == 1) {					currentArc = 2;					this.x = xOffset2;				}				else if (currentArc == 2) {					currentArc = 3;					this.x = xOffset3;				}				else if (currentArc == 3) {					currentArc = 4;					this.x = xOffset4;									}				vX *= Settings.speedMultiplier;				hitTestEnabled = false;			}									var xOffset:Number;			var A:Number;			var B:Number;			var C:Number;			var currentX:Number = this.x;			if (currentArc == 0) {				xOffset = xOffset0;				A = A0;				B = B0;				C = C0;				currentX += v0;				if (currentX >= maxX0) {					dispatchEvent(new Event("start", true, true));					currentArc = 1;				}			}			else if (currentArc == 1) {				xOffset = xOffset1;				A = A1;				B = B1;				C = C1;				currentX += vX;			}			else if (currentArc == 2) {				xOffset = xOffset2;				A = A2;				B = B2;				C = C2;				currentX += vX;			}			else if (currentArc == 3) {				xOffset = xOffset3;				A = A3;				B = B3;				C = C3;				currentX += vX;			}						else { //the last bounce segment before it loops				xOffset = xOffset4;				A = A4;				B = B4;				C = C4;				currentX += vX;			}			currentY = A*(currentX - xOffset)*(currentX - xOffset) + B*(currentX - xOffset) + C;			this.x = currentX;			this.y = currentY;			if (this.y < 250) {				hitTestEnabled = true;			}						}				private function die():void {			//trace("DIE");			_isDead = true;			dispatchEvent(new Event("die", true, true));		}				private function score():void {			//trace("Baby :: score");			_isScore = true;			dispatchEvent(new Event("score", true, true));					}	}	}