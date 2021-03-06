/**
 * Created by gaord on 2016/12/14.
 */
package tl.frameworks.mediator
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Vector3D;
	import flash.net.FileFilter;
	import flash.text.TextField;
	import flash.ui.Keyboard;

	import org.mousebomb.framework.GlobalFacade;
	import org.mousebomb.framework.MediatorBase;
	import org.robotlegs.mvcs.Mediator;

	import tl.core.role.RolePlaceVO;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.defines.ToolBrushType;
	import tl.frameworks.model.TLEditorMapModel;
	import tl.frameworks.model.vo.CreateMapVO;
	import tl.mapeditor.Config;
	import tl.mapeditor.ToolBoxType;
	import tl.mapeditor.ui.Toolbar;
	import tl.mapeditor.ui.common.MyButton;
	import tool.StageFrame;

	public class ToolbarMediator extends Mediator
	{
		[Inject]
		public var view :Toolbar;
		[Inject]
		public var mapModel: TLEditorMapModel;
		private var _isControl:Boolean;
		private var _file:File;
		private var _fileFilter:FileFilter = new FileFilter("*.tlmap", "*.tlmap");
		public function ToolbarMediator()
		{

		}

		override public function onRegister():void
		{
			eventMap.mapListener(view.stage,KeyboardEvent.KEY_DOWN, onKeyDown);
			eventMap.mapListener(view.stage,KeyboardEvent.KEY_UP, onKeyUp);
			eventMap.mapListener(view.stage,Event.RESIZE, onResize);
			onResize();
			//
			addViewListener(MouseEvent.CLICK, onToolbarClick);

		}

		private function onToolbarClick(event:MouseEvent):void
		{
			if(event.target is MyButton)
			{
				dispatchWith(NotifyConst.SWITCH_TOOLBOX,false, event.target.name);
			}
		}

		private function onResize(event:Event = null):void
		{
			view.x = 0;//StageFrame.stage.stageWidth - 280;
			view.onResize();
		}
		private function onKeyUp(event:KeyboardEvent):void
		{
			if(StageFrame.stage.focus is TextField) 	return;
			switch (event.keyCode)
			{
				case Keyboard.O:
					if(!_isControl)
						break;
					_file = File.applicationDirectory.resolvePath(Config.MAP_URL);
					//选择事件
					_file.addEventListener(Event.SELECT, onSelect, false, 0, true);
					_file.browseForOpen("打开地图文件", [_fileFilter]);
					//dispatchWith(NotifyConst.LOAD_MAP,false,File.desktopDirectory.resolvePath(Config.MAP_URL+"1001.tlmap"));
					break;
				case Keyboard.N:
					if(!_isControl)
						break;
					//dispatchWith(NotifyConst.NEW_MAP_UI);
					dispatchWith(NotifyConst.NEW_MAP, false,new CreateMapVO(320,320,"test",null));
					break;
				case Keyboard.S:
					if(!_isControl || !mapModel.mapVO)
						break;
					dispatchWith(NotifyConst.SAVE_MAP,false);
					break;
				case Keyboard.B:
					if(!mapModel.mapVO)
						break;
					dispatchWith(NotifyConst.CLOSE_UI);
					dispatchWith(NotifyConst.NEW_BRUSHSETTING_UI);
					//dispatchWith(NotifyConst.TOOL_BRUSH, false,ToolBrushType.BRUSH_TYPE_HEIGHT);
					break;
				case Keyboard.T:
					if(!mapModel.mapVO)
						break;
					dispatchWith(NotifyConst.CLOSE_UI);
					dispatchWith(NotifyConst.NEW_SURFACECHARTLET_UI);
					//dispatchWith(NotifyConst.TOOL_BRUSH, false,ToolBrushType.BRUSH_TYPE_TERRAINTEXTURE);
					break;
				case Keyboard.L:
					dispatchWith(NotifyConst.NEW_ZONESETTING_UI);
					//dispatchWith(NotifyConst.TOOL_BRUSH, false,ToolBrushType.BRUSH_TYPE_ZONE);
					break;
				case Keyboard.V:
					dispatchWith(NotifyConst.TOOL_SELECT, false);
					break;
				case Keyboard.G:
					if(!_isControl || !mapModel.mapVO)
						break;
					dispatchWith(NotifyConst.TOOL_NEW_RIGIDBODY,false);
					break;
				case Keyboard.Q:
					if(!_isControl || !mapModel.mapVO)
						break;
					dispatchWith(NotifyConst.TOGGLE_GRID,false);
					break;
				case Keyboard.R:
					dispatchWith(NotifyConst.NEW_STATISTICS_UI,false);
					break;
				case Keyboard.E:
					dispatchWith(NotifyConst.NEW_COVERAGEPANEL_UI,false);
					break;
				case Keyboard.X :
					dispatchWith(NotifyConst.NEW_WIZARD_UI, false, 1);
					break;
				case Keyboard.M :
					dispatchWith(NotifyConst.SWITCH_TOOLBOX, false, ToolBoxType.WIZARD_LIBRARY);
					break;
				case Keyboard.H :
					dispatchWith(NotifyConst.SWITCH_TOOLBOX, false, ToolBoxType.BAR_NAME_28);
					break;
				case Keyboard.F :
					dispatchWith(NotifyConst.SWITCH_TOOLBOX, false, ToolBoxType.BAR_NAME_30);
					break;
				case Keyboard.Z:
					if(!_isControl)
					{
						//z隐藏ui
						dispatchWith(NotifyConst.CLOSE_ALL_UI);
					}else{
						//ctrl+Z撤销
						dispatchWith(NotifyConst.UNDO);
					}
					break;
				case Keyboard.NUMPAD_ADD:
					dispatchWith(NotifyConst.TOOL_BRUSH_SIZE_ADD, false, 1);
					dispatchWith(NotifyConst.TOOL_RIGIDBODY_SIZE_ADD, false, 10/9);
					break;
				case Keyboard.NUMPAD_SUBTRACT:
					dispatchWith(NotifyConst.TOOL_BRUSH_SIZE_ADD, false, -1);
					dispatchWith(NotifyConst.TOOL_RIGIDBODY_SIZE_ADD, false, .9);
					break;
				case Keyboard.K:
//					dispatchWith(NotifyConst.TOOL_SKYBOX_SET,false,"snow");
//					dispatchWith(NotifyConst.LIGHT_DIRECTION_SET,false,new Vector3D(300-Math.random()*150,-300,300-Math.random()*150));
//						//测试代码，测试点选模型对象: 只有放置过模型才可以测
//						var rolePlaceVO:RolePlaceVO = mapModel.mapVO.entityGroups[mapModel.mapVO.entityGroupNames[0]][0];
//						dispatchWith(NotifyConst.UI_SELECT_WIZARD,false,rolePlaceVO);
					break;
				case Keyboard.DELETE:
					dispatchWith(NotifyConst.UI_DELETE_SELECTED);
					break;
				case Keyboard.CONTROL :
					_isControl = false;
					break;
			}
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.CONTROL :
					_isControl = true;
					break;
			}
		}
		/** 选择完成执行 **/
		private function onSelect(e:Event):void
		{
			dispatchWith(NotifyConst.LOAD_MAP,false,_file);
		}
	}
}
