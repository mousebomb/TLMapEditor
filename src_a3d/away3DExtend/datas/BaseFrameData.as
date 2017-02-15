
package away3DExtend.datas
{
	import flash.geom.Vector3D;
	
	import away3d.core.math.Quaternion;
	
	import tool.Pools.Away3dObjectPools;

	public class BaseFrameData extends MeshDataBase
	{
		public var position:Vector3D;
		public var orientation:Quaternion;
		
		public function BaseFrameData()
		{
			position = Away3dObjectPools.getVector3d();
			orientation = Away3dObjectPools.getQuaternion();
		}
		/*
		override public function clearPoolObject():void
		{
//			position.x = position.y = position.z = 0;
			
			super.clearPoolObject();
		}*/
		
		override public function dispose():void
		{
			Away3dObjectPools.recycleVector3d(position);
			Away3dObjectPools.recycleQuaternion(orientation);
			
			super.dispose();
		}
	}
}