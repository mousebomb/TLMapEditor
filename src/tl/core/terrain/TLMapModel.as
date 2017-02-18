/**
 * Created by gaord on 2016/12/13.
 */
package tl.core.terrain
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.ByteArray;
	import flash.utils.ByteArray;

	import org.robotlegs.mvcs.Actor;

	import tl.core.rigidbody.RigidBodyVO;
	import tl.frameworks.NotifyConst;

	import tool.StageFrame;

	public class TLMapModel extends Actor
	{


		/** 当前处理的地图 */
		protected var _curMapVO:TLMapVO;

		public function get mapVO():TLMapVO
		{
			return _curMapVO;
		}

		/** 以Flash显示坐标来获得高度 */
		public function getHeight(x:Number, z:Number):Number
		{
			return _curMapVO.getHeight(Math.round(x / TLMapVO.TERRAIN_SCALE), Math.round(-z / TLMapVO.TERRAIN_SCALE));
		}

		/** 转换 - 从flash显示坐标转到地形网格坐标 */
		[Inline]
		public static function transToTerrainPos(x:Number, z:Number, p:Point = null):Point
		{
			if(!p)
				p = new Point();
			p.x = Math.round(x / TLMapVO.TERRAIN_SCALE);
			p.y = Math.round(-z / TLMapVO.TERRAIN_SCALE);
			return p;
		}

		/** 以Flash显示坐标来获得高度; 考虑刚体在内 */
		public function getHeightWithRigidBody(x:Number, z:Number):Number
		{
			var end:Number = getHeight(x, z);

			for (var i:int = 0; i < _curMapVO.rigidBodies.length; i++)
			{
				var vo:RigidBodyVO = _curMapVO.rigidBodies[i];
				if (vo.contains(x, z) && vo.y>end)
				{
					end = vo.y;
				}
			}
			return end;
		}


		// #pragma mark --  读取map  ------------------------------------------------------------
		public function readMapVO(by:ByteArray):void
		{
			_curMapVO                   = new TLMapVO();
			by.uncompress();
			// 版本号
			var version :uint = by.readUnsignedInt();
			// 地图名
			_curMapVO.name = by.readUTF();
			// tiles heightMap
			var w:int                   = by.readUnsignedShort();
			var h:int                   = by.readUnsignedShort();
			var rawLen:uint              = (w+1) * (h+1);
			var rawHeights:Vector.<int> = new Vector.<int>(rawLen);
			for (var i:int = 0; i < rawLen; i++)
			{
				rawHeights[i]= (by.readShort());
			}
			_curMapVO.fromTerrainHeightMap(w, h, rawHeights);
			//splatAlpha
			trace(StageFrame.renderIdx,"[TLMapModel]/readMapVO", by.position);
			var splatAlphaLen:uint = by.readUnsignedInt();
			var rawSplat:ByteArray = new ByteArray();
			by.readBytes(rawSplat , 0,splatAlphaLen);
			trace(StageFrame.renderIdx,"[TLMapModel]/readMapVO rawSplat", rawSplat.length);
			var tFile0:String = by.readUTF();
			var tFile1:String = by.readUTF();
			var tFile2:String = by.readUTF();
			var tFile3:String = by.readUTF();
			var tFile4:String = by.readUTF();
			_curMapVO.fromSplatAlpha(rawSplat,tFile0,tFile1,tFile2,tFile3,tFile4);
			// 刚体
			var rbLen : uint = by.readUnsignedShort();
			_curMapVO.fromRigidBodies( by ,rbLen );
			// 模型

			// 区域存储
//			_curMapVO.fromZoneData();
			_curMapVO.initEmptyZone();
			// 光照
			_curMapVO.sunLightDirection = new Vector3D(by.readFloat(),by.readFloat(),by.readFloat());
			//
			dispatchWith(NotifyConst.MAP_VO_INITED);
		}

	}
}
