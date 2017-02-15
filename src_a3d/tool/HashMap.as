package tool
{
	import flash.utils.Dictionary;
	
	/**
	 * 键值对哈希表 
	 * @author Administrator
	 */	
	public class HashMap
	{
		private var _props:Dictionary = null;  
		
		public function HashMap()
		{  
			this.clear();  
		}  
		
		/**
		 * 清理所有数据 
		 * 
		 */		
		public function clear():void
		{ 
			this._props = new Dictionary();  
		}  
		
		/**
		 * 是否有指定的key 
		 * @param key
		 * @return 
		 * 
		 */		
		public function containsKey(key:*):Boolean
		{  
			return this._props[key] != null;  
		}  
		
		/**
		 * 是否有指定的值 
		 * @param value
		 * @return 
		 * 
		 */		
		public function containsValue(value:*):Boolean
		{  
			var result:Boolean = false;  
			for each (var val:* in _props)
			{
				if (val == value)
				{
					return true;
				}
			}
			return false;
		}  
		
		/**
		 * 返回指定key所对应的值 
		 * @param key
		 * @return 
		 * 
		 */		
		public function get(key:*):*
		{  
			return this._props[key];  
		}  
		
		/**
		 * 插入一个键值对 
		 * @param key
		 * @param value
		 * @return 
		 * 
		 */		
		public function put(key:*,value:*):*
		{  
			var result:* = _props[key];  
			this._props[key] = value;  
			return result;  
		}  
		
		/**
		 * 移除指定key的键值对 
		 * @param key
		 * @return 
		 * 
		 */		
		public function remove(key:*):*
		{  
			var result:* = _props[key];
			delete _props[key];  
			return result;  
		}  
		
		/**
		 * 返回整个表的键值对数量 (速度慢，谨慎使用
		 * @return 
		 * 
		 */		
		public function get size():uint
		{  
			return keys.length;  
		} 
		
		/**
		 *  是否有键值对在表中(速度慢，谨慎使用
		 * @return 
		 * 
		 */		
		public function isEmpty():Boolean
		{  
			return this.size < 1;  
		}  
		
		/**
		 * 返回所有值组成的数组 
		 * @return 
		 */		
		public function get values():Array
		{  
			var result:Array = new Array(); 
			for each (var val:* in _props)
			{
				result.push(val);
			}
			return result;  
		}  
		
		/**
		 * 返回所有键组成的数组 (速度慢，谨慎使用
		 * @return 
		 * 
		 */		
		public function get keys():Array
		{
			var retKeys:Array = [];
			for (var key:* in _props)
			{
				retKeys.push(key);
			}
			return retKeys;  
		}  
		
		/**
		 * 返回数据字典 
		 * @return 
		 * 
		 */
		public function get props():Dictionary
		{ 
			return this._props;  
		} 
	}
}