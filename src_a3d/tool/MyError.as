package tool
{
	/**
	 * 自定义错误提示类
	 * @author 李舒浩
	 */	
	public class MyError extends Error
	{
		private static const errorVec:Vector.<String> = Vector.<String>([
			 "单例模式不可重复实例化,请调用getInstance()方法"
			,"Away3DConfig类myStage未赋值,请在给项目中获得stage时赋值于此,以便Away3D类库使用stage属性"
		]);
		
		public function MyError(type:int = 0)
		{
			var message:String = MyError.errorVec[type];
			super(message);
		}
	}
}