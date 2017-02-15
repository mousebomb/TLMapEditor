package tl.core.old
{
	import tl.mapeditor.Config;

	/**
	 *节点类 
	 * @author 黄栋
	 * 
	 */	
	public class Node
	{
		public var x:int;							//格子所在二维数组X
		public var y:int;							//格子所在二维数组Y
		public var pointX:int;						//格子所在地图坐标X
		public var pointY:int;						//格子所在地图坐标Y
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var walkable:Boolean = true;
		public var parent:Node;
		public var costMultiplier:Number = 1.0;
		public var version:int = 1;
		public var links:Array;					//同轴数据
		public var pointH:int;						//格子Y轴位置
		
		private var _Value:int;
		public function Node(x:int, y:int)
		{
			this.x = x;
			this.y = y;
			
		}
		public function set value(num:int):void{
			_Value=num;
			if(_Value==1||_Value==3){
				walkable=false;
			}
			else{
				walkable=true;
			}
			if(_Value != Config.STATE_TYPE_6) pointH = 0;
		}
		public function get value():int{
			return _Value;
		}
		public function toString():String {
			return "x:" + x + " y:" + y;
		}
	}
}