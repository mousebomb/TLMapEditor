package tool.Pools
{
	import flash.geom.Vector3D;

	public class Vector3DPool
	{
		private var _objVec:Vector.<Vector3D>;
		private var _maxSize:uint;
		
		public function Vector3DPool(maxSize:uint = 100)
		{
			_objVec = new Vector.<Vector3D>();
			_maxSize = maxSize;
		}
		
		public function getVector3D():Vector3D
		{
			if (_objVec.length)
			{
				var obj:Vector3D = _objVec.pop();
				return obj;
			}
			return new Vector3D();
		}
		
		public function recycle(obj:Vector3D):void
		{
			if (_objVec.length < _maxSize)
			{
				_objVec.push(obj);
			}
		}
	}
}