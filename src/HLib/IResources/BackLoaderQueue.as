package HLib.IResources
{
	import HLib.IResources.load.LoaderParam;
	import HLib.IResources.load.LoaderTaskParam;

	public class BackLoaderQueue implements ILoaderQueue
	{
		private var _params:Vector.<LoaderParam>;
		
		private var _queueType:int;
		public function BackLoaderQueue(type:int)
		{
			_queueType = type;
			_params = new Vector.<LoaderParam>();
		}
		
		public function addTask(taskParam:LoaderTaskParam):String
		{
			for each (var tmpParam:LoaderParam in taskParam.params)
			{
				tmpParam.queueType = _queueType;
				_params.push(tmpParam);
			}
			return taskParam.key;
		}
		
		public function removeResKey(resKey:String):void
		{
			var tmpLen:int = _params.length;
			for (var i:int = 0; i < tmpLen; ++i)
			{
				if (_params[i].resKey == resKey)
				{
					_params.splice(i, 1);
					break;
				}
			}
		}
		
		public function get nextParam():LoaderParam
		{
			if (_params.length)
			{
				for (var i:int = _params.length - 1; i >= 0; --i)
				{
					if (_params[i].state == LoaderParam.NOT_LOADED)
					{
						return _params[i];
					}
				}
			}
			return null;
		}
		
		public function finishParam(param:LoaderParam):void
		{
			removeResKey(param.resKey);
		}
		
		public function clear():void
		{
			
		}
		
		public function removeTask(key:String):void
		{
			
		}
	}
}