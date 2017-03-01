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
		private var _createId:int;
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

		public function get createId():int
		{
			return _createId;
		}

		public function set createId(value:int):void
		{
			_createId = value;
		}

		public function get createValue():String
		{
			var str:String
			switch (_createId)
			{
				case 0 :
					str = '一';
					break;
				case 1 :
					str = '二';
					break;
				case 2 :
					str = '三';
					break;
				case 3 :
					str = '四';
					break;
				case 4 :
					str = '五';
					break;
				case 5 :
					str = '六'
					break;
				case 6 :
					str = '七';
					break;
				case 7 :
					str = '八';
					break;
				case 8 :
					str = '九';
					break;
				case 9 :
					str = '十';
					break;
				default :
					str = (_createId + 1) + '';
					break;
			}
			return str;
		}

	}
}
