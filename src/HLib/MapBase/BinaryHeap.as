package HLib.MapBase
{
	/**
	 * 二叉树数据 
	 * @author Administrator
	 * 
	 */	
	public class BinaryHeap
	{
		private var _heapVec:Vector.<Node> = new Vector.<Node>();
		
		public function BinaryHeap()
		{
			_heapVec.push(null);
		}
		
		public function get length():uint
		{
			return _heapVec.length;
		}
		
		public function clear():void
		{
			_heapVec.length = 0;
			_heapVec.push(null);
		}
		
		/**
		 * 添加一个数据 
		 * @param value
		 * 
		 */		
		public function push(value:Node):void 
		{
			_heapVec.push(value);
			var curIdx:int = _heapVec.length - 1;
			var parentIdx:int = curIdx >> 1;
			var temp:Node;
			while (curIdx > 1 && _heapVec[curIdx].f < _heapVec[parentIdx].f)
			{
				temp = _heapVec[curIdx];
				_heapVec[curIdx] = _heapVec[parentIdx];
				_heapVec[parentIdx] = temp;
				curIdx = parentIdx;
				parentIdx = curIdx >> 1;
			}
		}
		
		/**
		 * 删除 最后一个数据
		 * @return 
		 * 
		 */		
		public function pop():Node 
		{
			if (_heapVec.length <= 2)
			{
				return _heapVec.pop();
			}
			
			var min:Node = _heapVec[1];
			_heapVec[1] = _heapVec.pop();
			var l:int = _heapVec.length;
			var curIdx:int = 1;
			var leftIdx:int;
			var rightIdx:int;
			var minIdx:int;
			var tmpNode:Node;
			
			leftIdx = curIdx << 1;
			rightIdx = leftIdx + 1;
			while (leftIdx < l)
			{
				if (rightIdx < l)
				{
					minIdx = _heapVec[leftIdx].f < _heapVec[rightIdx].f ? leftIdx : rightIdx;
				}
				else
				{
					minIdx = leftIdx;
				}
				
				if (_heapVec[minIdx].f < _heapVec[curIdx].f)
				{
					tmpNode = _heapVec[minIdx];
					_heapVec[minIdx] = _heapVec[curIdx];
					_heapVec[curIdx] = tmpNode;
					
					curIdx = minIdx;
					leftIdx = curIdx << 1;
					rightIdx = leftIdx + 1;
				}
				else
				{
					break;
				}
			}
			return min;
		}

	}
}