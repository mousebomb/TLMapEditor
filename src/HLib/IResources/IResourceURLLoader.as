package HLib.IResources
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import HLib.Tool.HLog;
	import HLib.UICom.BaseClass.HTopBaseView;
	import HLib.UICom.Component.HAlert;
	import HLib.UICom.Component.HAlertItem;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.IResourceBar;
	import Modules.MainFace.MainInterfaceManage;
	
	import starling.events.Event;
	
	public class IResourceURLLoader extends URLLoader
	{
		private var _PackName:String;
		private var _SubPath:String;
		private var _ExtString:String;
		private var _IsShowProgress:Boolean=true;
		private var _Count:int=0;
		private var _OutTimeCount:int=0;
		private var _StartTime:Number=0;
		private var _Timer:Timer=new Timer(2000);
		public var loadEvent:String = "";			//激发事件
		public var progressCallBack:Function;		//进程回调
		public var isOverResourceBar:Boolean = true;	//是否加载完隐藏进度条
		private var _isLoad:Boolean;					//加载标志
		
		public function IResourceURLLoader()
		{
			super();
			this.dataFormat = URLLoaderDataFormat.BINARY;
			_Timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		public function set IsShowProgress(value:Boolean):void{
			_IsShowProgress=value;
		}
		public function get IsShowProgress():Boolean{
			return _IsShowProgress;
		}
		public function myLoad(packName:String,subPath:String,extString:String=".swf",context:LoaderContext=null):void{
			_PackName=packName;
			_SubPath=subPath;
			_ExtString=extString;
			IResourcesAdvance.getInstance().TakeOver(_PackName);		
			if(IResourcePool.getInstance().getResource(_PackName)==null){
				if(IResourceManager.getInstance().Config==null) return;
				if(_IsShowProgress){
					IResourceBar.getInstance().Count=1;
					IResourceBar.getInstance().IsOver=false;
					IResourceBar.getInstance().setProgress(0, 100, _PackName+_ExtString);
				}
				this.addEventListener(IOErrorEvent.IO_ERROR,onError);
				this.addEventListener(ProgressEvent.PROGRESS,onProgress);
				this.addEventListener(flash.events.Event.COMPLETE,onComplete);
				_StartTime = IResourceClock.getInstance().getStateTime("start");
				_isLoad = true;
				this.load(new URLRequest(IResourceManager.getInstance().Config.ResourceUrl+"assets/"+_SubPath+"/"+_PackName+_ExtString+IResourcePool.getInstance().getVersion(_PackName)));
				_Timer.start();
				trace("Loading "+_PackName+"  go");
				HLog.getInstance().appMsg("Loading "+_PackName+"  go" );
				IResourcesAdvance.getInstance().addOnce ++;
			}else{
				_Count=0;
				_Timer.stop();
				_Timer=null;
				_isLoad = false;
				this.dispatchEvent(new IResourceEvent(IResourceEvent.Complete));
				trace("Loading "+_PackName+"  is exist");
				HLog.getInstance().appMsg("Loading "+_PackName+"  is exist");
			}
		}
		private function onResWindowClose(e:starling.events.Event):void{
			if(_IsShowProgress){
				IResourceBar.getInstance().IsOver=true;
			}
		}
		private function onError(e:IOErrorEvent):void {
			_isLoad = false;
			trace("Loading "+_PackName+"    There was an error");
			HLog.getInstance().appMsg("Loading "+_PackName+"    There was an error");
			HLog.getInstance().appMsg("reLoading "+_PackName);
			if(_Count>5){
				_Count=0;
				_Timer.stop();
				_Timer=null;
				if(!MainInterfaceManage.getInstance().isShowSourceAlert) return;
				var _HAlertItem:HAlertItem=HAlert.show("找不到加载需要的资源文件！"+_PackName +"\n资源包："+ _SubPath,"加载错误",HTopBaseView.getInstance(), "确定");//IResourceBar.getInstance(),"确定");
				_HAlertItem.addEventListener("WindowClose",onResWindowClose);
				this.dispatchEvent(new IResourceEvent(IResourceEvent.Error,_PackName));	
				IResourcesAdvance.getInstance().addOnce--;
				return;
			}
			_Count++;
			_isLoad = true;
			_StartTime = IResourceClock.getInstance().getStateTime("start");
			this.load(new URLRequest(IResourceManager.getInstance().Config.ResourceUrl+"assets/"+_SubPath+"/"+_PackName+_ExtString+IResourcePool.getInstance().getVersion(_PackName,_Count)));
			HLog.getInstance().appMsg("Loading "+_PackName+"  go" );
		}
		
		private function onProgress(e:ProgressEvent):void {
			_OutTimeCount=0;
			if(progressCallBack != null) progressCallBack( int(e.bytesLoaded),int(e.bytesTotal), _PackName+_ExtString );
			if(!_IsShowProgress) return;
			var max:int = int(e.bytesTotal)
			if(_PackName == "source_interface_0" || _PackName == "source_interface_1")
				max = 910000 + 1443000
			IResourceBar.getInstance().setProgress(int(e.bytesLoaded),max, _PackName+_ExtString);
		}
		private function onComplete(e:flash.events.Event):void {
			if(_Timer){
				_Timer.stop();
				_Timer=null;	
			}
			_isLoad = false;
			var data:ByteArray = e.currentTarget.data;
			var bytesLoaded:uint = e.currentTarget.bytesLoaded;
			var bytesTotal:uint = e.currentTarget.bytesTotal;
			trace(_PackName+" has loaded.");			
			var time:Number = IResourceClock.getInstance().getStateTime("end",_StartTime);
			HLog.getInstance().allBytesLoaded += bytesLoaded;
			IResourceBar.getInstance().NetSpeed = bytesLoaded / time;
			HLog.getInstance().appMsg("Loading "+_PackName+" has loaded.useTime" + time  + " bytesLoaded" + Number(bytesLoaded/1024).toFixed(3) +"KB bytesTotal" + Number(bytesTotal/1024).toFixed(3)  + "KB allBytesTotal" + Number(HLog.getInstance().allBytesLoaded/1024/1024).toFixed(6) + "M");
			if(_IsShowProgress && isOverResourceBar)
				IResourceBar.getInstance().IsOver = true;
			
			_Count=0;
			_OutTimeCount=0;
			this.removeEventListener(IOErrorEvent.IO_ERROR, this.onError);
			this.removeEventListener(ProgressEvent.PROGRESS, this.onProgress);
			this.removeEventListener(flash.events.Event.COMPLETE, this.onComplete);
			IResourcePool.getInstance().addResource(_PackName, data);	//把加载好的二进制数据保存起来
			this.dispatchEvent(new IResourceEvent(IResourceEvent.Complete));	
			IResourcesAdvance.getInstance().addOnce--;		
		}
		/**清除当前加载*/
		public function clearMyLoader():void
		{
			_Count=0;
			_OutTimeCount=0;
			this.removeEventListener(IOErrorEvent.IO_ERROR, this.onError);
			this.removeEventListener(ProgressEvent.PROGRESS, this.onProgress);
			this.removeEventListener(flash.events.Event.COMPLETE, this.onComplete);
			IResourcesAdvance.getInstance().addOnce--;	
			HAssetsManager.getInstance().clrearLoad(_PackName)
			if(_isLoad)
				this.close()
			_isLoad = false;
		}
		private function onTimer(e:TimerEvent):void{
			_OutTimeCount++;
			if(_OutTimeCount>20){
				_OutTimeCount=0;
				reLoad();
			}
		}
		private function reLoad():void{
			trace("Loading "+_PackName+"    There was an error");
			HLog.getInstance().appMsg("Loading "+_PackName+"    There was an error");
			HLog.getInstance().appMsg("reLoading "+_PackName);
			if(_Count>5){
				_Count=0;
				_Timer.stop();
				_Timer=null;
				IResourceBar.getInstance().IsOver=false;
				if(!MainInterfaceManage.getInstance().isShowSourceAlert) return;
				var _HAlertItem:HAlertItem=HAlert.show("找不到加载需要的资源文件:"+_PackName +"\n资源包："+ _SubPath+",如果使用了加速浏览器请将倍速调低一点,或刷新网页重试!","加载错误",HTopBaseView.getInstance(), "确定");//IResourceBar.getInstance(),"确定");
				_HAlertItem.addEventListener("WindowClose",onResWindowClose);
				this.dispatchEvent(new IResourceEvent(IResourceEvent.Error,_PackName));	
				return;
			}
			_Count++;
			_isLoad = true;
			_StartTime = IResourceClock.getInstance().getStateTime("start");
			this.load(new URLRequest(IResourceManager.getInstance().Config.ResourceUrl+"assets/"+_SubPath+"/"+_PackName+_ExtString+IResourcePool.getInstance().getVersion(_PackName,_Count)));
			HLog.getInstance().appMsg("Loading "+_PackName+"  go" );
		}
	}
}