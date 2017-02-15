package tl.IResources
{
	import org.mousebomb.framework.GlobalFacade;

	import tl.frameworks.NotifyConst;

	public class IResourceLoader3DManager
	{
		private static var MyInstance:IResourceLoader3DManager;
		private var _TaskArgs:Array=new Array();
		private var _RunArgs:Array=new Array();
		private var _BandWidth:int=5;
		private var _BandNow:int=0;
		public function IResourceLoader3DManager()
		{
			if( MyInstance ){
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			MyInstance=this;
		}
		public static function getInstance():IResourceLoader3DManager{
			if(!MyInstance){
				MyInstance=new IResourceLoader3DManager();	
			}
			return MyInstance;
		}
		public function Register(loader3D:IResourceLoader3D):Boolean{
			_TaskArgs.push(loader3D);
			loader3D.register=true;
			dispatch();
			return true;
		}

		private function dispatch():void{
			if(_RunArgs.length<_BandWidth){
				if(_TaskArgs.length<1) return;
				var _IResourceLoader3D:IResourceLoader3D=_TaskArgs.shift();
				_RunArgs.push(_IResourceLoader3D);
				_IResourceLoader3D.addEventListener(IResourceEvent.RegisterComplete, onRegisterComplete);
				_IResourceLoader3D.addEventListener(IResourceEvent.Error, onRegisterError);
				_IResourceLoader3D.start();
			}
		}
		/** 加载资源失败 **/
		private function onRegisterError(e:IResourceEvent):void
		{
			var _IResourceLoader3D:IResourceLoader3D = e.currentTarget as IResourceLoader3D;
			_IResourceLoader3D.register=false;
			_IResourceLoader3D.removeEventListener(IResourceEvent.RegisterComplete, onRegisterComplete);
			_IResourceLoader3D.removeEventListener(IResourceEvent.Error, onRegisterError);
			var index:int = _RunArgs.indexOf(_IResourceLoader3D);
			_RunArgs.splice(index,1);
			
			trace("Loading " + _IResourceLoader3D.packName + _IResourceLoader3D.extString + "  is Error");
			GlobalFacade.sendNotify(NotifyConst.LOG,this,"Loading " + _IResourceLoader3D.packName + _IResourceLoader3D.extString + "  is Error");
			//执行加载下一个
			dispatch();
		}
		private function onRegisterComplete(e:IResourceEvent):void{
			var _IResourceLoader3D:IResourceLoader3D=e.target as IResourceLoader3D;
			_IResourceLoader3D.register=false;
			_IResourceLoader3D.removeEventListener(IResourceEvent.RegisterComplete, onRegisterComplete);
			var _Index:int=_RunArgs.indexOf(_IResourceLoader3D);
			if(_Index<0){
				trace("IResourceLoader3DManager have a error:not find object...");
				return;
			}
			_RunArgs.splice(_Index,1);
			//batchStart(_IResourceLoader3D.packName+_IResourceLoader3D.extString);
//			trace("IResourceLoader3DManager: _RunArgs.length:"+_RunArgs.length+" _TaskArgs.length:"+_TaskArgs.length);
			GlobalFacade.sendNotify(NotifyConst.LOG,this,"IResourceLoader3DManager: _RunArgs.length:"+_RunArgs.length+" _TaskArgs.length:"+_TaskArgs.length);
			dispatch()
		}
		private function batchStart(resName:String):void{
			var _Index:int=-1;
			var _IResourceLoader3D:IResourceLoader3D;
			for each(_IResourceLoader3D in _RunArgs){
				if(_IResourceLoader3D.packName+_IResourceLoader3D.extString==resName){
					_Index=_TaskArgs.indexOf(_IResourceLoader3D);
					if(_Index<0) continue;
					_RunArgs.splice(_Index,1);
					_IResourceLoader3D.register=false;
					_IResourceLoader3D.removeEventListener(IResourceEvent.RegisterComplete, onRegisterComplete);
				}
			}
			for each(_IResourceLoader3D in _TaskArgs){
				if(_IResourceLoader3D.packName+_IResourceLoader3D.extString==resName){
					_Index=_TaskArgs.indexOf(_IResourceLoader3D);
					_TaskArgs.splice(_Index,1);
					_IResourceLoader3D.register=false;
					_IResourceLoader3D.removeEventListener(IResourceEvent.RegisterComplete, onRegisterComplete);
					_IResourceLoader3D.start();
				}
			}

		}
	}
}