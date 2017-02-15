package tl.core.Wizard.Move
{
	import flash.utils.getTimer;
	
	public class LineMove extends MoveBase
	{
		protected var _startTime:uint;
		protected var _tarTime:uint;
		protected var _delay:uint;
		
		public function LineMove()
		{
			super();
			
			//			cls_type = MoveBase.LINE_MOVE_TYPE;
		}
		
		override public function update():void
		{
			var curTime:int = getTimer() - _tarTime;
			if (curTime > 0)
			{
				var tmpRate:Number = curTime / _delay;
				_curPos.x = _startPos.x + _distPos.x * tmpRate;
				_curPos.y = _startPos.y + _distPos.y * tmpRate;
				_curPos.z = _startPos.z + _distPos.z * tmpRate;
			}
			else
			{
				if (_isOver == false)
				{
					_curPos.setTo(_endPos.x, _endPos.y, _endPos.z);
					_isOver = true;
				}
			}
		}
	}
}