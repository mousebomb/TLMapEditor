package tl.core.Wizard
{
	public class CoefObject
	{
		public var id:int;
		public var name:String;
		public var param1:int;
		public var param2:int;
		public var param3:int;
		public var param4:int;
		public var formula:String;
		public function CoefObject()
		{
			
		}
		public function refresh(value:Array):void{
			id=int(value[0]);
			name=value[0];
			param1=int(value[0]);
			param2=int(value[0]);
			param3=int(value[0]);
			param4=int(value[0]);
			formula=value[0];
			
		}
	}
}