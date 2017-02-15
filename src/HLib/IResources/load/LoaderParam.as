package HLib.IResources.load
{
	import flash.utils.getTimer;
	
	import HLib.IResources.IResourceManager;
	import HLib.IResources.LoaderManager;
	import HLib.IResources.VersionManager;
	import HLib.Tool.CallBackFun;
	
	public class LoaderParam
	{
		public static const NOT_LOADED:uint = 0;
		public static const LOADED:uint = 1;
		public static const FINISH_LOADED:uint = 2;
		
		public static const ERR_SUCC:uint = 0;
		public static const ERR_NO_EXIST_IO:uint = 1;
		public static const ERR_NO_EXIST_SECURITY:uint = 4;
		public static const ERR_TIMEOUT:uint = 2;
		public static const ERR_NOT_SIZE:uint = 3;
		
		/** 0:成功  1：未找到文件  2：加载超时   3：文件大小与版本不一致 */
		public var errCode:uint;
		
		public var filename:String;
		public var filePath:String;
		public var fileExt:String;
		
		public var loadByte:int;
		public var totalByte:int;
		public var loadRate:Number;
		
		public var progressFun:CallBackFun;
		public var errFun:CallBackFun;							//加载错误
		public var succFun:CallBackFun;
		
		public var startTime:uint;
		
		public var loadCls:Class;
		
		public var state:uint;
		
		public var retryCount:int = 0;
		
		/** 队列类型：0：重要，1：普通，2后台 */
		public var queueType:int;
		
		public var taskParam:LoaderTaskParam;
		
		public function LoaderParam()
		{
			errFun = new CallBackFun();
			succFun = new CallBackFun();
			progressFun = new CallBackFun();
			
			state = NOT_LOADED;
			
			loadRate = 0;
			errCode = ERR_SUCC;
		}
		
		public function initPoolObject(data:Object = null):void
		{
			state = NOT_LOADED;
		}
		
		public function clearPoolObject():void
		{
			filename = "";
			filePath = "";
			fileExt = "";
			errCode = ERR_SUCC;
			
			errFun.clear();
			succFun.clear();
			progressFun.clear();
			taskParam = null;
			
			retryCount = 0;
			
			loadCls = null;
			
			loadRate = 0;
			
			//			state = NOT_LOADED;
		}
		
		public function get resKey():String
		{
			if(filePath == '')
				return "assets/" + filename + fileExt;
			else
				return "assets/" + filePath + "/" + filename + fileExt;
		}
		
		public static function generatePathKey(name:String, ext:String, path:String = null):String
		{
			if(path)
			{
				return "assets/" + path + "/" + name + ext;
			}
			return "assets/" + name + ext;
		}
		
		
		public function dispose():void
		{
			filename = "";
			filePath = "";
			fileExt = "";
			
			errFun.dispose();
			succFun.dispose();
			taskParam = null;
		}
		
		private function get queueName():String
		{
			if (queueType == LoaderManager.MUST)
			{
				return "重要";
			}
			else if (queueType == LoaderManager.NORMAL)
			{
				return "普通";
			}
			return "后台";
		}
		
		public function get useTime():uint
		{
			return getTimer() - startTime;
		}
		
		public function get urlStr():String
		{
			if(filePath == '')
				return IResourceManager.getInstance().Config.ResourceUrl + "assets/" +
					"" + filename + fileExt + VersionManager.inst.getFileVer(resKey) + "&retry=" + retryCount;// + Math.random()
			else 
				return IResourceManager.getInstance().Config.ResourceUrl + "assets/" + filePath + "/" +
					"" + filename + fileExt + VersionManager.inst.getFileVer(resKey) + "&retry=" + retryCount;// + Math.random()
		}
		
		public function get versionFileSize():uint
		{
			return VersionManager.inst.getFileSize(resKey);
		}
		
		public function toStr():String
		{
			var retStr:String = "[" + queueName + "](";
			retStr += taskParam.key;
			retStr += ")";
			return retStr + ":" + urlStr + "-->time:" + useTime + "-->size:ver," + 
				versionFileSize + "/" + totalByte + "-->errCode:" + errCode;
		}
	}
}