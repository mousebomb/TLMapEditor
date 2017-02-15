package HLib.Tool
{
	public class ConvertArray
	{
		public static function StringTwoArray(s:String,splits:String,arraylength:int,beginindex:int=0):Array
		{
			if(s!="" && splits!="")
			{
				var arr:Array=s.split(splits);
				var args:Array=new Array();
				var ss:Array;
				var leng:int = (arr.length-beginindex)/arraylength
				for(var i:int=0;i<leng;i++)
				{
					ss=new Array();
					for(var j:int=0;j<arraylength;j++)
					{
						ss[j]=arr[j+i*arraylength+beginindex];
					}
					args.push(ss);
				}
			}
			return args;
		}
		public static function ArrayTwoArray(ar:Array,arraylength:int,beginindex:int=0):Array
		{
			if(ar!=null){
				var args:Array=new Array();
				var ss:Array;
				var leng:int = (ar.length-beginindex)/arraylength
				for(var i:int=0;i<leng;i++){
					ss=new Array();
					for(var j:int=0;j<arraylength;j++){
						ss[j]=ar[j+i*arraylength+beginindex];
					}
					args.push(ss);
				}
			}
			return args;
		}		
	}
}