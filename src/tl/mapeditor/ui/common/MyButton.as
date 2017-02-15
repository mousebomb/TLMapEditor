package tl.mapeditor.ui.common
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;

	import tl.mapeditor.ResourcePool;
	import tl.utils.Tool;

	public class MyButton extends MySprite
	{
		private var _upBtmd:BitmapData;			//按钮样式bitmapdata
		private var _overBtmd:BitmapData;
		private var _downBtmd:BitmapData;
		private var _disabledBtmd:BitmapData;
		private var _selectedBtmd:BitmapData;

		private var _isSelected:Boolean = false;	//当前是否选中状态
		private var _isDisabled:Boolean = false;	//是否失效状态

		private var _styleBitmap:Bitmap;			//显示按钮内容biemap
		private var _labelText:MyTextField;			//按钮显示文本
		private var _label:String = "";			//按钮文字

		//绘制按钮颜色值
		public var upColor:uint            = 0xFFB47015;
		public var overColor:uint          = 0xFFDBAC6D;
		public var downColor:uint          = 0xFFA45D0E;
		public var disabledColor:uint      = 0xFF8E908F;
		public var selectedColor:uint      = 0xFFCB8F42;
		//鼠标移动样式文本显示颜色
		public var upTextColor:uint        = 0xCCCCCC;
		public var overTextColor:uint      = 0xCCCCCC;
		public var downTextColor:uint      = 0xCCCCCC;
		public var disabledTextColor:uint  = 0xCCCCCC;
		public var selecteTextColor:uint   = 0xCCCCCC;
		public var isOpenTextColor:Boolean = false;	//是否开启鼠标移入按钮时文本变色功能
		public var isTextBold:Boolean      = true;			//按钮内容文本是否加粗
		public var isDispose:Boolean       = false;			//是否删除鼠标时调用dispose方法清除bitmapdata(一般用于外部自定义按钮皮肤后释放用)

		public function MyButton() { super(); }

		/**
		 * 初始化方法,如果需要自定义皮肤请先调用setSkin方法
		 * @param text        : 按钮显示文字(格式按HtextField中的colorLabel方法输入)
		 * @param myWidth    : 按钮宽度
		 * @param myHeight    : 按钮高度
		 */
		public function init(text:String = "", $myWidth:int = 50, $myHeight:int = 22):void
		{
			myWidth  = $myWidth;
			myHeight = $myHeight;
			//如果没有默认
			if (!_upBtmd)
			{
				isDispose     = true;
				_upBtmd       = new BitmapData(myWidth, myHeight, true, upColor);
				_overBtmd     = new BitmapData(myWidth, myHeight, true, overColor);
				_downBtmd     = new BitmapData(myWidth, myHeight, true, downColor);
				_disabledBtmd = new BitmapData(myWidth, myHeight, true, disabledColor);
				_selectedBtmd = new BitmapData(myWidth, myHeight, true, selectedColor);
			}
			//按钮样式位图
			_styleBitmap = new Bitmap();
			this.addChild(_styleBitmap);

			//实例化显示文本
			if (!_labelText)
			{
				_labelText = new MyTextField();
				this.addChild(_labelText);
				_labelText.mouseEnabled = false;
				_labelText.algin        = TextFormatAlign.CENTER;
				_labelText.color        = upTextColor;
				_labelText.bold         = isTextBold;
				_labelText.width        = myWidth;
				Tool.setDisplayGlowFilter(_labelText, 0x0, 1, 2, 2, 3);
			}

			drawTheButton(_upBtmd);
			label = text;

			//添加事件
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
		}

		/**
		 * 默认按钮样式
		 */
		public function setDefaultSkin():void
		{
			isDispose                   = false;
			var upBtmd:BitmapData       = new Skin_Button_Up
			var overBtmd:BitmapData     = new Skin_Button_Over;
			var downBtmd:BitmapData     = new Skin_Button_Down
			var disabledBtmd:BitmapData = new Skin_Button_Up
			var selectBtmd:BitmapData   = new Skin_Button_Select
			//设置皮肤
			setSkin(upBtmd, overBtmd, downBtmd, disabledBtmd, selectBtmd);
		}

		/**
		 * 设置按钮皮肤
		 * @param upBtmd        : 按钮UP样式
		 * @param overBtmd        : 按钮Over样式
		 * @param downBtmd        : 按钮Down样式
		 * @param disabledBtmd    : 按钮废除状态
		 * @param selectedBtmd    : 按钮选中状态
		 * @param isDraw        : 是否设置皮肤的时候就绘制按钮(true:绘制 false:不绘制,默认为不绘制,此参数一般再中途替换按钮皮肤时调用)
		 */
		public function setSkin(upBtmd:BitmapData = null, overBtmd:BitmapData = null, downBtmd:BitmapData = null,
								disabledBtmd:BitmapData = null, selectedBtmd:BitmapData = null, isDraw:Boolean = false):void
		{
			_upBtmd       = upBtmd;
			_overBtmd     = overBtmd;
			_downBtmd     = downBtmd;
			_disabledBtmd = disabledBtmd;
			_selectedBtmd = selectedBtmd;

			if (isDraw)
			{
				//绘制按钮样式
				drawTheButton(_upBtmd);
				//设置按钮文字位置
				label = label;
			}
		}

		/**
		 * 设置是否选中状态
		 * @param value    : 是否选中状态(true:选中状态 false:非选中状态)
		 */
		public function set selected(value:Boolean):void
		{
			_isSelected = value;
			if (_isSelected)
				drawTheButton(_selectedBtmd);
			else
				drawTheButton(_upBtmd);
			//设置选中按钮文本颜色
			if (isOpenTextColor)
			{
				if (_isSelected)
					_labelText.color = selecteTextColor;
				else
					_labelText.color = upTextColor;
				label = label;
			}
			this.dispatchEvent(new Event("Mouse_Selected"));
		}

		public function get selected():Boolean { return _isSelected; }

		/**
		 * 是否废除状态
		 * @param value    : 是否废除状态(true:废除状态 false:非废除状态)
		 */
		public function set disabled(value:Boolean):void
		{
			_isDisabled = value;
			if (_isDisabled)
			{
				drawTheButton(_disabledBtmd);
				this.mouseEnabled = false;
			}
			else
			{
				drawTheButton(_upBtmd);
				this.mouseEnabled = true;
			}
			//设置选中按钮文本颜色
			if (isOpenTextColor)
			{
				if (_isDisabled)
					_labelText.color = disabledTextColor;
				else
					_labelText.color = upTextColor;
				label = label;
			}
			this.dispatchEvent(new Event("Mouse_Disabled"));
		}

		public function get disabled():Boolean { return _isDisabled; }

		/**
		 * 设置按钮文字
		 * @param value    : 按钮显示文字样式,颜色格式为HTextField的colorLabel
		 */
		public function set label(value:String):void
		{
			_label            = value;
			_labelText.label  = value;
			_labelText.height = _labelText.textHeight + 4;
			_labelText.y      = (this.myHeight - _labelText.textHeight - 6) >> 1;
		}

		public function get label():String { return _label; }

		/** 获取按钮显示文本(一般用于特殊处理用,如修改描边样式) **/
		public function get labelText():MyTextField
		{ return _labelText; }

		/** 清除方法 **/
		public function clear():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);

			//清除文本
			if (_labelText.parent) _labelText.parent.removeChild(_labelText);

			//清除位图
			if (isDispose)
			{
				_upBtmd.dispose();
				_overBtmd.dispose();
				_downBtmd.dispose();
				_disabledBtmd.dispose();
				_selectedBtmd.dispose();
			}

			_upBtmd       = null;
			_overBtmd     = null;
			_downBtmd     = null;
			_disabledBtmd = null;
			_selectedBtmd = null;
			_labelText    = null;

			this.dispatchEvent(new Event("ClearComponent"));
		}

		/**
		 * 绘制按钮样式
		 * @param btmd    : 当前绘制的样式
		 */
		private function drawTheButton(btmd:BitmapData):void
		{
//			myWidth = btmd.width;
//			myHeight = btmd.height;
//			_labelText.width = myWidth;
			_styleBitmap.bitmapData = btmd;
			_styleBitmap.width      = myWidth;
			_styleBitmap.height     = myHeight;
		}

		/** 按钮点击事件 **/
		private function onMouseEvent(e:MouseEvent):void
		{
			if (_isSelected) return;
			if (_isDisabled) return;
			switch (e.type)
			{
				case MouseEvent.MOUSE_UP:
					drawTheButton(_overBtmd);
					if (isOpenTextColor)
					{
						_labelText.color = upTextColor;
						label            = label;
					}
					this.dispatchEvent(new Event("Mouse_Up"));
					break;
				case MouseEvent.MOUSE_DOWN:
					drawTheButton(_downBtmd);
					if (isOpenTextColor)
					{
						_labelText.color = downTextColor;
						label            = label;
					}
					this.dispatchEvent(new Event("Mouse_Down"));
					break;
				case MouseEvent.MOUSE_OVER:
					drawTheButton(_overBtmd);
					if (isOpenTextColor)
					{
						_labelText.color = overTextColor;
						label            = label;
					}
					this.dispatchEvent(new Event("Mouse_Over"));
					break;
				case MouseEvent.MOUSE_OUT:
					drawTheButton(_upBtmd);
					if (isOpenTextColor)
					{
						_labelText.color = upTextColor;
						label            = label;
					}
					this.dispatchEvent(new Event("Mouse_Out"));
					break;
			}
		}
	}
}