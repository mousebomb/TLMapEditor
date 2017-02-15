package tool.Pools
{

	public class NormalPool extends PoolBase
	{
		public function NormalPool(maxSize:uint = 100, checkExists:Boolean = true)
		{
			super(maxSize, checkExists);
		}
		
		public function getObject(cls:Class, ...args):IPoolObject
		{
			return getObject1.apply(this, [cls].concat(args)) as IPoolObject;
		}
		
		public function recycle(obj:IPoolObject):void
		{
			recycle1(obj);
		}
	}
}