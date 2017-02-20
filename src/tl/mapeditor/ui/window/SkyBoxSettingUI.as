/**
 * Created by Administrator on 2017/2/18.
 */
package tl.mapeditor.ui.window
{
	import tl.mapeditor.ui.common.MyButton;
	import tl.mapeditor.ui.common.MySprite;
	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;
	/**天空盒子设置*/
	public class SkyBoxSettingUI extends UIBase
	{
		public var vectorBtn:Vector.<MyButton> ;
		public function SkyBoxSettingUI()
		{
			super();
		}
		override public function init(title:String, $width:int = 100, $height:int = 100, bgColor:uint = 0x2F2E2E, hasCloseBtn:Boolean = true, isDrag:Boolean = true):void
		{
			if (this.isInit) return;
			this.isInit = true;
			super.init(title, $width, $height, bgColor, hasCloseBtn, isDrag);


			var bgSpr:MySprite = new MySprite();
			this.addChild(bgSpr);
			Tool.drawRectByGraphics(bgSpr.graphics, null, this.myWidth-30, this.myHeight-35, 0x191818, 1, 0, 0, 1, 0x3D3D3D);
			bgSpr.x = 15;
			bgSpr.y = titleY;

			var btn:MyButton;
			vectorBtn = new <MyButton>[]
			for (var i:int = 0; i < 6; i++)
			{
				btn = Tool.getMyBtn('', 120);
				btn.name = 'SkyBoxSettingUI_' + i;
				bgSpr.addChild(btn);
				btn.x = 5;
				btn.y = 5 + i * (btn.myHeight + 5);
				vectorBtn.push(btn);
			}
		}
	}
}
