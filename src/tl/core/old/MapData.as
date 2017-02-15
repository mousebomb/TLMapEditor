package tl.core.old
{
	import flash.geom.Point;
	
	import Lib.Tool.Config;

	/**
	 * 地图数据
	 * @author 李舒浩
	 */	
	public class MapData
	{
		public var myWidth:int;		//地图宽度
		public var myHeight:int;		//地图高度
		public var mapRows:int;		//地图(512*512)列数
		public var mapCols:int;		//地图(512*512)行度
		public var smallWidth:int;		//地图宽度
		public var smallHeight:int;	//地图长度
		public var mapResPathName:String;	//地图资源名
		public var mapResName:String;		//地图资源名
		public var startPoint:Point;		//起始坐标点
		public var jumpPoint:String;		//跳跃点
		public var pointMatrix:String;		//地图表信息
		public var pointH:String;			//地图高度信息
		public var wizard:String;			//地图精灵摆放信息
		
		public var colsNum:int;			//格子行数→
		public var rowsNum:int;			//格子列数↓
		
		public function MapData() {  }
		
		public function refreshXML(xml:XML):void
		{
			myWidth = xml.width;
			myHeight = xml.height;
			mapRows = xml.maprows;
			mapCols = xml.mapcols;
			smallWidth = xml.smallwidth;
			smallHeight = xml.smallheight;
			mapResPathName = xml.maprespath;
			mapResName = xml.mapresname;
			var arr:Array = xml.startpoint.split(",");
			startPoint = new Point(arr[0], arr[1]);
			jumpPoint = xml.jumppoint;
			pointMatrix = xml.point;
			pointH = xml.pointh;
			wizard = xml.wizard;
			//计算格子行列数
			var cols:int = int((myHeight / Config.GRID_HEIGHT)+0.5);	//行数
			var rows:int = int((myWidth / Config.GRID_WIDTH)+0.5);		//列数
			colsNum = cols;
			rowsNum = rows;
		}
		
		
		
	}
}