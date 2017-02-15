package tl.core.Wizard.Move
{
	import flash.utils.Dictionary;
	
	public class MoveObjectPool
	{
		private static var _dict:Dictionary = new Dictionary();
		public static function getMoveObj(cls:Class):MoveBase
		{
			var objVec:Vector.<MoveBase> = _dict[cls];
			if (objVec == null || objVec.length == 0)
			{
				return new cls();
			}
			return objVec.pop();
		}
		
		public static function recycleMoveObj(obj:MoveBase):void
		{
			var cls:Class = obj["constructor"] as Class;
			var objVec:Vector.<MoveBase> = _dict[cls];
			if (objVec == null)
			{
				_dict[cls] = objVec = new Vector.<MoveBase>();
			}
			objVec.push(obj);
		}
	}
}