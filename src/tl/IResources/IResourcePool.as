package tl.IResources
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.net.LocalConnection;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import tl.utils.HashMap;

	/**
	 * 资源池
	 * 
	 */ 
	public class IResourcePool extends EventDispatcher
	{
		/**
		 * 资源池队列
		 */ 
		protected var pool:Dictionary= new Dictionary();
		private static var MyInstance:IResourcePool;
		private var _UpKey:String="";
		private var _SameKeyNum:int=0;
		public var _HashMap:HashMap=new HashMap();
		public var _Config:XML;
		public var _Localver:String="";
		public function IResourcePool()
		{
			if( MyInstance ){
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			MyInstance=this;
			
		}
		public static function getInstance():IResourcePool{
			if(!MyInstance){
				MyInstance=new IResourcePool();
			}
			return MyInstance;
		}
		/**
		 * 向资源池中增加对象
		 */ 
		public function addResource(key:String,obj:*):void
		{
			if(pool[key]==null) pool[key]=obj;
			//统计同一个资源添加次数
			if(_HashMap.get("add_"+key)){
				var _Num:int=_HashMap.get("add_"+key);
				_Num+=1;
				_HashMap.put("add_"+key,_Num);
			}else{
				_HashMap.put("add_"+key,1);
			}
		}
		/**
		 * 从资源池中获取对象
		 */ 
		public function getResource(key:String):*
		{
			//统计资源获取次数
			if(_HashMap.get(key)){
				var _Num:int=_HashMap.get(key);
				_Num+=1;
				_HashMap.put(key,_Num);
			}else{
				_HashMap.put(key,1);
			}
			return pool[key];
		}
		/**
		 * 更新资源池中的对象
		 */ 
		public function updateResource(key:String,obj:*):void
		{
			dispose(key);
			pool[key] = obj;
		}
		/**
		 * 向资源池中减少对象
		 */ 
		public function removeResource(key:String):void
		{
			if(pool[key]==null) return;
			dispose(key);
		}
		/**
		 * 清除所有资源
		 */
		public function clear():void
		{
			for(var key:String in pool)
			{
				dispose(key);				
			}
		}
		/**
		 * 释放指定的资源
		 */
		public function dispose(key:String):void
		{
			if(pool[key] is Bitmap)
			{
				(pool[key] as Bitmap).bitmapData.dispose();
			}
			
			if(pool[key] is BitmapData)
			{
				(pool[key] as BitmapData).dispose();
			}
			
			if(pool[key] is Array)
			{			
				if(pool[key][i] is BitmapData){
					for(var i:int=0;i<pool[key].length;i++){
						(pool[key][i] as BitmapData).dispose();
					}
				}
				else{
					pool[key]=null;
				}

			}
			
			if(pool[key] is LoaderInfo)
			{
				var _LoaderInro:LoaderInfo=pool[key];
				_LoaderInro.loader.unload();
				pool[key]=null;
				_LoaderInro=null
			}
			
			delete pool[key];
			trace("dispose Resource:",key);
//			HLog.getInstance().appMsg("dispose Resource:"+key);
		}
		
		/**
		 * 强制执行一次内存回收,慎用
		 */
		public function enforceDispose():void{
			try
			{
				var lc1: LocalConnection = new LocalConnection();
				var lc2:LocalConnection = new LocalConnection();
				lc1.connect("gcConnection");
				lc2.connect("gcConnection");
			}
			catch (e:Error)
			{
			}
		}
		public function Comparison(key:String,size:String,byteArray:ByteArray=null):Boolean{
			var _Isornot:Boolean=false;
			var _Args:Array=_Config.elements(key).toString().split(",");
			var _Size:String=_Args[0];
			var _Md5:String=_Args[1];
			var md5:String="NaN";
			trace("Comparison size:",size+"/"+_Size,"md5:",md5+"/"+_Md5);
//			HLog.getInstance().appMsg("Comparison size:"+size+"/"+_Size+" md5:"+md5+"/"+_Md5);
			if(_Size==size){//&&_Md5==md5){
				_Isornot=true;
			}
			return _Isornot;
			return true;
		}
		public function getVersion(key:String,step:int=0):String{
			var _Version:String=_Config.elements(key.toLocaleLowerCase());
			if(!_Version){
				_Version="0";
			}
			return "?v="+_Version+String(int(_Localver)+step);
		}
	}
}