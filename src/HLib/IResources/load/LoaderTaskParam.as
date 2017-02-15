package HLib.IResources.load
{
	import HLib.Tool.CallBackFun;
	
	import tool.Pools.IPoolObject;

	public class LoaderTaskParam implements IPoolObject
	{
		public var key:String;
		
		public var params:Vector.<LoaderParam>;
		
		public var finishFun:CallBackFun;				//全部加载完成
		public var errFun:CallBackFun;
		public var progressFun:CallBackFun;
		
//		public var isCancel:Boolean = false;
		/**显示加载队列类型，1、全屏进度条   2、单独进度条*/
		public var progressType:int;
		
		public function LoaderTaskParam()
		{
			finishFun = new CallBackFun();
			errFun = new CallBackFun();
			progressFun = new CallBackFun();
			
			params = new Vector.<LoaderParam>();
		}
		
		public function get isAllSurc():Boolean
		{
			var paramLen:int = params.length;
			for (var i:int = 0; i < paramLen; ++i)
			{
				if (params[i].state != LoaderParam.FINISH_LOADED)
				{
					return false;
				}
			}
			return true;
		}
		
		public function initPoolObject(data:Object = null):void
		{
			
		}
	
		public function clearPoolObject():void
		{
			key = "";
			
//			isCancel = false;
			finishFun.clear();
			errFun.clear();
			progressFun.clear();
			
			params.length = 0;
		}
		
		public function get loadRate():Number
		{
			var resVal:Number = 0;
			for each (var param:LoaderParam in params)
			{
				resVal += param.loadRate;
			}
			return resVal / params.length;
		}
		
		public function dispose():void
		{
			key = "";
			
			finishFun.dispose();
			
			params = null;
		}
	}
}