package away3d.loaders.parsers
{
	/**
	 * 模型二进制数据处理类
	 * @author 李舒浩
	 * 
	 * //////////////////////////////////  md5mesh模型数据格式解释  ////////////////////////////////////
	 * 
	 * MD5Version 	: md5版本号
	 * commandline	: md5命令行
	 * numJoints	: 总关节数
	 * numMeshes	: 总网格数()
	 * 
	 * joints {} 	: 关节节点，其数据顺序为
	 * 关节名称，关节父级ID，关节位置，关节旋转
	 * 关节在对无动画的纯md5Mesh模型来说没有意义，渲染时无需用到。
	 * 
	 * mesh {} 		: 网格节点，其数据顺序为
	 * meshes 		: 子网格名
	 * shader		: 着色球,渲染球名
	 * 
	 * numverts		: 顶点数量
	 * vert			: 顶点,其数据顺序为
	 * 顶点索引，顶点纹理U，顶点纹理V，顶点初始权重，顶点最大权重
	 * 
	 * numtris		: 三角面数量
	 * tri			: 三角面,其数据顺序为
	 * 三角形索引，构成三角形对应的三个顶点的索引
	 * 
	 * numweights	: 权重数
	 * weight		: 权重,其数据顺序为
	 * 权重索引，权重对应的关节索引，权重值，权重位置
	 * 
	 * bones		: 
	 * 
	 * 如果有多个网格，就是以上数据的重复。
	 * 
	 * //////////////////////////////////  md5anim模型数据格式解释  ////////////////////////////////////
	 * 
	 * MD5Version 	: md5版本号
	 * commandline	: md5命令行
	 * numFrames	: 帧数
	 * numJoints 	: 总关节数
	 * frameRate 	: 帧速率
	 * numAnimatedComponents	: 动画元件数量(每一帧动作数据数量)
	 * 
	 * hierarchy	: 是层级关系
	 * 数据内容为： 
	 * 		骨骼名称，父级索引，flag, 索引起始位
	 * 其中flag是一个用来做二进制求与关系来决定当前的数据是 偏移Tx,Ty,TZ 还是 旋转Qx,Qy,Qz
	 * 索引起始位是 frame 动画帧字段中数据的起始索引
	 * 
	 * bounds		: 是包围盒
	 * 通过 min 和 max 可以决定当前动作的 AABB. 不做碰撞检测的话，一般用不到
	 * 
	 * baseframe	: 基础帧信息
	 * 实际上模型的各骨骼动画都是以此为起始值进行偏移的
	 * 6个值分别是 Tx,Ty,Tz,Qx,Qy,Qz
	 * 
	 * frame		: 具体的动画帧信息
	 * 数据内容为： 帧索引， numAnimatedComponents 定义的长度数量的 动画数据。 其中的数值具体有什么用，需要查询 hierarchy 中的 flag.
	 */
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

	public class MD5BytesProcess
	{
		//mesh模型解析定义
		public static const VERSION:int = 0;					//MD5Version(版本号)
		public static const COMMANDLINE:int = 1;				//commandline(命令行)
		public static const NUM_JOINTS:int = 2;				//numJoints(关节数)
		
		public static const NUM_MESHES:int = 10;				//numMeshes(子网格数)
		public static const JOINTS:int = 11;					//joints数据
		public static const MESH:int = 12;					//mesh数据
		
		public static const NUM_FRAMES:int = 20;				//帧数
		public static const FRAMERATE:int = 21;				//帧速率
		public static const NUM_ANIM_COMPONENTS:int = 22;		//动画元件数量(每一帧动作数据数量)
		public static const HIERARCHY:int = 23;				//层级关系
		public static const BOUNDS:int = 24;					//包围盒数据
		public static const BASEFRAME:int = 25;				//基础帧信息
		public static const FRAME:int = 26;					//具体动画帧信息
		
		
		/**
		 * 写入数据
		 * @param bytes	: 写入对应的字节数组
		 * @param type	: 写入类型
		 * @param data	: 写入的数据
		 */		
		public static function writeData(bytes:ByteArray, type:int, data:Object):void
		{
			//写入类型
			bytes.writeByte(type);
			//根据类型写入对应的数据
			var len:int;
			var i:int;
			switch(type)
			{
				case VERSION:		//MD5Version(版本号)
					bytes.writeInt(int(data));
					break;
//				case COMMANDLINE:	//commandline(命令行)
//					break;
				case NUM_JOINTS:	//numJoints(关节数)
					bytes.writeInt(int(data));
					break;
				case NUM_MESHES:	//numMeshes(子网格数)
					bytes.writeInt(int(data));
					break;
				case JOINTS:		//关节
					bytes.writeUTF(String(data.joint.name));			//关节名
					bytes.writeInt(int(data.joint.parentIndex));		//关节父级ID
					var inverseBindPose:Vector.<Number> = data.joint.inverseBindPose;
					len = inverseBindPose.length;
					bytes.writeInt(int(len));							//写入逆绑定姿势长度
					for(i = 0; i < len; i++)
						bytes.writeDouble(Number(inverseBindPose[i]));
					//关节位置坐标(x,y,z)
					bytes.writeDouble(Number(data.pos.x));
					bytes.writeDouble(Number(data.pos.y));
					bytes.writeDouble(Number(data.pos.z));
					//关节方向
					bytes.writeDouble(Number(data.quat.x));
					bytes.writeDouble(Number(data.quat.y));
					bytes.writeDouble(Number(data.quat.z));
					bytes.writeDouble(Number(data.quat.w));
					break;
				case MESH:			//网格
					bytes.writeUTF(String(data.meshName));		//子网格名
					bytes.writeUTF(String(data.shaderName));	//着色球名
					//vert (顶点)
					var vec:Vector.<*> = data.vertexData;
					len = vec.length;
					bytes.writeInt(len);	//顶点数量
					for(i = 0; i < len; i++)
					{
						bytes.writeInt(int(vec[i].index));			//顶点索引
						bytes.writeDouble(Number(vec[i].s));		//uv坐标U
						bytes.writeDouble(Number(vec[i].t));		//uv坐标V
						bytes.writeInt(int(vec[i].startWeight));	//顶点初始权重
						bytes.writeInt(int(vec[i].countWeight));	//顶点最大权重
					}
					//tri (三角面)
					var trisVec:Vector.<uint> = data.trisData;
					len = trisVec.length;
					bytes.writeInt(len);	//三角面数量
					for(i = 0; i < len; i++)
					{
						//构成三角面的三个点
						bytes.writeInt(int(trisVec[i]));
					}
					//weight (权重)
					vec = data.weightsData;
					len = vec.length;
					bytes.writeInt(len);	//权重数量
					for(i = 0; i < len; i++)
					{
						bytes.writeInt(int(vec[i].index));		//权重索引
						bytes.writeInt(int(vec[i].joint));		//权重对应的关节索引
						bytes.writeDouble(Number(vec[i].bias));	//权重值
						//权重位置
						bytes.writeDouble(Number(vec[i].pos.x));
						bytes.writeDouble(Number(vec[i].pos.y));
						bytes.writeDouble(Number(vec[i].pos.z));
					}
					//bones
					bytes.writeInt(data.bones);
					break;
				case NUM_FRAMES:			//帧数
					bytes.writeInt(int(data));
					break;
				case FRAMERATE:				//总关节数
					bytes.writeInt(int(data));
					break;
				case NUM_ANIM_COMPONENTS:	//动画元件数量
					bytes.writeInt(int(data));
					break;
				case HIERARCHY:				//层级关系
					bytes.writeUTF(String(data.name));			//写入骨骼名称
					bytes.writeInt(int(data.parentIndex));	//写入父级索引
					bytes.writeInt(int(data.flags));			//写入flag
					bytes.writeInt(int(data.startIndex));	//写入索引起始位
					break;
				case BOUNDS:				//包围盒数据
					//写入min 和 max
					//写入min
					bytes.writeDouble(Number(data.min.x));
					bytes.writeDouble(Number(data.min.y));
					bytes.writeDouble(Number(data.min.z));
					//写入max
					bytes.writeDouble(Number(data.max.x));
					bytes.writeDouble(Number(data.max.y));
					bytes.writeDouble(Number(data.max.z));
					break;
				case BASEFRAME:				//基础帧信息
					bytes.writeDouble(Number(data.position.x));		//Tx
					bytes.writeDouble(Number(data.position.y));		//Ty
					bytes.writeDouble(Number(data.position.z));		//Tz
					
					bytes.writeDouble(Number(data.orientation.x));	//Qx
					bytes.writeDouble(Number(data.orientation.y));	//Qy
					bytes.writeDouble(Number(data.orientation.z));	//Qz
					bytes.writeDouble(Number(data.orientation.w));	//Qw
					break;
				case FRAME:					//具体动画帧信息
					//写入帧下标
					bytes.writeInt(int(data.index));
					var components:Vector.<Number> = data.components;
					len = components.length;
					//写入长度
					bytes.writeInt(len);
					//每帧元素数据
					for(i = 0; i < len; i++)
						bytes.writeDouble(Number(components[i]));
					break;
			}
		}
		/**
		 * 根据类型读取二进制数据
		 * @param bytes	: 读取的二进制流
		 * @param type	: 读取类型
		 * @return 
		 */		
		public static function readData(bytes:ByteArray, type:int):Object
		{
			var data:Object;
			var x:Number;
			var y:Number;
			var z:Number;
			var len:int;
			switch(type)
			{
				case VERSION:		//MD5Version(版本号)
					data = bytes.readInt();
					break;
//				case COMMANDLINE:	//commandline(命令行)
//					break;
				case NUM_JOINTS:	//numJoints(关节数)
					data = bytes.readInt();
					break;
				case NUM_MESHES:	//numMeshes(子网格数)
					data = bytes.readInt();
					break;
				case JOINTS:		//关节
//					data = {};
//					data.name = bytes.readUTF();	//关节名
//					data.id = bytes.readInt();		//关节父级ID
//					//关节位置坐标(x,y,z)
//					x = bytes.readDouble();
//					y = bytes.readDouble();
//					z = bytes.readDouble();
//					data.vector3D = new Vector3D(x, y, z);
//					//关节方向
//					x = bytes.readDouble();
//					y = bytes.readDouble();
//					z = bytes.readDouble();
//					var w:Number = bytes.readDouble();
//					data.quat = new Vector3D(x, y, z, w);
					
					data = {};
					data.name = bytes.readUTF();		//关节名
					data.parentIndex = bytes.readInt();	//关节父级ID
					len = bytes.readInt();				//inverseBindPose长度
					data.inverseBindPose = new Vector.<Number>(len, true);
					for(i = 0; i < len; i++)
						data.inverseBindPose[i] = bytes.readDouble();
					
					//关节位置坐标(x,y,z)
					data.pos = new Vector3D(bytes.readDouble(), bytes.readDouble(), bytes.readDouble());
					//关节方向
					data.quat = new Vector3D(bytes.readDouble(), bytes.readDouble(), bytes.readDouble(), bytes.readDouble());
					break;
				case MESH:			//网格
					data = {};
					data.meshName = bytes.readUTF();	//子网格名
					data.shaderName = bytes.readUTF();	//着色球名
					//vert (顶点)
					len = bytes.readInt();		//顶点数量
					var vec:Vector.<Object> = new Vector.<Object>(len, true);
					var obj:Object;
					for(var i:int = 0; i < len; i++)
					{
						obj = {};
						obj.index = bytes.readInt();	//顶点索引
						obj.s = bytes.readDouble();	//uv坐标U
						obj.t = bytes.readDouble();	//uv坐标V
						obj.startWeight = bytes.readInt();	//顶点初始权重
						obj.countWeight = bytes.readInt();	//顶点最大权重
						vec[i] = obj;
					}
					data.vertexData = vec;
					//tri (三角面)
					len = bytes.readInt();
					var arrVec:Vector.<uint> = new Vector.<uint>(len, true);
					for(i = 0; i < len; i++)
					{
						//构成三角面的点
						arrVec[i] = bytes.readInt();
					}
					data.trisData = arrVec;
					//weight (权重)
					len = bytes.readInt();
					vec = new Vector.<Object>(len, true);
					for(i = 0; i < len; i++)
					{
						obj = {};
						obj.index = bytes.readInt();	//权重索引
						obj.joint = bytes.readInt();	//权重对应的关节索引
						obj.bias = bytes.readDouble();	//权重值
						//权重位置
						x = bytes.readDouble();
						y = bytes.readDouble();
						z = bytes.readDouble();
						obj.pos = new Vector3D(x, y, z);
						vec[i] = obj;
					}
					data.weightsData = vec;
					//bones
					data.bones = bytes.readInt();
					break;
				case NUM_FRAMES:			//帧数
					data = bytes.readInt();
					break;
				case FRAMERATE:				//总关节数
					data = bytes.readInt();
					break;
				case NUM_ANIM_COMPONENTS:	//动画元件数量
					data = bytes.readInt();
					break;
				case HIERARCHY:				//层级关系
					data = {};
					data.name = bytes.readUTF();		//骨骼名称
					data.parentIndex = bytes.readInt();	//父级索引
					data.flags = bytes.readInt();		//flag
					data.startIndex = bytes.readInt();	//索引起始位
					break;
				case BOUNDS:				//包围盒数据
					data = {};
					//min
					data.min = new Vector3D(bytes.readDouble(), bytes.readDouble(), bytes.readDouble());
					//max
					data.max = new Vector3D(bytes.readDouble(), bytes.readDouble(), bytes.readDouble());
					break;
				case BASEFRAME:				//基础帧信息
					data = {};
					//Tx,Ty,Tz
					data.position = new Vector3D(bytes.readDouble(), bytes.readDouble(), bytes.readDouble());
					//Qx,Qy,Qz,Qw
					data.orientation = new Vector3D(bytes.readDouble(), bytes.readDouble(), bytes.readDouble(), bytes.readDouble());
					break;
				case FRAME:					//具体动画帧信息
					data = {};
					data.index = bytes.readInt();	//帧下标
					len = bytes.readInt();			//长度
					//每帧元素数据
					data.components = new Vector.<Number>(len, true);
					for(i = 0; i < len; i++)
						data.components[i] = bytes.readDouble();
					break;
			}
			return data;
		}
	}
}