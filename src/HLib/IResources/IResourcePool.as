package HLib.IResources
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.sampler.getSize;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import HLib.Pools.PoolObject;
	import HLib.Tool.HFrameWorkerManager;
	import HLib.Tool.HLog;
	
	import Modules.Wizard.WizardKey;
	
	/**
	 * 资源池
	 * 
	 */ 
	public class IResourcePool extends EventDispatcher
	{
		private static var MyInstance:IResourcePool;
		private var pool:Dictionary = new Dictionary();
		private var poolArgs:Array = new Array();
		//public var _HashMap:HashMap=new HashMap();
		public var _Config:XML;
		public var _Localver:String="localhost";
		
		public function IResourcePool()
		{
			init();
			
			HFrameWorkerManager.getInstance().addFunc(this, onCheckPool);
		}
		
		public static function getInstance():IResourcePool
		{
			if(MyInstance == null)
			{
				MyInstance = new IResourcePool();
			}
			return MyInstance;
		}
		
		
		//-------------------------------------------------------------------------------------------------------
		private function onCheckPool():void
		{
			if (++_checkKeep > 60)
			{
				_checkKeep = 0;
				
				checkPoolObject();
			}
		}
		
		private var _checkKeep:uint;
		private function checkPoolObject():void
		{
			var poolObject:PoolObject;
			for each (var typePools:Dictionary in poolArgs)
			{
				for (var key:* in typePools)
				{
					poolObject = typePools[key];
					if (poolObject == null)
					{
						delete typePools[key];
					}
					else if (poolObject.isPassDue)
					{
						typePools[key] = null;
						delete typePools[key];
					}
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------------------
		
		private function init():void
		{
			var _Dictionary:Dictionary;
			for(var i:int = 0; i < 10; i++)
			{
				_Dictionary = new Dictionary();
				poolArgs.push(_Dictionary);
			}
		}
		
		/**
		 * 向资源池中增加对象
		 */ 
		public function addResource(key:String, obj:*):void
		{
			if(pool[key] == null) 
			{
				pool[key] = obj;
			}
		}
		
		/**
		 * 从资源池中获取对象
		 */ 
		public function getResource(key:String):*
		{
			return pool[key];
		}
		
		/**
		 * 从资源池中获取对象
		 */ 
		public function getByteArrayResource(key:String):*
		{
			key = 'byteArray' + key + '.atf';
			return pool[key];
		}
		
		//-------------------------------------------------------------------------------------------------------
		/**
		 * 向类型资源池中增加对象
		 */ 
		public function hasResourceByType(key:String, type:int):Boolean
		{
			if(type < 0)
			{
				return false;
			}
			if(poolArgs[type] == null)
			{
				return false;
			}
			var obj:PoolObject = poolArgs[type][key];
			if(obj && obj.data)
			{
				return true;
			}
			return false;
		}
		
		public function resetResTime(key:String, type:int):void
		{
			if(poolArgs[type] == null)
			{
				return;
			}
			var obj:PoolObject = poolArgs[type][key];
			if(obj)
			{
				obj.resetTime();
			}
		}
		
		/**
		 * 向类型资源池中增加对象
		 */ 
		public function addResourceByType(key:String, obj:*, type:int):void
		{
			
			if(poolArgs[type][key] == null)
			{
				var poolObj:PoolObject = new PoolObject(obj, 600000);
				poolArgs[type][key] = poolObj;
				poolObj.rt = WizardKey.canDispose(key) ? poolObj.rt : 0;
			}
		}
		
		/**
		 * 从类型资源池中获取对象
		 */ 
		public function getResourceByType(key:String, type:int):*
		{
			if(type < 0) 
			{
				return null;
			}
			
			var obj:PoolObject = poolArgs[type][key];
			if (obj)
			{
				return obj.data;
			}
			return null;
		}
		/*
		public function disposeAllResByType():void
		{
			//只释放模型，贴图，动作，特效暂不释放
			var _disposeResCount:int = 0;
			for(var i:int = 0; i < 4; i++)
			{
				for(var key:String in poolArgs[i])
				{
					if(!WizardKey.canDispose(key))
					{
						continue;
					}
					poolArgs[i][key].dispose();
					delete poolArgs[i][key];	
					_disposeResCount++;
				}
			}
		}*/
		/**
		 * 更新资源池中的对象
		 */ 
		public function updateResource(key:String, obj:*):void
		{
			dispose(key);
			pool[key] = obj;
		}
		/**
		 * 向资源池中减少对象
		 */ 
		public function removeResource(key:String):void
		{
			if(pool[key]==null) 
			{
				return;
			}
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
			trace("dispose Resource:",key,getSize(this));
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
			trace("dispose Resource:",key,getSize(this));
			HLog.getInstance().appMsg("dispose Resource:"+key);
		}
		
		public function Comparison(key:String,size:String,byteArray:ByteArray=null):Boolean
		{
			var _Isornot:Boolean=false;
			var _Args:Array=_Config.elements(key).toString().split(",");
			var _Size:String=_Args[0];
			var _Md5:String=_Args[1];
			var md5:String="NaN";
			trace("Comparison size:",size+"/"+_Size,"md5:",md5+"/"+_Md5);
			HLog.getInstance().appMsg("Comparison size:"+size+"/"+_Size+" md5:"+md5+"/"+_Md5);
			if(_Size==size){//&&_Md5==md5){
				_Isornot=true;
			}
			return _Isornot;
			return true;
		}
		
		public function getVersion(key:String,step:int=0):String
		{			
			var _Version:String=_Config.elements(key.toLocaleLowerCase());
			if(!_Version)
			{
				_Version = "0";
			}
			if(_Version == "0")
			{
				return "?v=" + _Localver;
			}
			else
			{
				return "?v=" + _Version;
			}
		}
		
		public function get myPool():String
		{
			var _CountS:String="";
			for(var i:String in pool)
			{
				_CountS+="|"+i;
			}
			return _CountS;
		}
		
		public static function hasResource(param0:String):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
	}
}