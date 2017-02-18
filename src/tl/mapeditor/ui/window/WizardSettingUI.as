/**
 * Created by Administrator on 2017/2/17.
 */
package tl.mapeditor.ui.window
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import tl.core.old.WizardObject;
	import tl.core.role.Role;
	import tl.mapeditor.ui.common.MyButton;
	import tl.mapeditor.ui.common.MySprite;
	import tl.mapeditor.ui.common.MyTextField;
	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;

	/**模型设置界面*/
	public class WizardSettingUI extends UIBase
	{
		public var nameTxt:MyTextField;	//模型名称
		public var upBtn:MyButton;
		public var leftBtn:MyButton;
		public var rightBtn:MyButton;
		public var downBtn:MyButton;
		public function WizardSettingUI()
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
			Tool.drawRectByGraphics(bgSpr.graphics, null, this.myWidth-20, this.myHeight-titleY-10, 0x191818, 1, 0, 0, 1, 0x3D3D3D);
			bgSpr.x = 10;
			bgSpr.y = titleY;
			nameTxt = Tool.getMyTextField(this.myWidth-20, -1, 12, 0x999999, "center");
			bgSpr.addChild(nameTxt);
			nameTxt.y = this.myHeight-titleY-26 >> 1;

			var up:BitmapData = new Skin_direction_up()
			upBtn = new MyButton();
			upBtn.name = 'up'
			upBtn.setSkin(up, up, up, up);
			upBtn.init('抬高', 60, 70);
			bgSpr.addChild(upBtn);
			upBtn.x = this.myWidth - 20 - up.width >> 1;
			upBtn.y = 0;
			upBtn.labelText.y = upBtn.myHeight - 15;

			var down:BitmapData = new Skin_direction_down()
			downBtn = new MyButton();
			downBtn.name = 'down'
			downBtn.setSkin(down, down, down, down);
			downBtn.init('降低', 60, 70);
			bgSpr.addChild(downBtn);
			downBtn.x = this.myWidth - 20 - down.width >> 1;
			downBtn.y = this.myHeight-titleY-10 - down.height;
			downBtn.labelText.y = 0;

			var left:BitmapData = new Skin_direction_left()
			leftBtn = new MyButton();
			leftBtn.name = 'left'
			leftBtn.setSkin(left, left, left, left);
			leftBtn.init('左转', 70, 60);
			bgSpr.addChild(leftBtn);
			leftBtn.x = 0;
			leftBtn.y = this.myHeight-titleY-10 - leftBtn.height >> 1;
			leftBtn.labelText.x = 40;

			var right:BitmapData = new Skin_direction_right()
			rightBtn = new MyButton();
			rightBtn.name = 'right'
			rightBtn.setSkin(right, right, right, right);
			rightBtn.init('右转', 70, 60);
			bgSpr.addChild(rightBtn);
			rightBtn.x = this.myWidth - 20 - right.width;
			rightBtn.y = this.myHeight-titleY-10 - right.height >> 1;
			rightBtn.labelText.x = -32;

		}
	}
}
