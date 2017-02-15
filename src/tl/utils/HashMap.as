package tl.utils
{
	import flash.utils.Dictionary;

	/**
	 * 键值对哈希表 
	 * @author Administrator
	 */	
	public class HashMap
	{
		private var _keys:Array = null;  
		private var props:Dictionary = null;  
		
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
			this.props = new Dictionary();  
			this._keys = new Array();  
		}  
		
		/**
		 * 是否有指定的key 
		 * @param key
		 * @return 
		 * 
		 */		
		public function containsKey(key:*):Boolean
		{  
			return this.props[key] != null;  
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
			var len:uint = this.size;  
			if(len > 0){  
				for(var i:uint = 0 ; i < len ; i++){  
					if(this.props[this._keys[i]] == value) return true;  
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
			return this.props[key];  
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
			var result:* = null;  
			if(this.containsKey(key)){  
				result = this.get(key);  
				this.props[key] = value;  
			}else{  
				this.props[key] = value;  
				this._keys.push(key);  
			}  
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
			var result:* = null;  
			if(this.containsKey(key)){  
				result = this.props[key];
				delete this.props[key];  
				var index:int = this._keys.indexOf(key);  
				if(index > -1){  
					this._keys.splice(index,1);  
				}  
			}  
			return result;  
		}  
		
		/**
		 * 返回整个表的键值对数量 
		 * @return 
		 * 
		 */		
		public function get size():uint
		{  
			return this._keys.length;  
		} 
		
		/**
		 *  是否有键值对在表中
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
			var len:uint = this.size;  
			if(len > 0){  
				for(var i:uint = 0;i<len;i++){  
					result.push(this.props[this._keys[i]]);  
				}  
			}  
			return result;  
		}  
		
		/**
		 * 返回所有键组成的数组 
		 * @return 
		 * 
		 */		
		public function get keys():Array
		{ 
			return this._keys;  
		}  
		
	}
}