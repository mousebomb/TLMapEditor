/**
 * Created by gaord on 2016/12/14.
 */
package tl.frameworks.mediator
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.ui.Keyboard;

	import org.mousebomb.framework.GlobalFacade;
	import org.mousebomb.framework.MediatorBase;
	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.defines.ToolBrushType;
	import tl.frameworks.model.vo.CreateMapVO;
	import tl.mapeditor.Config;
	import tl.mapeditor.ui.Toolbar;
	import tl.mapeditor.ui.common.MyButton;
	import tool.StageFrame;

	public class ToolbarMediator extends Mediator
	{
		[Inject]
		public var view :Toolbar;
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
			switch (event.keyCode)
			{
				case Keyboard.O:
					dispatchWith(NotifyConst.LOAD_MAP,false,File.desktopDirectory.resolvePath(Config.MAP_URL+"1001.tlmap"));
					break;
				case Keyboard.N:
					dispatchWith(NotifyConst.NEW_MAP, false,new CreateMapVO(320,320,"test",null));
					break;
				case Keyboard.B:
					dispatchWith(NotifyConst.TOOL_BRUSH, false,ToolBrushType.BRUSH_TYPE_HEIGHT);
					break;
				case Keyboard.T:
					dispatchWith(NotifyConst.TOOL_BRUSH, false,ToolBrushType.BRUSH_TYPE_TERRAINTEXTURE);
					break;
				case Keyboard.L:
					dispatchWith(NotifyConst.TOOL_BRUSH, false,ToolBrushType.BRUSH_TYPE_ZONE);
					break;
				case Keyboard.V:
					dispatchWith(NotifyConst.TOOL_SELECT, false);
					break;
				case Keyboard.NUMPAD_ADD:
					dispatchWith(NotifyConst.TOOL_BRUSH_SIZE_ADD, false, 1);
					dispatchWith(NotifyConst.TOOL_RIGIDBODY_SIZE_ADD, false, 10/9);
					break;
				case Keyboard.NUMPAD_SUBTRACT:
					dispatchWith(NotifyConst.TOOL_BRUSH_SIZE_ADD, false, -1);
					dispatchWith(NotifyConst.TOOL_RIGIDBODY_SIZE_ADD, false, .9);
					break;
				case Keyboard.G:
					break;
				case Keyboard.S:
					break;
				case Keyboard.Q:
					break;
			}
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
			}
		}
	}
}
