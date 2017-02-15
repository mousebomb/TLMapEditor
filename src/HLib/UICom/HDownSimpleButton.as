package HLib.UICom
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import HLib.UICom.Component.HSimpleButton;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;

	/**
	 * 支持长按事件的按钮 
	 * @author Administrator
	 * 
	 */	
	public class HDownSimpleButton extends HSimpleButton
	{
		private var _mIsDown:Boolean;
		private var _delayTime:int = 80;
		private var _timer:Timer;
		public function HDownSimpleButton()
		{
			super();
		}
		
		protected function onTimeComplete(event:TimerEvent):void
		{
			if(_mIsDown)
				dispatchEventWith("btnContinueDown", true);
			else
				_timer.stop();
		}		
		
		/**
		 * 鼠标事件 
		 * @param e
		 * 
		 */		
		override protected function onTouch(e:TouchEvent):void{
			//选中和失效状态不处理
			if(selected || disabled)return;
			
			var isDraw:Boolean ,isDispatch:Boolean;
			var _Touch:Touch=e.getTouch(this);
			if(_Touch == null){
				if(_currentState != _upState)
				{
					isDraw = true;
					_currentState = _upState;
					selectedTextColor = upTextColor;
				}
			}	else {
				if (_Touch.phase == "began")//down
				{
					_mIsDown = true;
					if(!_timer)
					{
						_timer  = new Timer(_delayTime)
						_timer.addEventListener(TimerEvent.TIMER, onTimeComplete);
					}
					_timer.start();
					if(_currentState != _downState)
					{
						isDraw = true;
						_currentState = _downState;
						selectedTextColor = downTextColor;
					}
				} 	else if (_Touch.phase == "hover") {//over
					if(_currentState != _overState)
					{
						isDraw = true;
						_currentState = _overState;
						if(isMoveTextColor)
							selectedTextColor = moveTextColor;
						else
							selectedTextColor = overTextColor
					}
				} 	else if (_Touch.phase == "ended") {//click
					_mIsDown = false;
					if(_timer)
						_timer.stop();
					//对象池事件
					if(disabled)
					{
						if(_currentState != _disabledState)
						{
							isDraw = true;
							_currentState = _disabledState
							selectedTextColor = disabledTextColor
						}
					}	else if(selected) {
						if(_currentState != _selectedState)
						{
							isDraw = true;
							_currentState = _selectedState;
							selectedTextColor = selectedTextColor
						}
					}	else {
						if(_currentState != _upState)
						{
							isDraw = true;
							_currentState = _upState;
							selectedTextColor = upTextColor
						}
					}
					isDispatch = true;
				}
			}
			if(isDraw)
			{
				this.myDrawByTexture(_currentState);
				updateLabel();
			}
			if(isDispatch)
			{
				if(_timer)
					_timer.stop();
				dispatchEventWith(Event.TRIGGERED, true);
			}
		}

		public function get delayTime():int
		{
			return _delayTime;
		}

		public function set delayTime(value:int):void
		{
			_delayTime = value;
		}

	}
}