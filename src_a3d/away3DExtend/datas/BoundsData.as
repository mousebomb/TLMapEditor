package away3DExtend.datas
{
	import flash.geom.Vector3D;
	
	import tool.Pools.Away3dObjectPools;

	public class BoundsData extends MeshDataBase
	{
		public var min:Vector3D;
		public var max:Vector3D;
		
		public function BoundsData()
		{
			min = Away3dObjectPools.getVector3d();
			max = Away3dObjectPools.getVector3d();
		}
		/*
		override public function clearPoolObject():void
		{
			min.x = min.y = min.z = 0;
			max.x = max.y = max.z = 0;
			
			super.clearPoolObject();
		}
		*/
		override public function dispose():void
		{
			Away3dObjectPools.recycleVector3d(min);
			Away3dObjectPools.recycleVector3d(max);
			
			super.dispose();
		}
	}
}