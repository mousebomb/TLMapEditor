package HLib.UICom.BaseClass
{
	import flash.events.EventDispatcher;

	public class ObjectPool extends EventDispatcher
	{
		private var _Class:Class;
		private var _ClearInIt:String="";
		private var _MaxSize:int=0;
		private var _Size:int=0;
		private var _ObjectArgs:Array=new Array();
		private var _UseObjectArgs:Array=new Array();
		public function ObjectPool(_class:Class=null,_maxSize:int=0,clearInIt:String="")
		{
			_Class=_class;
			_MaxSize=_maxSize;
			_ClearInIt=clearInIt;
		}
		public function InIt(_class:Class=null,_maxSize:int=0,clearInIt:String=""):void{
			_Class=_class;
			_MaxSize=_maxSize;
			_ClearInIt=clearInIt;
		}
		public function backOjbect(value:*):Boolean{
			if(!_Class) return false;
			if(!value is _Class) return false;
			var _Index:int=_UseObjectArgs.indexOf(value);
			if(_Index<0) return false;
			_UseObjectArgs.splice(_Index,1);
			//_ObjectArgs.push(value);
			_ObjectArgs.push(new _Class());
			if(_ClearInIt!=""){
				value[_ClearInIt]();
			}
			return true;
		}
		public function getOjbect():*{
			var _TempClass:*;
			if(_ObjectArgs.length>0){
				_TempClass=_ObjectArgs.shift();
				_UseObjectArgs.push(_TempClass);
			}
			else{
				_TempClass=new _Class();
				_UseObjectArgs.push(_TempClass);
			}
			return _TempClass;
		}
		public function removeOjbect():void{
			
		}
		public function clear():void{
			
		}

		public function get useObjectArgs():Array
		{
			return _UseObjectArgs;
		}

	}
}