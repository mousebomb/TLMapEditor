package HLib.Tool
{
	import flash.system.ApplicationDomain;
	
	public class LangManager
	{
		private static var dic:Object;
		public static function getValue(key:String):String
		{
			if(!key)
				return '';
			if(key.length==0)
				return key;
			if(dic==null)
			{
				if(!ApplicationDomain.currentDomain.hasDefinition('org.managers.Lang'))
				{
					return key;
				}
				dic = ApplicationDomain.currentDomain.getDefinition('org.managers.Lang').dic;		
			}
			if(dic==null)
			{
				return key;
			}
			var _value:String = dic[key];
			if(_value == null ||_value == '')_value = key;
			return _value;
		}

	}
}