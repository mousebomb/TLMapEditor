package HLib.IResources
{
	/**
	 * 性能测试类 
	 * @author 李舒浩
	 */	
	
	import flash.utils.getTimer;

	public class PerformanceTest
	{
		private static var _performanceTest:PerformanceTest;
		private var _nowTime:Number = 0;	//开始的时间记录
		
		public function PerformanceTest()
		{  
			if(_performanceTest)
			{
				throw new Error("单例只能实例化一次,请用 getInstance() 取实例");
			}
			_performanceTest = this;
		}
		
		public static function getInstance():PerformanceTest
		{
			if(!_performanceTest) _performanceTest = new PerformanceTest();
			return _performanceTest;
		}
		/**
		 * 执行测试 
		 * @param state	: 状态类型(start : 开始, end : 结束)
		 */		
		public function testRunning(state:String):Number
		{
			if(state == "start") {
				_nowTime = getTimer();
				return _nowTime;
			} else {
				var useTime:Number = (getTimer()-_nowTime)/1000;
				var tipsText:String = ('运行结束,当前执行段消耗时间为:$time秒').replace('$time',useTime);
//				trace(tipsText);
//				HSuspendTips.ShowTips(tipsText);
				return useTime;
			}
		}
	}
}