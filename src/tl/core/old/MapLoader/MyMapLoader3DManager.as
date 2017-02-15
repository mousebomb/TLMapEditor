package tl.core.old.MapLoader
{
	/**
	 * 地图加载管理类
	 * @author 李舒浩
	 */	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import HLib.IResources.IResourceEvent;
	import HLib.IResources.LoaderManager;
	import HLib.IResources.load.LoaderParam;
	import HLib.IResources.load.LoaderTaskParam;
	
	import tool.StageFrame;
	
	public class MyMapLoader3DManager extends EventDispatcher
	{
		private static var _instance:MyMapLoader3DManager;
		
		public function MyMapLoader3DManager()
		{
			if(_instance)
			{
				throw new Error("单例不可重复实例化!!");
			}
			_instance = this;
			_loader = LoaderManager.inst;
		}
		
		public static function get instance():MyMapLoader3DManager
		{
			return _instance ||= new MyMapLoader3DManager();
		}
		
		private var _loader:LoaderManager;
		
		/**
		 * 添加加载项
		 * @param $packName	: 资源文件名
		 * @param $subPath	: 资源文件夹名
		 * @param $extString: 资源后缀名
		 * @param $isFirst	: 是否优先
		 */		
		public function addLoader(key:String, $packName:String, $subPath:String, $extString:String, finishFun:Function = null):String
		{
			var taskParam:LoaderTaskParam = new LoaderTaskParam();
			taskParam.key = key;
//			taskParam.isCancel = true;
			taskParam.finishFun.addFun(finishFun);
			
			if (MyMapResTool.instance.getResource($packName + $extString) == null)
			{
				var param:LoaderParam = new LoaderParam();//ObjectPools.getLoaderParam();
				param.state = LoaderParam.NOT_LOADED;
				param.filePath = $subPath;
				param.filename = $packName;
				param.fileExt = $extString;
				param.loadCls = MyMapLoader;
//				param.taskParam = taskParam;
				taskParam.params.push(param);
				
				_loader.addTask(taskParam, LoaderManager.NORMAL);
			}
			else
			{
				_taskParams.push(taskParam);
				StageFrame.addNextFrameFun(dispatchComplete);
			}
			
			return key;
		}
		
		private function dispatchComplete():void
		{
			for each (var taskParam:LoaderTaskParam in _taskParams)
			{
				taskParam.finishFun.exec();
				dispatchEvent(new IResourceEvent(IResourceEvent.ResourceTaskComplete + taskParam.key, taskParam.key));
			}
			_taskParams.length = 0;
		}
		
		private var _taskParams:Vector.<LoaderTaskParam> = new Vector.<LoaderTaskParam>();
		
		/*public function removeKey(key:String):void
		{
			_loader.removeTask(key);
		}*/
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_loader.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_loader.removeEventListener(type, listener, useCapture);
		}
		
		override public function dispatchEvent(event:Event):Boolean
		{
			return _loader.dispatchEvent(event);
		}
		
		public override function hasEventListener(type:String):Boolean
		{
			return _loader.hasEventListener(type);
		}
		
		public override function willTrigger(type:String):Boolean
		{
			return _loader.willTrigger(type);
		}
	}
}