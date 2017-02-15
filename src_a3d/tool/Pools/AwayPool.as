package tool.Pools
{
	public class AwayPool
	{
		private var _objVec:Vector.<IPoolObject>;
		private var _maxSize:uint;
		public function AwayPool(maxSize:uint = 100)
		{
			_objVec = new Vector.<IPoolObject>();
			_maxSize = maxSize;
		}
		
		public function getObject(cls:Class):IPoolObject
		{
			if (_objVec.length)
			{
				return _objVec.pop();
			}
			return new cls();
		}
		
		public function recycle(obj:IPoolObject):void
		{
			if (_objVec.length < _maxSize)
			{
				_objVec.push(obj);
			}
			else
			{
				obj.dispose();
			}
		}
	}
}