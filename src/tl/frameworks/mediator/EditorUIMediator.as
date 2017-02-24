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
	import tl.frameworks.model.TLEditorMapModel;
	import tl.mapeditor.ToolBoxType;
	import tl.mapeditor.ui.*;

	public class EditorUIMediator extends Mediator
	{
		public function EditorUIMediator()
		{
		}

		[Inject]
		public var view:EditorUI;
		[Inject]
		public var editorMapModel:TLEditorMapModel;
		private var _isRemove:Boolean;


		override public function onRegister():void
		{
			addContextListener(NotifyConst.MAP_VO_INITED, onMapVoInited);
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
				case ToolBoxType.BAR_NAME_1 :
					dispatchWith(NotifyConst.NEW_POPMENUBAR_UI, false, ToolBoxType.fillVector);
					break;
				case ToolBoxType.BAR_NAME_2 :
					dispatchWith(NotifyConst.NEW_POPMENUBAR_UI, false, ToolBoxType.toolVector);
					break;
				case ToolBoxType.BAR_NAME_3:
					dispatchWith(NotifyConst.NEW_POPMENUBAR_UI, false, ToolBoxType.uiVector);
					break;
				case ToolBoxType.BAR_NAME_4 :
					dispatchWith(NotifyConst.NEW_POPMENUBAR_UI, false, ToolBoxType.ranVector);
					break;
				case ToolBoxType.BAR_NAME_5:
					dispatchWith(NotifyConst.NEW_HELP_UI);
					break;
				case ToolBoxType.BAR_NAME_7 :
					dispatchWith(NotifyConst.TOGGLE_GRID,false);
					break;
				case ToolBoxType.BAR_NAME_8:
					dispatchWith(NotifyConst.TOGGLE_ZONE);
					break;
				case ToolBoxType.BAR_NAME_9:
					dispatchWith(NotifyConst.NEW_ZONESETTING_UI);
					break;
				case ToolBoxType.BAR_NAME_11:
					dispatchWith(NotifyConst.TOGGLE_BOUNDS);
					break;
				case ToolBoxType.BAR_NAME_13 :
					if(editorMapModel.mapVO)
						dispatchWith(NotifyConst.TOOL_NEW_RIGIDBODY,false);
					break;
				case ToolBoxType.BAR_NAME_16:
					dispatchWith(NotifyConst.CLOSE_UI);
					dispatchWith(NotifyConst.NEW_SURFACECHARTLET_UI);
					break;
				case ToolBoxType.BAR_NAME_25 :
					dispatchWith(NotifyConst.CLOSE_UI);
					dispatchWith(NotifyConst.NEW_BRUSHSETTING_UI);
					break;
				default :
					view.switchToolBox(e.data);
					break;
			}
		}
		/**默认打开缩略图、属性面板、模型库界面*/
		private function onMapVoInited(event:TLEvent):void
		{
			if(!view.Thumbnail || !view.Thumbnail.parent)
				view.switchToolBox(ToolBoxType.BAR_NAME_28);
			if(!view.property || !view.property.parent)
				view.switchToolBox(ToolBoxType.BAR_NAME_30);
			if(!view.wizardBarUI || !view.wizardBarUI.parent)
				view.switchToolBox(ToolBoxType.WIZARD_LIBRARY);
		}
	}
}
