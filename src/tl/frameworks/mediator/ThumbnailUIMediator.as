/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import flash.geom.Point;

	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;
	import tl.frameworks.model.TLEditorMapModel;

	import tl.mapeditor.ui.window.ThumbnailUI;

	/**缩略图*/
	public class ThumbnailUIMediator extends Mediator
	{

		[Inject]
		public var view:ThumbnailUI;
		[Inject]
		public var mapModel: TLEditorMapModel;
		public function ThumbnailUIMediator()
		{
			super();
		}
		override public function onRegister():void
		{
			super.onRegister();

			view.init("缩略图", 260, 160);
			view.x = 90;
			view.y = 32;
			addContextListener(NotifyConst.MOUSE_POS_CHANGED, onChangePosition)
		}

		private function onChangePosition(event:TLEvent):void
		{
			view.positionTxt.text = "x:" + mapModel.mouseTilePos.x + "\ny:" + mapModel.mouseTilePos.y;
		}

		override public function onRemove():void
		{
			super.onRemove();
		}
	}
}
