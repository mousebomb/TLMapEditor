package away3DExtend.datas
{
	import flash.geom.Vector3D;
	
	import tool.Pools.Away3dObjectPools;

	public class JointData extends MeshDataBase
	{
		public var index:int;
		public var joint:int;
		public var bias:Number;
		public var pos:Vector3D;
		
		public function JointData()
		{
			pos = Away3dObjectPools.getVector3d();
		}
		
		override public function dispose():void
		{
			Away3dObjectPools.recycleVector3d(pos);
			
			super.dispose();
		}
	}
}