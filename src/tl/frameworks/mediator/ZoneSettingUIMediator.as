/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.defines.ToolBrushType;
	import tl.frameworks.defines.ZoneType;

	import tl.frameworks.model.TLEditorMapModel;
	import tl.mapeditor.ui.common.MyButton;

	import tl.mapeditor.ui.window.ZoneSettingUI;

	/**区域设置*/
	public class ZoneSettingUIMediator extends Mediator
	{
		[Inject]
		public var view:ZoneSettingUI;
		[Inject]
		public var mapModel:TLEditorMapModel ;
		private const _dragRect:Rectangle = new Rectangle(0, 0, 100, 0);
		private var _isDrag:Boolean;
		public function ZoneSettingUIMediator()
		{
			super();
		}


		override public function onRegister():void
		{
			super.onRegister();

			view.init();
			view.x = 90;
			view.y = 200;
			addViewListener(MouseEvent.CLICK, onMouseClick);
			eventMap.mapListener(view.dragBar, MouseEvent.MOUSE_DOWN, onMouseDown);
			eventMap.mapListener(view.stage, MouseEvent.MOUSE_UP, onMouseUp);

			view.penTxt.text = '笔刷大小：' + mapModel.brushSize
			view.dragBar.dragBarPercent  = mapModel.brushSize/300;
			addContextListener(NotifyConst.CLOSE_ALL_UI, onClose);
		}

		private function onClose(event:*):void
		{
			if(view.parent)
				view.parent.removeChild(view)
		}

		private function onMouseUp(event:MouseEvent):void
		{
			if(_isDrag)
			{
				view.dragBar.onMouseUp(event);
				view.penTxt.text = '笔刷大小：' + Number(view.dragBar.dragBarPercent * 300).toFixed();
				dispatchWith(NotifyConst.TOOL_BRUSH_SIZE, false, int(view.dragBar.dragBarPercent * 300));
			}	else {
				if(view.parent)
				{
					view.parent.removeChild(view);
				}
			}
			_isDrag = false;
		}

		private function onMouseDown(event:MouseEvent):void
		{
			_isDrag = true;
			view.dragBar.onMouseDown(event);
		}
		private function onMouseClick(e:MouseEvent):void
		{
			if( !(e.target is MyButton) || !mapModel.mapVO) return;
			var btn:MyButton = e.target as MyButton;
			switch(btn.name)
			{
				case "FallArea":			//跌落
					mapModel.curZoneType = ZoneType.ZONE_TYPE_3;
					break;
				case "Obstacles":			//障碍
					mapModel.curZoneType = ZoneType.ZONE_TYPE_1;
					break;
				case "Mask":				//遮挡
					mapModel.curZoneType = ZoneType.ZONE_TYPE_2;
					break;
				case "ClearSetting":		//清除设置
					mapModel.curZoneType = ZoneType.ZONE_TYPE_0;
					break;
				case "PKArea":				//PK区域
					mapModel.curZoneType = ZoneType.ZONE_TYPE_4;
					break;
				case "SafetyArea":		//安全区域
					mapModel.curZoneType = ZoneType.ZONE_TYPE_5;
					break;
				case "AreaA":				//区域A
					mapModel.curZoneType = ZoneType.ZONE_TYPE_6;
					break;
				case "AreaB":				//区域B
					mapModel.curZoneType = ZoneType.ZONE_TYPE_7;
					break;
				case "AreaC":				//区域C
					mapModel.curZoneType = ZoneType.ZONE_TYPE_8;
					break;
				case "AreaD":				//区域D
					mapModel.curZoneType = ZoneType.ZONE_TYPE_9;
					break;
				case "AreaE":				//区域E
					mapModel.curZoneType = ZoneType.ZONE_TYPE_10;
					break;
				case "PKMask":				//PK透明区域
					mapModel.curZoneType = ZoneType.ZONE_TYPE_11;
					break;
				case "SafetyMask":		//安全透明区域
					mapModel.curZoneType = ZoneType.ZONE_TYPE_12;
					break;
				case "NotSetting":		//取消设置
					mapModel.curZoneType = -1;
					break;
			}
			//移除上一个选中的按钮
			if(view.upSelectBtn) view.upSelectBtn.selected = false;
			//设置当前选中按钮
			view.upSelectBtn = btn;
			view.upSelectBtn.selected = true;

			if(view.parent)
			{
				view.parent.removeChild(view);
			}
			if(btn.name == 'NotSetting')
			{
				dispatchWith(NotifyConst.TOOL_SELECT, false);
			}	else {
				dispatchWith(NotifyConst.TOOL_BRUSH, false , ToolBrushType.BRUSH_TYPE_ZONE);
			}

		}
	}
}
