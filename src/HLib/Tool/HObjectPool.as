package HLib.Tool
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import Modules.Test.GMWindow;

	/**
	 * 对象池 
	 * @author Administrator
	 * 郑利本
	 */	
	public class HObjectPool
	{
		private static  var instance:HObjectPool;
		private var _maxLength:int = 300;
		/** 
		 *  动态类对象池
		 */
		private var _dictionPool:Dictionary=new Dictionary();
		public function HObjectPool()
		{
		}
		
		public static  function getInstance():HObjectPool
		{
			if (instance == null) 
			{
				instance=new HObjectPool
			}
			return instance;
		}
		
		/** 
		 * 放入对象
		 * @param disObj 要的放入对象 
		 
		 */
		public function pushObj(obj:Object, type:int=0):void
		{
			var objName:String = getQualifiedClassName(obj) + type;
			if (obj == null) 
			{
				return;
			}
			if (this._dictionPool[objName] == null) 
			{
				this._dictionPool[objName]=[];
			}
			if(this._dictionPool[objName].length < this._maxLength)
				this._dictionPool[objName].push(obj);
		}
		
		/** 
		 * 取出对象 
		 * @param targetObj 需要的对象类类名，
		 * @return 取出的相应对象 
		 * 
		 */
		public function popObj(targetObj:Object, type:int=0):Object 
		{
			var objName:String=getQualifiedClassName(targetObj);
			if (this._dictionPool[objName + type] != null && this._dictionPool[objName + type].length > 0)
			{
				return this._dictionPool[objName + type].pop()  as  Object;
			}
			var objClass:Class=getDefinitionByName(objName)  as  Class;
			var obj:Object=new objClass as Object;
			//----------添加对象统计数据---------------------------
			for(var i:String in _dictionPool){
				GMWindow.getInstance()._countObject[i]=_dictionPool[i].length;
			}
			//-------------------------------------------------------
			return obj;
		}
	}
}