/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import flash.events.MouseEvent;

	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.defines.FunctionPointType;
	import tl.mapeditor.ui.common.MyButton;
	import tl.mapeditor.ui.window.FunctionPointUI;

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

			view.init("功能点设置", 260, 140);
			view.x = 90;
			view.y = 372;

			var leng:int = view.btnVector.length;
			for (var i:int = 0; i < leng; i++)
			{
				eventMap.mapListener(view.btnVector[i],MouseEvent.CLICK, onClick);
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
						dispatchWith(NotifyConst.UI_ADD_FUNCPOINT, false, FunctionPointType.START);
						break;
					case '跳转点' :
						dispatchWith(NotifyConst.UI_ADD_FUNCPOINT, false, FunctionPointType.JUMP);
						break;
					case '特殊点' :
						dispatchWith(NotifyConst.UI_ADD_FUNCPOINT, false, FunctionPointType.SPECIAL);
						break;
					case '预留点一' :
						dispatchWith(NotifyConst.UI_ADD_FUNCPOINT, false, FunctionPointType.EXTRA_1);
						break;
					case '预留点二' :
						dispatchWith(NotifyConst.UI_ADD_FUNCPOINT, false, FunctionPointType.EXTRA_2);
						break;
				}
			}
		}
	}
}
