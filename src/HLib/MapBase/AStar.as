package HLib.MapBase 
{
	import flash.utils.getTimer;
	
	/**
	 * A星寻路 
	 * @author 郑利本修改
	 * 
	 */
	public class AStar
	{
		private var _open:BinaryHeap = new BinaryHeap();
		private var _grid:HMapData;
		private var _endNode:Node;
		private var _startNode:Node;
		private var _path:Array;
		public var heuristic:Function;
		private var _straightCost:Number = 1.0;
		private var _diagCost:Number = Math.SQRT2;
		private var nowversion:int = 1;
		
		public function AStar()
		{		
			
		}
		
		public function set mapData(value:HMapData):void
		{
			this._grid = value;
			heuristic = manhattan;
		}
		/*
		private function justMin(x:Object, y:Object):Boolean 
		{
		return x.f < y.f;
		}*/
		/**
		 * 获取路径
		 * @return 
		 * 
		 */		
		public function findPath(startNode:Node, endNode:Node):Boolean
		{
			_startNode = startNode;
			_endNode = endNode;
			nowversion++;
			_open.clear();// = new BinaryHeap();
			_startNode.g = 0;
			return search();
		}
		/**
		 * 寻路 
		 * @return 
		 * 
		 */	
		public function search():Boolean
		{
			var tmpTime:uint = getTimer();
			var tmpCount:uint = 0;
			
			var node:Node = _startNode;
			var links:Vector.<Link>;
			var tmpLink:Link;
			node.version = nowversion;
			while (node != _endNode)
			{
				links = node.links;
				var len:int = links.length;
				for (var i:int = 0; i < len; i++)
				{
					tmpCount ++;
					tmpLink = links[i];
					var test:Node = tmpLink.node;
					var cost:Number = tmpLink.cost;
					var g:Number = node.g + cost;
					var h:Number = heuristic(test);
					var f:Number = g + h;
					if (test.version == nowversion)
					{
						if (test.f > f)
						{
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
							
							if (test.color == Node.WHITE)
							{
								test.color = Node.BLACK;
								_open.push(test);
							}
						}
					}
					else 
					{
						test.f = f;
						test.g = g;
						test.h = h;
						test.parent = node;
						test.color = Node.BLACK;
						_open.push(test);
						test.version = nowversion;
					}
					
				}
				if (_open.length == 1)
				{
					return false;
				}
				node = _open.pop() as Node;
				node.color = Node.WHITE;
			}
			
			if (getTimer() - tmpTime > 1)
			{
				trace("----------------------------------->寻路时间过长：", tmpCount, "--", getTimer() - tmpTime);
			}
			
			buildPath();
			return true;
		}
		
		/**
		 * 创建数据组 
		 */		
		private function buildPath():void 
		{
			_path = [];
			var node:Node = _endNode;
			_path.push(node);
			while (node != _startNode)
			{
				node = node.parent;
				_path.unshift(node);
			}
		}
		/**
		 * 获取原始路径 
		 * @return 
		 * 
		 */		
		public function get path():Array 
		{
			return _path;
		}
		
		public function manhattan(node:Node):Number 
		{
			return Math.abs(node.x - _endNode.x) + Math.abs(node.y - _endNode.y);
		}
		
		public function manhattan2(node:Node):Number {
			var dx:Number = Math.abs(node.x - _endNode.x);
			var dy:Number = Math.abs(node.y - _endNode.y);
			return dx + dy + Math.abs(dx - dy) / 1000;
		}
		
		public function euclidian(node:Node):Number 
		{
			var dx:Number = node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		private var TwoOneTwoZero:Number = 2 * Math.cos(Math.PI / 3);
		
		public function chineseCheckersEuclidian2(node:Node):Number
		{
			var y:int = node.y / TwoOneTwoZero;
			var x:int = node.x + node.y / 2;
			var dx:Number = x - _endNode.x - _endNode.y / 2;
			var dy:Number = y - _endNode.y / TwoOneTwoZero;
			return sqrt(dx * dx + dy * dy);
		}
		/**
		 * 数据开平方
		 * @param x
		 * @return 
		 * 
		 */		
		private function sqrt(x:Number):Number 
		{
			return Math.sqrt(x);
		}
		/**
		 * 几何启发函数 
		 * @param node
		 * @return 
		 * 
		 */		
		public function euclidian2(node:Node):Number
		{
			var dx:Number = node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y;
			return dx * dx + dy * dy;
		}
		/**
		 * 对角启发函数 
		 * @param node
		 * @return 
		 * 
		 */		
		public function diagonal(node:Node):Number
		{
			var dx:Number = Math.abs(node.x - _endNode.x);
			var dy:Number = Math.abs(node.y - _endNode.y);
			var diag:Number = Math.min(dx, dy);
			var straight:Number = dx + dy;
			return _diagCost * diag + _straightCost * (straight - 2 * diag);
		}
	}
}