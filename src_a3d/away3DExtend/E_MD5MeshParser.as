package away3DExtend
{
	/**
	 * 二进制md5mesh解析类
	 * @author 李舒浩
	 */	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	import flash.utils.Dictionary;
	
	import away3DExtend.datas.JointData;
	import away3DExtend.datas.MeshData;
	import away3DExtend.datas.VertexData;
	
	import away3d.arcane;
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.data.SkeletonJoint;
	import away3d.core.base.Geometry;
	import away3d.core.base.SkinnedSubGeometry;
	import away3d.core.math.Quaternion;
	import away3d.loaders.parsers.MD5BytesProcess;
	import away3d.loaders.parsers.ParserBase;
	import away3d.loaders.parsers.ParserDataFormat;

	import flash.utils.getTimer;

	import tool.Pools.Away3dObjectPools;
	import tool.StageFrame;

	use namespace arcane;
	
	public class E_MD5MeshParser extends ParserBase
	{
		private var _jointsIndex:int = 0;
		/**是否开始解析*/
		private var _startedParsing:Boolean;
		/**解析数据*/
		private var _textData:ByteArray;

		/**版本号*/
		private var _version:int;
		/**骨骼数*/
		private var _numJoints:int;
		/**子网格数*/
		private var _numMeshes:int;
		/**	关节数据 */
		private var _bindPoses:Vector.<Matrix3D> = new Vector.<Matrix3D>();
		/**	骨骼 */
		private var _skeleton:SkeletonExtend;
		/**	网格数据保存 */
		private var _meshData:Vector.<MeshData>;
		/**	着色球数据保存 */
		private var _shaders:Vector.<String>;
		
		private var _maxJointCount:int;
		private var _animationSet:SkeletonAnimationSet;
		private var _mesh:MeshExtend;
		private var _geometry:Geometry;
		
		/**是否解压文件*/
		private var _isCompress:Boolean = true;
		/**解压类型*/
		private var _compressType:String = CompressionAlgorithm.LZMA;
		
		public function E_MD5MeshParser(additionalRotationAxis:Vector3D = null, additionalRotationRadians:Number = 0)
		{
			super(ParserDataFormat.BINARY);
		}
		
		/**
		 * Indicates whether or not a given file extension is supported by the parser.
		 * 表示给定的文件扩展名是否被支持的解析器。 
		 * @param extension 	The file extension of a potential file to be parsed.
		 * 						要分析潜在的文件的文件扩展名。 
		 * @return 				Whether or not the given file type is supported.
		 * 						是否给定的文件类型支持
		 */
		public static function supportsType(extension:String):Boolean
		{
			extension = extension.toLowerCase();
			return extension == "e_md5mesh";
		}
		
		/**
		 * Tests whether a data block can be parsed by the parser.
		 * 表示给定的文件扩展名是否被支持的解析器。 
		 * 
		 * @param data 	The data block to potentially be parsed.
		 * 				要分析潜在的文件的文件扩展名。 
		 * @return 		Whether or not the given data is supported.
		 * 				是否给定的文件类型支持
		 */
		public static function supportsData(data:*):Boolean
		{
			data = data;
			return false;
		}

		/**
		 * 进行解析
		 * @inheritDoc
		 */
		protected override function proceedParsing():Boolean
		{
			if (!_startedParsing)
			{
				//获取解析数据
				_textData = getByteData();
				var tmpsize:uint = _textData.length;
				//执行解压
				if(_isCompress)
				{
					try
					{
						_textData.uncompress(_compressType);
					}
					catch (err:Error)
					{
						finalizeAsset(new Geometry());
						//					finalizeAsset(_mesh);
//						finalizeAsset(_skeleton);
//						finalizeAsset(_animationSet);
						return ParserBase.PARSING_DONE;
//						throw new Error("模型解压缩错误" + "-->" + fileName + "size:" + tmpsize);
					}
				}
				_startedParsing = true;
			}
			//判断是否还有事件进行解析
			while (hasTime() && _textData.bytesAvailable !=0) 
			{
				// 时间片读取一段数据
				parseNextBlock();
				// 最终拼装
				if(_textData.bytesAvailable == 0)
				{
					calculateMaxJointCount();
					_animationSet = new SkeletonAnimationSet(_maxJointCount);
//					_mesh = new MeshExtend(new Geometry(), null);
					_geometry = new Geometry();//_mesh.geometry;
					var meshDataLen:int = _meshData.length;
					for (var z:int = 0; z < meshDataLen; ++z)
					{
						_geometry.addSubGeometry(translateGeom(_meshData[z].vertexData, _meshData[z].weightData, _meshData[z].indices, _meshData[z].noteData));
					}
					
					//_geometry.animation = _animation;
					//					_mesh.animationController = _animationController;
					
					finalizeAsset(_geometry);
//					finalizeAsset(_mesh);
					finalizeAsset(_skeleton);
					finalizeAsset(_animationSet);
					return ParserBase.PARSING_DONE;
				}
			}
			return ParserBase.MORE_TO_PARSE;
		}

		/** 时间片 解析 */
		private function parseNextBlock():void
		{
			if(parseTmpType == -1)
			{
			// 状态为干净的，则继续下一块
				//截取数据类型
				parseTmpType = _textData.readByte();
				switch(parseTmpType)
				{
						// 一次读完的
					case MD5BytesProcess.VERSION:		//MD5Version(版本号)
						_version =  _textData.readInt();//int(MD5BytesProcess.readData(_textData, type));
						if (_version != 10)
						{
							throw new Error("遇到未知的版本号!" + "-->" + fileName);
						}
						parseTmpType=-1;
						break;
						//					case MD5BytesProcess.COMMANDLINE:	//commandline(命令行)
						//						break;
					case MD5BytesProcess.NUM_JOINTS:	//numJoints(关节数)
						_numJoints = _textData.readInt();//int(MD5BytesProcess.readData(_textData, type));
						//						_bindPoses = new Vector.<Matrix3D>(_numJoints, true);
						parseTmpType=-1;
						break;
					case MD5BytesProcess.NUM_MESHES:	//numMeshes(子网格数)
						_numMeshes =  _textData.readInt();//int(MD5BytesProcess.readData(_textData, type));
						parseTmpType=-1;
						break;
					case MD5BytesProcess.JOINTS:		//joints数据
						parseJoints0();
						// 剩余量比对 看要不要分片
						if( parseLoopI+PARSE_POSE_MAX < parseLoopLen)
						{
							// 这里分时间片
							parseJoints1(parseLoopI+PARSE_POSE_MAX);
						}else{
							// 数量小，不分片
							parseJoints1(parseLoopLen);
							parseLoopI=0;
							parseJoints2();
						}
						break;
					case MD5BytesProcess.MESH:			//mesh数据
						parseMesh0();
						// 1. vertex
						// 剩余量比对
						if(parseLoopI+PARSE_VERTEX_MAX<parseLoopLen)
						{
							//这里分时间片
							parseMesh1Vertex(parseLoopI+PARSE_VERTEX_MAX);
							// 标记需要继续读取vertex
							parseMeshState = 1;
							break;
						}else{
							parseMesh1Vertex(parseLoopLen);
							parseMeshState = -1;
							parseLoopI=0;
						}

						//2. indices
						tmpIndices = new Vector.<uint>();
						parseLoopLen = _textData.readInt();
						if(parseLoopI+PARSE_INDICES_MAX<parseLoopLen)
						{
							//这里分时间片
							parseMesh2Indices(parseLoopI+PARSE_INDICES_MAX);
							// 标记需要继续读取indice
							parseMeshState = 2;
							break;
						}else{
							parseMesh2Indices(parseLoopLen);
							parseMeshState = -1;
							parseLoopI=0;
						}

						//3. joints
						tmpWeights = new Vector.<JointData>();
						parseLoopLen = _textData.readInt();
						if(parseLoopI+PARSE_JOINTS_MAX<parseLoopLen)
						{
							//这里分时间片
							parseMesh3Joints(parseLoopI+PARSE_JOINTS_MAX);
							// 标记需要继续读取joints
							parseMeshState = 3;
							break;
						}else{
							parseMesh3Joints(parseLoopLen);
							parseMeshState = -1;
							parseLoopI=0;
						}
						// finish
						parseMesh99();
						break;
				}
			}else{
				// 从状态恢复进度
				switch (parseTmpType)
				{
					case MD5BytesProcess.JOINTS:
						// 剩余量比对 看要不要分片
						if( parseLoopI+PARSE_POSE_MAX < parseLoopLen)
						{
							// 这里分时间片
							parseJoints1(parseLoopI+PARSE_POSE_MAX);
						}else{
							// 数量小，不分片
							parseJoints1(parseLoopLen);
							parseLoopI=0;
							parseJoints2();
						}
						break;
					case MD5BytesProcess.MESH:
						if(parseMeshState==1){
							// 1. vertex
							// 剩余量比对
							if(parseLoopI+PARSE_VERTEX_MAX<parseLoopLen)
							{
								//这里分时间片
								parseMesh1Vertex(parseLoopI+PARSE_VERTEX_MAX);
								// 标记需要继续读取vertex
								parseMeshState = 1;
								break;
							}else{
								parseMesh1Vertex(parseLoopLen);
								//begin2
								parseMeshState = 2;
								parseLoopI=0;
								tmpIndices = new Vector.<uint>();
								parseLoopLen = _textData.readInt();
							}
						}
						if(parseMeshState==2)
						{
							//2. indices
							if (parseLoopI + PARSE_INDICES_MAX < parseLoopLen)
							{
								//这里分时间片
								parseMesh2Indices(parseLoopI + PARSE_INDICES_MAX);
								// 标记需要继续读取indice
								parseMeshState = 2;
								break;
							} else
							{
								parseMesh2Indices(parseLoopLen);
								//begin3
								parseMeshState = 3;
								parseLoopI = 0;
								tmpWeights = new Vector.<JointData>();
								parseLoopLen = _textData.readInt();
							}
						}

						if(parseMeshState==3)
						{
							//3. joints
							if (parseLoopI + PARSE_JOINTS_MAX < parseLoopLen)
							{
								//这里分时间片
								parseMesh3Joints(parseLoopI + PARSE_JOINTS_MAX);
								// 标记需要继续读取joints
								parseMeshState = 3;
								break;
							} else
							{
								parseMesh3Joints(parseLoopLen);
								parseMeshState = -1;
								parseLoopI = 0;
							}
							// finish
							parseMesh99();
						}
						break;
				}
			}


		}
		/*------ 时间片 解析 通用相关 */
		private var parseLoopI:int;
		private var parseLoopLen:int;
		private static var parseTmpVec3D:Vector3D;
		/** 当前读取二进制区块类型  读取数据用(-1表示区块读完的) */
		private var parseTmpType : int = -1;


		///// JOINTS 相关

		// 当前时间片读到的joint
		private var parseTmpJoint:SkeletonJoint;
		public static const PARSE_POSE_MAX :int = 1000;
		/** 开始读取joints 头 */
		private function parseJoints0():void
		{
			_skeleton ||= new SkeletonExtend();
			//joint  读取要存入的joint
			parseTmpJoint = new SkeletonJoint();
			parseTmpJoint.name = _textData.readUTF();		//关节名
			parseTmpJoint.parentIndex = _textData.readInt();	//关节父级ID
			parseLoopLen = _textData.readInt();				//inverseBindPose长度
			parseTmpJoint.inverseBindPose = new Vector.<Number>(parseLoopLen, true);
			parseLoopI=0;
		}
		/** 最多读到max */
		private function parseJoints1(max:int):void
		{
			for(; parseLoopI < max; parseLoopI++)
			{
				parseTmpJoint.inverseBindPose[parseLoopI] = _textData.readDouble();
			}
		}

		private function parseJoints2():void
		{
			// 读完重置0
			parseLoopI=0;

			parseTmpVec3D = Away3dObjectPools.getVector3d();
			parseTmpVec3D.setTo(_textData.readDouble(), _textData.readDouble(), _textData.readDouble());
			//_bindPoses
			var quat:Quaternion = Away3dObjectPools.getQuaternion();//new Quaternion(data.quat.x, data.quat.y, data.quat.z, data.quat.w);
			quat.x = _textData.readDouble();
			quat.y = _textData.readDouble();
			quat.z = _textData.readDouble();
			quat.w = _textData.readDouble();
			_bindPoses[_jointsIndex] = quat.toMatrix3D(Away3dObjectPools.getMatrix3d());
			_bindPoses[_jointsIndex].appendTranslation(parseTmpVec3D.x, parseTmpVec3D.y, parseTmpVec3D.z);
			Away3dObjectPools.recycleVector3d(parseTmpVec3D);
			Away3dObjectPools.recycleQuaternion(quat);

			_skeleton.joints[_jointsIndex++] = parseTmpJoint;
			// 类型标记读完 解除时间片判定锁定
			parseTmpType = -1;
		}

		///// JOINTS 结束

		///// MESH 开始

		private var tmpVertexData:Vector.<VertexData>;
		private var tmpWeights:Vector.<JointData>;
		private var tmpIndices:Vector.<uint>;
		private var tmpNoteData:Dictionary;

		public static const PARSE_VERTEX_MAX :int = 300;
		public static const PARSE_INDICES_MAX :int = 1000;
		public static const PARSE_JOINTS_MAX :int = 300;

		/** 当前读取mesh的哪部分  -1 表示不处在读取中   1:vertex 2:indices 3:joint */
		private var parseMeshState:int = -1;

		/** 开始步骤 */
		private function parseMesh0():void
		{
			_meshData ||= new Vector.<MeshData>();
			_shaders ||= new Vector.<String>();

			tmpNoteData = new Dictionary();
			tmpNoteData["meshes"] = _textData.readUTF();	//子网格名
			_shaders.push( _textData.readUTF() );			//着色球名

			parseLoopLen = _textData.readInt();		//顶点数量
			tmpVertexData = new Vector.<VertexData>(parseLoopLen, true);
			parseLoopI = 0;
		}

		/** 1.读取vertex数据 */
		private function parseMesh1Vertex( max : int ):void
		{
			for(;parseLoopI<max ;++parseLoopI)
			{
				var vertex:VertexData = Away3dObjectPools.getVertex();//new VertexData();
				vertex.index = _textData.readInt();
				vertex.s = _textData.readDouble();
				vertex.t = _textData.readDouble();
				vertex.startWeight = _textData.readInt();
				vertex.countWeight = _textData.readInt();
				tmpVertexData[vertex.index] = vertex;
			}
		}

		/** 2.读取vertex索引 */
		private function parseMesh2Indices( max: int ):void
		{
			for(;parseLoopI<max ;++parseLoopI)
				tmpIndices.push(_textData.readInt());
		}

		/**3.读取joints*/
		private function parseMesh3Joints(max:int):void
		{
			for(;parseLoopI<max ;++parseLoopI)
			{
				var weight:JointData = Away3dObjectPools.getJoint();//new JointData();
				weight.index = _textData.readInt();
				weight.joint = _textData.readInt();
				weight.bias = _textData.readDouble();
				weight.pos.setTo(_textData.readDouble(), _textData.readDouble(), _textData.readDouble());
				tmpWeights[weight.index] = weight;
			}
		}

		/**最后步骤*/
		private function parseMesh99():void
		{
			// 读完重置0
			parseLoopI=0;
			//tri (三角面)
			tmpNoteData["bones"] = _textData.readInt();
			//保存给网格
			var mLen:uint = _meshData.length;
			_meshData[mLen] = Away3dObjectPools.getMesh();//new MeshData();
			_meshData[mLen].vertexData = tmpVertexData;
			_meshData[mLen].weightData = tmpWeights;
			_meshData[mLen].indices = tmpIndices;		//tri (三角面)
			_meshData[mLen].noteData = tmpNoteData;	//保存注释解析数据对象
			// 类型标记读完 解除时间片判定锁定
			parseTmpType=-1;
			parseMeshState = -1;
		}



		///// MESH 结束




		
		/** 计算最大关节计数 **/
		private function calculateMaxJointCount():void
		{
			_maxJointCount = 4;
			return;
			
			var numMeshData:int = _meshData.length;
			for (var i:int = 0; i < numMeshData; ++i)
			{
				var meshData:MeshData = _meshData[i];
				var vertexData:Vector.<VertexData> = meshData.vertexData;
				var numVerts:int = vertexData.length;
				
				for (var j:int = 0; j < numVerts; ++j)
				{
					var zeroWeights:int = countZeroWeightJoints(vertexData[j], meshData.weightData);
					var totalJoints:int = vertexData[j].countWeight - zeroWeights;
					if (totalJoints > _maxJointCount)
					{
						_maxJointCount = totalJoints;
					}
				}
			}
		}
		
		private function countZeroWeightJoints(vertex:VertexData, weights:Vector.<JointData>):int
		{
			var start:int = vertex.startWeight;
			var end:int = vertex.startWeight + vertex.countWeight;
			var count:int = 0;
			var weight:Number;
			
			for (var i:int = start; i < end; ++i)
			{
				weight = weights[i].bias;
				if (weight == 0)
				{
					++count;
				}
			}
			
			return count;
		}
		/**
		 * Converts the mesh data to a SkinnedSub instance.
		 * 网格的数据转换为SkinnedSub实例。
		 * 
		 * @param vertexData 	The mesh's vertices.
		 * 						网格的顶点
		 * @param weights 		The joint weights per vertex.
		 * 						每个顶点的权重
		 * @param indices 		The indices for the faces.
		 * 						面数
		 * @param noteData		注释的数据(// meshes: smesh_7_002 //bones 1)
		 * 
		 * @return 				A SkinnedSubGeometry instance containing all geometrical data for the current mesh.
		 * 						包含所有的几何数据为目前目SkinnedSubGeometry实例
		 */
		private function translateGeom(vertexData:Vector.<VertexData>, weights:Vector.<JointData>, indices:Vector.<uint>, noteData:Dictionary):SkinnedSubGeometry
		{
			var len:int = vertexData.length;
			var v1:int, v2:int, v3:int;
			var vertex:VertexData;
			var weight:JointData;
			var bindPose:Matrix3D;
			var pos:Vector3D;
			var subGeom:SkinnedSubGeometryExtend = new SkinnedSubGeometryExtend(_maxJointCount);
			var uvs:Vector.<Number> = new Vector.<Number>(len * 2, true);
			var vertices:Vector.<Number> = new Vector.<Number>(len * 3, true);
			var jointIndices:Vector.<Number> = new Vector.<Number>(len * _maxJointCount, true);
			var jointWeights:Vector.<Number> = new Vector.<Number>(len * _maxJointCount, true);
			var l:int;
			var nonZeroWeights:int;
			
			var countWeight:int;
			for (var i:int = 0; i < len; ++i) 
			{
				vertex = vertexData[i];
				v1 = vertex.index*3;
				v2 = v1 + 1;
				v3 = v1 + 2;
				vertices[v1] = vertices[v2] = vertices[v3] = 0;
				
				nonZeroWeights = 0;
				countWeight = vertex.countWeight;
				for (var j:int = 0; j < countWeight; ++j)
				{
					weight = weights[vertex.startWeight + j];
					if (weight.bias > 0) 
					{
						bindPose = _bindPoses[weight.joint];
						pos = bindPose.transformVector(weight.pos);
						vertices[v1] += pos.x * weight.bias;
						vertices[v2] += pos.y * weight.bias;
						vertices[v3] += pos.z * weight.bias;
						
						// indices need to be multiplied by 3 (amount of matrix registers)
						jointIndices[l] = weight.joint * 3;
						jointWeights[l++] = weight.bias;
						++nonZeroWeights;
					}
				}
				
				for (j = nonZeroWeights; j < _maxJointCount; ++j)
				{
					jointIndices[l] = 0;
					jointWeights[l++] = 0;
				}
				
				v1 = vertex.index << 1;
				uvs[v1++] = vertex.s;
				uvs[v1] = vertex.t;
			}
			
			var vertexLen:uint = vertexData.length;
			for (i = 0; i < vertexLen; ++i)
			{
				Away3dObjectPools.recycleVertex(vertexData[i]);
			}
			
			var weightLen:uint = weights.length;
			for (i = 0; i < weightLen; ++i)
			{
				Away3dObjectPools.recycleJoint(weights[i]);
			}
			
			subGeom.updateIndexData(indices);
			subGeom.fromVectors(vertices, uvs, null, null);
			// cause explicit updates
			//引起明确的更新
//			subGeom.vertexNormalData;
//			subGeom.vertexTangentData;
			// turn auto updates off because they may be animated and set explicitly
//			关闭自动更新关闭，因为它们可以是动画和显式设置
			subGeom.autoDeriveVertexTangents = false;
			subGeom.autoDeriveVertexNormals = false;
			
			subGeom.updateJointIndexData(jointIndices);
			subGeom.updateJointWeightsData(jointWeights);
			//注释的数据(// meshes: smesh_7_001 //bones 1...)
			subGeom.noteData = noteData;
			return subGeom;
		}
	}
}