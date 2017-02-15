package tl.core.old.MapLoader
{
	/**
	 * 地图资源池(专门保存地图资源)
	 * @author 李舒浩
	 */	
	import flash.utils.Dictionary;
	
	import away3d.textures.ATFTexture;

	public class MyMapResTool
	{
		private static var _instance:MyMapResTool;
		
		private var _pool:Dictionary = new Dictionary(false);		//当前场景地图资源
		public function MyMapResTool()
		{
			if(_instance)
			{
				throw new Error("单例不可重复实例化");
			}
			_instance = this;
		}
		
		public static function get instance():MyMapResTool
		{
			return _instance ||= new MyMapResTool();
		}
		
		/**
		 * 向资源池中增加对象
		 */ 
		public function addResource(key:String, obj:ATFTexture):void
		{
			if(_pool[key] == null)
			{	
				_pool[key] = obj;
			}
		}
		
		/**
		 * 从资源池中获取对象
		 */ 
		public function getResource(key:String):ATFTexture
		{
			return _pool[key];
		}
		
		/**
		 * 清除所有资源
		 */
		public function clear():void
		{
			for each (var atfObj:ATFTexture in _pool)
			{
				atfObj.dispose();
			}
			_pool = new Dictionary(true);
		}
	}
}