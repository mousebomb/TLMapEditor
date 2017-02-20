/**
 * Created by gaord on 2017/2/14.
 */
package tl.mapeditor.ui3d
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;

	import flash.geom.Point;
	import flash.utils.Dictionary;

	import tl.core.GPUResProvider;
	import tl.core.terrain.TLMapVO;
	import tl.frameworks.defines.ZoneType;

	import tool.StageFrame;

	/** 用于显示地图区域标注
	 *  一种类型 配一种颜色
	 *  */
	public class MapZoneView extends ObjectContainer3D
	{

		public function MapZoneView()
		{
			super();
			StageFrame.addGameFun(validateNow);
		}

		public function getColorMaterial(color:uint):ColorMaterial
		{
			return GPUResProvider.getInstance().getColorMaterial(color);
		}

		private var dic:Dictionary = new Dictionary();

		public function getTile(tileX:int, tileY:int):Mesh
		{
			return dic[key(tileX,tileY)];
		}

		public function setZoneType(tileX:int, tileY:int, color:uint):void
		{
			var tile :Mesh = getTile(tileX,tileY);
			if(color==ZoneType.COLOR_NULL)
			{
				if(tile) tile.dispose();
			}else{
				if(!tile)
				{
					tile    = new Mesh(new CubeGeometry(TLMapVO.TERRAIN_SCALE, TLMapVO.TERRAIN_SCALE, TLMapVO.TERRAIN_SCALE), getColorMaterial(color));
					tile.x           = (tileX+.5) * TLMapVO.TERRAIN_SCALE;
					tile.z           = -(tileY +.5)* TLMapVO.TERRAIN_SCALE;
					tile.y = mapVO.getHeight( tileX ,tileY );
					dic[key(tileX,tileY)] = tile;
					addChild(tile);
				}else{
					tile.material = getColorMaterial(color);
				}
			}
		}

		private function key(tileX:int,tileY:int):uint
		{
			return tileX * 10000+tileY;
		}

		private function tileXYByKey(key:int):Point
		{
			var end :Point = new Point(  int(key /10000),  key % 10000 );
			return end;
		}

		/** 高度数据已变化 ，需要刷新显示 */
		public var isHeightDirty:Boolean = false;
		public var mapVO:TLMapVO;
		/** 跟随地形调整高度 */
		public function validateHeight( ):void
		{
			for  (var key : *  in dic)
			{
				var mesh :Mesh = dic[key];
				var tileXY :Point = tileXYByKey( key );
				mesh.y = mapVO.getHeight( tileXY.x ,tileXY.y);
			}
			isHeightDirty = false;
		}

		public function validateNow():void
		{
			if(isHeightDirty)
				validateHeight();
		}

		/** 从地图数据读入 重新设置 */
		public function fromMapVO(mapVO:TLMapVO):void
		{
			// 记录高度变更后重设
			this.mapVO = mapVO;
			// 清理之前显示的(如有)
			for (var i:int = numChildren - 1; i > 0; i--)
			{
				getChildAt(i).disposeWithChildren();
			}
			dic = new Dictionary();
			//显示
			for (var ty:int = 0; ty < mapVO.terrainVerticlesY; ty++)
			{
				for (var tx:int = 0; tx < mapVO.terrainVerticlesX; tx++)
				{
					var type :int=mapVO.getNodeVal(tx,ty);
					if(type)
						setZoneType(tx,ty,ZoneType.COLOR_BY_TYPE[ type]);
				}
			}
		}
	}
}
