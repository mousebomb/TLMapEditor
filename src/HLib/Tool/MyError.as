package HLib.Tool
{
	/**
	 * 自定义错误提示类
	 * @author 李舒浩
	 */	
	public class MyError extends Error
	{
		private static const errorVec:Vector.<String> = Vector.<String>([
			Tg.T( "单例模式不可重复实例化,请调用getInstance()方法")
		]);
		
		public function MyError(type:int = 0)
		{
			var message:String = MyError.errorVec[type];
			super(message);
		}
	}
}