package HLib.IResources
{
	import HLib.IResources.load.LoaderParam;
	import HLib.IResources.load.LoaderTaskParam;
	
	public class LoaderQueue implements ILoaderQueue
	{
		public static const FIFO:uint = 0;
		public static const FILO:uint = 1;
		
		private var _loaderParams:Vector.<LoaderParam> = new Vector.<LoaderParam>();
		private var _taskParams:Vector.<LoaderTaskParam> = new Vector.<LoaderTaskParam>();
		
		private var _sortType:uint = FIFO;
		
		private var _queueType:int;
		public function LoaderQueue(type:int)
		{
			_queueType = type;
			
			if (_queueType == LoaderManager.MUST)
			{
				_sortType = FIFO;
			}
		}
		
		private function containsKey(key:String):Boolean
		{
			for each(var taskParam:LoaderTaskParam in _taskParams)
			{
				if (taskParam.key == key)
				{
					return true;
				}
			}
			return false;
		}
		
		private function getIndexByKey(key:String):int
		{
			var taskParam:LoaderTaskParam;
			var taskLen:int = _taskParams.length;
			for (var i:int = 0; i < taskLen; ++i)
			{
				taskParam = _taskParams[i];
				if (taskParam.key == key)
				{
					return i;
				}
			}
			return -1;
		}
		
		public function addTask(taskParam:LoaderTaskParam):String
		{
			if(containsKey(taskParam.key)) 
			{
				return taskParam.key;
			}
			
			_taskParams.push(taskParam);
			
			for each (var param:LoaderParam in taskParam.params)
			{
				param.queueType = _queueType;
				_loaderParams.push(param);
			}
			
			/*
			var isExist:Boolean = false;
			var tmpLoaderParams:Vector.<LoaderParam> = taskParam.params;
			var tmpLoaderParam:LoaderParam;
			var len1:int = tmpLoaderParams.length;
			var tmpLoaderParam1:LoaderParam;
			var len2:int = _loaderParams.length;
			for (var i:int = 0; i < len1; ++i)
			{
			tmpLoaderParam = tmpLoaderParams[i];
			isExist = false;
			len2 = _loaderParams.length;
			for (var j:int = 0; j < len2; ++j)
			{
			tmpLoaderParam1 = _loaderParams[j];
			if (tmpLoaderParam.resKey == tmpLoaderParam1.resKey)
			{
			tmpLoaderParams[i] = tmpLoaderParam1;
			isExist = true;
			tmpLoaderParam1.taskParams.push(taskParam);
			
			_loaderParams.splice(j, 1);
			_loaderParams.push(tmpLoaderParam1);
			break;
			}
			}
			if (isExist == false)
			{
			tmpLoaderParam.taskParams.push(taskParam);
			tmpLoaderParam.queueType = _queueType;
			_loaderParams.push(tmpLoaderParam);
			}
			}
			*/
			
			return taskParam.key;
		}
		
		public function get nextParam():LoaderParam
		{
			var tmpLen:int = _loaderParams.length - 1;
			var tmpParam:LoaderParam;
			var i:int;
			if (_sortType == FILO)
			{
				for (i = tmpLen; i >= 0; --i)
				{
					tmpParam = _loaderParams[i];
					if (tmpParam.state == LoaderParam.NOT_LOADED)
					{
						return tmpParam;
					}
				}
			}
			else
			{
				for (i = 0; i <= tmpLen; ++i)
				{
					tmpParam = _loaderParams[i];
					if (tmpParam.state == LoaderParam.NOT_LOADED)
					{
						return tmpParam;
					}
				}
			}
			return null;
		}
		
		public function finishParam(param:LoaderParam):void
		{
			var idx:int = _loaderParams.indexOf(param);
			_loaderParams.splice(idx, 1);
		}
		
		public function clear():void
		{
			/*for each (var taskParam:LoaderTaskParam in _taskParams)
			{
//				if (taskParam.isCancel)
//				{
					removeTask(taskParam.key);
//				}
			}*/
			_loaderParams.length = 0;
			_taskParams.length = 0;
		}
		
		public function removeTask(key:String):void
		{
			var tmpIdx:int = getIndexByKey(key);
			
			var tmpLen:int = _loaderParams.length;
			var tmpParam:LoaderParam;
			for (var i:int = tmpLen - 1; i >= 0; --i)
			{
				tmpParam = _loaderParams[i];
				if (tmpParam.taskParam.key == key)
				{
					_loaderParams[i] = _loaderParams[_loaderParams.length - 1];
					_loaderParams.pop();
				}
			}
			_taskParams.splice(tmpIdx, 1);
			/*
			var tarTaskParam:LoaderTaskParam = _taskParams[tmpIdx];
			var i:int;
			var j:int;
			if (tmpIdx != -1)
			{
			var tarTaskParam:LoaderTaskParam = _taskParams[tmpIdx];
			var tmpParams:Vector.<LoaderParam> = tarTaskParam.params;
			var tmpParam:LoaderParam;
			var tmpParamLen:int = tmpParams.length;
			var tmpTaskIdx:int;
			var tmpTasks:Vector.<LoaderTaskParam>;
			var tmpIdx11:int;
			for (i = tmpParamLen - 1; i >= 0; --i)
			{
			tmpParam = tmpParams[i];
			tmpTasks = tmpParam.taskParams;
			tmpTaskIdx = tmpTasks.indexOf(tarTaskParam);
			if (tmpTaskIdx != -1)
			{
			tmpTasks[tmpTaskIdx] = tmpTasks[tmpTasks.length - 1];
			tmpTasks.pop();
			if (tmpTasks.length == 0)
			{
			tmpIdx11 = _loaderParams.indexOf(tmpParam);
			if (tmpIdx11 != -1)
			{
			_loaderParams.splice(tmpIdx11, 1);
			}
			}
			}
			}
			}
			*/
		}
	}
}