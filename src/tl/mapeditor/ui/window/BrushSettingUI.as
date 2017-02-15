/**
 * Created by Administrator on 2017/2/10.
 */
package tl.mapeditor.ui.window
{
	import flash.events.MouseEvent;

	import tl.mapeditor.ui.common.MyDragBar;

	import tl.mapeditor.ui.common.MyTextField;

	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;

	/**地形笔刷设置*/
	public class BrushSettingUI extends UIBase
	{
		public var vectorTxt:Vector.<MyTextField> ;
		public var vectorDragBar:Vector.<MyDragBar> ;
		public function BrushSettingUI()
		{
			super();
		}

		override public function init(title:String, $width:int = 100, $height:int = 100, bgColor:uint = 0x2F2E2E, hasCloseBtn:Boolean = true, isDrag:Boolean = true):void
		{
			if(this.isInit) return;
			this.isInit = true;
			super.init(title, $width, $height, bgColor, hasCloseBtn, isDrag);

			var text:MyTextField;
			var dragBar:MyDragBar;
			vectorTxt = new <MyTextField>[];
			vectorDragBar = new <MyDragBar>[];
			var labelArr:Array = ['笔刷大小', '笔刷强度', '柔和', 300, 100, 1];
			for (var i:int=0; i<3; i++)
			{
				text = Tool.getMyTextField(70, -1, 12, 0x999999, "center");
				text.background = true;
				text.backgroundColor = 0x191919;
				text.border = true;
				text.borderColor = 0x3D3D3D;
				text.text = labelArr[i];
				text.mouseEnabled = text.mouseWheelEnabled = false;
				this.addChild(text);
				text.y = 36 * i + 50;
				text.x = 5;

				dragBar = new MyDragBar();
				this.addChild(dragBar);
				dragBar.name = 'BrushSettingUI_' + i;
				dragBar.maxValue = labelArr[i + 3]
				dragBar.y = 36 * i + 50;
				dragBar.x = 80;
				vectorDragBar.push(dragBar);

				text = Tool.getMyTextField(50, -1, 12, 0x999999, "center");
				text.background = true;
				text.backgroundColor = 0x191919;
				text.border = true;
				text.borderColor = 0x3D3D3D;
				text.text = dragBar.dragBarPercent + '';
				text.mouseEnabled = text.mouseWheelEnabled = false;
				this.addChild(text);
				text.y = 36 * i + 50;
				text.x = 370;
				vectorTxt.push(text);
			}
		}

		override protected function onClickClose(e:MouseEvent = null):void
		{
			super.onClickClose(e);
		}
	}
}
