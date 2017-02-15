/**
 * Created by gaord on 2016/12/15.
 */
package tl.frameworks.mediator
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;
	import tl.mapeditor.ToolBoxType;
	import tl.mapeditor.ui.*;

	public class EditorUIMediator extends Mediator
	{
		public function EditorUIMediator()
		{
		}

		[Inject]
		public var view:EditorUI;
		private var _isRemove:Boolean;


		override public function onRegister():void
		{
			eventMap.mapListener(view.stage , MouseEvent.CLICK,onMouseClick);
			addContextListener( NotifyConst.SWITCH_TOOLBOX, onSWITCH_TOOLBOX);
		}

		private function onSWITCH_TOOLBOX(e:TLEvent):void
		{
			_isRemove = false;
			var menuName :String = e.data;
			if(menuName == ToolBoxType.BAR_NAME_1 || menuName == ToolBoxType.BAR_NAME_2 || menuName == ToolBoxType.BAR_NAME_3 || menuName == ToolBoxType.BAR_NAME_4 || menuName == ToolBoxType.BAR_NAME_5)
			{
				_isRemove = true;
			}

			switch (menuName)
			{
				case ToolBoxType.BAR_NAME_5:
					dispatchWith(NotifyConst.NEW_HELP_UI);
					break;
				case ToolBoxType.BAR_NAME_7 :
					dispatchWith(NotifyConst.TOGGLE_GRID,false);
					break;
				case ToolBoxType.BAR_NAME_8:
					dispatchWith(NotifyConst.TOGGLE_ZONE);
					break;
				case ToolBoxType.BAR_NAME_13 :
					dispatchWith(NotifyConst.TOOL_NEW_RIGIDBODY,false);
					break;
				case ToolBoxType.BAR_NAME_9:
					dispatchWith(NotifyConst.NEW_ZONESETTING_UI);
					break;
				case ToolBoxType.BAR_NAME_10:
					dispatchWith(NotifyConst.NEW_FUNCTIONPOINT_UI);
					break;
				case ToolBoxType.BAR_NAME_16:
					dispatchWith(NotifyConst.NEW_SURFACECHARTLET_UI);
					break;
				case ToolBoxType.BAR_NAME_28:
					dispatchWith(NotifyConst.NEW_THUMBNAIL_UI);
					break;
				case ToolBoxType.BAR_NAME_30:
					dispatchWith(NotifyConst.NEW_PROPERTYPANEL_UI);
					break;
				default :
					view.switchToolBox(e.data);
					break;
			}
			if(view.wizardBar && view.wizardBar.parent)
				dispatchWith(NotifyConst.UI_PREVIEW_SHOW, false, {x:view.wizardBar.x + 10, y:view.wizardBar.y + 20});
		}

		private function onMouseClick(event:MouseEvent):void
		{
			if(view && view.popMenuBar && view.popMenuBar.parent && !_isRemove)
				view.popMenuBar.parent.removeChild(view.popMenuBar);
			_isRemove = false;

		}
	}
}
