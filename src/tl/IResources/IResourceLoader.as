package tl.IResources
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Timer;

	import org.mousebomb.framework.GlobalFacade;

	import tl.frameworks.NotifyConst;

	public class IResourceLoader extends Loader
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
		public function IResourceLoader()
		{
			super();
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
//					IResourceBar.getInstance().Count=1;
//					IResourceBar.getInstance().IsOver=false;
//					IResourceBar.getInstance().setProgress(0,100);
				}
				this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
				this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
				this.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
				_StartTime = IResourceClock.getInstance().getStateTime("start");
	
				this.load(new URLRequest(IResourceManager.getInstance().Config.ResourceUrl+"assets/"+_SubPath+"/"+_PackName+_ExtString+IResourcePool.getInstance().getVersion(_PackName)),context);
				_Timer.start();
//				trace("Loading "+_PackName+"  go");
				GlobalFacade.sendNotify(NotifyConst.LOG,this,"Loading "+_PackName+"  go");
//				HLog.getInstance().appMsg("Loading "+_PackName+"  go" );
				IResourcesAdvance.getInstance().addOnce ++;
			}else{
				_Count=0;
				_Timer.stop();
				_Timer=null;
				this.dispatchEvent(new IResourceEvent(IResourceEvent.Complete));
//				trace("Loading "+_PackName+"  is exist");
//				HLog.getInstance().appMsg("Loading "+_PackName+"  is exist");
			}
		}
//		private function onResWindowClose(e:starling.events.Event):void{
//			if(_IsShowProgress){
//				IResourceBar.getInstance().IsOver=true;
//			}
//		}
		private function onError(e:IOErrorEvent):void {
			trace("Loading "+_PackName+"    There was an error");
			GlobalFacade.sendNotify(NotifyConst.LOG,this,"Loading "+_PackName+"    There was an error");
			GlobalFacade.sendNotify(NotifyConst.LOG,this,"reLoading "+_PackName);
//			HLog.getInstance().appMsg("Loading "+_PackName+"    There was an error");
//			HLog.getInstance().appMsg("reLoading "+_PackName);
			if(_Count>5){
				_Count=0;
				_Timer.stop();
				_Timer=null;
//				var _HAlertItem:HAlertItem=HAlert.show("找不到加载需要的资源文件！"+_PackName,"加载错误",IResourceBar.getInstance(),"确定");
//				_HAlertItem.addEventListener("WindowClose",onResWindowClose);
				this.dispatchEvent(new IResourceEvent(IResourceEvent.Error,_PackName));	
				IResourcesAdvance.getInstance().addOnce --;
				return;
			}
			_Count++;
			_StartTime = IResourceClock.getInstance().getStateTime("start");
			this.load(new URLRequest(IResourceManager.getInstance().Config.ResourceUrl+"assets/"+_SubPath+"/"+_PackName+_ExtString+IResourcePool.getInstance().getVersion(_PackName,_Count)));
//			HLog.getInstance().appMsg("Loading "+_PackName+"  go" );
			GlobalFacade.sendNotify(NotifyConst.LOG,this,"Loading "+_PackName+"  go");
		}
		
		private function onProgress(e:ProgressEvent):void {
			_OutTimeCount=0;
			if(!_IsShowProgress) return;
//			IResourceBar.getInstance().setProgress(int(e.bytesLoaded),int(e.bytesTotal));
		}
		private function onComplete(e:Event):void {
			if(_Timer){
				_Timer.stop();
				_Timer=null;	
			}
			var _LoaderInfo:LoaderInfo=e.target as LoaderInfo;
			trace(_PackName+" has loaded.");			
			var time:Number = IResourceClock.getInstance().getStateTime("end",_StartTime);
//			HLog.getInstance().allBytesLoaded += _LoaderInfo.bytesLoaded;
//			IResourceBar.getInstance().NetSpeed=_LoaderInfo.bytesLoaded/time;
//			HLog.getInstance().appMsg("Loading "+_PackName+" has loaded.useTime" + time  + " bytesLoaded" + Number(_LoaderInfo.bytesLoaded/1024).toFixed(3) +"KB bytesTotal" + Number(_LoaderInfo.bytesTotal/1024).toFixed(3)  + "KB allBytesTotal" + Number(HLog.getInstance().allBytesLoaded/1024/1024).toFixed(6) + "M");
//			if(_IsShowProgress){
//				IResourceBar.getInstance().IsOver=true;
//			}
			_Count=0;
			_OutTimeCount=0;
			this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onError);
			this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.onProgress);
			this.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onComplete);
			IResourcePool.getInstance().addResource(_PackName,_LoaderInfo);
			this.dispatchEvent(new IResourceEvent(IResourceEvent.Complete));	
			IResourcesAdvance.getInstance().addOnce --;		
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
			GlobalFacade.sendNotify(NotifyConst.LOG,this,"Loading "+_PackName+"    There was an error");
			GlobalFacade.sendNotify(NotifyConst.LOG,this,"reLoading "+_PackName);
//			HLog.getInstance().appMsg("Loading "+_PackName+"    There was an error");
//			HLog.getInstance().appMsg("reLoading "+_PackName);
			if(_Count>5){
				_Count=0;
				_Timer.stop();
				_Timer=null;
//				IResourceBar.getInstance().IsOver=false;
//				var _HAlertItem:HAlertItem=HAlert.show("找不到加载需要的资源文件:"+_PackName+",如果使用了加速浏览器请将倍速调低一点,或刷新网页重试!","加载错误",IResourceBar.getInstance(),"确定");
//				_HAlertItem.addEventListener("WindowClose",onResWindowClose);
				this.dispatchEvent(new IResourceEvent(IResourceEvent.Error,_PackName));	
				return;
			}
			_Count++;
			_StartTime = IResourceClock.getInstance().getStateTime("start");
			this.load(new URLRequest(IResourceManager.getInstance().Config.ResourceUrl+"assets/"+_SubPath+"/"+_PackName+_ExtString+IResourcePool.getInstance().getVersion(_PackName,_Count)));
			GlobalFacade.sendNotify(NotifyConst.LOG,this,"Loading "+_PackName+"  go");
//			HLog.getInstance().appMsg("Loading "+_PackName+"  go" );
		}
	}
}