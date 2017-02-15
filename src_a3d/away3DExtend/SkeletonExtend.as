package away3DExtend
{
	/**
	 * 扩展Skeleton类
	 * @author 李舒浩
	 */	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3d.arcane;
	import away3d.animators.data.Skeleton;
	import away3d.animators.data.SkeletonJoint;
	
	use namespace arcane;
	
	public class SkeletonExtend extends Skeleton
	{
		public function SkeletonExtend()
		{
			super();
		}
		
		/**
		 * 通过骨骼名获取指定骨骼的vector3D坐标
		 * @param jointName
		 * @return 
		 */		
		public function jointVector3DFromName(jointName:String):Vector3D
		{
			var matrix3D:Matrix3D = jointMatrix3DFromName(jointName);
			return (matrix3D == null ? null : matrix3D.position);
		}
		/**
		 * 通过骨骼名获取指定骨骼的Matrix3D
		 * @param jointName
		 * @return 
		 */	
		private function jointMatrix3DFromName(jointName:String):Matrix3D
		{
			var skeletonJoint:SkeletonJoint = jointFromName(jointName);
			if(!skeletonJoint) 
			{
				return null;
			}
			
			tmpMatrix.identity();
			tmpMatrix.rawData = skeletonJoint.inverseBindPose;
			tmpMatrix.invert();
			return tmpMatrix;
		}
		
		private static var tmpMatrix:Matrix3D = new Matrix3D();
	}
}