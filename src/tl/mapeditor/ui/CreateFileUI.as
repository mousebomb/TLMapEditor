package tl.mapeditor.ui
{
	/**创建新文件UI
	 */

	import flash.display.BitmapData;
	import flash.events.MouseEvent;

	import tl.mapeditor.ToolBoxType;
	import tl.mapeditor.ui.common.MyButton;
	import tl.mapeditor.ui.common.MyTextField;
	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;

	public class CreateFileUI extends UIBase
	{
		public var inputTextW:MyTextField;		//地图宽度
		public var inputTextH:MyTextField;		//地图高度
		public var inputTextN:MyTextField;		//地图名字
		public var bitmapBtn:MyButton;			//选择高度图按钮
		//修改前文本内容
		
		public function CreateFileUI()
		{
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
			var textField:MyTextField = Tool.getTitleText("地图宽度");
			this.addChild(textField);
			textField.x = 15;
			textField.y = titleY + 5;
			//显示文本
			inputTextW = Tool.getInputText(165, 16);
			this.addChild(inputTextW);
			inputTextW.algin = "center";
			inputTextW.name = "地图宽度";
			inputTextW.text = '256';
			inputTextW.x = textField.x + textField.width + 2;
			inputTextW.y = textField.y + (textField.height - inputTextW.height)/2;
			inputTextW.type = "input";
			inputTextW.restrict = "0-9";
			//文件前缀
			var textField_2:MyTextField = Tool.getTitleText("地图高度");
			this.addChild(textField_2);
			textField_2.x = textField.x;
			textField_2.y = textField.y + textField.height + 8;
			//显示文本
			inputTextH = Tool.getInputText(165, 16);
			this.addChild(inputTextH);
			inputTextH.name = "地图高度";
			inputTextH.x = textField_2.x + textField_2.width + 2;
			inputTextH.y = textField_2.y + (textField_2.height - inputTextH.height)/2;
			inputTextH.type = "input";
			inputTextH.restrict = "0-9";
			inputTextH.algin = "center";
			inputTextH.text = '256';
			//文件夹名
			textField = Tool.getTitleText("地图命名");
			this.addChild(textField);
			textField.x = textField_2.x;
			textField.y = textField_2.y + textField_2.height + 8;
			//显示文本
			inputTextN = Tool.getInputText(165, 16);
			this.addChild(inputTextN);
			inputTextN.name = "地图命名";
			inputTextN.x = textField.x + textField.width + 2;
			inputTextN.y = textField.y + (textField.height - inputTextN.height)/2;
			inputTextN.type = "input";
			inputTextN.algin = "center";
			inputTextN.text = 'map';
			//高度图
			var textField_1:MyTextField;
			textField_1 = Tool.getTitleText("高度图");
			this.addChild(textField_1);
			textField_1.x = textField.x;
			textField_1.y = textField.y + textField.height + 8;
			//显示文本
			bitmapBtn  = Tool.getMyBtn('选择高度图', 165)
			this.addChild(bitmapBtn);
			bitmapBtn.name = "选择高度图";
			bitmapBtn.x = inputTextN.x;
			bitmapBtn.y = textField_1.y + (textField_1.height - bitmapBtn.height)/2;
			
			//确定按钮
			var btn:MyButton = Tool.getMyBtn("确定", 60, btnUpBtmd.height, btnUpBtmd, btnOverBtmd, btnDownBtmd);
			this.addChild(btn);
			btn.name = ToolBoxType.CREATE_FILE;
			btn.x = (this.myWidth - btn.width)/2;
			btn.y = this.myHeight - btn.height - 7;
			btn.addEventListener(MouseEvent.CLICK, onMouseClick);
			
		}
		/** 点击确定 **/
		private function onMouseClick(e:MouseEvent):void
		{
			this.closeWindow();
		}

		override protected function onClickClose(e:MouseEvent = null):void
		{
			super.onClickClose(e);
		}
		
		
	}
}