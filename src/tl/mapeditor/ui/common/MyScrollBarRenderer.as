/**
 * Created by Administrator on 2017/2/28.
 */
package tl.mapeditor.ui.common
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;

	import tl.utils.Tool;

	public class MyScrollBarRenderer extends MySprite
	{
		private var _showBm:Bitmap;
		private var _bgBm:Bitmap;
		private var _rendererData:Object;
		private var _add_up:BitmapData;
		private var _labelTxt:MyTextField;
		private var _isSelected:Boolean = false;
		private var _upBmd:BitmapData;
		private var _overBmd:BitmapData;
		private var _selectBmd:BitmapData;
		private var _add_down:BitmapData ;
		public function MyScrollBarRenderer()
		{
			super();
		}

		public function init(mw:int, mh:int):void
		{
			if(this.isInit)
			{
				_bgBm.width = mw;
				_bgBm.height = mh;
				this.myWidth = _bgBm.width ;
				this.myHeight = _bgBm.height ;
				_labelTxt.width = mw;
				_labelTxt.y = this.myHeight - 12 >> 1;
				return;
			}
			this.isInit = true;
			_upBmd = new renderer_up();
			_bgBm = new Bitmap(_upBmd);
			this.addChild(_bgBm);
			_bgBm.width = mw;
			_bgBm.height = mh;
			this.myWidth = _bgBm.width ;
			this.myHeight = _bgBm.height ;
			_labelTxt = Tool.getMyTextField(myWidth, -1, 12, 0x999999, "center", 4);
			_labelTxt.mouseEnabled = _labelTxt.mouseWheelEnabled = false;
			_labelTxt.y = this.myHeight - 12 >> 1;
			this.addChild(_labelTxt)
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
		}


		/** 按钮点击事件 **/
		private function onMouseEvent(e:MouseEvent):void
		{
			if (_isSelected) return;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER:
					if(!_overBmd)
						_overBmd = new renderer_over();
					_bgBm.bitmapData = _overBmd;
					break;
				case MouseEvent.MOUSE_OUT:
					_bgBm.bitmapData = _upBmd;
					break;
			}
		}
		public function updateRenderer(data:Object, isShow:Boolean=false):void
		{
			_rendererData = data;
			if(isShow)
			{
				if(!_showBm)
				{
					_add_up = new Skin_add_down();
					_showBm = new Bitmap(_add_up)
					_showBm.x = this.myWidth - _add_up.width - 10;
					_showBm.y = this.myHeight - _add_up.height >> 1;
					this.addChild(_showBm)
				}	else {
					_showBm.visible = true;
					_showBm.bitmapData = _add_up;
				}
			}	else if(_showBm) {
				_showBm.visible = false;
			}
			_labelTxt.text = data.label;
		}

		public function get isSelected():Boolean
		{
			return _isSelected;
		}

		public function set isSelected(value:Boolean):void
		{
			_isSelected = value;
			if(value)
			{
				if(!_selectBmd)
					_selectBmd = new renderer_selected();
				_bgBm.bitmapData = _selectBmd;
				if(_showBm)
				{
					if(!_add_down)
					{
						_add_down = new Skin_cut_down();
					}
					_showBm.bitmapData = _add_down;
				}
			}	else {
				_bgBm.bitmapData = _upBmd;
				if(_showBm)
				{
					_showBm.bitmapData = _add_up;
				}
			}
		}

		public function get rendererData():Object
		{
			return _rendererData;
		}

		public function set rendererData(value:Object):void
		{
			_rendererData = value;
		}
	}
}
