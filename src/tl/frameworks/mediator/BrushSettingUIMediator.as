/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import flash.events.MouseEvent;

	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.defines.ToolBrushType;
	import tl.frameworks.model.TLEditorMapModel;

	import tl.mapeditor.ui.common.MyDragBar;

	import tl.mapeditor.ui.window.BrushSettingUI;

	import tool.StageFrame;

	/**地形笔刷设置*/
	public class BrushSettingUIMediator extends Mediator
	{
		[Inject]
		public var view:BrushSettingUI;

		[Inject]
		public var mapModel:TLEditorMapModel;
		private var _drag:String;
		public function BrushSettingUIMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			super.onRegister();

			view.init("地形笔刷设置", 425, 160);
			view.x = 350;
			view.y = 32;

			var positionArr:Array = [mapModel.brushSize, mapModel.brushStrong, mapModel.brushSoftness]
			 for (var i:int = 0; i < 3; i++)
			 {
				 view.vectorDragBar[i].addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				 view.vectorDragBar[i].dragSprX = positionArr[i];
				 view.vectorTxt[i].text = view.vectorDragBar[i].dragBarPercent + '';
			 }

			StageFrame.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			if(mapModel.mapVO)
				dispatchWith(NotifyConst.TOOL_BRUSH, false,ToolBrushType.BRUSH_TYPE_HEIGHT);
		}

		override public function onRemove():void
		{
			super.onRemove();
			if(mapModel.mapVO)
			{
				dispatchWith(NotifyConst.TOOL_SELECT, false);
			}
		}

		private function onMouseDown(event:MouseEvent):void
		{
			var drag:MyDragBar = event.currentTarget as MyDragBar;
			drag.onMouseDown(event);
			_drag = drag.name;
			var vx:int = event.movementX;
			var vy:int = event.movementX;
			trace(StageFrame.renderIdx,"BrushSettingUIMediator/onMouseDown", vx, vy);
		}

		public function onMouseUp(event:MouseEvent):void
		{
			for (var i:int = 0; i < 3; i++)
			{
				view.vectorDragBar[i].onMouseUp(event);
				view.vectorTxt[i].text = view.vectorDragBar[i].dragBarPercent + '';
			}
			if(_drag)
			{
				if(_drag == 'BrushSettingUI_0')
				{
					dispatchWith(NotifyConst.TOOL_BRUSH_QIANGDU, false, view.vectorDragBar[0].dragBarPercent);
				} 	else if(_drag == 'BrushSettingUI_1') {
					dispatchWith(NotifyConst.TOOL_BRUSH_SIZE, false, view.vectorDragBar[1].dragBarPercent);
				} 	else if(_drag == 'BrushSettingUI_2') {
					dispatchWith(NotifyConst.TOOL_BRUSH_ROUHE, false, view.vectorDragBar[2].dragBarPercent);
				}
			}
			_drag = null;
		}
	}
}
