package HLib.Tool
{
	/**
	 * 帧监听管理类
	 * @author 黄栋
	 * @重构 李舒浩
	 */	
	import flash.display.Stage;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import HLib.MyClientNamespace;
	import HLib.Event.Event_F;
	import HLib.Event.HEvent;
	
	import tool.FPSCount;
	import tool.FrameWorkerBase;
	
	use namespace MyClientNamespace;
	
	public class HFrameWorkerManager extends FrameWorkerBase
	{
		private static var MyInstance:HFrameWorkerManager;
		
		private var _isInit:Boolean = false;			//是否初始化过
		
		private var _stage:Stage;
		private var _keys:Dictionary;
		
		private var _fpsNow:int = 0;
		private var _fps:int = 0;
		private var _fpsStartTime:Number = 0;
		
		public function HFrameWorkerManager()
		{
			if( MyInstance )
			{
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			MyInstance = this;	
		}
		
		public static function getInstance():HFrameWorkerManager 
		{
			if ( !MyInstance ) 
			{				
				MyInstance = new HFrameWorkerManager();
			}
			return MyInstance;
		}
		
		public function InIt($stage:Stage):void
		{
			if(_isInit) 
			{
				return;
			}
			
			_stage = $stage;
			
			_keys = new Dictionary();
			
			this.addEnterFrameCallBack("Fps_Pulsating", fpsCount);
			
			_isInit = true;
		}
		
		private function fpsCount():void
		{
			_fps++;
			var _fpsLasTime:Number = getTimer();
			if(Number(_fpsLasTime - _fpsStartTime) > 1000)
			{
				_fpsStartTime = _fpsLasTime;
				//游戏休眠状态的切换判断
				//				if(_fpsNow>8 && _fps<8){
				//					this.dispatchEvent(new HEvent(HEvent.Fps_Dormancy,true));
				//				}
				if(_fpsNow < 8 && _fps > 8)
				{
					this.dispatchEvent(new Event_F(HEvent.Fps_Dormancy, false));
				}
				FPSCount.nowFps = _fpsNow = _fps;
				_fps = 0;
				
				//this.dispatchEvent(new HEvent(HEvent.Fps_Pulsating,_fpsNow));
			}
		}
		
		public function addFunc(key:Object, func:Function):void
		{
			if(hasEnterFrameCallBack(key))
			{
				return;
			}
			//添加方法
			_keys[key] = func;
			addFun_1(func);
		}
		
		public function removeFunc(key:Object):void
		{
			if(hasEnterFrameCallBack(key))
			{
				removeFun_1(_keys[key]);
				delete _keys[key];
			}
		}
		
		/**
		 * 添加到指定帧执行方法 
		 * @param key	: 方法key
		 * @param func	: 需要添加的方法
		 */		
		MyClientNamespace function addEnterFrameCallBack(key:String, func:Function):void
		{
			addFunc(key, func);
		}
		
		/**
		 * 移除帧方法 
		 * @param key	: 需要移除的方法Key
		 */		
		MyClientNamespace function removeEnterFrameCallBack(key:String):void
		{
			removeFunc(key);
		}
		
		/**
		 * 获取当前方法是否已经添加到指定数组中了 
		 * @param key	: 方法key
		 * @return 		: true: 有添加 false: 没有添加
		 */		
		MyClientNamespace function hasEnterFrameCallBack(key:Object):Boolean
		{
			if(key == null) 
			{
				throw new Error("MyEnterFrame Error: key is null!");
			}
			return (_keys[key] != null);
		}
		
		public function get fpsNow():int
		{
			return _fpsNow;
		}		
	}
}