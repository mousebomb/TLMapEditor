/**
 * Created by Administrator on 2017/2/10.
 */
package tl.mapeditor.ui.window
{
	import flash.events.MouseEvent;

	import tl.mapeditor.ui.common.MyButton;

	import tl.mapeditor.ui.common.MyDragBar;
	import tl.mapeditor.ui.common.MySprite;

	import tl.mapeditor.ui.common.MyTextField;

	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;

	/**地形笔刷设置*/
	public class BrushSettingUI extends UIBase
	{
		public var vectorTxt:Vector.<MyTextField> ;
		public var vectorDragBar:Vector.<MyDragBar> ;
		public var showBtn:MyButton;
		public var hideBtn:MyButton;
		public function BrushSettingUI()
		{
			super();
		}

		override public function init(title:String, $width:int = 100, $height:int = 100, bgColor:uint = 0x2F2E2E, hasCloseBtn:Boolean = true, isDrag:Boolean = true):void
		{
			if(this.isInit) return;
			this.isInit = true;
			super.init(title, $width, $height, bgColor, hasCloseBtn, isDrag);

			var bgSpr:MySprite = new MySprite();
			this.addChild(bgSpr);
			Tool.drawRectByGraphics(bgSpr.graphics, null, this.myWidth-30, this.myHeight-40, 0x191818, 1, 0, 0, 1, 0x3D3D3D);
			bgSpr.x = 15;
			bgSpr.y = titleY;
			var text:MyTextField;
			var dragBar:MyDragBar;
			vectorTxt = new <MyTextField>[];
			vectorDragBar = new <MyDragBar>[];
			var labelArr:Array = ['笔刷大小', '笔刷强度', '柔和', '最高值', '最低值', 300, 200, 1, 2047, -2048];
			for (var i:int=0; i<5; i++)
			{
				text = Tool.getMyTextField(70, -1, 12, 0x999999, "center");
				text.background = true;
				text.backgroundColor = 0x191919;
				text.border = true;
				text.borderColor = 0x3D3D3D;
				text.text = labelArr[i];
				text.mouseEnabled = text.mouseWheelEnabled = false;
				bgSpr.addChild(text);
				text.y = 36 * i + 15;
				text.x = 17;

				dragBar = new MyDragBar();
				bgSpr.addChild(dragBar);
				if(i == 1)
					dragBar.isNegative = true;
				dragBar.name = 'BrushSettingUI_' + i;
				dragBar.maxValue = labelArr[i + 5]
				dragBar.y = 36 * i + 15;
				dragBar.x = 100;
				vectorDragBar.push(dragBar);

				text = Tool.getMyTextField(70, -1, 12, 0x999999, "center");
				text.background = true;
				text.backgroundColor = 0x191919;
				text.border = true;
				text.borderColor = 0x3D3D3D;
				text.text = dragBar.dragBarPercent + '';
				text.mouseEnabled = text.mouseWheelEnabled = false;
				bgSpr.addChild(text);
				text.y = 36 * i + 15;
				text.x = dragBar.x + dragBar.myWidth + 10;
				vectorTxt.push(text);
			}
			showBtn = Tool.getMyBtn('显示地形刷', 120);
			showBtn.name = '显示地形刷';
			this.addChild(showBtn);
			showBtn.x = 60;
			showBtn.y = 230;

			hideBtn = Tool.getMyBtn('隐藏地形刷', 120);
			hideBtn.name = '隐藏地形刷';
			this.addChild(hideBtn);
			hideBtn.x = 240;
			hideBtn.y = 230;
		}

		override protected function onClickClose(e:MouseEvent = null):void
		{
			super.onClickClose(e);
		}
	}
}
