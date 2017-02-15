package HLib.WizardBase
{
	public class Direction extends Object
	{
		public static const NORTH_WEST:uint = 0;
		public static const NORTH:uint = 1;
		public static const NORTH_EAST:uint = 2;
		public static const WEST:uint = 3;
		public static const CENTER:uint = 4;
		public static const EAST:uint = 5;
		public static const SOUTH_WEST:uint = 6;
		public static const SOUTH:uint = 7;
		public static const SOUTH_EAST:uint = 8;
		public static const directions:Vector.<Number> = new Vector.<Number>(9);
		
		public function Direction()
		{
			return;
		}// end function
		
		public static function calcDirection(param1:Number, param2:Number, param3:Number, param4:Number) : uint
		{
			var _loc_5:* = param3 < param1 ? (0) : (param3 == param1 ? (1) : (2));
			var _loc_6:* = param4 < param2 ? (0) : (param4 == param2 ? (3) : (6));
			return _loc_5 + _loc_6;
		}// end function
		
		new Vector.<Number>(9)[0] = 135;
		new Vector.<Number>(9)[1] = 180;
		new Vector.<Number>(9)[2] = 225;
		new Vector.<Number>(9)[3] = 90;
		new Vector.<Number>(9)[4] = 0;
		new Vector.<Number>(9)[5] = 270;
		new Vector.<Number>(9)[6] = 45;
		new Vector.<Number>(9)[7] = 0;
		new Vector.<Number>(9)[8] = 315;
	}
}

