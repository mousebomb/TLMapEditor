package HLib.IResources
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import HLib.IResources.load.LoaderParam;
	
	public class MyLoaderSwf extends URLLoader implements IResLoader
	{
		private var _param:LoaderParam;
		private var _swfLoader:Loader = new Loader;
		private var _overTimeId:uint;
		public function MyLoaderSwf()
		{
			super();
		}
		
		public function get param():LoaderParam
		{
			return _param;
		}
		
		public function startLoad(param:LoaderParam):void
		{
			_param = param;
			var urlReq:URLRequest = new URLRequest(_param.urlStr);
			this.dataFormat = URLLoaderDataFormat.BINARY;
			addEventListener(Event.COMPLETE, onLoadFinish);
			addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			addEventListener(ProgressEvent.PROGRESS,onProgress);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			load(urlReq);
			
			clearTimeOut();
			var time:int = 60000;
			if(_param.urlStr.indexOf('myfont') > -1)
				time = 60000 * 5;
			_overTimeId = setTimeout(onLoadError, 60000, null);
		}

		/** 生成shader需要做挂钩 */
		public static var ctx :LoaderContext ;
		private function onLoadFinish(evt:Event):void
		{
			var data:ByteArray = this.data;
			_swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadError);
			_swfLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			_swfLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,onComplete);
			if(VersionManager.inst.checkFileSize(_param.resKey, data.length))
			{
				_swfLoader.loadBytes(data,ctx);
			}	else {
				onLoadError(null);
			}
		}
		
		private function onComplete(event:Event):void
		{
			var _LoaderInfo:LoaderInfo=event.target as LoaderInfo;
			var tatol:Number = VersionManager.inst.getFileSize(_param.urlStr);
			if (VersionManager.inst.checkFileSize(_param.resKey, _LoaderInfo.bytesLoaded))
			{
				IResourcePool.getInstance().addResource(_param.filename,_LoaderInfo);
				_param.succFun.exec(this);	
			}	else {
				onLoadError(null);
			}
		}
		private function onProgress(event:ProgressEvent):void 
		{
			_param.loadByte = event.bytesLoaded;
			_param.totalByte = event.bytesTotal;
			if(event.bytesTotal == 0)
			{
				event.bytesTotal = VersionManager.inst.getFileSize(_param.resKey)
			}
			_param.loadRate = event.bytesLoaded/event.bytesTotal;
			_param.progressFun.exec(this);
		}
		
		private function onLoadError(evt:Event):void
		{
			_param.errFun.exec(this);
		}
		
		private function clearTimeOut():void
		{
			if (_overTimeId)
			{
				clearTimeout(_overTimeId);
				_overTimeId = 0;
			}
		}
		
		public function stop():void
		{
			clearTimeout(_overTimeId);
			_swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadError);
			_swfLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			_swfLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,onComplete);
			
			removeEventListener(Event.COMPLETE, onLoadFinish);
			removeEventListener(ProgressEvent.PROGRESS,onProgress);
			removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			/*try
			{
				close();
			}
			catch (err:Error)
			{
				trace("加载地表错误-->", _param.toStr(), err);
			}*/
		}
	}
}