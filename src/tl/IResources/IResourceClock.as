package tl.IResources
{
	import flash.utils.getTimer;

	public class IResourceClock
	{
		private static var MyInstance:IResourceClock;
		private var _nowTime:Number = 0;	//开始的时间记录
		public function IResourceClock()
		{
			if( MyInstance ){
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			MyInstance=this;
		}
		public static function getInstance():IResourceClock{
			if(!MyInstance){
				MyInstance=new IResourceClock();	
			}
			return MyInstance;
		}
		/**
		 * 执行测试 
		 * @param state	: 状态类型(start : 开始, end : 结束)
		 */		
		public function getStateTime(state:String,startTime:Number=0):Number
		{
			if(state == "start") {
				_nowTime = getTimer();
				return _nowTime;
			} else {
				var useTime:Number = (getTimer()-startTime)/1000;
				var tipsText:String = ('运行结束,当前执行段消耗时间为:$time秒').replace('$time',useTime);
				return useTime;
			}
		}
	}
}