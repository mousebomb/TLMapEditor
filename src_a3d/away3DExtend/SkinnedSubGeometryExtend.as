package away3DExtend
{
	/**
	 * 自定义SkinnedSubGeometry类
	 * @author 李舒浩
	 */	
	import away3d.arcane;
	import away3d.core.base.ISubGeometry;
	import away3d.core.base.SkinnedSubGeometry;
	
	use namespace arcane;
	
	public class SkinnedSubGeometryExtend extends SkinnedSubGeometry
	{
		public function SkinnedSubGeometryExtend(jointsPerVertex:int)
		{
			super(jointsPerVertex);
		}
		
		/**
		 * 更新UV数据
		 */
		public function updateUVData(uvs:Vector.<Number>):void
		{
			if (_autoDeriveVertexTangents)
				_vertexTangentsDirty = true;
			_faceTangentsDirty = true;
			_vertexData = uvs;
			invalidateBuffers(_jointIndicesInvalid);
		}
		
		/**
		 * Clones the current object.
		 * @return An exact duplicate of the current object.
		 */
		override public function clone():ISubGeometry
		{
			var clone:SkinnedSubGeometryExtend = new SkinnedSubGeometryExtend(_jointsPerVertex);
			clone.updateData(_vertexData.concat());
			clone.updateIndexData(_indices.concat());
			clone.updateJointIndexData(_jointIndexData.concat());
			clone.updateJointWeightsData(_jointWeightsData.concat());
			clone._autoDeriveVertexNormals = _autoDeriveVertexNormals;
			clone._autoDeriveVertexTangents = _autoDeriveVertexTangents;
			clone._numCondensedJoints = _numCondensedJoints;
			clone._condensedIndexLookUp = _condensedIndexLookUp;
			clone._condensedJointIndexData = _condensedJointIndexData;
			return clone;
		}
	}
}