package HLib.MapBase
{
	
	
	/**
	 * 节点类 
	 * @author 黄栋
	 * 
	 */	
	public class Node
	{
		public static const BLACK:uint = 0;
		public static const WHITE:uint = 0;
		
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
		public var links:Vector.<Link>;					//同轴数据
		public var pointH:int;						//格子Y轴位置
		
		public var color:uint = WHITE;
		
		private var _Value:int;					//格子类型
		
		public function Node()
		{
			links = new Vector.<Link>();
		}
		//----------------------------------------------------------------------------------------------
		private static var _linkPools:Vector.<Link> = new Vector.<Link>();	
		private static function getLinkByPool(node:Node, cost:Number):Link
		{
			var tmpLink:Link;
			if (_linkPools.length)
			{
				tmpLink = _linkPools.pop();
			}
			else
			{
				tmpLink = new Link();
			}
			tmpLink.init(node, cost);
			return tmpLink;
		}
		
		private static function recycleLink(link:Link):void
		{
			link.reset();
			if (_linkPools.length < 50000)
			{
				_linkPools.push(link);
			}
		}
		
		//----------------------------------------------------------------------------------------------
		
		public function addLinkNode(node:Node, cost:Number):void
		{
			links.push(getLinkByPool(node, cost));
		}
		
		public function set value(num:int):void
		{
			_Value = num;
			if(_Value == 1 || _Value == 3)
			{
				walkable = false;
			}
			else
			{
				walkable = true;
			}
		}
		
		public function init(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function reset():void
		{
			x = y = pointX = pointY = 0;
			
			f = g = h = 0;
			
			walkable = true;
			parent = null;
			
			costMultiplier = version = 1;
			
			for each (var link:Link in links)
			{
				recycleLink(link);
			}
			
			links.length = 0;
			
			pointH = 0; 
			color = WHITE;
			
			_Value = 0;
		}
		
		public function get value():int
		{
			return _Value;
		}
		
		public function toString():String
		{
			return "x:" + x + " y:" + y + " " + (walkable ? "可行走" : "不可行走");
		}
	}
}