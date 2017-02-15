package tool.Pools
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3DExtend.datas.BaseFrameData;
	import away3DExtend.datas.BoundsData;
	import away3DExtend.datas.FrameData;
	import away3DExtend.datas.HierarchyData;
	import away3DExtend.datas.JointData;
	import away3DExtend.datas.MeshData;
	import away3DExtend.datas.VertexData;
	
	import away3d.core.math.Quaternion;
	
	
	public class Away3dObjectPools
	{
		private static var _baseFrameDatas:AwayPool;
		private static var _boundsDatas:AwayPool;
		private static var _frameDatas:AwayPool;
		private static var _hierarchyDatas:AwayPool;
		private static var _jointDatas:AwayPool;
		private static var _meshDatas:AwayPool;
		private static var _vertexDatas:AwayPool;

		private static var _quaternions:AwayPool;
		private static var _vectors:Vector3DPool;
		
		private static var _matrix3ds:Matrix3DPool;
		
		setup();
		
		public static function setup():void
		{
			_baseFrameDatas = new AwayPool(10000);
			_boundsDatas = new AwayPool(10000);
			_frameDatas = new AwayPool(10000);
			_hierarchyDatas = new AwayPool(10000);
			
			_jointDatas = new AwayPool(100000);
			_meshDatas = new AwayPool(100);
			_vertexDatas = new AwayPool(100000);
			
			_quaternions = new AwayPool(1000);
			_vectors = new Vector3DPool(1000);
			
			_matrix3ds = new Matrix3DPool(1000);
		}
		
		//--------------------------------------------------------------------------------------------------------------------------------
		public static function getBaseFrame():BaseFrameData
		{
			return _baseFrameDatas.getObject(BaseFrameData) as BaseFrameData;
		}
		
		public static function recycleBaseFrame(baseFrameData:BaseFrameData):void
		{
			_baseFrameDatas.recycle(baseFrameData);
		}
		//--------------------------------------------------------------------------------------------------------------------------------
		public static function getBounds():BoundsData
		{
			return _boundsDatas.getObject(BoundsData) as BoundsData;
		}
		
		public static function recycleBounds(boundsData:BoundsData):void
		{
			_boundsDatas.recycle(boundsData);
		}
		//--------------------------------------------------------------------------------------------------------------------------------
		public static function getFrame():FrameData
		{
			return _frameDatas.getObject(FrameData) as FrameData;
		}
		
		public static function recycleFrame(frameData:FrameData):void
		{
			_frameDatas.recycle(frameData);
		}
		//--------------------------------------------------------------------------------------------------------------------------------
		public static function getHierarchy():HierarchyData
		{
			return _hierarchyDatas.getObject(HierarchyData) as HierarchyData;
		}
		
		public static function recycleHierarchy(hierarchyData:HierarchyData):void
		{
			_hierarchyDatas.recycle(hierarchyData);
		}
		//--------------------------------------------------------------------------------------------------------------------------------
		public static function getJoint():JointData
		{
			return _jointDatas.getObject(JointData) as JointData;
		}
		
		public static function recycleJoint(jointData:JointData):void
		{
			_jointDatas.recycle(jointData);
		}
		//--------------------------------------------------------------------------------------------------------------------------------
		public static function getMesh():MeshData
		{
			return _meshDatas.getObject(MeshData) as MeshData;
		}
		
		public static function recycleMesh(meshData:MeshData):void
		{
			_meshDatas.recycle(meshData);
		}
		//--------------------------------------------------------------------------------------------------------------------------------
		public static function getVertex():VertexData
		{
			return _vertexDatas.getObject(VertexData) as VertexData;
		}
		
		public static function recycleVertex(vertexData:VertexData):void
		{
			_vertexDatas.recycle(vertexData);
		}
		//--------------------------------------------------------------------------------------------------------------------------------
		public static function getQuaternion():Quaternion
		{
			return _quaternions.getObject(Quaternion) as Quaternion;
		}
		
		public static function recycleQuaternion(vertexData:Quaternion):void
		{
			_quaternions.recycle(vertexData);
		}
		//--------------------------------------------------------------------------------------------------------------------------------
		public static function getVector3d():Vector3D
		{
			return _vectors.getVector3D();
		}
		
		public static function recycleVector3d(v3d:Vector3D):void
		{
			_vectors.recycle(v3d);
		}
		//--------------------------------------------------------------------------------------------------------------------------------
		public static function getMatrix3d():Matrix3D
		{
			return _matrix3ds.getMatrix3D();
		}
		
		public static function recycleMatrix3D(matrix3D:Matrix3D):void
		{
			_matrix3ds.recycle(matrix3D);
		}
	}
}