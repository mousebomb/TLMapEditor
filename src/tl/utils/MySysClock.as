package tl.utils
{
	/**
	 * 公用时间类
	 * @author 李舒浩 
	 */	
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class MySysClock extends Sprite
	{
		private static var _mySysClock:MySysClock;
		private var _callBackDic:Dictionary = new Dictionary();	//方法存储字典
		private var _dicLen:uint = 0;								//执行方法数量
		private var _timerSeconds:int = 1000;						//每次执行的时间段(毫秒数)
		private var _lastTime:Number = 0;							//上一次时间
		private var _timeDiff:int=0;
		
		public function MySysClock()
		{
			if( _mySysClock ) throw new MyError();
			_mySysClock = this;
		}
		/** 获取单例时间对象 **/
		public static function getInstance():MySysClock 
		{
			_mySysClock ||= new MySysClock();
			return _mySysClock;
		}
		public function CountDiff(cliTime:int,svrTime:int):void
		{
			_timeDiff = svrTime - cliTime;
			trace (_timeDiff);
		}
		/** 获取一个与服务端同步的时间 **/
		public function getSysTimer():int
		{
			var date:Date = new Date();
			var sysTimer:int = int(date.time/1000) + _timeDiff;
			date = null;
			return sysTimer;
		}
		/**  获得一个与服务器同步的日期对象 **/		
		public function getSysDate():Date
		{
			var sysTimer:int = getSysTimer();
			return new Date(sysTimer*1000);
		}
		/** 获取一个与服务端同步的时间格式字符串**/
		public function getSysTimerString():String
		{
			return Tool.conversionTime( getSysTimer(), "h:m:s");
		}
		/** 获取一个与服务端同步的时间有月日的格式字符串**/
		public function getSysTimerString2():String
		{
			return Tool.conversionTime( getSysTimer(), "y-m-d  h:m:s");
		}
		/**
		 * 添加定时器实时调用方法 
		 * @param key		: 方法的key值
		 * @param callBack	: 调用的方法
		 * 	@PS	: key为一个对象，同一个对象不能执行两个方法，如需要执行多个方法请在调用的方法中再执行多个方法
		 */		
		public function addCallBack(key:Object,callBack:Function):void
		{
			if(_callBackDic[key]!=null)
			{
				throw new Error("当前方法是用的KEY值已经存在，请换KEY名，KEY为：" + key);
				return;
			}
			_callBackDic[key] = callBack;
			_dicLen++;
				
			if( !MyEnterFrame.getInstance().hasFunction(1, onEnterFrame) )
				MyEnterFrame.getInstance().addFunction(1, onEnterFrame);
		}
		/**
		 * 移除定时器实时调用的方法 
		 * @param key	: 方法的key值
		 */		
		public function removeCallBack(key:String):void
		{
			if(!_callBackDic[key]) return;
			delete _callBackDic[key];
			_dicLen--;
			if(_dicLen <= 0) 
				MyEnterFrame.getInstance().removeFunction(1, onEnterFrame);
		}
		
		/**
		 * 是否有指定的方法 
		 * @param key	: 方法的key
		 */		
		public function isHasCallBack(key:String):Boolean
		{
			return (_callBackDic[key] != null);
		}
		/** 获取调度方法数量 **/		
		public function get myLenght():uint
		{
			return _dicLen;
		}
		
		/** 调度执行方法 **/
		private function onEnterFrame():void
		{
			var nowTime:Number = new Date().time;
			if((nowTime - _lastTime) >= _timerSeconds) 
			{
				_lastTime = nowTime;
				actionCallBack();
			}
		}
		/** 执行回调 **/
		private function actionCallBack():void
		{
			for each(var callback:Function in _callBackDic)
			{
				callback();
			}
		}
	}
}