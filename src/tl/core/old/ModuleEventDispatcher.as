package tl.core.old
{
	import flash.events.EventDispatcher;

	import tl.utils.HashMap;

	public class ModuleEventDispatcher extends EventDispatcher
	{
		private static var MyInstance :ModuleEventDispatcher;
		private var _IsDispatcher:Boolean=true;
		private var _HashMap:HashMap=new HashMap();
		private var _UpKey:String="";
		private var _SameKeyNum:int=0;
		public function ModuleEventDispatcher()
		{
			if( MyInstance ){
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			MyInstance=this;			
		}
		public static function getInstance() :ModuleEventDispatcher 
		{
			if ( MyInstance == null ) 
			{				
				MyInstance = new ModuleEventDispatcher();
			}
			return MyInstance;
		}
		public function ModuleCommunication(EventKey:String,EventData:Object=null):void{
			if(!_IsDispatcher) return;
			//如果同一个事件短时间内分发多次则忽略
			if(_UpKey==EventKey){
				_SameKeyNum++
				//trace("Dispatcher Event: "+_UpKey+"  Number:"+_SameKeyNum);
			}else{
				_SameKeyNum=0;
			}
			_UpKey=EventKey;
			//统计事件分发的次数
			if(_HashMap.get(EventKey)){
				var _Num:int=_HashMap.get(EventKey);
				_Num+=1;
				_HashMap.put(EventKey,_Num);
			}else{
				_HashMap.put(EventKey,1);
			}
			this.dispatchEvent(new ModuleEvent(EventKey,EventData));
		}
		public function Count(EventKey:String):void{
			//统计事件分发的次数
			if(_HashMap.get(EventKey)){
				var _Num:int=_HashMap.get(EventKey);
				_Num+=1;
				_HashMap.put(EventKey,_Num);
			}else{
				_HashMap.put(EventKey,1);
			}
		}
		/**
		 * 事件回调方法 
		 * @param EventKey　事件key
		 * @param fun       回调方法(方法的参数只能有一个,可以用数组传递fun需要的多个参数)
		 * 
		 * 示例：ModuleEventDispatcher.getInstance().EventCall("CreateMyBuddy",onCreateMyBuddy);
		 * 　　　private function onCreateMyBuddy(_TempBuddy:Buddy):void{}
		 *   或　private function onCreateMyBuddy(args:Array):void{}
		 * 又或　ModuleEventDispatcher.getInstance().EventCall("CreateMyBuddy",function (args:Array):void{trace("...");});
		 */
		public function EventCall(EventKey:String,fun:Function):void{
			if(!_IsDispatcher) return;
			if(fun.length<1){
				this.addEventListener(EventKey,function(e:ModuleEvent):void{fun();});
			}
			else{
				this.addEventListener(EventKey,function(e:ModuleEvent):void{
					var _Object:Object=e.data;
					fun(_Object);
				});
			}
		}
		public function set IsDispatcher(value:Boolean):void{
			_IsDispatcher=value;
		}
		public function get IsDispatcher():Boolean{
			return _IsDispatcher;
		}
		public function get myHashMap():HashMap{
			return _HashMap;
		}
	}
}