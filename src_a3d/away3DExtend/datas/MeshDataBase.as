package away3DExtend.datas
{
	import tool.Pools.IPoolObject;

	public class MeshDataBase implements IPoolObject
	{
		public function MeshDataBase()
		{
			
		}
		
		// 从池中取出已有对象时触发
		public function initPoolObject(data:Object = null):void
		{
			
		}
		// 回收到池时触发 
		public function clearPoolObject():void
		{
			
		}
		
		public function dispose():void
		{
			
		}
	}
}