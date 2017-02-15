package HLib.IResources
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import HLib.IResources.load.LoaderParam;
	
	public class BackLoader extends URLLoader implements IResLoader
	{
		private var _param:LoaderParam;
		
		public function BackLoader(request:URLRequest=null)
		{
			super(request);
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
			addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			load(urlReq);
			
			_overTimeId = setTimeout(onLoadError, 60000, null);
		}
		private var _overTimeId:int = 0;
		
		private function onLoadProgress(evt:ProgressEvent):void
		{
			_param.loadByte = evt.bytesLoaded;
			_param.totalByte = evt.bytesTotal;
//			trace("------------------------------------------->", _param.resKey);
		}
		
		private function onLoadFinish(evt:Event):void
		{
			_param.succFun.exec(this);
		}
		
		private function onLoadError(evt:Event):void
		{
			_param.errFun.exec(this);
		}
		
		public function stop():void
		{
			clearTimeout(_overTimeId);
			_overTimeId = 0;
			
			removeEventListener(Event.COMPLETE, onLoadFinish);
			removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
//			try
//			{
//				close();
//			}
//			catch (err:Error)
//			{
//				trace("加载地表错误-->", _param.toStr(), err);
//			}
		}
		
	}
}