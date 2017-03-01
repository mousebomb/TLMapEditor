/**
 * Created by Administrator on 2017/3/1.
 */
package tl.mapeditor.ui.window
{
	import flash.display.BitmapData;

	import tl.mapeditor.ui.common.MyButton;
	import tl.mapeditor.ui.common.MyTextField;
	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;

	public class CreateCoverageUI extends UIBase
	{
		public var createTxt:MyTextField;
		public var closeBtn:MyButton;
		public function CreateCoverageUI()
		{
			super();
		}
		override public function init(title:String, $width:int = 100, $height:int = 100, bgColor:uint = 0x2F2E2E, hasCloseBtn:Boolean = true, isDrag:Boolean = true):void
		{
			if(this.isInit) return;
			this.isInit = true;
			super.init(title, $width, $height, bgColor, hasCloseBtn, isDrag);

			var btnUpBtmd:BitmapData = new Skin_Button_Select();			//普通按钮
			var btnOverBtmd:BitmapData = new Skin_Button_Over();
			var btnDownBtmd:BitmapData = new Skin_Button_Down();
			//行
			var textField:MyTextField = Tool.getTitleText("创建图层");
			this.addChild(textField);
			textField.x = 15;
			textField.y = titleY + 20;
			//显示文本
			createTxt = Tool.getInputText(165, 16);
			this.addChild(createTxt);
			createTxt.algin = "center";
			createTxt.name = "创建图层";
			createTxt.text = '新建图层';
			createTxt.x = textField.x + textField.width + 2;
			createTxt.y = textField.y + (textField.height - createTxt.height)/2;
			createTxt.type = "input";
			//确定按钮
			closeBtn = Tool.getMyBtn("确定", 60, btnUpBtmd.height, btnUpBtmd, btnOverBtmd, btnDownBtmd);
			this.addChild(closeBtn);
			closeBtn.x = (this.myWidth - closeBtn.width)/2;
			closeBtn.y = this.myHeight - closeBtn.height - 20;

		}
	}
}
