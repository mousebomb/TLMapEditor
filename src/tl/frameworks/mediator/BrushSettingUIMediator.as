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

			view.init("地形笔刷设置", 425, 280);
			view.x = 350;
			view.y = 32;

			var positionArr:Array = [mapModel.brushSize, mapModel.brushStrong, mapModel.brushSoftness,mapModel.brushHeightMax,mapModel.brushHeightMin];
			 for (var i:int = 0; i < 5; i++)
			 {
				 eventMap.mapListener(view.vectorDragBar[i], MouseEvent.MOUSE_DOWN, onMouseDown);
				 if(view.vectorDragBar[i].isNegative)
				 {
					 view.vectorTxt[i].text = positionArr[i] + '';
					 view.vectorDragBar[i].dragBarPercent = (positionArr[i] + view.vectorDragBar[i].halfValue)/view.vectorDragBar[i].maxValue;
				 }
				 else
				 {
					 view.vectorTxt[i].text = '' + positionArr[i] ;
					 view.vectorDragBar[i].dragBarPercent = positionArr[i]/view.vectorDragBar[i].maxValue;
				 }
			 }

			eventMap.mapListener(StageFrame.stage, MouseEvent.MOUSE_UP, onMouseUp);
			if(mapModel.mapVO)
				onClickShow(null);
			eventMap.mapListener(view.hideBtn, MouseEvent.CLICK, onClickHide);
			eventMap.mapListener(view.showBtn, MouseEvent.CLICK, onClickShow);
			addContextListener(NotifyConst.CLOSE_UI, onClose);
		}

		private function onClose(event:*):void
		{
			if(view.parent)
				view.parent.removeChild(view)
		}

		override public function onRemove():void
		{
			super.onRemove();
			onClickHide(null);
		}

		/**显示笔刷*/
		private function onClickShow(event:MouseEvent):void
		{
			if(mapModel.mapVO)
				dispatchWith(NotifyConst.TOOL_BRUSH, false,ToolBrushType.BRUSH_TYPE_HEIGHT);
		}
		/**隐藏笔刷*/
		private function onClickHide(event:MouseEvent):void
		{
			if(mapModel.mapVO)
				dispatchWith(NotifyConst.TOOL_SELECT, false);
		}
		private function onMouseDown(event:MouseEvent):void
		{
			var drag:MyDragBar = event.currentTarget as MyDragBar;
			drag.onMouseDown(event);
			_drag = drag.name;
		}

		public function onMouseUp(event:MouseEvent):void
		{
			for (var i:int = 0; i < 5; i++)
			{
				view.vectorDragBar[i].onMouseUp(event);
				var index:int;
				if(view.vectorDragBar[i].isNegative)
					index = view.vectorDragBar[i].dragBarPercent * view.vectorDragBar[i].maxValue - (view.vectorDragBar[i].maxValue >> 1);
				else
					index = view.vectorDragBar[i].dragBarPercent * view.vectorDragBar[i].maxValue;
				view.vectorTxt[i].text = index + '';
			}
			if(_drag)
			{
				if(_drag == 'BrushSettingUI_0')
				{
					dispatchWith(NotifyConst.TOOL_BRUSH_SIZE, false, int(view.vectorTxt[0].text));
				} 	else if(_drag == 'BrushSettingUI_1') {
					dispatchWith(NotifyConst.TOOL_BRUSH_QIANGDU, false, int(view.vectorTxt[1].text));
				} 	else if(_drag == 'BrushSettingUI_2') {
					dispatchWith(NotifyConst.TOOL_BRUSH_ROUHE, false, int(view.vectorTxt[2].text));
				}	else if(_drag == 'BrushSettingUI_3') {
					dispatchWith(NotifyConst.TOOL_BRUSH_H_MAX, false, int(view.vectorTxt[3].text));
				}	else if(_drag == 'BrushSettingUI_4') {
					dispatchWith(NotifyConst.TOOL_BRUSH_H_MIN, false, int(view.vectorTxt[4].text));
				}
			}
			_drag = null;
		}
	}
}
