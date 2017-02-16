/**
 * Created by Administrator on 2017/2/10.
 */
package tl.mapeditor.ui.window
{
	import flash.events.MouseEvent;

	import tl.mapeditor.ui.common.MySprite;
	import tl.mapeditor.ui.common.MyTextField;

	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;

	/**属性面板*/
	public class PropertyPanelUI extends UIBase
	{
		private const _showNum:int = 8;
		public var titleTextVec:Vector.<MyTextField>;
		public var valueTextVec:Vector.<MyTextField>;
		public function PropertyPanelUI()
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
			Tool.drawRectByGraphics(bgSpr.graphics, null, this.myWidth-20, 16*(_showNum+1)+2, 0x191818, 1, 0, 0, 1, 0x3D3D3D);
			bgSpr.x = (this.myWidth - bgSpr.width)/2;
			bgSpr.y = titleY;


			var text:MyTextField;
			titleTextVec = new <MyTextField>[];
			valueTextVec = new <MyTextField>[];
			var labelArr:Array = ['属性', '地图文件夹名', '地图图片前缀', '地图文件名', '地图总大小', '地图行列数量', '地图块大小', '格子数量']
			for(var i:int = 0; i < _showNum; i++)
			{
				text = Tool.getMyTextField(90, -1, 12, 0x999999, "center");
				text.background = true;
				text.backgroundColor = 0x191919;
				text.border = true;
				text.borderColor = 0x3D3D3D;
				text.text = labelArr[i];
				text.mouseEnabled = text.mouseWheelEnabled = false;
				bgSpr.addChild(text);
				text.y = 16 * i;
				if(i > 0)
					titleTextVec.push(text)

				text = Tool.getMyTextField(150, -1, 12, 0x999999, "center");
				text.background = true;
				text.backgroundColor = 0x191919;
				text.border = true;
				text.borderColor = 0x3D3D3D;
				if(i == 0)
					text.text = '值';
				else
					text.text = ''
				text.mouseEnabled = text.mouseWheelEnabled = false;
				bgSpr.addChild(text);
				text.x = 90;
				text.y = 16 * i;
				if(i > 0)
					valueTextVec.push(text);
			}
		}

		override protected function onClickClose(e:MouseEvent = null):void
		{
			super.onClickClose(e);
		}
	}
}
