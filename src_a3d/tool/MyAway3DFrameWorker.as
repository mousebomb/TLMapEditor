package tool
{
	/**
	 * 公用EnterFrame事件
	 * @authro 李舒浩 
	 * 
	 * 用法：
	 * 		MyEnterFrame.instance.addFunction(执行帧数类型, 需要执行的方法);
	 * 		MyEnterFrame.instance.removeFunction(执行帧数类型, 需要移除的方法);
	 * 		MyEnterFrame.instance.close();	//移除所有的帧监听执行方法
	 * 
	 * 属性与方法:
	 * 		addFunction		: 添加执行方法
	 * 		removeFunction	: 移除执行方法
	 * 		close			: 清除方法
	 */	
	
	import flash.utils.Dictionary;
	
	use namespace MyAway3DNameSpace
	
	public class MyAway3DFrameWorker extends FrameWorkerBase
	{
		private static var _Instance:MyAway3DFrameWorker;
		
		private var _isInit:Boolean = false;			//是否初始化过
		
		private var _keys:Dictionary;
		
		public function MyAway3DFrameWorker()
		{
			if(_Instance) 
			{
				throw new Error("单例模式不可重复实例化");
			}
			_Instance = this;
		}
		
		public static function get instance():MyAway3DFrameWorker
		{
			if(!_Instance)
			{
				_Instance = new MyAway3DFrameWorker();
				_Instance.init();
			}
			return _Instance;
		}
		/** 初始化方法(不可调用) **/
		MyAway3DNameSpace function init():void
		{
			if(_isInit) 
			{
				return;
			}
			
			_keys = new Dictionary();
			
			_isInit = true;
		}
		
		/**
		 * 添加到指定帧执行方法 
		 * @param key	: 方法key
		 * @param func	: 需要添加的方法
		 */		
		MyAway3DNameSpace function addEnterFrameCallBack(key:String, func:Function):void
		{
			addFun(key, func);
		}
		
		/**
		 * 移除帧方法 
		 * @param key	: 需要移除的方法Key
		 */		
		MyAway3DNameSpace function removeEnterFrameCallBack(key:String):void
		{
			removeFun(key);
		}
		
		/**
		 * 获取当前方法是否已经添加到指定数组中了 
		 * @param key	: 方法key
		 * @return 		: true: 有添加 false: 没有添加
		 */		
		MyAway3DNameSpace function hasEnterFrameCallBack(key:String):Boolean
		{
			if(key == null)
			{
				throw new Error("MyEnterFrame Error: key is null!");
			}
			return (_keys[key] != null);
		}
		
		public function addFun(key:Object, fun:Function):void
		{
			if(_keys[key] != null)
			{
				return;
			}
			_keys[key] = fun;
			addFun_1(fun);
		}
		
		public function removeFun(key:Object):void
		{
			var fun:Function = _keys[key];
			removeFun_1(fun);
			delete _keys[key];
		}
		
		override public function dispose():void
		{
			_keys = null;
			
			super.dispose();
		}
	}
}