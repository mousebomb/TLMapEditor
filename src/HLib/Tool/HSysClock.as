package HLib.Tool
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * 公用时间类
	 * @author 李舒浩 
	 */	
	public class HSysClock extends Sprite
	{
		private static var MyInstance:HSysClock;
		private var _callBackDic:Dictionary = new Dictionary();	//方法存储字典
		private var _HFrameWorker:HFrameWorker=new HFrameWorker();
		private var _dicLen:uint = 0;								//执行方法数量
		private const TIMER_SECOND:int = 1000;						//每次执行的时间段(毫秒数)
		private var _lastTime:Number = 0;							//上一次时间
		private var _TimeDiff:int=0;
		
		public function HSysClock()
		{
			if( MyInstance )
			{
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			MyInstance = this;
		}
		/** 获取单例时间对象 **/
		public static function getInstance():HSysClock 
		{
			if ( MyInstance == null ) 
			{				
				MyInstance = new HSysClock();
			}
			return MyInstance;
		}
		
		public function CountDiff(cliTime:int, svrTime:int):void
		{
			_TimeDiff = svrTime - cliTime;
			_HFrameWorker.InIt("HSysClock");
		}
		
		/** 获取一个与服务端同步的时间 **/
		public function getSysTimer():int
		{
			var date:Date = new Date();
			var sysTimer:int = int(date.time / 1000) + _TimeDiff;
			date = null;
			return sysTimer;
		}
		
		/**  获得一个与服务器同步的日期对象 **/		
		public function getSysDate():Date
		{
			var sysTimer:int = getSysTimer();
			return new Date(sysTimer * 1000);
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
		public function addCallBack(key:Object, callBack:Function):void
		{
			if(_callBackDic[key] != null)
			{
				//				throw new Error("当前方法是用的KEY值已经存在，请换KEY名，KEY为：" + key);
				return;
			}
			_callBackDic[key] = callBack;
			_dicLen++;
			
			if( !_HFrameWorker.hasFunction(onEnterFrame) )
			{
				_HFrameWorker.addFunction(onEnterFrame);
			}
		}
		
		/**
		 * 移除定时器实时调用的方法 
		 * @param key	: 方法的key值
		 */		
		public function removeCallBack(key:Object):void
		{
			if(!_callBackDic[key]) 
			{
				return;
			}
			delete _callBackDic[key];
			_dicLen--;
			if(_dicLen <= 0) 
			{
				_HFrameWorker.removeFunction(onEnterFrame);
			}
		}
		
		/**
		 * 是否有指定的方法 
		 * @param key	: 方法的key
		 */		
		public function isHasCallBack(key:Object):Boolean
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
			var nowTime:Number = getTimer();
			var tmpTime:Number = nowTime - _lastTime;
		
			if (tmpTime > TIMER_SECOND)
			{
				var flag:int = tmpTime -TIMER_SECOND;
				for each(var callback:Function in _callBackDic)
				{
					callback();
				}
				_lastTime = nowTime -flag ;
			}
		}
		
		
		public function get TimeDiff():int
		{
			return _TimeDiff;
		}
	}
}