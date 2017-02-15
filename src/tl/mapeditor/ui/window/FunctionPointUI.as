/**
 * Created by Administrator on 2017/2/10.
 */
package tl.mapeditor.ui.window
{
	import flash.events.MouseEvent;

	import tl.mapeditor.ui.common.MyButton;

	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;

	/**功能点设置*/
	public class FunctionPointUI extends UIBase
	{
		public var btnVector:Vector.<MyButton> = new <MyButton>[];
		public function FunctionPointUI()
		{
		}

		override public function init(title:String, $width:int = 100, $height:int = 100, bgColor:uint = 0x2F2E2E, hasCloseBtn:Boolean = true, isDrag:Boolean = true):void
		{
			if(this.isInit) return;
			this.isInit = true;
			super.init(title, $width, $height, bgColor, hasCloseBtn, isDrag);

			var btn:MyButton;
			var arr:Array = ['出生点', '跳转点', '特殊点', '预留点一', '预留点二'];
			for (var i:int = 0; i < 5; i++)
			{
				btn = Tool.getMyBtn(arr[i], 200);
				btn.name = arr[i];
				this.addChild(btn);
				btn.x = 20;
				btn.y = 30 * i + 40;
				btnVector.push(btn)
			}
		}

		override protected function onClickClose(e:MouseEvent = null):void
		{
			super.onClickClose(e);
		}
	}
}
