package tl.mapeditor.ui.common
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	import tl.mapeditor.ResourcePool;
	import tl.utils.Tool;

	import tool.StageFrame;

	/**
	 * UI基类提供关闭按钮，响应拖动UI的标题文本,
	 */	
	public class UIBase extends MySprite
	{
		private var _closeBtn:MyButton;
		protected const titleY:int = 25;
		
		private var _titleText:MyTextField;
		private var _isDrag:Boolean = true;
		
		private var _isShowWindow:Boolean = false;
		
		public function UIBase()  {  super();  }
		
		/**
		 * 初始化
		 * @param title			: 标题文字
		 * @param $width		: 窗口宽度
		 * @param $height		: 窗口高度
		 * @param bgColor		: 背景颜色
		 * @param hasCloseBtn	: 是否显示关闭按钮
		 * @param isDrag		: 是否可拖动
		 */		
		public function init(title:String, $width:int = 100, $height:int = 100, bgColor:uint = 0x2F2E2E, hasCloseBtn:Boolean = true, isDrag:Boolean = true):void
		{
			//绘制背景
			_isDrag = isDrag;
			this.myWidth = $width;
			this.myHeight = $height;
			this.drawRect($width, $height, bgColor);
			//绘制渐变线
			var matr:Matrix = new Matrix();
			matr.createGradientBox(this.myWidth, 40, Math.PI/2, 0, 0);
			_graphics.beginGradientFill(GradientType.LINEAR, [0x4F4F4F, 0x2F2E2E], [100, 30], [0, 100], matr);
			_graphics.drawRect(0, 0, this.myWidth, 30);
			_graphics.endFill();
			//标题文本
			_titleText = Tool.getMyTextField(this.myWidth, -1, 16, 0xCCCCCC, "center");
			this.addChild(_titleText);
			_titleText.text = title;
			_titleText.selectable = false;
			_titleText.y = titleY - _titleText.height - 2;
			_titleText.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//关闭按钮
			if(hasCloseBtn)
			{
				var checkSelectBtmd:BitmapData = ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_CheckButton_Select");
				_closeBtn = Tool.getMyBtn("", checkSelectBtmd.width, checkSelectBtmd.height, checkSelectBtmd, checkSelectBtmd, checkSelectBtmd);
				this.addChild(_closeBtn);
				_closeBtn.x = this.myWidth - _closeBtn.myWidth - 7;
				_closeBtn.y = (titleY - _closeBtn.myHeight)/2;
				_closeBtn.addEventListener(MouseEvent.CLICK, onClickClose);
			}
		}
		/** 点下标题 **/
		protected function onMouseDown(e:MouseEvent):void
		{
			if(this.parent)
				this.parent.setChildIndex(this, this.parent.numChildren - 1);
			if(!_isDrag) return;
			StageFrame.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.startDrag();
			e.stopImmediatePropagation();
		}
		/** 松开标题 **/
		protected function onMouseUp(e:MouseEvent):void
		{
			StageFrame.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.stopDrag();
			e.stopImmediatePropagation();
		}
		/** 点击关闭按钮 **/
		protected function onClickClose(e:MouseEvent = null):void
		{
			_isShowWindow = false; 
			if(this.parent)
				this.parent.removeChild(this);
		}
		/**
		 * 设置标题
		 * @param value	: 标题名
		 */		
		public function set title(value:String):void
		{
			_titleText.text = value;
		}

		/** 关闭窗口 **/
		public function closeWindow():void  
		{ 
			onClickClose();
		}
		/** 是否显示窗口中 **/
		public function get isShowWindow():Boolean  {  return _isShowWindow;  }

		
	}
}