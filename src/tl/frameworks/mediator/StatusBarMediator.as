/**
 * Created by gaord on 2016/12/15.
 */
package tl.frameworks.mediator
{
	import flash.events.Event;

	import org.mousebomb.framework.GlobalFacade;
	import org.mousebomb.framework.MediatorBase;
	import org.mousebomb.framework.Notify;
	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;

	import tool.StageFrame;

	public class StatusBarMediator extends Mediator
	{
		[Inject]
		public var view:StatusBar;

		public function StatusBarMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			addContextListener(NotifyConst.STATUS, onSTATUS);
			onResize();
			eventMap.mapListener(StageFrame.stage, Event.RESIZE, onResize);
		}

		private function onResize(event:* = null):void
		{
			view.y = StageFrame.stage.stageHeight ;

		}

		private function onSTATUS(e:TLEvent):void
		{
			view.statusTf.text = e.data;
		}
	}
}
