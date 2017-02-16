/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;
	import tl.frameworks.model.LogModel;

	import tl.mapeditor.ui.window.LogUI;

	import tool.StageFrame;

	/**日志*/
	public class LogUIMediator extends Mediator
	{
		[Inject]
		public var view: LogUI;
		[Inject]
		public var logModel: LogModel;
		public function LogUIMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			super.onRegister();

			view.init("日志", 320, 240);
			view.showLog(logModel._log);
			view.x = StageFrame.stage.stageWidth - view.myWidth >> 1;
			view.y = StageFrame.stage.stageHeight - view.myHeight >> 1;

			addContextListener(NotifyConst.STATUS, onSTATUS);
		}

		private function onSTATUS(e:TLEvent):void
		{
			view.showLog(logModel._log);
		}
	}
}
