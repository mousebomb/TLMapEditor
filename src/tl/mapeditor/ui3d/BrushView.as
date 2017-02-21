/**
 * Created by gaord on 2016/12/13.
 */
package tl.mapeditor.ui3d
{
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.primitives.SphereGeometry;

	import tl.core.GPUResProvider;

	import tl.core.terrain.TLMapVO;

	import tl.core.terrain.TLTileVO;
	import tl.core.terrain.TileView;

	/** 地形刷 显示在地图上跟随光标
	 * 应该是一个圆形，会跟随地面有坡度；
	 * */
	public class BrushView extends Mesh
	{
		public function BrushView()
		{
			super(new SphereGeometry(BASE_SIZE), new ColorMaterial(0x00cc00, 0.5));
			scaleY = 0.5;
		}

		public static const BASE_SIZE:int = 100;
		private var _brushSize:int        = BASE_SIZE;

		/** 大小 */
		public function get brushSize():int
		{
			return _brushSize;
		}

		public function set brushSize(value:int):void
		{
			_brushSize = value;
			var sizeOnBase :Number = value / BASE_SIZE;
			this.scaleX =this.scaleZ = sizeOnBase;
		}

		/** 地形刷强度 (一笔最高高度) */
		private var _brushStrong:int = 50;
		public function get brushStrong():int
		{
			return _brushStrong;
		}

		public function set brushStrong(value:int):void
		{
			_brushStrong = value;
			var sizeOnBase :Number = value / BASE_SIZE;
			this.scaleY = sizeOnBase;
		}

		/** 纹理刷强度 0.01~1.00 */
		private var _brushSplatPower:Number = 0.5;
		public function get brushSplatPower():Number
		{
			return _brushSplatPower;
		}

		public function set brushSplatPower(value:Number):void
		{
			_brushSplatPower = value;
			var sizeOnBase :Number = value;
			this.scaleY = sizeOnBase;
		}

		public function asZoneBrush():void
		{
			// 一个格子大
			this.brushSize = TLMapVO.TERRAIN_SCALE;			this.scaleY = .1;

		}
	}
}
