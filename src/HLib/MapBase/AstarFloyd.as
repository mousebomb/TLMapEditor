package HLib.MapBase
{
	import flash.geom.Point;
	
	import Modules.Map.HMap3D;

	public class AstarFloyd
	{
		
		/**
		 * 平滑处理 
		 * 
		 */		
		public static function floyd(path:Array):Array
		{
			if (path == null)
			{
				return null;
			}
			var floydPath:Array = path.concat();
			var len:int = floydPath.length;
			
			//遍历路径数组中全部路径节点，合并在同一直线上的路径节点
			if (len > 2)
			{
				var vector:Node = new Node();
				var tempVector:Node = new Node();
				floydVector(vector, floydPath[len - 1], floydPath[len - 2]);
				for (var i:int = floydPath.length - 3; i >= 0; i--)
				{
					floydVector(tempVector, floydPath[i + 1], floydPath[i]);
					if (vector.x == tempVector.x && vector.y == tempVector.y)
					{
						floydPath.splice(i + 1, 1);
					} 
					else 
					{
						vector.x = tempVector.x;
						vector.y = tempVector.y;
					}
				}
			}
			
			//消除拐点操作。检查节点间是否存在障碍物，若它们之间不存在障碍物，则直接合并此两路径节点间所有节点。
			len = floydPath.length;
			for (i = len - 1; i >= 0; i--)
			{
				for (var j:int = 0; j <= i - 2; j++)
				{
					if (floydCrossAble(floydPath[i], floydPath[j]))
					{
						for (var k:int = i - 1; k > j; k--)
						{
							floydPath.splice(k, 1);
						}
						i = j;
						len = floydPath.length;
						break;
					}
				}
			}
			
			return floydPath;
		}
		
		private static var _tmpPosVec:Vector.<Point> = new Vector.<Point>();
		private static function floydCrossAble(n1:Node, n2:Node):Boolean
		{
			var dx:Number;
			var dy:Number;
			var steps:Number;
			var xIncr:Number;
			var yIncr:Number;
			
			dx = n2.x - n1.x;
			dy = n2.y - n1.y;
			var isDx:Boolean;
			if (Math.abs(dx) > Math.abs(dy))
			{
				isDx = true;
				steps = Math.abs(dx);
			}
			else 
			{
				isDx = false;
				steps = Math.abs(dy);
			}
			
			xIncr = dx / steps;
			yIncr = dy / steps;
			
			var tarX:int;
			var tarY:int;
			var i:int;
			var tmpPos:Point;
			var tmpLen:int = _tmpPosVec.length;
			for (i = 0; i < steps; i++)
			{
				tarX = n1.x + i * xIncr;
				tarY = n1.y + i * yIncr;
				
				if (i >= tmpLen)
				{
					_tmpPosVec.push(new Point(tarX, tarY));
				}
				else
				{
					_tmpPosVec[i].setTo(tarX, tarY);
				}
			}
			
			for (i = steps - 1; i > 0; i--)
			{
				tmpPos = _tmpPosVec[i];
				if (tmpPos.x >= 0 && tmpPos.y >= 0)
				{
					if(tmpPos.x < HMap3D.getInstance().mapData._GridRows && tmpPos.y < HMap3D.getInstance().mapData._GridCols)
					{
						if(!HMap3D.getInstance().mapData.getNode(tmpPos.x, tmpPos.y).walkable) 
						{
							return false;
						}
					}
				}
			}
			return true;
		}
		
		/**
		 * 同轴处理 
		 * @param target
		 * @param n1
		 * @param n2
		 * 
		 */		
		private static function floydVector(target:Node, n1:Node, n2:Node):void
		{
			target.x = n1.x - n2.x;
			target.y = n1.y - n2.y;
		}
	}
}