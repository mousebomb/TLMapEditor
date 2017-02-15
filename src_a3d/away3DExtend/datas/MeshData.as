package away3DExtend.datas
{
	import flash.utils.Dictionary;

	public class MeshData extends MeshDataBase
	{
		public var vertexData:Vector.<VertexData>;
		public var weightData:Vector.<JointData>;
		public var indices:Vector.<uint>;
		public var noteData:Dictionary;	//注释的数据
		
		public function MeshData()
		{
			
		}
	}
}