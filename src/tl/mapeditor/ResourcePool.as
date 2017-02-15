package tl.mapeditor
{
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.geom.Matrix;

	import tl.utils.HashMap;

	/**
	 * 资源池
	 * @author 李舒浩
	 */	
	public class ResourcePool
	{
		private static var _pool:ResourcePool;
		
		private var _meshPoolHashMap:HashMap = new HashMap();	//mesh保存hashMap
		
		public function ResourcePool()
		{
			if(_pool)	throw new Error("单例");
			_pool = this;
		}
		public static function getInstance():ResourcePool
		{
			if(!_pool) _pool = new ResourcePool();
			return _pool;
		}
		/**
		 * 添加资源
		 * @param key	: 资源名
		 * @param res	: 资源
		 */		
		public function addRes(key:String, res:*):void
		{
			_meshPoolHashMap.put(key, res);
		}
		/**
		 * 获取指定资源
		 * @param key	: 资源名
		 */		
		public function getRes(key:String):*
		{
			return _meshPoolHashMap.get(key);
		}
		/**
		 * 删除指定资源
		 * @param key	: 需要删除的资源名
		 */		
		public function delRes(key:String):void
		{
			_meshPoolHashMap.remove(key);
		}
		/**
		 * 查询是否有此资源key
		 * @param key	: 资源名
		 */		
		public function containsKey(key:String):Boolean
		{
			return _meshPoolHashMap.containsKey(key);
		}
		/**
		 * 查询是否有此资源
		 * @param value	: 资源
		 */	
		public function containsValue(value:*):Boolean
		{
			return _meshPoolHashMap.containsValue(value);
		}
		/**
		 * 获取资源数组
		 */		
		public function getValues(type:int):Array
		{
			return _meshPoolHashMap.values;
		}
		/**
		 * 获取资源key数组
		 */	
		public function getKeys(type:int):Array
		{
			return _meshPoolHashMap.keys;
		}
		/**
		 * 从swf资源中获取bitmapdata
		 * @param key		: swf名
		 * @param resName	: 连接名
		 */		
		public function getBtmdBySwf(key:String, resName:String):BitmapData
		{
			if(!containsKey(key)) return null;
			if(containsKey(resName))
			{
				return getRes(resName);
			}
			var loaderInfo:LoaderInfo = getRes(key);
			var cla:Class = loaderInfo.applicationDomain.getDefinition(resName) as Class;
			if(!cla) return null;
			var bitmapdata:BitmapData = new cla();
			addRes(resName, bitmapdata);
			var vec:Vector.<String> = Vector.<String>(["Skin_ReductButton_Up", "Skin_ReductButton_Over", "Skin_ReductButton_Down"]);
			var index:int = vec.indexOf(resName);
			if(index > -1)
			{
				var btmd:BitmapData = new BitmapData(bitmapdata.width, bitmapdata.height, true, 0x0);
				btmd.draw(bitmapdata, new Matrix(1, 0, 0, -1, 0, bitmapdata.height));
				addRes(vec[index].replace("ReductButton", "ReductButtonU"), btmd);
			}
			return bitmapdata;
		}
	}
}