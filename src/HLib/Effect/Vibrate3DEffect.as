package HLib.Effect
{
	import flash.utils.getTimer;
	
	/**
	 * 振屏 
	 * @author 杨张永
	 * 
	 */
	public class Vibrate3DEffect
	{
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _z:Number = 0;
		
		private var _scopeHalf:Number = 0;
		private var _scope:Number = 0;
		
		private var _startTime:uint;
		private var _delay:uint;
		
		public function Vibrate3DEffect()
		{
			
		}
		
		private var _isActive:Boolean = false;
		public function setVals(scope:Number, delay:uint):void
		{
			_scope = Math.max(scope, _scope);
			
			if (getTimer() + delay > _startTime + _delay)
			{
				_startTime = getTimer();
				_scopeHalf = _scope / 2;
				_delay = delay;
			}
			
			_isActive = true;
		}
		
		public function update():void
		{
			if (_isActive)
			{
				if (getTimer() - _startTime < _delay)
				{
					_x = _scopeHalf - Math.random() * _scope;
					_y = _scopeHalf - Math.random() * _scope;
					_z = _scopeHalf - Math.random() * _scope;
				}
				else
				{
					_scope = 0;
					_x = _y = _z = 0;
					_isActive = false;
				}
			}
		}
		
		public function get offX():Number
		{
			return _x;
		}
		public function get offY():Number
		{
			return _y;
		}
		public function get offZ():Number
		{
			return _z;
		}
	}
}