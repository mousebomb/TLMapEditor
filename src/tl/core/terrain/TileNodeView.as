/**
 * Created by gaord on 2017/2/14.
 */
package tl.core.terrain
{
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.materials.methods.TLTileGridMethod;

	public class TileNodeView extends Mesh
	{
		private static var sharedTerrainMaterial:TextureMaterial;

		public function TileNodeView(tile:TileView, texture:NodeMapTexture)
		{
			if (null == sharedTerrainMaterial)
			{
				sharedTerrainMaterial          = new TextureMaterial(texture, false, true, true);
				sharedTerrainMaterial.diffuseMethod = new TLTileGridMethod([texture.uvScaleW,texture.uvScaleH], texture);
//				sharedTerrainMaterial.diffuseMethod = new TLTileGridMethod([1,1], null);
				sharedTerrainMaterial.specular = 0.0;
				sharedTerrainMaterial.alphaBlending=true;
			}
			super(tile.geometry, sharedTerrainMaterial);
			this.x = tile.x;
			this.z = tile.z;
		}
	}
}
