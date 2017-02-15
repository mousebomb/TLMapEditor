/**
 * Created by gaord on 2016/12/13.
 */
package tl.core.terrain
{
	public class TLTileVO
	{

		/** 显示世界里的起始坐标 用于显示的 */
		public var worldX:Number;
		public var worldZ:Number;


		public var parentTerrain:TLMapVO;

		public function TLTileVO(map:TLMapVO)
		{
			parentTerrain = map;
		}


		/** 横向顶点数 */
		public static const tileVerticlesX:int = 16;
		/** 纵向顶点数 */
		public static const tileVerticlesY:int = 16;

		/** 起始顶点 */
		public var beginVerticleX:int;
		public var beginVerticleY:int;


		// TerrainVertex
		// x,y,z ,x,y,z,x,y,z,x,y,z...
		public var vertexData:Vector.<Number> = new <Number>[];
		// 0,1,2 ,2,1,3 ...  也就是 indices
		public var indexData:Vector.<uint>    = new <uint>[];

		/*0,0 ,1,0, 0,1 ,  */
		public var uvs:Vector.<Number> = new <Number>[];
		/** splat alpha mask */
//		public var alphaMask :Vector
		public var uvsAlphaMask :Vector.<Number> = new <Number>[];

		public function fillVertexBuffer():void
		{
			for (var y:int = 0; y <= tileVerticlesY; y++)
			{
				for (var x:int = 0; x <= tileVerticlesX; x++)
				{
					var TrueX:int = beginVerticleX + x;
					var TrueY:int = beginVerticleY + y;

					// flash 3D空间显示顶点是 x z y高度
					var destVertex:Object = {};
					destVertex.x          = x * TLMapVO.TERRAIN_SCALE;
					destVertex.z          = y * TLMapVO.TERRAIN_SCALE;
					destVertex.y          = parentTerrain.getHeight(TrueX, TrueY);

					destVertex.displacement = 0;
					// verticle
					vertexData.push(destVertex.x, destVertex.y, (-destVertex.z));
					// UV  xyzw作为索引 代表4对uv  1x 2y 3z 4w  为了配合away3d，uv按总地图的算，以一整幅图为UV，然后通过splat里的缩放uv再把tile的缩回去
//							texScrollU.x;
//							texScrollV.x;
					// 在本Tile内的UV
//					destVertex.u = x / tileVerticlesX;
//					destVertex.v = y / tileVerticlesY;
					// 在terrain内的UV
					destVertex.u = (beginVerticleX + x )/ parentTerrain.terrainVerticlesX;
					destVertex.v = (beginVerticleY + y) / parentTerrain.terrainVerticlesY;
					uvs.push(destVertex.u, destVertex.v);

				}
			}
			//
		}

		/**高度图变化后刷新*/
		public function validateHeight():void
		{
			var indexVertexDataY:int;
			for (var y:int = 0; y <= tileVerticlesY; y++)
			{
				for (var x:int = 0; x <= tileVerticlesX; x++)
				{
					var TrueX:int = beginVerticleX + x;
					var TrueY:int = beginVerticleY + y;

					var height:Number = parentTerrain.getHeight(TrueX, TrueY);

					// verticle
					indexVertexDataY = getIndexOfVertexData(x,y) * 3 + 1;
					if (vertexData[indexVertexDataY] != height)
					{
						vertexData[indexVertexDataY] = height;
						isHeightValidated            = true;
					}
				}
			}
		}

		/** 高度图变化刷新中发现 确实变化了; 给视图标记用的 */
		public var isHeightValidated:Boolean = false;

		public function fillIndexBuffer():void
		{
			// 转换成flash用的顶点缓存
			var a1Index:uint;
			var a2Index:uint;
			var a3Index:uint;
			var a4Index:uint;
			for (var y:int = 0; y < tileVerticlesY; y++)
			{
				for (var x:int = 0; x < tileVerticlesX; x++)
				{
					// 每个都加入它x,y ~ x+1,y+1的矩形 2个三角形
					/*
					 * a1 - a2
					 * |  \  |
					 * a3 - a4
					 * */
					a1Index = getIndexOfVertexData(x, y); // 本行x个
					a2Index = getIndexOfVertexData(x + 1, y);//本行x+1
					a3Index = getIndexOfVertexData(x, y + 1);
					a4Index = getIndexOfVertexData(x + 1, y + 1);
//					indexData.push(a1Index, a3Index, a4Index, a1Index, a4Index, a2Index);
					// z取反后 三角形反过来
					indexData.push(a1Index, a4Index, a3Index, a1Index, a2Index, a4Index);
				}
			}
		}

		[Inline]
		private final function getIndexOfVertexData(smoothX:int, smoothY:int):int
		{
			return smoothX + smoothY * (1 + tileVerticlesX);
		}


		public function init():void
		{
			fillVertexBuffer();
			fillIndexBuffer();
		}
	}
}
