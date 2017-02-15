package HLib.Pools
{
	import HLib.UICom.Away3DUICom.HProgressBar3D;
	
	import Modules.Wizard.Move.TweenObjectProxy;
	
	import tool.Pools.NormalPool;
	
	public class ObjectPools
	{
		private static var _loaderParamPools:NormalPool;
		
		private static var _poolObjectPools:NormalPool;
		
		private static var _text3dPools:NormalPool;
		
		private static var _effPools:NormalPool;
		
		private static var _iconPools:NormalPool;
		
		private static var _unitPools:NormalPool;
		
		private static var _text2DPools:NormalPool;
		
		private static var _proBarPools:NormalPool;
		
		private static var _tweenProxyPools:NormalPool;
		
		setup();
		public static function setup():void
		{
			_loaderParamPools = new NormalPool(30);
			
			_poolObjectPools = new NormalPool(100);
			
			_text3dPools = new NormalPool(100);
			
			_effPools = new NormalPool(30);
			
			_iconPools = new NormalPool(30);
			
			_unitPools = new NormalPool(100);
			
			_text2DPools = new NormalPool(50);
			
			_proBarPools = new NormalPool(50);
			
			_tweenProxyPools = new NormalPool(1000);
		}
		//--------------------------------------------------------------------------------------------------------------------------------
		// 
		public static function getTweenProxy(tarObj:*):TweenObjectProxy
		{
			var param:TweenObjectProxy = _tweenProxyPools.getObject(TweenObjectProxy, tarObj) as TweenObjectProxy;
			return param;
		}
		
		public static function recycleTweenProxy(obj:TweenObjectProxy):void
		{
			_tweenProxyPools.recycle(obj);
		}
		
		//--------------------------------------------------------------------------------------------------------------------------------
		//--------------------------------------------------------------------------------------------------------------------------------
		// Text2D
		public static function getProBar():HProgressBar3D
		{
			var param:HProgressBar3D = _proBarPools.getObject(HProgressBar3D) as HProgressBar3D;
			return param;
		}
		
		public static function recycleProBar(param:HProgressBar3D):void
		{
			param.dispose();
			//			_proBarPools.recycle(param);
		}
		
		//--------------------------------------------------------------------------------------------------------------------------------
		// 池对象
		public static function getPoolObj(data:*, rt:uint = 60000):PoolObject
		{
			var obj:PoolObject = _poolObjectPools.getObject(PoolObject) as PoolObject;
			obj.data = data;
			obj.rt = rt;
			obj.resetTime();
			return obj;
		}
		
		public static function recyclePoolObj(obj:PoolObject):void
		{
			_poolObjectPools.recycle(obj);
		}
	}
}