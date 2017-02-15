package tl.mapeditor.ui.common
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	public class MyTextButton extends MyTextField
	{
		private var _upColor:uint = 0x0;				//up颜色(默认黑色)
		private var _overColor:uint = 0x666666;		//over颜色(默认灰色)
		private var _downColor:uint = 0x057BB2;		//down颜色(默认深蓝色)
		private var _disabledColor:uint = 0x808080;	//失效颜色(默认灰色)
		private var _selectedColor:uint = 0xFFEC6A;	//选中颜色(默认金色)
		
		private var _isSelected:Boolean = false;		//是否为选中状态
		private var _disabled:Boolean = false;		//是否废除状态
		

		public function MyTextButton()  {  super(); init(); }
		
		private function init():void
		{
			//设置文字样式
			this.color = _upColor;
			this.selectable = false;
			
			//添加事件
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
/********************************************事件处理************************************************/
		/** up事件 **/
		private function onMouseUp(e:MouseEvent):void
		{
			if(_disabled) return;
			if(_isSelected) return;
			this.color = _upColor;
			this.text = this.text;
		}
		/** down事件 **/
		private function onMouseDown(e:MouseEvent):void
		{
			if(_disabled) return;
			if(_isSelected) return;
			this.color = _downColor;
			this.text = this.text;
		}
		/** over事件 **/
		private function onMouseOver(e:MouseEvent):void
		{
			if(_disabled) return;
			if(_isSelected) return;
			this.color = _overColor;
			this.text = this.text;
		}
		/** out事件 **/
		private function onMouseOut(e:MouseEvent):void
		{
			if(_disabled) return;
			if(_isSelected) return;
			this.color = _upColor;
			this.text = this.text;
		}
/********************************************外部方法************************************************/
		/**
		 * 设置颜色样式 
		 * @param arr	: 文字按钮颜色数组,类型要是16进制颜色值
		 * 				: ([0]:up颜色 [1]:over颜色 [2]:down颜色 [3]:disabled(失效)颜色 [4]:selected(选中)颜色)
		 */		
		public function setColor(arr:Array):void
		{
			_upColor = arr[0];
			_overColor = arr[1];
			_downColor = arr[2];
			_disabledColor = arr[3];
			_selectedColor = arr[4];
			
			this.color = _upColor;
		}
		/** 根据文字长度更新按钮大小 **/
		public function updateSize():void
		{
			this.width = this.textWidth+4;
			this.height = this.textHeight+4;
		}
		/**
		 * 设置是否选中
		 * @param value	: true:选中 false:不选中
		 */		
		public function set selected(value:Boolean):void  
		{  
			_isSelected = value;  
			if(_isSelected)
				this.color = _selectedColor;
			else
				this.color = _upColor;
			this.text = this.text;
		}
		public function get selected():Boolean 			 { return  _isSelected;  }
		/**
		 * 是否为废除状态
		 * @param value	: true:废除状态 false:非废除状态
		 */		
		public function set disabled(value:Boolean):void
		{
			_disabled = value;
			if(_disabled)	this.color = _disabledColor;
			else			this.color = _upColor;
			this.text = this.text;
		}
		public function get disabled():Boolean { return _disabled; }
		
		/** 清除方法 **/
		public function clear():void
		{
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			this.dispatchEvent(new Event("ClearComponent"));
		}
		
		public function set upColor(value:uint):void  {  _upColor = value;  }
		public function get upColor():uint  {  return _upColor;  }

		public function set overColor(value:uint):void  {  _overColor = value;  }
		public function get overColor():uint  {  return _overColor;  }

		public function set downColor(value:uint):void  {  _downColor = value;  }
		public function get downColor():uint  {  return _downColor;  }

		public function set disabledColor(value:uint):void  {  _disabledColor = value;  }
		public function get disabledColor():uint  {  return _disabledColor;  }

		public function set selectedColor(value:uint):void  {  _selectedColor = value;  }
		public function get selectedColor():uint  {  return _selectedColor;  }
	}
}