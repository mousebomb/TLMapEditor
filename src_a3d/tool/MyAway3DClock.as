package tool
{
	/**
	 * 公用时间类
	 * @author 李舒浩 
	 */	
	use namespace MyAway3DNameSpace
	
	public class MyAway3DClock
	{
		private static var _instance:MyAway3DClock;
		
		private var _keyVec:Vector.<String> = new Vector.<String>();//定时器key
		private var _callBackVec:Vector.<Function> = new Vector.<Function>();//方法数组
		
		private var _timerSeconds:int = 5*60*1000;						//每次执行的时间段(毫秒数)
		private var _lastTime:Number = 0;							//上一次时间
		private var _serialNum:uint=0;
		public function MyAway3DClock()
		{
			if( _instance ) throw new Error ("单例不可重复实例化");
			_instance = this;
		}
		/** 获取单例时间对象 **/
		public static function get instance():MyAway3DClock 
		{
			return _instance ||= new MyAway3DClock();
		}
		/**
		 * 添加定时器
		 * @param $key		: 定时器key
		 * @param $callBack	: 定时器执行方法
		 */		
		public function addCallBack($key:String, $callBack:Function):String
		{
			_serialNum++;
			_keyVec.push( $key+"#"+_serialNum );
			_callBackVec.push( $callBack );
			
			if( !MyAway3DFrameWorker.instance.hasEnterFrameCallBack( "MyAwayDClock") ){
				MyAway3DFrameWorker.instance.addEnterFrameCallBack( "MyAwayDClock", onEnterFrame );
			}
			return $key+"#"+_serialNum;
		}
		/**
		 * 移除定时器实时调用的方法 
		 * @param key	: 方法的key值
		 */		
		public function removeCallBack($key:String):void
		{
			var index:int = _keyVec.indexOf( $key );
			if(index < 0) return;
			_keyVec.splice( index, 1 );
			_callBackVec.splice( index, 1 );			
			if(_keyVec.length == 0) {
				MyAway3DFrameWorker.instance.removeEnterFrameCallBack( "MyAwayDClock" );
				_serialNum=0;
			}
		}		
		/**
		* 清理定时器
		*/		
		public function clearCallBackAll():void{
			_keyVec.length=0;
			_callBackVec.length=0;
			MyAway3DFrameWorker.instance.removeEnterFrameCallBack( "MyAwayDClock" );
			_serialNum=0;
		}
		public function setSerialNum(value:uint):void{
			_serialNum=value;
		}
		public function get callBackFunVecLength():int{
			return _callBackVec.length;
		}
		/**
		 * 是否有指定的方法 
		 * @param key	: 方法的key
		 */		
		public function isHasCallBack($key:String):Boolean
		{
			return (_keyVec.indexOf($key) > -1);
		}
		/** 获取调度方法数量 **/		
		public function get length():uint
		{
			return _keyVec.length;
		}
		
		/** 调度执行方法 **/
		private function onEnterFrame():void
		{
			PropertyCount.getInstance().keyStart("Away3d.MyAway3dClock.onEnterFrame","away3d");
			var nowTime:Number = new Date().time;
			if((nowTime - _lastTime) >= _timerSeconds) 
			{
				_lastTime = nowTime;
				actionCallBack();
			}
			PropertyCount.getInstance().keyEnd("Away3d.MyAway3dClock.onEnterFrame","away3d");
		}
		/** 执行回调 **/
		private function actionCallBack():void
		{
			var len:int = _callBackVec.length;
			for(var i:int = 0; i < len; i++)
			{
				_callBackVec[i]();
			}
		}

	}
}