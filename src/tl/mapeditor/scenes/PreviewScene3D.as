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
	import tl.core.skybox.TLSkyBox;

	/** 用于ui上预览3d模型的 */
	public class PreviewScene3D extends Scene3D
	{

		public function PreviewScene3D()
		{
			super();
			addChild(new Trident());
			skyBoxView = new TLSkyBox();
			addChild(skyBoxView);
		}


		/**天空盒*/
		public var skyBoxView:TLSkyBox;


	}
}
