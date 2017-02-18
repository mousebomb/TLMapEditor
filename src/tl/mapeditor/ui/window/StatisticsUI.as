/**
 * Created by Administrator on 2017/2/17.
 */
package tl.mapeditor.ui.window
{
	import flash.events.MouseEvent;

	import tl.mapeditor.ui.common.MySprite;
	import tl.mapeditor.ui.common.MyTextField;
	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;

	/**统计界面*/
	public class StatisticsUI extends UIBase
	{
		public var typeTxt:MyTextField;
		public var valueTxt:MyTextField;
		public function StatisticsUI()
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
			Tool.drawRectByGraphics(bgSpr.graphics, null, this.myWidth-20, 325, 0x191818, 1, 0, 0, 1, 0x3D3D3D);
			bgSpr.x = 10;
			bgSpr.y = titleY;

			typeTxt = Tool.getMyTextField(190, 315, 12, 0x999999, "left", 4);
			typeTxt.mouseEnabled = typeTxt.mouseWheelEnabled = false;
			bgSpr.addChild(typeTxt);
			typeTxt.x = 5;
			typeTxt.y = 5;

			valueTxt = Tool.getMyTextField(190, 315, 12, 0x999999, "left", 4);
			valueTxt.mouseEnabled = valueTxt.mouseWheelEnabled = false;
			bgSpr.addChild(valueTxt);
			valueTxt.x = 210;
			valueTxt.y = 5;
		}

		override protected function onClickClose(e:MouseEvent = null):void
		{
			super.onClickClose(e);
		}
	}
}
