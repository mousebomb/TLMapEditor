/*
 Copyright (c) 2009 Paulius Uza  <paulius@uza.lt>
 http://www.uza.lt
 All rights reserved.
  
 Permission is hereby granted, free of charge, to any person obtaining a copy 
 of this software and associated documentation files (the "Software"), to deal 
 in the Software without restriction, including without limitation the rights 
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished 
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all 
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

@ignore
*/
 
package tl.mapeditor.ui.common
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/* VERSION 1.0 */

	public class MyScale9SimpleStateButton extends MyScale9BitmapSprite
	{
		
		/**
		 * STATE BITMAP DATA OBJECTS
		 */
		 
		private var state_normal:BitmapData;
		private var state_hover:BitmapData;
		private var state_down:BitmapData;
		
		/**
		 * STATE PARAMETERS
		 */
		
		private var has_hover:Boolean = false;
		private var has_down:Boolean = false;
		private var hovering:Boolean = false;
		private var is_selected:Boolean = false;
		
		/**
		 * SCALE 9
		 */
	
		private var scaling_grid:Rectangle;
		//private var this:Scale9BitmapSprite;
		public function MyScale9SimpleStateButton(){}

		/**
		 * Boolean "selected" allows to toggle the button. 
		 * When "selected" is set to true, only "down" state of the button is displayed.
		 */

		public function set selected(value:Boolean):void {
			is_selected = value;
			if(is_selected) {
				this.updateState(state_down);
			} else {
				if(hovering) {
					this.updateState(state_hover);
				} else {
					this.updateState(state_normal);
				}
			}
		}
		
		/**
		 *  Returns Boolean
		 *  representing if the button is selected
		 */
		
		public function get selected():Boolean {
			return is_selected;
		}
		
		/**
		 *  CONSTRUCTOR
		 *  - grid: Rectangle representing the central area of scale9 grid. For ex.: for a 126x26 bitmap you would set the grid as: new Rectangle(3,3,120,20);
		 *  - normal: BitmapData representing "normal" state of the button
		 *  - hover: BitmapData (optional) representing "hover" state of the button
		 *  - down: BitmapData (optional) representing "down" state of the button
		 */
		
		public function InIt(grid:Rectangle, normal:BitmapData, hover:BitmapData = null, down:BitmapData = null)
		{
			scaling_grid = grid;
			state_normal = normal.clone();
			
			if(hover) {
				has_hover = true;
				state_hover = hover.clone();
			} else {
				state_hover = normal.clone();
			}
			if(down) {
				has_down = true;
				state_down = down.clone();
			} else {
				state_down = normal.clone();
			}
			
			if(state_normal.rect.equals(state_hover.rect) && state_normal.rect.equals(state_down.rect)) {
				init();
			} else {
				/* 
				 * WIDTH AND HEIGHT OF THE BITMAP DATA OBJECT REPRESENTING EACH STATE (NORMAL, HOVER, DOWN) 
				 * MUST BE EQUAL. 
				 */
				throw(new Error("State bitmap data dimensions must be equal"));
			}
		}
		
		/**
		 * Event Handler
		 * On Mouse Over
		 */
		
		private function onStateRollOver(evt:MouseEvent):void {
			hovering = true;
			if(!is_selected) {
				this.updateState(state_hover);
			}
		}
		
		/**
		 * Event Handler
		 * On Mouse Out
		 */
		
		private function onStateRollOut(evt:MouseEvent):void {
			hovering = false;
			if(!is_selected) {
				this.updateState(state_normal);
			}
		}
		
		/**
		 * Event Handler
		 * On Mouse Down
		 */
		
		private function onStateMouseDown(evt:MouseEvent):void {
			this.updateState(state_down);
		}
		
		/**
		 * Event Handler
		 * On Mouse Up
		 */
		
		private function onStateMouseUp(evt:MouseEvent):void {
			if(!selected) {
				if(hovering) {
					this.updateState(state_hover);
				} else {
					this.updateState(state_normal);
				}
			}
		}
		
//		/**
//		 * Event Handler
//		 * On Mouse Click
//		 */
//		
//		private function onStateClick(evt:MouseEvent):void {
//			dispatchEvent(new Scale9SimpleStateEvent(this,Scale9SimpleStateEvent.CLICKED));
//		}
		
//		/**
//		 * Variable override
//		 * Passes the width parameter to current button this
//		 */
//		
//		override public function set width(width : Number) : void {
//			this.width = width;
//		}
//		
//		/**
//		 * Variable override
//		 * Gets the current width of the button this
//		 */
//		
//		override public function get width():Number {
//			return this.width;
//		}
//		
//		/**
//		 * Variable override
//		 * Passes the height parameter to current button this
//		 */
//
//		override public function set height(height : Number) : void {
//			this.height = height;
//		} 
//		
//		/**
//		 * Variable override
//		 * Gets the current height of the button this
//		 */
//		
//		override public function get height():Number {
//			return this.height;
//		}
		
		/**
		 * Variable override
		 * Passes the scaleX parameter to current button this
		 */
		
		override public function set scaleX(scale:Number):void {
			this.scaleX = scale;
		}
		
		/**
		 * Variable override
		 * Gets the current scaleX of the button this
		 */
		
		override public function get scaleX():Number {
			return this.scaleX;
		}
		
		/**
		 * Variable override
		 * Passes the scaleY parameter to current button this
		 */
		
		override public function set scaleY(scale:Number):void {
			this.scaleY = scale;
		}
		
		/**
		 * Variable override
		 * Gets the current scaleY of the button this
		 */
		
		override public function get scaleY():Number {
			return this.scaleY;
		}
		
		/**
		 * Main Initialization Function
		 * Initializes the button this
		 * Sets button defaults
		 * Sets up event listeners for appropriate button states
		 */
		
		private function init():void {
			buttonMode = true;
			useHandCursor = true;
			//this = new Scale9BitmapSprite();
			this.SpriteInIt(state_normal, scaling_grid);
			//addChild(this);
			if(has_hover) {
				addEventListener(MouseEvent.ROLL_OVER, onStateRollOver);
				addEventListener(MouseEvent.ROLL_OUT, onStateRollOut);
			}
			if(has_down) {
				addEventListener(MouseEvent.MOUSE_DOWN, onStateMouseDown);
				addEventListener(MouseEvent.MOUSE_UP,onStateMouseUp);
			}
			//addEventListener(MouseEvent.CLICK,onStateClick);
		}
	}
}