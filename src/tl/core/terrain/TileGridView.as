/**
 * Created by gaord on 2016/12/21.
 */
package tl.core.terrain
{
	import away3d.arcane;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.materials.methods.TLTileGridMethod;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import tl.mapeditor.ui.DebugHeightMap;

	use namespace arcane;

	public class TileGridView extends Mesh
	{
		private var _tile:TileView;
		private static var sharedTerrainMaterial:TextureMaterial;

		/** @param tile 依照tile的几何体显示 */
		public function TileGridView(tile:TileView)
		{
			_tile = tile;
			if (gridTexture == null ) createGridTexture();
			if (null == sharedTerrainMaterial)
			{
				sharedTerrainMaterial               = new TextureMaterial(gridTexture, false, true, true);
				sharedTerrainMaterial.diffuseMethod = new TLTileGridMethod([_tile.tileVO.parentTerrain.terrainVerticlesX, _tile.tileVO.parentTerrain.terrainVerticlesY], gridTexture);
				sharedTerrainMaterial.specular      = 0.0;
				sharedTerrainMaterial.alphaBlending=true;
			}
			super(_tile.geometry, sharedTerrainMaterial);
			this.x = _tile.x;
			this.z = _tile.z;
		}

		private static var gridTexture :Texture2DBase;

		private static function createGridTexture():void
		{
				if(gridTexture == null )
				{
					// 只对应UV坐标，所以无关这里的尺寸，这里只为显示效果足够即可
					var bmd:BitmapData = new BitmapData(32, 32, true, 0x00ffffff);
					for (var i:int = 0; i < 32; i++)
					{
						bmd.setPixel32(0, i, 0xffCCCCCC);
						bmd.setPixel32(31, i, 0xffCCCCCC);
						bmd.setPixel32(i, 0, 0xffCCCCCC);
						bmd.setPixel32(i, 31, 0xffCCCCCC);
					}
					DebugHeightMap.getInstance().bitmap2=new Bitmap(bmd);
					gridTexture = new BitmapTexture(bmd);
				}
		}

	}
}
