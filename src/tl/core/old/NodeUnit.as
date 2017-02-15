package tl.core.old
{
	import flash.geom.Point;
	import flash.geom.Vector3D;

	
	public class NodeUnit
	{
		public static const angle:int=30;
		
		public static function threeToTwo(vector3D:Vector3D):Point{
			//			return new Point(vector3D.x,-vector3D.z/Math.cos(30*Math.PI/180));
			return new Point(vector3D.x,-vector3D.z);
		}
		public static function twoToThree(point:Point):Vector3D{
			var _Vector3D:Vector3D=new Vector3D();		
			//			_Vector3D.x=point.x;
			//			_Vector3D.z=-point.y*Math.cos(30*Math.PI/180);
			//			_Vector3D.y=_Vector3D.z*Math.tan(30*Math.PI/180)+5;
			
			_Vector3D.x=point.x;
			_Vector3D.z=-point.y;
			_Vector3D.y=0;
			return _Vector3D;
		}	
		public static function twoToThreeForUI(point:Point,dx:Number,dy:Number,dz:Number):Vector3D{
			var _Vector3D:Vector3D=new Vector3D();		
			_Vector3D.x=dx;
			_Vector3D.y=-dy/dz*100;
			_Vector3D.z=-100;
			return _Vector3D;
		}	
	}
}