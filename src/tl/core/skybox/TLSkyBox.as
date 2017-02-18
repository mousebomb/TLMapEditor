/**
 * Created by gaord on 2017/2/18.
 */
package tl.core.skybox
{
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.SkyBox;
	import away3d.textures.ATFCubeTexture;

	import tl.core.GPUResProvider;

	public class TLSkyBox extends ObjectContainer3D
	{
		private var _skybox :SkyBox;
		public function TLSkyBox()
		{
			super();
		}

		public function setSkyBoxTextureName(cubeName:String):void
		{
			GPUResProvider.getInstance().getSkyboxTexture(cubeName ,onCubeTextureReady);
		}

		private function onCubeTextureReady(atf:ATFCubeTexture):void
		{
			setSkyBox(atf);
		}
		public function setSkyBox(cubeTexture:ATFCubeTexture):void
		{
			if(_skybox) _skybox.dispose();
			_skybox = new SkyBox(cubeTexture);
			addChild(_skybox);
		}

		public function get skybox():SkyBox
		{
			return _skybox;
		}
	}
}
