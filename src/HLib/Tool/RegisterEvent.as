package HLib.Tool
{
	import flash.events.IEventDispatcher;
	
	import HLib.DataUtil.HashMap;
	
	public class RegisterEvent
	{
		private static var _evtDict:HashMap = new HashMap();
		
		public static function addEvt(tarObj:Object, regObj:IEventDispatcher, evtType:String, callFun:Function):void
		{
			var evtList:Vector.<RegEvtObj> = _evtDict.get(tarObj);
			if (evtList == null)
			{
				evtList = new Vector.<RegEvtObj>()
				_evtDict.put(tarObj, evtList);
			}
			evtList.push(new RegEvtObj(regObj, evtType, callFun));
		}
		
		public static function removeEvt(tarObj:Object, regObj:IEventDispatcher, evtType:String, callFun:Function):void
		{
			var evtList:Vector.<RegEvtObj> = _evtDict.get(tarObj);
			if (evtList)
			{
				for each (var regEvtObj:RegEvtObj in evtList)
				{
					if (regEvtObj.regObj == regObj && regEvtObj.evtType == evtType && regEvtObj.callFun == callFun)
					{
						regEvtObj.dispose();
					}
				}
				evtList.length = 0;
			}
		}
		
		public static function removeAllEvt(tarObj):void
		{
			var evtList:Vector.<RegEvtObj> = _evtDict.remove(tarObj);
			if (evtList)
			{
				for each (var regEvtObj:RegEvtObj in evtList)
				{
					regEvtObj.dispose();
				}
			}
		}
	}
}
import flash.events.IEventDispatcher;

class RegEvtObj
{
	public function RegEvtObj(regObj:IEventDispatcher, type:String, callFun:Function):void
	{
		this.regObj = regObj;
		this.evtType = type;
		this.callFun = callFun;
		
		regObj.addEventListener(evtType, callFun);
	}
	
	public var regObj:IEventDispatcher;
	public var evtType:String;
	public var callFun:Function;
	
	public function dispose():void
	{
		regObj.removeEventListener(evtType, callFun);
	}
}