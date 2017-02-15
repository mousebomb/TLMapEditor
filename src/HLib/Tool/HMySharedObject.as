package HLib.Tool
{
	/**
	 * Flash本地存储cookie类
	 * @author 李舒浩
	 */	
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	
	public class HMySharedObject extends EventDispatcher
	{
		private static var _mySharedObject:HMySharedObject;
		
		private var _mySO:SharedObject;		//当前保存的共享区域
		
		public function HMySharedObject()
		{
			if(_mySharedObject)
				throw new Error("单例模式类不可重复实例化,请调用getInstance()方法");
		}
		
		public static function getInstance():HMySharedObject
		{
			if(!_mySharedObject) 
				_mySharedObject = new HMySharedObject();
			return _mySharedObject;
		}
		
		public function init(sharedObjectName:String = "mySharedObject"):void
		{
			_mySO = SharedObject.getLocal(sharedObjectName);
		}
		/**
		 * 存储cookie 
		 * @param keyName	: 存储内容key名(String)
		 * @param data		: 存储的值(String, object, Array, Vector, Dictionary...)
		 */		
		public function saveObject(keyName:String, data:*):void
		{
			if(!_mySO)
			{
				throw new Error("当前SharedObject未初始化,请先调用init()方法");
				return;
			}
			_mySO.data[keyName] = data;
			_mySO.flush();
		}
		/**
		 * 读取cookie内容 
		 * @param keyName	: 读取内容值(String)
		 * @return 			: 读取后的内容,如果是空的则返回undefined
		 */		
		public function readObject(keyName:String):*
		{
			return _mySO.data[keyName];
		}
		/**
		 * 获取当前是否有此属性数据 
		 * @param keyName	: 存储数据key值
		 * @return 			: Boolean(true:有保存此内容, false:没有保存此内容)
		 */		
		public function isHasOwnProperty(keyName:String):Boolean
		{
			return (readObject(keyName) ? true : false );
		}
		
		/** 获取当前共享对象的当前大小（KB） **/
		public function get size():Number
		{
			return _mySO.size;
		}
		
		/** 清除所有数据并从磁盘删除共享对象 **/
		public function clear():void
		{
			_mySO.clear();
		}
		/** 关闭远程共享对象和服务器间的连接 **/
		public function close():void
		{
			_mySO.close();
		}
	}
}