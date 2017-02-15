package  HLib.MapBase
{
	/**
	 * 同轴数据保存 
	 * @author Administrator
	 * 郑利本
	 */	
	public class Link
	{
		public var node:Node;
		public var cost:Number;
		
		public function Link()
		{
		}
		
		public function init(node:Node, cost:Number):void
		{
			this.node = node;
			this.cost = cost;
		}
		
		public function reset():void
		{
			node = null;
			cost = 0;
		}
	}
}