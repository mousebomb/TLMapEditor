package HLib.IResources
{
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import HLib.IResources.load.LoaderParam;
	import HLib.IResources.load.LoaderTaskParam;
	
	import Modules.Common.HKeyboardManager;
	
	import away3d.debug.Debug;

	/** 不管 2d 3d 地图 实际加载类*/
	public class LoaderManager extends EventDispatcher
	{
		private static var _inst:LoaderManager;
		public static function get inst():LoaderManager
		{
			if (_inst == null)
			{
				_inst = new LoaderManager();
			}
			
			return _inst;
		}
		//===================================================
		public static const MUST:uint = 0;
		public static const NORMAL:uint = 1;
		public static const BACK:uint = 2;
		
		
		private const MAX_LOAD_QUEUE_NUM:int = 4;		//最大队列数
		
		private var _normalQueue:LoaderQueue;
		
		private var _backQuque:BackLoaderQueue;
		
		private var _mustQueue:LoaderQueue;
		
		private var _queues:Vector.<ILoaderQueue>;
		
		public function LoaderManager():void
		{
			_mustQueue = new LoaderQueue(MUST);
			_normalQueue = new LoaderQueue(NORMAL);
			_backQuque = new BackLoaderQueue(BACK);
			
			_queues = new Vector.<ILoaderQueue>();
			_queues.push(_mustQueue);
			_queues.push(_normalQueue);
			_queues.push(_backQuque);
		}
		
		public function clearAll():void
		{
			//			_mustQueue.clear();
			_normalQueue.clear();
		}
		
		public function addTask(taskParam:LoaderTaskParam, queueType:uint = 1):String
		{
			var tmpKey:String = taskParam.key;
			
			var isCache:Boolean = true;
			var param:LoaderParam;
			for each (param in taskParam.params)
			{
				if (BackLoaderManager.inst.hasCache(param.resKey) == false)
				{
					isCache = false;
					break;
				}
			}
			
			for each (param in taskParam.params)
			{
				BackLoaderManager.inst.addBackCache(param.resKey);
				param.taskParam = taskParam;
			}
			
			if (queueType != BACK)
			{
				if (isCache)
				{
					queueType = MUST;
				}
			}
			_queues[queueType].addTask(taskParam);
			
			startNextTask();
			
			return tmpKey;
		}
		
		private function startNextTask():void
		{
			for (var i:int = 0; i < MAX_LOAD_QUEUE_NUM; ++i)
			{
				if (goOnTask() == false)
				{
					return;
				}
			}
		}
		
		public function removeTask(key:String, queueType:int = -1):void
		{
			if (queueType == -1)
			{
				_mustQueue.removeTask(key);
				_normalQueue.removeTask(key);
				//				_backQuque.removeTask(key);
			}
			else
			{
				_queues[queueType].removeTask(key);
			}
		}
		
		private function createLoader(param:LoaderParam):IResLoader
		{
			return new (param.loadCls)();
		}
		
		private function get nextParam():LoaderParam
		{
			var param:LoaderParam = _mustQueue.nextParam;
			if (_isPauseOther == false)
			{
				if (param == null)
				{
					param = _normalQueue.nextParam;
				}
				if (param == null)
				{
					param = _backQuque.nextParam;
				}
			}
			return param;
		}
		
		private var _isPauseOther:Boolean = false;
		public function stopOther():void
		{
			_isPauseOther = true;
		}
		
		public function playOther():void
		{
			_isPauseOther = false;
			startNextTask();
		}
		
		private var _loadNum:int = 0;
		private function goOnTask():Boolean
		{
			var param:LoaderParam = nextParam;
			if(_loadNum >= MAX_LOAD_QUEUE_NUM || param == null) 
			{
				return false;
			}
			
			if (param.queueType != BACK)
			{
				_backQuque.removeResKey(param.resKey);
			}
			
			var loader3D:IResLoader = createLoader(param);
			param.state = LoaderParam.LOADED;
			param.errFun.addFun(onError);
			param.succFun.addFun(onSucc);
			param.progressFun.addFun(onProgress);
			param.startTime = getTimer();
			loader3D.startLoad(param);
			
			//			trace("开始加载素材-->", param.toStr());
			
			++_loadNum;
			return true;
		}
		
		private function entryNext(tmpParam:LoaderParam, isFinish:Boolean):void
		{
			//			var tmpParam:LoaderParam = loader.param;
			/*if (tmpParam.totalByte != 0 && tmpParam.loadByte != tmpParam.totalByte)
			{
			throw new Error("加载的文件未完成--->" + tmpParam.urlStr + ":" + tmpParam.loadByte + ":" + tmpParam.totalByte);
			}*/
			if (isFinish)
			{
				BackLoaderManager.inst.addCache(tmpParam.resKey);
			}
			
			var tmpQueue:ILoaderQueue = _queues[tmpParam.queueType];
			tmpQueue.finishParam(tmpParam);
			tmpParam.state = LoaderParam.FINISH_LOADED;
			
			var tmpTaskParam:LoaderTaskParam = tmpParam.taskParam;
			var tmpKey:String = tmpTaskParam.key;
			if (tmpTaskParam.isAllSurc && tmpKey != "")
			{
//				trace("素材包加载完成--------------------------->", tmpKey);
				
				tmpQueue.removeTask(tmpKey);
				
				tmpTaskParam.finishFun.exec(tmpTaskParam.key, tmpTaskParam.progressType);
				dispatchEvent(new IResourceEvent(IResourceEvent.ResourceTaskComplete + tmpKey, tmpKey, isFinish));
			}
		}
		
		private function onProgress(loader:IResLoader):void
		{
			var tmpTaskParam:LoaderTaskParam = loader.param.taskParam;
			tmpTaskParam.progressFun.exec(tmpTaskParam.loadRate, tmpTaskParam.key, tmpTaskParam.progressType);
		}
		
		/** 加载错误 **/
		private function onError(loader:IResLoader):void
		{
			--_loadNum;
			if(_loadNum < 0)
			{
				_loadNum = 0;
			}
			var tmpParam:LoaderParam = loader.param;
			loader.stop();
			
			if (++tmpParam.retryCount < 3)
			{
				tmpParam.state = LoaderParam.NOT_LOADED;
//				trace("重置加载进程-->", tmpParam.toStr());
			}
			else
			{
				entryNext(tmpParam, false);
				if (HKeyboardManager.getInstance().isGM)
				{
					Debug.error("找不到加载需要的资源文件！" + tmpParam.toStr());
				}
			}
			startNextTask();
		}
		
		/** 加载全部资源加载完成 **/
		private function onSucc(loader:IResLoader):void
		{
			--_loadNum;
			if(_loadNum < 0)
			{
				_loadNum = 0;
			}
//			trace("素材加载完成-->", loader.param.toStr());
			var tmpParam:LoaderParam = loader.param;
			loader.stop();
			
			entryNext(tmpParam, true);
			startNextTask();
		}
		//================================================================================================================================================================
	}
}