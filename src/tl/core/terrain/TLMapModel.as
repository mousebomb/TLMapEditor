/**
 * Created by gaord on 2016/12/13.
 */
package tl.core.terrain
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

	import org.robotlegs.mvcs.Actor;

	import tl.core.funcpoint.FuncPointVO;
	import tl.core.rigidbody.RigidBodyVO;
	import tl.frameworks.NotifyConst;
	import tl.utils.HPointUtil;

	import tool.StageFrame;

	public class TLMapModel extends Actor
	{


		/** 当前处理的地图 */
		protected var _curMapVO:TLMapVO;

		public function get mapVO():TLMapVO
		{
			return _curMapVO;
		}

		private const VERTEX_P_TL:Point = new Point(0,0);
		private const VERTEX_P_TR:Point = new Point(TLMapVO.TERRAIN_SCALE,0);
		private const VERTEX_P_BL:Point = new Point(0,TLMapVO.TERRAIN_SCALE);
		private const VERTEX_P_BR:Point = new Point(TLMapVO.TERRAIN_SCALE,TLMapVO.TERRAIN_SCALE);
		private const VERTEX_DJX_DISTANCE:Number = TLMapVO.TERRAIN_SCALE ;
		/** 以Flash显示坐标来获得高度 */
		public function getHeight(x:Number, z:Number , lerp :Boolean = false):Number
		{
			if(lerp)
			{
				// 4点插值计算
				var vertexX:int =Math.floor(x / TLMapVO.TERRAIN_SCALE);
				var vertexY:int =Math.floor(-z / TLMapVO.TERRAIN_SCALE);
				var p1:Number  = _curMapVO.getHeight(vertexX,vertexY);
				var p2:Number  = _curMapVO.getHeight(vertexX+1,vertexY);
				var p3:Number  = _curMapVO.getHeight(vertexX,vertexY+1);
				var p4:Number  = _curMapVO.getHeight(vertexX+1,vertexY+1);
				if(p1==p2 && p2==p3 && p3==p4)
						return p1;
				// 计算平均值，作为中心点高度
				var avg:Number = (p1+p2+p3+p4)/4;
				// 求出目标点离中心点的距离 以计算4个点的差的权重
				var offsetX:Number = (x % TLMapVO.TERRAIN_SCALE);
				var offsetY:Number = (-z % TLMapVO.TERRAIN_SCALE);
				var offsetP :Point = new Point(offsetX,offsetY);
				var distance1 :Number = HPointUtil.getTowPointDisTance(VERTEX_P_TL,offsetP);
				var distance2 :Number = HPointUtil.getTowPointDisTance(VERTEX_P_TR,offsetP);
				var distance3 :Number = HPointUtil.getTowPointDisTance(VERTEX_P_BL,offsetP);
				var distance4 :Number = HPointUtil.getTowPointDisTance(VERTEX_P_BR,offsetP);
				var pow1 :Number = (1-distance1/VERTEX_DJX_DISTANCE);
				var pow2 :Number = (1-distance2/VERTEX_DJX_DISTANCE);
				var pow3 :Number = (1-distance3/VERTEX_DJX_DISTANCE);
				var pow4 :Number = (1-distance4/VERTEX_DJX_DISTANCE);
				if(pow1<0) pow1=0;
				if(pow2<0) pow2=0;
				if(pow3<0) pow3=0;
				if(pow4<0) pow4=0;
				// 4个点的权重影响
				var delta1 :Number = p1-avg;
				var delta2 :Number = p2-avg;
				var delta3 :Number = p3-avg;
				var delta4 :Number = p4-avg;
				var deltaAvg :Number = (delta1 * pow1 + delta2 * pow2 + delta3*pow3 + delta4*pow4) ;
//				trace(StageFrame.renderIdx,"[TLMapModel]/getHeight 坐标" ,x,(-z),"vertex坐标", vertexX,vertexY ,"偏移",offsetX,offsetY , "四角", p1,p2,p3,p4, "中心",avg,"=",avg+deltaAvg);
				return avg+deltaAvg;
			}else
			{
				return _curMapVO.getHeight(Math.round(x / TLMapVO.TERRAIN_SCALE), Math.round(-z / TLMapVO.TERRAIN_SCALE));
			}
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
		{//Todo 四叉树
			var end:Number = getHeight(x, z , true);

			for (var i:int = 0; i < _curMapVO.rigidBodies.length; i++)
			{
				var vo:RigidBodyVO = _curMapVO.rigidBodies[i];
				var rigidProvidedY:Number = vo.provideY4XZ(x,z);
				if (rigidProvidedY>end)
				{
					end = rigidProvidedY;
				}
			}
			return end;
		}


		// #pragma mark --  读取map  ------------------------------------------------------------
		protected function newMapVO():void
		{
			if(_curMapVO)
				_curMapVO.clear();
			_curMapVO = new TLMapVO();
		}
		public function readMapVO(by:ByteArray):void
		{
			newMapVO();
			by.uncompress();
			// 版本号
			_curMapVO.version = by.readUnsignedInt();
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
			_curMapVO.fromEntityGroupData(by);
			// 区域
			_curMapVO.fromZoneData(by);
			// 光照角度
			_curMapVO.sunLightDirection = new Vector3D(by.readFloat(),by.readFloat(),by.readFloat());
			// 功能点
			var lLen : uint = by.readUnsignedShort();
			for(i=0;i<lLen;i++)
			{
				var fpvo :FuncPointVO = new FuncPointVO();
				fpvo.tileX = by.readUnsignedShort();
				fpvo.tileY = by.readUnsignedShort();
				fpvo.type = by.readUnsignedByte();
				_curMapVO.funcPoints.push(fpvo);
			}
			// 天空盒
			_curMapVO.skyboxTextureName = by.readUTF();
			//
			this.onMapVOInited();
		}

		/** 地图读取完毕 */
		protected function onMapVOInited():void
		{

			dispatchWith(NotifyConst.MAP_VO_INITED);
		}

	}
}
