/**
 * Created by gaord on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import away3d.containers.View3D;

	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;

	public class PreviewView3DMediator extends Mediator
	{
		[Inject]
		public var view:View3D;
		public function PreviewView3DMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			addContextListener(NotifyConst.UI_PREVIEW_SHOW,onShow);
			addContextListener(NotifyConst.UI_PREVIEW_HIDE,onHide);

		}

		private function onHide(e :*):void
		{
			view.visible = false;
		}

		private function onShow(e :*):void
		{
			view.visible = true;
			view.x = e.data.x;
			view.y = e.data.y;
		}
	}
}
