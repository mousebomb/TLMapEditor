package HLib.Tool
{
	/**
	 * 坐标转换
	 * @author 李舒浩
	 */	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import away3d.containers.View3D;

	public class ConversionPosition
	{
		public function ConversionPosition()  {  }
		
		/** away3d坐标 转 屏幕2D坐标: **/
		public static function get2DPoint(view:View3D, vec:Vector3D):Point
		{
			var markPosition:Vector3D = view .project(vec);
			var screenPosition:Point = new Point(markPosition.x, markPosition.y);
			return screenPosition;
		}
		/** 2D坐标转3D坐标 **/
		public static function getScreenTo3DPosition(view:View3D, point:Point, screenZ:int = 2500):Vector3D
		{
			var vec:Vector3D = view.unproject(point.x, point.y, screenZ);
			return vec;
		}
	}
}