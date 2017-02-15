package away3DExtend
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	
	import away3DExtend.datas.BaseFrameData;
	import away3DExtend.datas.BoundsData;
	import away3DExtend.datas.FrameData;
	import away3DExtend.datas.HierarchyData;
	
	import away3d.animators.data.JointPose;
	import away3d.animators.data.SkeletonPose;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.core.math.Quaternion;
	import away3d.loaders.parsers.MD5BytesProcess;
	import away3d.loaders.parsers.ParserBase;
	import away3d.loaders.parsers.ParserDataFormat;

	import flash.utils.getTimer;

	import tool.Pools.Away3dObjectPools;
	import tool.StageFrame;

	public class E_MD5AnimParser extends ParserBase
	{
		private var _rotationQuat:Quaternion;
		private var _startedParsing:Boolean;		//是否开始解析
		private var _textData:ByteArray;			//解析数据
		private var _version:int;					//版本号
		
		private var _numFrames:int;				//帧数
		private var _numJoints:int;				//关节数
		private var _frameRate:int;				//帧速率
		private var _numAnimatedComponents:int;	//动画元件数量<每一帧动作数据数量>
		
		private var _bounds:Vector.<BoundsData>;
		private var _frameData:Vector.<FrameData>;
		private var _hierarchy:Vector.<HierarchyData>;
		private var _baseFrameData:Vector.<BaseFrameData>;
		private var _clip:SkeletonClipNode;
		private var _hierarchyIndex:int = 0;
		private var _boundsIndex:int = 0;
		private var _baseFrameIndex:int = 0;
		
		private var _isCompress:Boolean = true;						//是否解压文件
		private var _compressType:String = CompressionAlgorithm.LZMA;	//解压类型
		
		public function E_MD5AnimParser(additionalRotationAxis:Vector3D = null, additionalRotationRadians:Number = 0)
		{
			super(ParserDataFormat.BINARY);
			
			_rotationQuat = Away3dObjectPools.getQuaternion();//new Quaternion();
			var t1:Quaternion = Away3dObjectPools.getQuaternion();//new Quaternion();
			var t2:Quaternion = Away3dObjectPools.getQuaternion();//new Quaternion();
			
			t1.fromAxisAngle(Vector3D.X_AXIS, -Math.PI*.5);
			t2.fromAxisAngle(Vector3D.Y_AXIS, -Math.PI*.5);
			
			_rotationQuat.multiply(t2, t1);
			
			if (additionalRotationAxis) 
			{
				_rotationQuat.multiply(t2, t1);
				t1.fromAxisAngle(additionalRotationAxis, additionalRotationRadians);
				_rotationQuat.multiply(t1, _rotationQuat);
			}
			Away3dObjectPools.recycleQuaternion(t1);
			Away3dObjectPools.recycleQuaternion(t2);
		}
		/**
		 * Indicates whether or not a given file extension is supported by the parser.
		 * 表示给定的文件扩展名是否被支持的解析器
		 * @param extension	: The file extension of a potential file to be parsed.
		 * 					: 要分析一个的文件的文件扩展名
		 * @return 			: Whether or not the given file type is supported.
		 * 					: 是否支持给定的文件类型
		 */
		public static function supportsType(extension:String):Boolean
		{
			extension = extension.toLowerCase();
			return extension == "e_md5anim";
		}
		
		/**
		 * Tests whether a data block can be parsed by the parser.
		 * 测试是否一个数据块可以由解析器解析
		 * @param data	: The data block to potentially be parsed.
		 * 				: 数据块可能被解析
		 * @return 		: Whether or not the given data is supported.
		 * 				: 是否支持给定的文件类型
		 */
		public static function supportsData(data:*):Boolean
		{
			data = data;
			return false;
		}
		
		/**
		 * 开始解析
		 * @inheritDoc
		 */
		protected override function proceedParsing():Boolean
		{
			if (!_startedParsing)
			{
				/*if (fileName.indexOf("gw_chong02_struck") != -1)
				{
					this;
				}*/
				_textData = getByteData();	//获取解析数据
				//执行解压
				if(_isCompress)
				{
					try
					{
						_textData.uncompress(_compressType);
					}
					catch (err:Error)
					{
						return ParserBase.PARSING_DONE;
					}
				}
				_startedParsing = true;
			}
			if(traslateClipState)
			{
				// 如果正在执行最后步骤，则这里直接做 并返回
				if(translateClip()){
					// 完成了
					traslateClipState = false;
					finalizeAsset(_clip);
					recycleObject();
					return ParserBase.PARSING_DONE;
				}else{
					traslateClipState=true;
					return ParserBase.MORE_TO_PARSE;
				}
			}
			// 不处在进行最后的步骤 才从body开始：
			var components:Vector.<Number>;
			var i:int;
			while (hasTime() && _textData.bytesAvailable != 0) 
			{
				//截取数据类型
				var type:int = _textData.readByte();
//				var data:Object = MD5BytesProcess.readData(_textData, type);
				switch(type)
				{
					case MD5BytesProcess.VERSION:				//MD5Version(版本号)
						_version = _textData.readInt();//int(data);
						if (_version != 10)
						{
							throw new Error("遇到未知的版本号!" + "-->" + fileName);
						}
						break;
					//					case MD5BytesProcess.COMMANDLINE:			//commandline(命令行)
					//						break;
					case MD5BytesProcess.NUM_FRAMES:			//numFrames(帧数)
						_numFrames = _textData.readInt();//int(data);
						_bounds = new Vector.<BoundsData>();
						_frameData = new Vector.<FrameData>();
						break;
					case MD5BytesProcess.NUM_JOINTS:			//numJoints(关节数)
						_numJoints = _textData.readInt();;//int(data);
						_hierarchy = new Vector.<HierarchyData>(_numJoints, true);
						_baseFrameData = new Vector.<BaseFrameData>(_numJoints, true);
						break;
					case MD5BytesProcess.FRAMERATE:				//frameRate(帧速率)
						_frameRate = _textData.readInt();;//int(data);
						break;
					case MD5BytesProcess.NUM_ANIM_COMPONENTS:	//numAnimatedComponents(动画元件数量<每一帧动作数据数量>)
						_numAnimatedComponents = _textData.readInt();//int(data);
						break;
					case MD5BytesProcess.HIERARCHY:				//hierarchy(层级关系)
						var hierarchyData:HierarchyData = Away3dObjectPools.getHierarchy();//new HierarchyData();
						hierarchyData.name = _textData.readUTF();//data.name;
						hierarchyData.parentIndex = _textData.readInt();//data.parentIndex;
						hierarchyData.flags = _textData.readInt();//data.flags;
						hierarchyData.startIndex = _textData.readInt();//data.startIndex;
						_hierarchy[_hierarchyIndex++] = hierarchyData;
						break;
					case MD5BytesProcess.BOUNDS:				//bounds(包围盒数据)
						var boundsData:BoundsData = Away3dObjectPools.getBounds();//new BoundsData();
						boundsData.min.setTo(_textData.readDouble(), _textData.readDouble(), _textData.readDouble());
						boundsData.max.setTo(_textData.readDouble(), _textData.readDouble(), _textData.readDouble());
						_bounds[_boundsIndex++] = boundsData;
						break;
					case MD5BytesProcess.BASEFRAME:				//baseframe(基础帧信息)
						var baseFrameData:BaseFrameData = Away3dObjectPools.getBaseFrame();//new BaseFrameData();
						baseFrameData.position.setTo(_textData.readDouble(), _textData.readDouble(), _textData.readDouble());
						baseFrameData.orientation.x = _textData.readDouble();
						baseFrameData.orientation.y = _textData.readDouble();
						baseFrameData.orientation.z = _textData.readDouble();
						baseFrameData.orientation.w = _textData.readDouble();
						_baseFrameData[_baseFrameIndex++] = baseFrameData;
						break;
					case MD5BytesProcess.FRAME:					//frame(具体动画帧信息)
						var frameData:FrameData = Away3dObjectPools.getFrame();//new FrameData();
						var comIdx:int = _textData.readInt();
						var comLen:int = _textData.readInt();
						components = new Vector.<Number>(comLen, true);
						for (i = 0; i < comLen; ++i)
						{
							components[i] = _textData.readDouble();
						}
						frameData.components = components;
						_frameData[comIdx] = frameData;
						break;
				}
				// 紧接着上面读完的执行：
				if(_textData.bytesAvailable == 0)
				{
					_clip = new SkeletonClipNode();
					translateLoopI = 0;
					if(translateClip()){
						// 完成了
						traslateClipState = false;
						finalizeAsset(_clip);
						recycleObject();
						return ParserBase.PARSING_DONE;
					}else{
						traslateClipState=true;
						return ParserBase.MORE_TO_PARSE;
					}
				}
			}

			return ParserBase.MORE_TO_PARSE;
		}

		protected function recycleObject():void
		{
			Away3dObjectPools.recycleQuaternion(_rotationQuat);
			
			var i:int;
			var len:int;
			len = _bounds.length;
			for (i = 0; i < len; ++i)
			{
				Away3dObjectPools.recycleBounds(_bounds[i]);
			}
			
			len = _frameData.length;
			for (i = 0; i < len; ++i)
			{
				Away3dObjectPools.recycleFrame(_frameData[i]);
			}
			
			len = _hierarchy.length;
			for (i = 0; i < len; ++i)
			{
				Away3dObjectPools.recycleHierarchy(_hierarchy[i]);
			}
			
			len = _baseFrameData.length;
			for (i = 0; i < len; ++i)
			{
				Away3dObjectPools.recycleBaseFrame(_baseFrameData[i]);
			}
		}
		
		/**
		 * Converts all key frame data to an SkinnedAnimationSequence.
		 * 所有的关键帧数据转换为SkinnedAnimationSequence
		 */
		private function translateClip():Boolean
		{
//			var t1=getTimer();
			translatedJoints = 0;
			while(translateLoopI<_numFrames && translatedJoints<PARSE_MAX_TRANSLATE_JOINTS)
			{
				_clip.addFrame(translatePose(_frameData[translateLoopI++]), 1000 / _frameRate);
			}
//			trace(StageFrame.renderIdx,"E_MD5AnimParser/translateClip translatedJoints=",translatedJoints,"time:",getTimer()-t1,"frames:",_numFrames);
			return translateLoopI>=_numFrames;
		}

		////// 时间片 开始 ////
		/** 最后的转换步骤 步进i */
		private var translateLoopI:int;
		/**是否在进行最后的转换步骤*/
		private var traslateClipState :Boolean=false;
		/** 一个时间片中，执行超过次数量的joints处理，就sleep */
		public static const PARSE_MAX_TRANSLATE_JOINTS :int = 600;
		/** 一个时间片中 已经转换过pose的累计joints数 */
		private var translatedJoints:int;

		////// 时间片 结束 ////
		/**
		 * Converts a single key frame data to a SkeletonPose.
		 * 一个关键帧数据转换为SkeletonPose
		 * @param frameData 	: The actual frame data.
		 * 						: 实际帧数据
		 * @return 				: A SkeletonPose containing the frame data's pose.
		 * 						: 一份载有该帧数据的构成SkeletonPose
		 */
		private function translatePose(frameData:FrameData):SkeletonPose
		{
			var hierarchy:HierarchyData;
			var pose:JointPose;
			var base:BaseFrameData;
			var flags:int;
			var j:int;
			var translate:Vector3D = new Vector3D();
			var orientation:Quaternion = new Quaternion();
			var components:Vector.<Number> = frameData.components;
			var skelPose:SkeletonPose = new SkeletonPose();
			var jointPoses:Vector.<JointPose> = skelPose.jointPoses;
			translatedJoints+=_numJoints;
			for (var i:int = 0; i < _numJoints; ++i) 
			{
				j = 0;
				pose = new JointPose();
				hierarchy = _hierarchy[i];
				base = _baseFrameData[i];
				flags = hierarchy.flags;
				translate.x = base.position.x;
				translate.y = base.position.y;
				translate.z = base.position.z;
				orientation.x = base.orientation.x;
				orientation.y = base.orientation.y;
				orientation.z = base.orientation.z;
				
				if (flags & 1)
					translate.x = components[hierarchy.startIndex + (j++)];
				if (flags & 2)
					translate.y = components[hierarchy.startIndex + (j++)];
				if (flags & 4)
					translate.z = components[hierarchy.startIndex + (j++)];
				if (flags & 8)
					orientation.x = components[hierarchy.startIndex + (j++)];
				if (flags & 16)
					orientation.y = components[hierarchy.startIndex + (j++)];
				if (flags & 32)
					orientation.z = components[hierarchy.startIndex + (j++)];
				
				var w:Number = 1 - orientation.x*orientation.x - orientation.y*orientation.y - orientation.z*orientation.z;
				orientation.w = w < 0? 0 : -Math.sqrt(w);
				
				if (hierarchy.parentIndex < 0)
				{
					pose.orientation.multiply(_rotationQuat, orientation);
					_rotationQuat.rotatePoint(translate, pose.translation);
				} 
				else 
				{
					pose.orientation.copyFrom(orientation);
					pose.translation.x = translate.x;
					pose.translation.y = translate.y;
					pose.translation.z = translate.z;
				}
				pose.orientation.y = -pose.orientation.y;
				pose.orientation.z = -pose.orientation.z;
				pose.translation.x = -pose.translation.x;
				
				jointPoses[i] = pose;
			}
			
			return skelPose;
		}
	}
}