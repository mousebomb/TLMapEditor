/**
 * Created by Administrator on 2017/2/17.
 */
package tl.frameworks.mediator
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;

	import org.robotlegs.mvcs.Mediator;

	import tl.core.old.WizardObject;
	import tl.core.role.Role;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;
	import tl.frameworks.model.WizardSettingModel;
	import tl.mapeditor.ui.common.MyButton;

	import tl.mapeditor.ui.window.WizardSettingUI;

	import tool.StageFrame;

	/**模型设置界面*/
	public class WizardSettingUIMediator extends Mediator
	{
		[Inject]
		public var view: WizardSettingUI;
		[Inject]
		public var model: WizardSettingModel;
		private var _isMouseDown:Boolean = false;
		private var _currentEvent:String;
		private var _currentMove:int;
		private var _isControl:Boolean;				//ctrl键按下标志
		public function WizardSettingUIMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			super.onRegister();
			view.init('模型编辑', 360, 240);
			eventMap.mapListener(view.stage,Event.RESIZE, onResize);
			eventMap.mapListener(view.upBtn,MouseEvent.MOUSE_DOWN, onClickBtnDown);
			eventMap.mapListener(view.downBtn,MouseEvent.MOUSE_DOWN, onClickBtnDown);
			eventMap.mapListener(view.leftBtn,MouseEvent.MOUSE_DOWN, onClickBtnDown);
			eventMap.mapListener(view.rightBtn,MouseEvent.MOUSE_DOWN, onClickBtnDown);
			eventMap.mapListener(view.upBtn,MouseEvent.MOUSE_UP, onClickBtnUp);
			eventMap.mapListener(view.downBtn,MouseEvent.MOUSE_UP, onClickBtnUp);
			eventMap.mapListener(view.leftBtn,MouseEvent.MOUSE_UP, onClickBtnUp);
			eventMap.mapListener(view.rightBtn,MouseEvent.MOUSE_UP, onClickBtnUp);
			addContextListener(NotifyConst.SELECT_WIZARDOBJECT_SETTING, onSelectedWizardObject)
			eventMap.mapListener(view.stage,KeyboardEvent.KEY_DOWN, onKeyDown);
			eventMap.mapListener(view.stage,KeyboardEvent.KEY_UP, onKeyUp);
			onSelectedWizardObject(null)
			onResize();
			addContextListener(NotifyConst.CLOSE_ALL_UI, onClose);
		}

		private function onClose(event:*):void
		{
			if(view.parent)
				view.parent.removeChild(view)
		}

		private function onClickBtnDown(event:MouseEvent):void
		{
			var btn:MyButton = event.currentTarget as MyButton;
			if(btn == view.upBtn || btn == view.downBtn)
			{
				if(btn == view.upBtn)
				{
					_currentMove = 1;
				}	else {
					_currentMove = -1;
				}
				_isMouseDown = true;
				_currentEvent = NotifyConst.TOOL_TARGET_UP
			}	else if(btn == view.rightBtn || btn == view.leftBtn){
				if(btn == view.leftBtn)
				{
					_currentMove = 1;
				}	else {
					_currentMove = -1;
				}
				_isMouseDown = true;
				_currentEvent = NotifyConst.TOOL_TARGET_ROTATE;
			}
			dispatchWith(_currentEvent, false, _currentMove);
			setTimeout(continueMove, 200);
		}

		private function onClickBtnUp(event:MouseEvent):void
		{
			_isMouseDown = false;
		}

		private function continueMove():void
		{
			trace(StageFrame.renderIdx,"WizardSettingUIMediator/onClickBtn", _isMouseDown);
			if(_isMouseDown)
			{
				dispatchWith(_currentEvent, false, _currentMove);
				StageFrame.addNextFrameFun(continueMove);
				if(_currentMove < 0)
				{
					_currentMove = -5;
				}	else {
					_currentMove = 5;
				}
			}
		}

		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
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

		private function onSelectedWizardObject(event:TLEvent):void
		{
			if(!model.showObj) return;
			if(model.showObj is Role)
				view.nameTxt.text = '设置' + model.showObj.vo.name + '位置';
			else
				view.nameTxt.text = '设置刚体位置';
		}

		private function onResize(event:* = null):void
		{
			view.x = 350;
			view.y = StageFrame.stage.stageHeight - view.myHeight;
		}

		override public function onRemove():void
		{
			super.onRemove();
			_isMouseDown = false;
		}
	}
}
