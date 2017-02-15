package HLib.IResources
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import HLib.IResources.load.LoaderParam;
	
	import Modules.Common.HAtfAssetsManager;
	import Modules.Common.SGCsvManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.DataSources.ChatDataSource;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class MyLoaderATF extends URLLoader implements IResLoader
	{
		
		private var _param:LoaderParam;
		private var _overTimeId:uint;
		
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
			addEventListener(ProgressEvent.PROGRESS,onProgress);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			load(urlReq);
			clearTimeout(_overTimeId);
			_overTimeId = setTimeout(onLoadError, 60000, null);
		}
		
		private function onLoadFinish(evt:Event):void
		{
			clearTimeOut();
			
			var data:ByteArray = this.data;
			var isTrue:Boolean = getByteArrayTrue(_param.filename, data.length)
			if(isTrue)
			{
				IResourcePool.getInstance().addResource('byteArray'+_param.filename + '.atf',data);
				if(ChatDataSource.getMyInstance().isDisposed || Starling.context.driverInfo == "Disposed") 
				{
					nextDelayCall();
				}	else {
					var myLoader:MyLoaderATF = evt.currentTarget as MyLoaderATF;
					var str:String = myLoader.param.taskParam.key;
					var fileName:String = myLoader.param.filename;
					if(str == 'mainInterfaceSource')
					{
						/*xml = SGCsvManager.getInstance().getXml(fileName);
						atlas = new TextureAtlas(Texture.fromAtfData(this.data, 1, false), xml);
						HAtfAssetsManager.getMyInstance().addAtfTextureAtlas(SourceTypeEvent.MAIN_INTERFACE_SOURCE, fileName, atlas);*/
					}	else if(str == "IconEffect") {
						xml = SGCsvManager.getInstance().getXml(fileName);
						atlas = new TextureAtlas(Texture.fromAtfData(this.data, 1, false), xml);
						HAtfAssetsManager.getMyInstance().addAtfTextureAtlas('IconEffect', fileName, atlas);
					}	else if(str == SourceTypeEvent.ITEM_ICON_SOURCE) {
						/*xml = SGCsvManager.getInstance().getXml(fileName);
						atlas = new TextureAtlas(Texture.fromAtfData(this.data, 1, false), xml);
						HAtfAssetsManager.getMyInstance().addAtfTextureAtlas(SourceTypeEvent.ITEM_ICON_SOURCE, fileName, atlas);*/
					}	else if(fileName == SourceTypeEvent.SOURCE_ACTIVITYICON_30) {
						xml = SGCsvManager.getInstance().getXml(fileName);
						atlas = new TextureAtlas(Texture.fromAtfData(this.data, 1, false), xml);
						HAtfAssetsManager.getMyInstance().addAtfTextureAtlas(SourceTypeEvent.SOURCE_ACTIVITYICON_30, fileName, atlas);
					}	else {
						var arr:Array = str.split('#');
						var leng:int = arr.length;
						var leng2:int;
						var source:String;
						var sourceArr:Array;
						var isSource:Boolean
						var isScend:Boolean = true;
						for(var i:int=0; i<leng; i++)
						{
							source = arr[i];
							sourceArr = source.split("|");
							leng2 = sourceArr.length;
							for(var j:int=1; j<leng2; j++)
							{
								if(sourceArr[j] == fileName)
								{
									var xml:XML = SGCsvManager.getInstance().getXml(fileName);
									var atlas:TextureAtlas = new TextureAtlas(Texture.fromAtfData(this.data, 1, false), xml);
									HAtfAssetsManager.getMyInstance().addAtfTextureAtlas(sourceArr[0], fileName, atlas);
									break;
								}
							}
						}
					}
					nextDelayCall()
				}
				
			}
			else 
			{
				onLoadError(null);
				_param.errCode = LoaderParam.ERR_NOT_SIZE;
			}
		}
		private function nextDelayCall():void
		{
			_param.succFun.exec(this)
		}
		
		private function getByteArrayTrue(filename:String, bytesLoaded:Number):Boolean
		{
			return VersionManager.inst.checkFileSize(_param.resKey, bytesLoaded);
		}		

		private function onProgress(event:ProgressEvent):void
		{
			if(event.bytesTotal == 0)
			{
				event.bytesTotal = VersionManager.inst.getFileSize(_param.resKey)				
				/*switch(_param.filename)
				{
					case 'version':
						bytesTotal = 331800;
						break;
					case 'source_toolBar_15':
						bytesTotal = 529180;
						break;
					case 'shader':
						bytesTotal = 7137;
						break;
					default:
						break;
				}*/
			}
			_param.loadByte = event.bytesLoaded;
			_param.totalByte = event.bytesTotal;
			_param.loadRate = event.bytesLoaded/event.bytesTotal;
			_param.progressFun.exec(this);
		}
		
		private function onLoadError(evt:Event):void
		{
			clearTimeout(_overTimeId);
			
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
			clearTimeOut();
			
			removeEventListener(Event.COMPLETE, onLoadFinish);
			removeEventListener(ProgressEvent.PROGRESS,onProgress);
			removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
//			try
//			{
//				close();
//			}
//			catch (err:Error)
//			{
//				trace("加载ATF资源错误-->", _param.toStr(), err);
//			}
		}
	}
}