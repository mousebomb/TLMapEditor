/**
 * Created by Administrator on 2017/2/18.
 */
package tl.mapeditor.ui.window
{
	import flash.display.BitmapData;

	import tl.mapeditor.ui.common.MyChangeButton;
	import tl.mapeditor.ui.common.MyDragBar;
	import tl.mapeditor.ui.common.MySprite;
	import tl.mapeditor.ui.common.MyTextField;
	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;

	/**灯光设置*/
	public class LightingPanelUI extends UIBase
	{
		public var vectorTxt:Vector.<MyTextField> ;
		public var vectorDragBar:Vector.<MyDragBar> ;
		public var vectorChageBtn:Vector.<MyChangeButton> = new <MyChangeButton>[];
		public function LightingPanelUI()
		{
			super();
		}

		override public function init(title:String, $width:int = 100, $height:int = 100, bgColor:uint = 0x2F2E2E, hasCloseBtn:Boolean = true, isDrag:Boolean = true):void
		{
			if(this.isInit)	return;
			this.isInit = true;

			super.init(title, $width, $height, bgColor, hasCloseBtn, isDrag);
			var bgSpr:MySprite = new MySprite();
			this.addChild(bgSpr);
			Tool.drawRectByGraphics(bgSpr.graphics, null, this.myWidth-30, this.myHeight-40, 0x191818, 1, 0, 0, 1, 0x3D3D3D);
			bgSpr.x = 15;
			bgSpr.y = titleY;

			var text:MyTextField;
			var dragBar:MyDragBar;
			var change:MyChangeButton;
			vectorTxt = new <MyTextField>[];
			vectorDragBar = new <MyDragBar>[];
			var labelArr:Array = ['X轴', 'Z轴', 'Y轴', 200, 200, 500];
			var vector1:Vector.<BitmapData> = new <BitmapData>[
				new Skin_PageButton_L_Up(), new Skin_PageButton_L_Over(), new Skin_PageButton_L_Down(), new Skin_PageButton_L_Disabled(), null
			];
			var vector2:Vector.<BitmapData> = new <BitmapData>[
				new Skin_PageButton_R_Up(), new Skin_PageButton_R_Over(), new Skin_PageButton_R_Down(), new Skin_PageButton_R_Disabled(), null
			]

			for (var i:int=0; i<3; i++)
			{
				text = Tool.getMyTextField(70, -1, 12, 0x999999, "center");
				text.background = true;
				text.backgroundColor = 0x191919;
				text.border = true;
				text.borderColor = 0x3D3D3D;
				text.text = labelArr[i];
				text.mouseEnabled = text.mouseWheelEnabled = false;
				bgSpr.addChild(text);
				text.y = 36 * i + 20;
				text.x = 17;

				dragBar = new MyDragBar();
				bgSpr.addChild(dragBar);
				dragBar.name = 'LightingPanelUI_' + i;
				dragBar.maxValue = labelArr[i + 3];
				if(i < 2)
					dragBar.isNegative = true;
				dragBar.y = 36 * i + 20;
				dragBar.x = 97;
				vectorDragBar.push(dragBar);

				change = new MyChangeButton();
				change.isVertical = false;
				change.setSkin(vector1, vector2);
				change.name = 'LightingPanelUI_' + i;
				change.init();
				bgSpr.addChild(change);
				change.x = this.myWidth - 30 - change.myWidth >> 1;
				change.y = 36 * i + 7;
				vectorChageBtn.push(change);

				text = Tool.getMyTextField(70, -1, 12, 0x999999, "center");
				text.background = true;
				text.backgroundColor = 0x191919;
				text.border = true;
				text.borderColor = 0x3D3D3D;
				text.text = dragBar.dragBarPercent + '';
				text.mouseEnabled = text.mouseWheelEnabled = false;
				bgSpr.addChild(text);
				text.y = 36 * i + 20;
				text.x = dragBar.x + dragBar.myWidth + 10;
				vectorTxt.push(text);
			}
		}
	}
}
