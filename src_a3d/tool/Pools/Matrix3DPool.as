package tool.Pools
{
	import flash.geom.Matrix3D;

	public class Matrix3DPool
	{
		private var _objVec:Vector.<Matrix3D>;
		private var _maxSize:uint;
		
		public function Matrix3DPool(maxSize:uint = 100)
		{
			_objVec = new Vector.<Matrix3D>();
			_maxSize = maxSize;
		}
		
		public function getMatrix3D():Matrix3D
		{
			if (_objVec.length)
			{
				var obj:Matrix3D = _objVec.pop();
				return obj;
			}
			return new Matrix3D();
		}
		
		public function recycle(obj:Matrix3D):void
		{
			if (_objVec.length < _maxSize)
			{
				obj.identity();
				_objVec.push(obj);
			}
		}
	}
}