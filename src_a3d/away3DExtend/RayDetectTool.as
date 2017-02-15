package away3DExtend
{
	/**
	 * 射线检测工具类
	 * @author 李舒浩
	 * 
	 * 用法:
	 * 	1、先调用 RayDetectTool.getTriPlaneVec(wizardUnit, _triPlaneVec);	//获得模型的三角面,如果多个模型使用循环获取所有模型三角面
	 * 	2、刷新所有需要射线检测的点是否有模型，aabb检测
	 * 	3、执行 RayDetectTool.getHitTestPlanePosition();获得当前射线与模型三角面碰撞点vector3D,$orig传mesh执行矩阵转换后的世界坐标( mesh.sceneTransform.transformVector)
	 * 		position, $direction为方向(0,1,0), $v0~$v2为三角面三个点,也就是RayDetectTool.getTriPlaneVec()获得的二维数组中每一个Vector.<Vector3D>
	 */	
	import flash.geom.Vector3D;
	
	import away3d.core.base.ISubGeometry;
	import away3d.entities.Mesh;

	public class RayDetectTool
	{
		public function RayDetectTool() { }
		
		/**
		 * 获得当前射线点是否在三角面上
		 * @param $orig		: 射线起源点(射线点)
		 * @param $direction: 射线方向(一般(0,1,0))
		 * @param $v0		: 三角面点1
		 * @param $v1		: 三角面点2
		 * @param $v2		: 三角面点3
		 * @return 			: 当前所在三角面点位置
		 */		
		public static function isHitTestPlane($orig:Vector3D, $direction:Vector3D, $v0:Vector3D, $v1:Vector3D, $v2:Vector3D):Boolean
		{
			var subA:Vector3D = $v0.subtract($v1);
			var subB:Vector3D = $v1.subtract($v2);
			var n:Vector3D = subA.crossProduct(subB);
			var vec3D:Vector3D = getFlatOfPoint(n, $v0, $direction, $orig);
			
			if(vec3D)
				return isPositionInPlane(vec3D, $v0, $v1, $v2);
			else
				return false;
		}
		/**
		 * 获得当前摄像点所在三角面上的位置点
		 * @param $orig		: 射线起源点(射线点)
		 * @param $direction: 射线方向(一般(0,1,0))
		 * @param $v0		: 三角面点1
		 * @param $v1		: 三角面点2
		 * @param $v2		: 三角面点3
		 * @return 			: 当前所在三角面点位置
		 */		
		public static function getHitTestPlanePosition($orig:Vector3D, $direction:Vector3D, $v0:Vector3D, $v1:Vector3D, $v2:Vector3D):Vector3D
		{
			var subA:Vector3D = $v0.subtract($v1);
			var subB:Vector3D = $v1.subtract($v2);
			var n:Vector3D = subA.crossProduct(subB);
			var vec3D:Vector3D = getFlatOfPoint(n, $v0, $direction, $orig);
			if(vec3D)
			{
				if( isPositionInPlane(vec3D, $v0, $v1, $v2) )
				{
					if(getFlatOfPoint(vec3D, $v0, $v1, $v2))	return vec3D;
					else 										return null;
				}
			}
			return null;
		}
		/**
		 * 获得指定网格所有三角面数组
		 * @param mesh		: 指定模型
		 * @param saveVec	: 需要保存的二维数组
		 * @return 			: 二维Vector数组,[ [点1,点2,点3] ]
		 */		
		public static function getTriPlaneVec(mesh:Mesh, saveVec:Vector.<Vector.<Vector3D>> = null):Vector.<Vector.<Vector3D>>
		{
			saveVec ||= new Vector.< Vector.<Vector3D> >();
			
			var geometries:Vector.<ISubGeometry>;
			//顶点数据集, 顶点数据总数量, 顶点当前所在位置
			var vertex:Vector.<Number>, len:uint, indexData:Vector.<uint>;
			mesh.geometry.convertToSeparateBuffers();
			geometries = mesh.geometry.subGeometries;
			for each(var subGeometry:ISubGeometry in geometries)
			{
				vertex = subGeometry.vertexData;		//顶点数据
				indexData = subGeometry.indexData;		//顶点索引
				len = indexData.length;					//顶点总数量
				
				for(var i:int = 0; i < len; i+=3)
				{
//					var vec1:Vector3D = new Vector3D( vertex[ indexData[i]*3 ], wizardUnit.y+vertex[ indexData[i]*3+1 ], vertex[ indexData[i]*3+2 ] );		//点1
//					_mapMeshPositionVec.push(vec1);
					var vec1:Vector3D = new Vector3D( vertex[ indexData[i]*3 ], vertex[ indexData[i]*3+1 ], vertex[ indexData[i]*3+2 ] );		//点1
					var vec2:Vector3D = new Vector3D( vertex[ indexData[i+1]*3 ], vertex[ indexData[i+1]*3+1 ], vertex[ indexData[i+1]*3+2 ] );	//点2
					var vec3:Vector3D = new Vector3D( vertex[ indexData[i+2]*3 ], vertex[ indexData[i+2]*3+1 ], vertex[ indexData[i+2]*3+2 ] );	//点3
					
					saveVec.push( Vector.<Vector3D>(
							[
								 mesh.sceneTransform.transformVector(vec1)
								,mesh.sceneTransform.transformVector(vec2)
								,mesh.sceneTransform.transformVector(vec3)
							]
						)
					);
				}
			}
			
			return saveVec;
		}
		
		/**
		 * 使用海伦公式计算面积
		 * 假设三边长为a, b, c
		 * p = (a + b + c) / 2; 
		 * 则面积的平方 s^2 = p * (p - a) * (p - b) * (p-c); 
		 * 
		 * @param $a	: 三角形a边
		 * @param $b	: 三角形b边
		 * @param $c	: 三角形c边
		 * @return 		: 三角形面积
		 */		
		private static function triangleArea($a:Number, $b:Number, $c:Number):Number
		{
			var p:Number = ($a + $b + $c) * 0.5; 
			var s:Number = p * (p - $a) * (p - $b) * (p - $c);
			s = Math.sqrt(s);
			return s;
		}
		
		/**
		 * 计算三维的点是否在三角面上
		 * @param $position	: 坐标点
		 * @param $v1		: 三角面点1
		 * @param $v2		: 三角面点2
		 * @param $v3		: 三角面点3
		 * @return 			: true 在三角面上 false 不在三角面上
		 */		
		private static function isPositionInPlane($position:Vector3D, $v1:Vector3D, $v2:Vector3D, $v3:Vector3D):Boolean
		{
			var length1:Number = $v1.subtract($v2).length;
			var length2:Number = $v2.subtract($v3).length;
			var length3:Number = $v3.subtract($v1).length;
			
			var data1:Number = $v1.subtract($position).length;
			var data2:Number = $v2.subtract($position).length;
			var data3:Number = $v3.subtract($position).length;
			var sSum:Number = triangleArea(length1,length2,length3);
			//三角面的面积
			var s1:Number = triangleArea(length1,data1,data2);
			var s2:Number = triangleArea(length2,data2,data3);
			var s3:Number = triangleArea(length3,data3,data1);
			var min:Number = Math.abs(sSum-s1-s2-s3);
			if(min < 0.001) return true;
			return false;
		}
		
		/**
		 * 求射线到平面的交点
		 * @param $normalPosition	: 垂直于平面的法线的点
		 * @param $planePosition	: 平面上一点
		 * @param $direction		: 射线的方向
		 * @param $orig				: 射线的端点
		 * @return					: 如果返回null则没有相交
		 */		
		private static function getFlatOfPoint($normalPosition:Vector3D, $planePosition:Vector3D, $direction:Vector3D, $orig:Vector3D):Vector3D
		{
			var sub:Vector3D = $planePosition.subtract($orig);
			var dot:Number = $normalPosition.dotProduct($direction);
			if(dot == 0) return null;
			
			var t:Number = $normalPosition.dotProduct(sub) / dot;
			//trace(t);
			var vec3D:Vector3D = $orig.add( new Vector3D( $direction.x * t, $direction.y * t, $direction.z * t ) );
			///trace(data+"交点");
			return vec3D;
			
		}
	}
}