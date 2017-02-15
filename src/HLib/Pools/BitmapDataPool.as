package HLib.Pools
{
	import flash.display.BitmapData;

	public class BitmapDataPool
	{
		private var _size:uint;
		private var _objVec:Vector.<BitmapData>;
		private var _maxSize:uint;
		
		public function BitmapDataPool(size:uint, maxSize:uint = 100)
		{
			_objVec = new Vector.<BitmapData>();
			_maxSize = maxSize;
			_size = size;
		}
		
		public function getObject():*
		{
			if (_objVec.length)
			{
				return _objVec.pop();
			}
			
			return new BitmapData(_size, _size)
		}
		
		public function recycle(bmd:BitmapData):void
		{
			if (bmd == null)
			{
				return;
			}
			if (_objVec.indexOf(bmd) != -1)
			{
				throw new Error("重复回收同一对象-->" + bmd);
			}
			
			if (_objVec.length < _maxSize)
			{
				_objVec.push(bmd);
			}
			else
			{
				bmd.dispose();
			}
		}
	}
}