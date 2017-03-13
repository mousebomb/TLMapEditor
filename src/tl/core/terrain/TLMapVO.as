/**
 * Created by gaord on 2016/12/13.
 */
package tl.core.terrain
{
	import away3d.tools.utils.TextureUtils;

	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.mousebomb.framework.GlobalFacade;

	import tl.core.funcpoint.FuncPointVO;
	import tl.core.rigidbody.RigidBodyVO;
	import tl.core.role.RolePlaceVO;
	import tl.frameworks.NotifyConst;

	import tool.StageFrame;

	public class TLMapVO
	{
		public function TLMapVO()
		{
		}

		/** 当前保存时的地图版本号 */
		public static const SAVE_VERSION :uint = 5;
		/** 当前读取的地图版本(仅读取时用） */
		public var version:uint;
		/** 地图名字 */
		public var name :String = 'null';

		/** 地形横向顶点数 必须是TILE的顶点尺度的倍数 */
		public var terrainVerticlesX:int;
		/** 地形纵向顶点数 必须是TILE的顶点尺度的倍数 */
		public var terrainVerticlesY:int;
		/** 存储的高度 short 16bit记录， -32768~32767 显示高度要乘以TERRAIN_ZSCALE */
		public var terrainHeightMapInt:Vector.<int> = new <int>[];
		/** 显示高度 存储高度乘以TERRAIN_ZSCALE */
		public var terrainHeightMap:Vector.<Number> = new <Number>[];
		/** 高度缩放比例 /16 即最终为 +-2047 */
		public static const TERRAIN_ZSCALE:Number   = 1 / 16;
		/** 长宽缩放比例 */
		public static const TERRAIN_SCALE:Number    = 32;
		/**FLOAT的极限*/
		public static const TERRAIN_HEIGHT_MAX_INT :int = 32767;
		public static const TERRAIN_HEIGHT_MIN_INT :int = -32768;
		public static const TERRAIN_HEIGHT_MAX :Number = TERRAIN_HEIGHT_MAX_INT * TERRAIN_ZSCALE;
		public static const TERRAIN_HEIGHT_MIN :Number = TERRAIN_HEIGHT_MIN_INT * TERRAIN_ZSCALE;
		/**纹理叠加最大层数*/
		public static const SPLATTEXTURES_MAX_LAYER :int = 4;
		public static const TEXTURES_MAX_LAYER :int = SPLATTEXTURES_MAX_LAYER+1;
		/** 分的块(tile) */
		public var numTileX:int                     = 1;
		public var numTileY:int                     = 1;

		/** 地图顶点二维索引展开； rawHeights 的实际尺寸是 terrainVerticlesX+1  , terrainVerticlesY+1 */
		[Inline]
		public final function terrainIndex(x:int, y:int):int
		{
			return x + y * (1 + terrainVerticlesX);
		}

		/**
		 * 从高度图初始化
		 * short 16bit记录， -32768~32767 显示高度乘以TERRAIN_ZSCALE
		 * rawHeights 的实际尺寸是 terrainVerticlesX+1  , terrainVerticlesY+1
		 * */
		public function fromTerrainHeightMap(w:int, h:int, rawHeights:Vector.<int>):void
		{
			terrainVerticlesX   = w;
			terrainVerticlesY   = h;
			terrainHeightMapInt = rawHeights;
			for (var y:int = 0; y <= terrainVerticlesY; y++)
			{
				for (var x:int = 0; x <= terrainVerticlesX; x++)
				{
					terrainHeightMap[terrainIndex(x,y)] = rawHeights[terrainIndex(x,y)] * TERRAIN_ZSCALE;
				}
			}
			//
			initTiles();
		}

		/**
		 * 从高度图初始化
		 * bmd 的实际尺寸是 terrainVerticlesX  , terrainVerticlesY
		 * */
		public function fromTerrainHeightBitmap(bmd:BitmapData):void
		{
			terrainVerticlesX   = bmd.width;
			terrainVerticlesY   = bmd.height;
			for (var y:int = 0; y <= terrainVerticlesY; y++)
			{
				for (var x:int = 0; x <= terrainVerticlesX; x++)
				{
					if(x==terrainVerticlesX || y==terrainVerticlesY)
					{
						terrainHeightMap[terrainIndex(x,y)] = 0;
						terrainHeightMapInt.push(0);
					}
					else
					{
						var intVal : int = bmd.getPixel(x, y) +TERRAIN_HEIGHT_MIN_INT;
						terrainHeightMap[terrainIndex(x,y)] = (intVal) * TERRAIN_ZSCALE;
						terrainHeightMapInt.push(intVal);
					}
				}
			}
			//
			initTiles();
		}

		/** 显示高度 */
		public function getHeight(coordX:int, coordY:int):Number
		{
			return terrainHeightMap[terrainIndex(coordX,coordY)];
		}

		/** 设置显示高度 */
		public function setHeight(coordX:int, coordY:int, hei:Number):void
		{
			terrainHeightMap[terrainIndex(coordX,coordY)]    = hei;
			// 每次写入int 会有误差，所以存了number的用于读取
			terrainHeightMapInt[terrainIndex(coordX,coordY)] = int(hei / TERRAIN_ZSCALE);
			//
			if (_debugBmd)
			{
				_debugBmd.setPixel(coordX, coordY, int(hei / TERRAIN_ZSCALE) -TERRAIN_HEIGHT_MIN_INT);
			}
		}

		/** 作为平地初始化 用于从编辑器新建 [编辑用] */
		public function initFlat():void
		{
			terrainHeightMap.length = (terrainVerticlesX + 1) * (terrainVerticlesY + 1);
			for (var y:int = 0; y <= terrainVerticlesY; y++)
			{
				for (var x:int = 0; x <= terrainVerticlesX; x++)
				{
					setHeight(x, y, 0);
				}
			}
			//
			initSplatAlpha();
			//
			initEmptyZone();
			//
			initTiles();
		}

		/**初始化tile*/
		private function initTiles():void
		{
			tiles    = new <TLTileVO>[];
			numTileX = terrainVerticlesX / TLTileVO.tileVerticlesX;
			numTileY = terrainVerticlesY / TLTileVO.tileVerticlesY;
			for (var y:int = 0; y < numTileY; y++)
			{
				for (var x:int = 0; x < numTileX; x++)
				{
					var tile:TLTileVO   = new TLTileVO(this);
					tile.beginVerticleX = x * TLTileVO.tileVerticlesX;
					tile.beginVerticleY = y * TLTileVO.tileVerticlesY;
					tile.worldX         = tile.beginVerticleX * TERRAIN_SCALE;
					tile.worldZ         = -tile.beginVerticleY * TERRAIN_SCALE;
					tiles.push(tile);
					tile.init();
				}
			}
		}

		public var tiles:Vector.<TLTileVO> = new <TLTileVO>[];

		/** 高度图变化了后 刷新tiles */
		public function validateTileHeight():void
		{
			for (var i:int = 0; i < tiles.length; i++)
			{
				tiles[i].validateHeight();
			}
		}

		//debug
		private var _debugBmd:BitmapData;

		public function get debugBmd():BitmapData
		{
			if (_debugBmd && (_debugBmd.width != terrainVerticlesX || _debugBmd.height != terrainVerticlesY ))
			{
				_debugBmd.dispose();
				_debugBmd = null;
			}
			if (_debugBmd == null)
			{
				_debugBmd = new BitmapData(terrainVerticlesX, terrainVerticlesY, false, 0);
				for (var y:int = 0; y < terrainVerticlesY; y++)
				{
					for (var x:int = 0; x < terrainVerticlesX; x++)
					{
						_debugBmd.setPixel(x, y, terrainHeightMapInt[terrainIndex(x,y)] -TERRAIN_HEIGHT_MIN_INT);
					}
				}

			}
			return _debugBmd;
		}


		////-------- 纹理融合  splatalpha ---
		/** 1幅底图纹理  (atf) + 4幅splat纹理 (atf) */
		public var textureFiles:Vector.<String> = new <String>[];

		/** 即时生成的alphamask  */
		public var splatAlphaTexture:SplatAlphaTexture;

		/** 根据顶点数 计算出的splatAlpha纹理尺寸 */
		public var splatAlphaW:uint;
		public var splatAlphaH:uint;

		/** 从存档的读取 */
		public function fromSplatAlpha(splatAlphaByteArray:ByteArray, tFile0:String, tFile1:String, tFile2:String, tFile3:String, tFile4:String):void
		{
			splatAlphaW = TextureUtils.getBestPowerOf2(terrainVerticlesY);
			splatAlphaH = TextureUtils.getBestPowerOf2(terrainVerticlesX);

			splatAlphaTexture = new SplatAlphaTexture(splatAlphaW, splatAlphaH, splatAlphaByteArray);
			textureFiles[0]   = tFile0;
			textureFiles[1]   = tFile1;
			textureFiles[2]   = tFile2;
			textureFiles[3]   = tFile3;
			textureFiles[4]   = tFile4;
		}

		/** 创建默认alpha图 新建地图[编辑用] */
		public function initSplatAlpha():void
		{
			splatAlphaW = TextureUtils.getBestPowerOf2(terrainVerticlesY);
			splatAlphaH = TextureUtils.getBestPowerOf2(terrainVerticlesX);

			splatAlphaTexture = new SplatAlphaTexture(splatAlphaW, splatAlphaH);

			textureFiles[0] = "db_107_01";// 土地
			textureFiles[1] = "db_107_shitou01";//石头
			textureFiles[2] = "db_607_caodi02";//青草
			textureFiles[3] = "db_107_a02";//干裂地面
			textureFiles[4] = "db_107_a01";//砖
//			for (var y:int = 0; y < splatAlphaH; y++)
//			{
//				for (var x:int = 0; x < splatAlphaW; x++)
//				{
////					splatAlphaTexture.setVal(x, y, SplatAlphaTexture.R, x / splatAlphaW * 255);
////					splatAlphaTexture.setVal(x, y, SplatAlphaTexture.G, 255 - y / splatAlphaH * 255);
//					splatAlphaTexture.setVal(x, y, SplatAlphaTexture.B, 255 - x / splatAlphaW * 255);
//					splatAlphaTexture.setVal(x, y, SplatAlphaTexture.A,  255);
//				}
//			}
			splatAlphaTexture.commitChange();
		}

		/** 图层索引 对应到贴图rgba的哪一个
		 * 底图不对应 */
		[Inline]
		public static function layerIndexToSplatIndex(layerIndex:int):int
		{
			switch(layerIndex)
			{
				case 1: return SplatAlphaTexture.X;
				case 2: return SplatAlphaTexture.Y;
				case 3: return SplatAlphaTexture.Z;
				case 4: return SplatAlphaTexture.W;
				default:
					throw new Error("图层索引"+layerIndex+"没有splatalpha");
					break;
			}
			return 0;
		}

		/** 设置某一材质层的坐标的alpha [编辑用]
		 * alpha参数是0.0~1.0 高精度  */
		[Inline]
		public final function setAlpha(x:int, y:int, layerIndex:int, alpha:Number):void
		{
			var key : int =(y * splatAlphaW + x )*10 + layerIndex;
			splatAlphaCache[key] = alpha;
			splatAlphaTexture.setVal(x, y, layerIndexToSplatIndex(layerIndex), alpha * 255);
			if(layerIndex == 4 )
			{
				this
			}
		}

		/** 获得某一材质层的坐标的alpha [编辑用]
		 * 返回的是 0.0~1.0 高精度 */
		[Inline]
		public final function getAlpha(x:int, y:int, layerIndex:int):Number
		{
			var key : int =(y * splatAlphaW + x )*10 + layerIndex;
			if( null == splatAlphaCache[key])
			{
				splatAlphaCache[key] = splatAlphaTexture.getVal(x, y, layerIndexToSplatIndex(layerIndex)) / 255;
			}
			return splatAlphaCache[key];
		}
		/** 四层 alphamask 缓存精度高的alpha */
		private var splatAlphaCache: Dictionary = new Dictionary();


		// #pragma mark --  刚体  ------------------------------------------------------------
		/** 刚体的记录， 显示在编辑器里作为带厚度的矩形，实际游戏中，只用来判断 */

		/** 从存档恢复刚体 */
		public function fromRigidBodies(rawData:ByteArray, num:int):void
		{
			rigidBodies = new <RigidBodyVO>[];
			for (var i:int = 0; i < num; i++)
			{
				var rb:RigidBodyVO = new RigidBodyVO();
				rb.readFromByteArray(rawData,version);
				rigidBodies.push(rb);
			}
		}
		/**刚体对象*/
		public var rigidBodies:Vector.<RigidBodyVO> = new <RigidBodyVO>[] ;


		// #pragma mark --  模型  ------------------------------------------------------------
		/** 模型对象 分组  [name:String] = Vector.<RolePlaceVO> */
		public var entityGroups :Dictionary = new Dictionary();
		/** 对象模型的组名 */
		public var entityGroupNames :Vector.<String> = new <String>[];

		/** 从数据初始化模型对象分组数据*/
		public function fromEntityGroupData( rawBytes :ByteArray ):void
		{
			var gLen : int = rawBytes.readUnsignedShort();
			for (var i:int = 0; i < gLen; i++)
			{
				var groupName:String = rawBytes.readUTF();
				var groupLen:uint    = rawBytes.readUnsignedShort();
				entityGroupNames.push(groupName);
				var group:Vector.<RolePlaceVO> = entityGroups[groupName] = new Vector.<RolePlaceVO>();
				for (var j:int = 0; j < groupLen; j++)
				{
					var vo :RolePlaceVO = new RolePlaceVO();
					vo.readFromByteArray(rawBytes,version);
					group.push(vo);
				}
			}
		}


		// #pragma mark --  区域存储为二维node的value  ------------------------------------------------------------
		/** node的value */
		public var nodes:Vector.<uint>;

		/** 初始化 空的（编辑器用） ，需要晚于地形初始化 */
		public function initEmptyZone():void
		{
			nodes = new Vector.<uint>( terrainVerticlesX*terrainVerticlesY );
		}

		/** 初始化 从数据 ，需要晚于地形初始化 */
		public function fromZoneData(rawBytes:ByteArray):void
		{
			nodes = new Vector.<uint>(terrainVerticlesX*terrainVerticlesY);
			for (var y:int = 0; y < terrainVerticlesY; y++)
			{
				for (var x:int = 0; x < terrainVerticlesX; x++)
				{
					var index:int = nodeIndex(x,y);
					nodes[index] = rawBytes.readUnsignedByte();
				}
			}
		}

		public function setNodeVal(x:int, y:int, val:int):void
		{
			nodes[nodeIndex(x,y)] = val;
			if(_debugNodeMap)
			{
				_debugNodeMap.setVal(x, y,  val);
				_debugNodeMap.invalidateContent();
			}
		}
		public function getNodeVal(x:int,y:int):int
		{
			return nodes[nodeIndex(x,y)];
		}

		/** 地图格子二维索引展开； */
		[Inline]
		public final function nodeIndex(x:int,y:int):int
		{
			return x+y*terrainVerticlesX;
		}

		/** 测试和编辑器用 显示格子区域颜色的材质 */
		private var _debugNodeMap :NodeMapTexture;
		public function get debugNodeMap():NodeMapTexture
		{
			if (_debugNodeMap && (_debugNodeMap.mapW != terrainVerticlesX || _debugNodeMap.mapH != terrainVerticlesY ))
			{
				_debugNodeMap.dispose();
				_debugNodeMap = null;
			}
			if (_debugNodeMap == null)
			{
				_debugNodeMap = new NodeMapTexture(terrainVerticlesX, terrainVerticlesY );
				for (var y:int = 0; y < terrainVerticlesY; y++)
				{
					for (var x:int = 0; x < terrainVerticlesX; x++)
					{
						_debugNodeMap.setVal(x, y, nodes[nodeIndex(x,y)]);
					}
				}
				_debugNodeMap.invalidateContent();
			}
			return _debugNodeMap;
		}


		// #pragma mark --  功能点  ------------------------------------------------------------
		public var funcPoints:Vector.<FuncPointVO> = new Vector.<FuncPointVO>();


		// #pragma mark --  光照角度  ------------------------------------------------------------
		/**光照角度*/
		public var sunLightDirection :Vector3D = new Vector3D(-0.2, -0.78, -0.2) ;
		// #pragma mark --  skybox  ------------------------------------------------------------
		/** 天空盒纹理名 */
		public var skyboxTextureName:String    ="sky";


		// #pragma mark --  清理  ------------------------------------------------------------
		public function clear():void
		{
			if(_debugNodeMap){
				_debugNodeMap.dispose();
				_debugNodeMap=null;
			}
			if(_debugBmd)
			{
				_debugBmd.dispose();
				_debugBmd=null;
			}
			if(splatAlphaTexture)
			{
				splatAlphaTexture.dispose();
				splatAlphaTexture=null;
			}
		}
	}
}
