/**
 * Created by gaord on 2016/12/15.
 */
package tl.mapeditor.scenes
{
	import away3d.containers.Scene3D;
	import away3d.debug.Trident;
	import away3d.primitives.SkyBox;
	import away3d.textures.ATFCubeTexture;
	import away3d.textures.BitmapCubeTexture;

	import tl.core.Embeds;

	import tl.core.LightProvider;

	/** 用于ui上预览3d模型的 */
	public class PreviewScene3D extends Scene3D
	{

		public function PreviewScene3D()
		{
			super();
			addChild(new Trident());
			this.addChild(new SkyBox(new BitmapCubeTexture(new Embeds.EnvPosX().bitmapData, new Embeds.EnvNegX().bitmapData, new Embeds.EnvPosY().bitmapData, new Embeds.EnvNegY().bitmapData, new Embeds.EnvPosZ().bitmapData, new Embeds.EnvNegZ().bitmapData)));
//			this.addChild(new SkyBox(new ATFCubeTexture(new Embeds.SKYBOX_ATF())));
		}


	}
}
