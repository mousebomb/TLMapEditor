/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import flash.display.Stage;
	import flash.events.MouseEvent;

	import org.robotlegs.mvcs.Mediator;

	import tl.mapeditor.ui.common.MyButton;

	import tl.mapeditor.ui.window.FunctionPointUI;

	import tool.StageFrame;

	/**功能点设置*/
	public class FunctionPointUIMediator extends Mediator
	{
		[Inject]
		public var view:FunctionPointUI;
		public function FunctionPointUIMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			super.onRegister();

			view.init("功能点设置", 240, 200);
			view.x = StageFrame.stage.stageWidth - view.myWidth >> 1;
			view.y = StageFrame.stage.stageHeight - view.myHeight >> 1;

			var leng:int = view.btnVector.length;
			for (var i:int = 0; i < leng; i++)
			{
				view.btnVector[i].addEventListener(MouseEvent.CLICK, onClick)
			}
		}

		private function onClick(event:MouseEvent):void
		{
			if(event.target is MyButton)
			{
				var btn:MyButton = event.target as MyButton;
				switch (btn.name)
				{
					case '出生点' :

						break;
					case '跳转点' :

						break;
					case '特殊点' :

						break;
					case '预留点一' :

						break;
					case '预留点二' :

						break;
				}
			}
		}
	}
}
