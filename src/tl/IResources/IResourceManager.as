package tl.IResources
{	
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	
	import Module.Windows.LogWindow;
	
	public class IResourceManager extends EventDispatcher
	{
		private static var MyInstance:IResourceManager;
		private var _LoaderQueueLength:int=5;
		private var _LoaderQueueArgs:Array=new Array();
		private var _ResList:Array=new Array();
		private var _IResourceToClass:IResourceToClass=new IResourceToClass();
		private var _LCT:LoaderContext=new LoaderContext(true);
		private var _GatherList:Array=new Array();
		private var _NowResourceAskArray:Array;
		private var _RetrunArray:Array;
		private var _NowTaskNum:int=0;
		private var _IsShowProgress:Boolean=true;
		private var _MyClass:Class;
		private var _Config:XML;
		private var _xmllist:XMLList;
		private var _Url:String="";
		private var allBytesLoaded:Number = 0; //所有加载总量
		public function IResourceManager()
		{
			if( MyInstance ){
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			MyInstance=this;
			
		}
		public static function getInstance():IResourceManager{
			if(!MyInstance){
				MyInstance=new IResourceManager();	
			}
			return MyInstance;
		}
		public function getLoader():IResourceLoader{
			if(_LoaderQueueArgs.length>_LoaderQueueLength) return null;
			return new IResourceLoader;
		}
		public function getIndex(_Loader:IResourceLoader):int{
			var _Index:int=-1;
			for(var i:int=0;i<_LoaderQueueArgs.length;i++){
				if(_Loader==_LoaderQueueArgs[i][1]){
					_Index=i;
				}
			}
			return _Index;
		}
		public function getIndexByKey(_ResKey:String):int{
			var _Index:int=-1;
			for(var i:int=0;i<_LoaderQueueArgs.length;i++){
				if(_ResKey==_LoaderQueueArgs[i][0]){
					_Index=i;
				}
			}
			return _Index;
		}
		public function resExist(_ResKey:String):Boolean{
			var _IsExist:Boolean=false;
			for(var i:int=0;i<_ResList.length;i++){
				if(_ResKey==_ResList[i][0]){
					_IsExist=true;
				}
			}
			return _IsExist;
		}
		public function set IsShowProgress(value:Boolean):void{
			_IsShowProgress=value;
		}
		public function get IsShowProgress():Boolean{
			return _IsShowProgress;
		}
		public function set Config(_xml:XML):void{
			_Config=_xml;
			_Url=_Config.ResourceUrl;
		}
		public function get Config():XML{
			return _Config;
		}
		private function onResWindowClose(e:Event):void{
//			IResourceBar.getInstance().IsOver=true;
		}
		private function bacthLoading():void{
			var _Loader:IResourceLoader=this.getLoader();
			if(_Loader==null) return;
			if(_ResList.length<1) return;
			var _ResArgs:Array=_ResList.shift();
			var resKey:String=_ResArgs[0];
			if(this.getIndexByKey(resKey)>-1) return;
			if(IResourcePool.getInstance().getResource(resKey)){
				onGather(resKey);
				return;
			}
			IResourcesAdvance.getInstance().TakeOver(resKey);
			//生成路径，如果要修改则改此处
			_Loader.IsShowProgress=_ResArgs[1];
			_LoaderQueueArgs.push([resKey,_Loader]);//资源名称,loader,开始时间,重新下载次数
			_Loader.addEventListener(IResourceEvent.Error,_onError);
			_Loader.addEventListener(IResourceEvent.Complete,_onLoaderComplete);
			_Loader.myLoad(resKey,_ResArgs[2],_ResArgs[3]);		
		}
		private function _onLoaderComplete(e:Event):void {
			var _Loader:IResourceLoader=e.target as IResourceLoader;
			var _Index:int=this.getIndex(_Loader);
			var _ResKey:String=_LoaderQueueArgs[_Index][0];
			if(_Index==-1){
				trace("loader error:not find loadcomplete object in LoaderQueueArgs");
				return;
			}else{
//				var time:Number = IResourceClock.getInstance().getStateTime("end",_LoaderQueueArgs[_Index][2]);
//				IResourceBar.getInstance().setProgress(0,100);
			}
			_Loader..removeEventListener(IResourceEvent.Error,_onError);
			_Loader.removeEventListener(IResourceEvent.Complete,_onLoaderComplete);
			_LoaderQueueArgs.splice(_Index,1);	
			onGather(_ResKey);
		}
		private function _onError(e:IResourceEvent):void {
			var _PackName:String=String(e.data);
			for(var i:int=0;i<_LoaderQueueArgs.length;i++){
				if(_PackName==_LoaderQueueArgs[i][0]){
					_LoaderQueueArgs.splice(i,1);
					return;
				}
			}
		}
		private function onGather(resKey:String):void{
			//---------收集资源组是否下载完成的算法----------------------
			var _UnCompleteNum:int=0;
			for(var i:int=0;i<_GatherList.length;i++){
				_UnCompleteNum=0;
				for(var j:int=1;j<_GatherList[i].length;j++){
					if(_GatherList[i][j]==resKey){
						_GatherList[i][j]=1;
					}
					if(_GatherList[i][j]==1){
						_UnCompleteNum++;
					}					
				}
				if(_UnCompleteNum>_GatherList[i].length-2){
					var _Key:String=_GatherList[i][0];
					_GatherList.splice(i,1);
					i--;
					trace("DispatchEvent:"+_Key+" load complete,GatherList length:"+_GatherList.length);
//					HLog.getInstance().appMsg("DispatchEvent:"+_Key+" load complete,GatherList length:"+_GatherList.length);
					this.dispatchEvent(new IResourceEvent(_Key,_Key));
					if(_ResList.length<1){
//						IResourceBar.getInstance().IsOver=true;
					}
				}
			}
			bacthLoading();
		}
		/**
		 *添加一个取资源的请求
		 * @param EventKeyWord 自定义一个唯一的事件名,ResourceArray:请求资源组,例如[[资源名,资源类名,想要返回的资源类型],[资源名,资源类名,想要返回的资源类型]]
		 * @param isFirst 是否优先
		 * @param IsShowProgress 是否显示加载进度条默认显示
		 * @param extString 加载类型.swf .jpg .png
		 * @param 想要返回的资源类型约束 0:LoaderInfo,1:BitmapData,2:MovieClip,3:SimpleButton
		 * @param 举例说明:
		 * @param IResourceManager.getInstance().AddAsk("GetMainUI",[["MainUI","role1","1"],["MainUI","box1","1"],["MainUI","bog_button","3"]]);
		 * @param IResourceManager.getInstance().addEventListener("GetMainUI",onGetMainUI);
		 * @param 
		 * @param private function onGetMainUI(e:IResourceEvent):void{
		 * @param IResourceManager.getInstance().removeEventListener("GetMainUI",onGetMainUI);
		 * @param var _args:Array=e.data as Array;
		 * @param //_args=[BitmapData,BitmapData,SimpleButton]
		 * @param }
		 */
		public function AddAsk(EventKeyWord:String,ResourceArray:Array,isFirst:Boolean=false,IsShowProgress:Boolean=true,subPath:String="",extString:String=".swf"):void{
			if(ResourceArray.length<1) return;
			var _KeyArgs:Array=new Array();
			_KeyArgs.push(EventKeyWord);
			for(var i:int=0;i<ResourceArray.length;i++){
				_KeyArgs.push(ResourceArray[i]);
				if(resExist(ResourceArray[i])) continue;
				if(isFirst){
					_ResList.splice(0,0,[ResourceArray[i],IsShowProgress,subPath,extString]);
				}
				else{
					_ResList.push([ResourceArray[i],IsShowProgress,subPath,extString]);
				}				
			}
			_GatherList.push(_KeyArgs);
			//判断下载队列是否已满
			for(i=0;i<_LoaderQueueLength;i++){
				bacthLoading();
			}			
		}
		/**下载列表中是否已存在此资源包,返回true表示存在,false表示不存在*/
		public function hasResTask(resKey:String):Boolean{
			var _Exist:Boolean=false;
			for(var i:int=0;i<_ResList.length;i++){
				if(_ResList[i][0]==resKey){
					_Exist=true;
				}
			}
			for(i=0;i<_LoaderQueueArgs.length;i++){
				if(_LoaderQueueArgs[i][0]==resKey){
					_Exist=true;
				}
			}
			return _Exist;
		}
		public function addResource(key:String,obj:*):void{
			IResourcePool.getInstance().addResource(key,obj);
		}
		public function disposeResource(key:String):void{
			IResourcePool.getInstance().dispose(key);
		}
		public function enforceDisposeResource():void{
			IResourcePool.getInstance().enforceDispose();
		}
		public function getResource(key:String):*{
			return IResourcePool.getInstance().getResource(key);
		}
		public function getClass(packname:String,classname:String):Class{
			if(IResourcePool.getInstance().getResource(packname)==null) return null;
			_MyClass=_IResourceToClass.IResourceGetClass(IResourcePool.getInstance().getResource(packname),classname);
			if(_MyClass==null) return null;
			return 	new _MyClass();	
		}
		/**
		 * 获取动态加载字体 
		 * @param packname
		 * @param classname
		 * @return 
		 * 
		 */		
		public function getMyFont(packname:String,classname:String):Class
		{
			if(IResourcePool.getInstance().getResource(packname)==null) return null;
			var _LoaderInfo:LoaderInfo = IResourcePool.getInstance().getResource(packname) as LoaderInfo;
			_MyClass = _LoaderInfo.applicationDomain.getDefinition(classname) as Class;
			return _MyClass;
		}
		
		/**
		 * 获取纹理
		 * @param packname 资源包
		 * @param classname 类名
		 * @return 
		 */		
//		public function getTextureFromBitmapData(packname:String,classname:String):Texture
//		{
//			if(IResourcePool.getInstance().getResource(packname)==null) return null;
//			_MyClass=_IResourceToClass.IResourceGetClass(IResourcePool.getInstance().getResource(packname),classname);
//			if(_MyClass==null) return null;
//			var bmd:BitmapData=(new _MyClass()) as BitmapData;	
//			return 	Texture.fromBitmapData(bmd);	
//		}
		public function getBitmapData(packname:String,classname:String):BitmapData{
			if(IResourcePool.getInstance().getResource(packname)==null) return null;
			_MyClass=_IResourceToClass.IResourceGetClass(IResourcePool.getInstance().getResource(packname),classname);
			if(_MyClass==null) return null;
			var _BitmapData:BitmapData=(new _MyClass()) as BitmapData;	
			return 	_BitmapData;	
		}
		public function getMovieClip(packname:String,classname:String):MovieClip{
			if(IResourcePool.getInstance().getResource(packname)==null) return null;
			_MyClass=_IResourceToClass.IResourceGetClass(IResourcePool.getInstance().getResource(packname),classname);
			if(_MyClass==null) return null;
			var _MovieClip:MovieClip=(new _MyClass()) as MovieClip;	
			return 	_MovieClip;	
		}
		public function getSimpleButton(packname:String,classname:String):SimpleButton{
			if(IResourcePool.getInstance().getResource(packname)==null) return null;
			_MyClass=_IResourceToClass.IResourceGetClass(IResourcePool.getInstance().getResource(packname),classname);
			if(_MyClass==null) return null;
			var _SimpleButton:SimpleButton=(new _MyClass()) as SimpleButton;		
			return 	_SimpleButton;	
		}
		public function getSound(packname:String,classname:String):Sound{
			if(IResourcePool.getInstance().getResource(packname)==null) return null;
			_MyClass=_IResourceToClass.IResourceGetClass(IResourcePool.getInstance().getResource(packname),classname);
			if(_MyClass==null) return null;
			var _Sound:Sound=(new _MyClass()) as Sound;
			IResourcePool.getInstance().addResource(classname,_Sound);
			return 	_Sound;	
		}
		public function getBmdArgs(packname:String,classname:String,num:int):Array{
			var _BmdArgs:Array=IResourcePool.getInstance().getResource(classname);
			if(_BmdArgs==null){
				_BmdArgs=[];
				var bmd:BitmapData, str:String;//添加出错防护
				for(var i:int=0;i<num;i++){
					str = classname+"_"+i
					bmd = getBitmapData(packname,str);
					if(bmd != null)
						_BmdArgs.push(bmd);
//					else
//						HLog.getInstance().appMsg("获取资源包" +packname +"出错资源" + str);
				}
				IResourcePool.getInstance().addResource(classname,_BmdArgs);
			}	
			return 	_BmdArgs;	
		}
		public function getObjectBitmapData(classname:String):BitmapData{
			_MyClass=getDefinitionByName(classname) as Class;
			if(_MyClass==null) return null;
			var _BitmapData:BitmapData=(new _MyClass()) as BitmapData;	
			return 	_BitmapData;	
		}
		public function getObjectMovieClip(classname:String):MovieClip{
			_MyClass=getDefinitionByName(classname) as Class;
			if(_MyClass==null) return null;
			var _MovieClip:MovieClip=(new _MyClass()) as MovieClip;	
			return 	_MovieClip;	
		}
		/**
		 * 获取图片 
		 * @param packname
		 * @return 
		 * 
		 */		
		public function getImageBMD(packname:String):BitmapData{
			if(IResourcePool.getInstance().getResource(packname)==null) return null;
			var _BitmapData:BitmapData=IResourcePool.getInstance().getResource(packname).loader.content.bitmapData as BitmapData;
			return 	_BitmapData;	
		}
	}
}