/**
 * Created by Administrator on 2017/2/9.
 */
package tl.frameworks.mediator
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;

	import tl.mapeditor.ui.Toolbar;
	import tl.mapeditor.ui.OperationBar;
	import tl.mapeditor.ui.common.MyButton;

	public class OperationBarMediator extends Mediator
	{
		[Inject]
		public var view:OperationBar
		public function OperationBarMediator()
		{

		}

		override public function onRegister():void
		{
			eventMap.mapListener(view.stage,Event.RESIZE, onResize);
			onResize();
			addViewListener(MouseEvent.CLICK, onToolbarClick);

		}

		private function onToolbarClick(event:MouseEvent):void
		{
			if(event.target is MyButton)
			{
				dispatchWith(NotifyConst.SWITCH_TOOLBOX,false, event.target.name);
			}
		}

		private function onResize(event:Event = null):void
		{
			view.y = 32;
			view.onResize();
		}
	}
}
