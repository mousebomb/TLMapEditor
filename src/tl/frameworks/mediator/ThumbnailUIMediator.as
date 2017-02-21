/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
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
			eventMap.mapListener(view.displayArea,MouseEvent.MOUSE_DOWN, onMouseDown);
			addContextListener(NotifyConst.MOUSE_POS_CHANGED, onChangePosition)
			onMapInit(null);
			addContextListener(NotifyConst.MAP_VO_INITED , onMapInit);
			addContextListener(NotifyConst.SCENE_CAM_MOVED, onMapMove)
		}

		private function onMapMove(event:TLEvent):void
		{
			var point:Point = event.data as Point;
			view.displayArea.x = point.x * view.moveRect.width;
			view.displayArea.y = point.x * view.moveRect.height;
		}

		private function onMouseDown(event:MouseEvent):void
		{
			view.displayArea.startDrag(false, view.moveRect);
			eventMap.mapListener(view.stage,MouseEvent.MOUSE_MOVE, onMouseMove);
			eventMap.mapListener(view.stage,MouseEvent.MOUSE_UP, onMouseUp);
		}

		private function onMouseMove(event:MouseEvent):void
		{
			var point:Point = new Point(view.displayArea.x/view.moveRect.width, view.displayArea.y/view.moveRect.height);
			dispatchWith(NotifyConst.UI_EDITOR_MOVE_CAM, false, point)
		}

		private function onMouseUp(event:MouseEvent):void
		{
			view.displayArea.stopDrag();
			eventMap.unmapListener(view.stage,MouseEvent.MOUSE_MOVE, onMouseMove);
			eventMap.unmapListener(view.stage,MouseEvent.MOUSE_UP, onMouseUp);
		}
		private function onMapInit(e:TLEvent):void
		{
			//默认选第一个
			if (!mapModel.mapVO) return;
			view.showThumbnailInfo(mapModel.mapVO.debugBmd);
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
