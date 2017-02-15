package tool
{
	/**
	 * 碰撞检测类,用于两个mesh之间的aabb碰撞检测 / 1个mesh与点的之间的碰撞检测
	 * @author 李舒浩
	 */	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import away3d.core.base.ISubGeometry;
	import away3d.core.base.SubGeometry;
	import away3d.entities.Mesh;

	public class HitTestExtend
	{
		/**
		 * 2个mesh对象aabb碰撞检测
		 * @param 	a	: a对象
		 * @param 	b	: b对象
		 * @return 		: true:碰到了 false:没碰到
		 * 
		 * @用法:
		 * 	在onEnterFrame方法中,不断判断
		 *  if( HitTestExtend.hitTestObject(_a, _b) ) 
		 *  { 
		 * 		// 碰到之后执行的逻辑处理
		 * 	}
		 */		
		public static function hitTestObject(a:Mesh, b:Mesh):Boolean
		{
			//判断min与max是否会有Infinity出现
			if(!isFinite(a.minX) || !isFinite(a.minY) || !isFinite(a.minZ) 
				|| !isFinite(a.maxX) || !isFinite(a.maxY) || !isFinite(a.maxZ)
				|| !isFinite(b.minX) || !isFinite(b.minY) || !isFinite(b.minZ)
				|| !isFinite(b.maxX) || !isFinite(b.maxY) || !isFinite(b.maxZ)
			) return true;
			
			var flag:Boolean = true;
			var objA:Object = getMinAndMaxVec(a);
			var objB:Object = getMinAndMaxVec(b);
			if(objA.maxVec3D.x < objB.minVec3D.x || objA.maxVec3D.y < objB.minVec3D.y || objA.maxVec3D.z < objB.minVec3D.z
				|| objA.minVec3D.x > objB.maxVec3D.x || objA.minVec3D.y > objB.maxVec3D.y || objA.minVec3D.z > objB.maxVec3D.z
			)
			{
				flag = false;
			}
			return flag;
		}
		/**
		 * 一个mesh对象与一点点之间的碰撞检测
		 * @param a			: 检测mesh对象
		 * @param point		: 碰撞点
		 * @return 			: true:碰到了 false:没碰到
		 * 
		 * @用法:
		 * 	在onEnterFrame方法中,不断判断
		 *  if( HitTestExtend.hitTestPoint(_a, vector3D) ) 
		 *  { 
		 * 		// 碰到之后执行的逻辑处理
		 * 	}
		 *  例如要判断一个mesh与另外一个mesh的中心点是否碰撞到,参数可传(_a, _b.position)
		 */		
		public static function hitTestPoint(a:Mesh, point:Vector3D):Boolean
		{
			if(!isFinite(a.minX) || !isFinite(a.minY) || !isFinite(a.minZ) 
				|| !isFinite(a.maxX) || !isFinite(a.maxY) || !isFinite(a.maxZ)
			) return true;
			
			var flag:Boolean = true;
			var objA:Object = getMinAndMaxVec(a);
			if(objA.maxVec3D.x < point.x || objA.maxVec3D.y < point.y || objA.maxVec3D.z < point.z
				|| objA.minVec3D.x > point.x || objA.minVec3D.y > point.y || objA.minVec3D.z > point.z
			)
			{
				flag = false;
			}
			return flag;
		}
		/**
		 * 获得min三维坐标与max三维坐标对象
		 * @param entity	: 获得对象mesh
		 * @return 			:  Object{
		 * 								 minVec3D : new Vector3D(minX, minY, minZ)
		 * 								,maxVec3D : new Vector3D(maxX, maxY, maxZ)
		 * 							}
		 */		
		public static function getMinAndMaxVec(entity:Mesh):Object
		{
			entity.geometry.convertToSeparateBuffers();
			var geometries:Vector.<ISubGeometry> = entity.geometry.subGeometries;
			//筛选所有的顶点坐标,获取最大值
			var minX:Number = 0, maxX:Number = 0, minY:Number = 0, maxY:Number = 0, minZ:Number = 0, maxZ:Number = 0;
			var vertex:Vector.<Number>, len:uint, index:uint, stride:uint;
			for each(var subGeometry:ISubGeometry in geometries)
			{
				vertex = subGeometry.vertexData;
				len = vertex.length;
				index = subGeometry.vertexOffset;		//顶点当前所在位置
				stride = subGeometry.vertexStride;		//顶点移动位置
				while (index < len)
				{
					var ver:Number = vertex[index];
					if (ver < minX)			minX = ver;
					else if (ver > maxX)	maxX = ver;
					
					ver = vertex[index + 1];
					if (ver < minY)			minY = ver;
					else if (ver > maxY)	maxY = ver;
					
					ver = vertex[index + 2];
					if (ver < minZ)			minZ = ver;
					else if (ver > maxZ)	maxZ = ver;
					index += stride;
				}
			}
			//计算偏移中心点vec
			var cX:Number = (maxX-minX)/2 - maxX;
			var cY:Number = (maxY-minY)/2  - maxY;
			var cZ:Number = (maxZ-minZ)/2  - maxZ;
			var cve:Vector3D = new Vector3D(cX,cY,cZ);
			//筛选8个象限最大的顶点坐标
			var sub:SubGeometry = entity.geometry.subGeometries[0] as SubGeometry;
			var vertexData:Vector.<Number> = sub.vertexData;
			var vec3D_1:Vector3D = new Vector3D(), vec3D_2:Vector3D = new Vector3D(), vec3D_3:Vector3D = new Vector3D()
				, vec3D_4:Vector3D = new Vector3D(), vec3D_5:Vector3D = new Vector3D(), vec3D_6:Vector3D = new Vector3D()
				, vec3D_7:Vector3D = new Vector3D(), vec3D_8:Vector3D = new Vector3D(), vec3D_11:Vector3D = new Vector3D()
				, vec3D_12:Vector3D = new Vector3D(), vec3D_13:Vector3D = new Vector3D(), vec3D_14:Vector3D = new Vector3D()
				, vec3D_15:Vector3D = new Vector3D(), vec3D_16:Vector3D = new Vector3D(), vec3D_17:Vector3D = new Vector3D()
				, vec3D_18:Vector3D = new Vector3D();
			len = vertexData.length;
			var ve3:Vector3D;
			var addVec:Vector3D;
			for(var i:int = 0; i < len; i+=3)
			{
				ve3 = new Vector3D(vertexData[i],vertexData[i+1],vertexData[i+2]);
				addVec = ve3.add(cve);
				
				if(addVec.x >= 0 && addVec.y >=0 && addVec.z >= 0)
				{
					if(addVec.length > vec3D_1.length)
					{
						vec3D_1 = addVec;
						vec3D_11 = ve3;
					}
				}
				if(addVec.x <= 0 && addVec.y >= 0 && addVec.z >= 0)
				{
					if(addVec.length > vec3D_2.length)
					{
						vec3D_2 = addVec;
						vec3D_12 = ve3;
					}
				}
				if(addVec.x <=0 && addVec.y <= 0 && addVec.z >= 0)
				{
					if(addVec.length > vec3D_3.length)
					{
						vec3D_3 = addVec;
						vec3D_13 = ve3;
					}
				}
				if(addVec.x >= 0 && addVec.y <= 0 && addVec.z >= 0)
				{
					if(addVec.length > vec3D_4.length)
					{
						vec3D_4 = addVec;
						vec3D_14 = ve3;
					}
				}
				if(addVec.x >= 0 && addVec.y >= 0 && addVec.z <= 0)
				{
					if(addVec.length > vec3D_5.length)
					{
						vec3D_5 = addVec;
						vec3D_15 = ve3;
					}
				}
				if(addVec.x <= 0 && addVec.y >= 0 && addVec.z <= 0)
				{
					if(addVec.length > vec3D_6.length)
					{
						vec3D_6 = addVec;
						vec3D_16 = ve3;
					}
				}
				if(addVec.x <= 0 && addVec.y <= 0 && addVec.z <= 0)
				{
					if(addVec.length > vec3D_7.length)
					{
						vec3D_7 = addVec;
						vec3D_17 = ve3;
					}
				}
				if(addVec.x >= 0 && addVec.y <= 0 && addVec.z <= 0)
				{
					if(addVec.length > vec3D_8.length)
					{
						vec3D_8 = addVec;
						vec3D_18 = ve3;
					} 
				}
			}
			//去除相同的点
			var vec3DArr:Vector.<Vector3D> = Vector.<Vector3D>([vec3D_11, vec3D_12, vec3D_13, vec3D_14, vec3D_15, vec3D_16, vec3D_17, vec3D_18]);
			var dic:Dictionary = new Dictionary();
			for(i = 0; i < 8; i++)
				dic[vec3DArr[i].toString()] = vec3DArr[i];
			vec3DArr.length = 0;
			for (var s:String in dic)
				vec3DArr.push(dic[s]);
			//把坐标转换回世坐标
			var arr:Vector.<Vector3D> = new Vector.<Vector3D>();
			len = vec3DArr.length;
			for(i = 0; i < len; i++)
				arr.push( entity.sceneTransform.transformVector(vec3DArr[i]) );
			//筛选最大顶点与最小顶点
			minX = arr[0].x;
			maxX = arr[0].x;
			minY = arr[0].y;
			maxY = arr[0].y;
			minZ = arr[0].z;
			maxZ = arr[0].z;
			len = arr.length;
			for(i = 1; i < len; i++)
			{
				if(minX > arr[i].x)			minX = arr[i].x;
				else if(maxX < arr[i].x)	maxX = arr[i].x;
				
				if(minY > arr[i].y)			minY = arr[i].y;
				else if(maxY < arr[i].y)	maxY = arr[i].y;
				
				if(minZ > arr[i].z)			minZ = arr[i].z;
				else if(maxZ < arr[i].z)	maxZ = arr[i].z;
			}
			//清理内存
			vertex = null;
			sub = null;
			vertexData = null;
			vec3D_1 = vec3D_2 = vec3D_2 = vec3D_2 = vec3D_2 = vec3D_2 = vec3D_2 = vec3D_2 = vec3D_2 = vec3D_2 = vec3D_2 = vec3D_2 = vec3D_2 = vec3D_2 = vec3D_2 = vec3D_2 = null;
			
			var obj:Object = {
				 minVec3D : new Vector3D(minX, minY, minZ)
				,maxVec3D : new Vector3D(maxX, maxY, maxZ)
			};
			return obj;
		}
	}
}