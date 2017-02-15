package tool.Pools
{
	public interface IPoolObject
	{
		// 从池中取出已有对象时触发
		function initPoolObject(data:Object = null):void;
		// 回收到池时触发 
		function clearPoolObject():void;
		
		function dispose():void;
	}
}