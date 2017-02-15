/**
 * Created by Administrator on 2017/2/10.
 */
package tl.mapeditor.ui.window
{
	import flash.events.MouseEvent;

	import tl.mapeditor.ui.common.MyTextField;

	import tl.mapeditor.ui.common.UIBase;

	public class LogUI extends UIBase
	{

		private var _logText:MyTextField;
		public function LogUI()
		{
			super();
		}

		override public function init(title:String, $width:int = 100, $height:int = 100, bgColor:uint = 0x2F2E2E, hasCloseBtn:Boolean = true, isDrag:Boolean = true):void
		{
			if(this.isInit) return;
			this.isInit = true;
			super.init(title, $width, $height, bgColor, hasCloseBtn, isDrag);
			_logText = new MyTextField();
			_logText.width = this.myWidth - 20;
			this.addChild(_logText);
			_logText.x = 10;
			_logText.y = titleY;
		}

		override protected function onClickClose(e:MouseEvent = null):void
		{
			super.onClickClose(e);
		}

		public function showLog(log:String):void
		{
			_logText.text = log;
		}
	}
}
