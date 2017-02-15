package HLib.MapBase.MapLoader
{
	/**
	 * 地图加载类
	 * @author 李舒浩
	 */

	import HLib.IResources.IResLoader;
	import HLib.IResources.VersionManager;
	import HLib.IResources.load.LoaderParam;

	import away3d.textures.ATFTexture;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class MyMapLoader extends URLLoader implements IResLoader
	{
		private var _param:LoaderParam;
		
		public function MyMapLoader():void
		{
			
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
		}
		
		private function onLoadProgress(evt:ProgressEvent):void
		{
			_param.loadByte = evt.bytesLoaded;
			_param.totalByte = evt.bytesTotal;
			//			trace("------------------------------------------->", _param.resKey);
		}
		
		private function onLoadFinish(evt:Event):void
		{
			var bytes:ByteArray = this.data;
			if (VersionManager.inst.checkFileSize(_param.resKey, bytes.length))
			{
				var atfTexture:ATFTexture = new ATFTexture(this.data);
				atfTexture.prepareUpload(onAtfReady);
			}
			else
			{
				_param.errFun.exec(this);
			}
		}

		private function onAtfReady(atfTexture:ATFTexture):void
		{
			MyMapResTool.instance.addResource(_param.filename + _param.fileExt, atfTexture);

			_param.succFun.exec(this);
		}
		
		private function onLoadError(evt:Event):void
		{
			if (evt == null)
			{
				_param.errCode = LoaderParam.ERR_TIMEOUT;
			}
			else
			{
				if (evt.type == IOErrorEvent.IO_ERROR)
				{
					_param.errCode = LoaderParam.ERR_NO_EXIST_IO;
				}
				else
				{
					_param.errCode = LoaderParam.ERR_NO_EXIST_SECURITY;
				}
			}
			
			_param.errFun.exec(this);
		}
		
		public function stop():void
		{
			removeEventListener(Event.COMPLETE, onLoadFinish);
			removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			close();
		}
	}
}