/**
 * Created by gaord on 2017/2/23.
 */
package tl.frameworks.service
{
	import org.robotlegs.mvcs.Actor;

	public class TLATFConverter extends Actor
	{
		public function TLATFConverter()
		{
			super();
		}

		/** 为模型和地表纹理打包 dxt5的atf
		 *
		 * DXT only
		 png2atf -i map1.png -c d -n 0,0 -r -o map1.atf

		 (DXT1+ETC1+PVRTC4bpp)
		 png2atf -i map1.png -c -n 0,0 -r -o map1.atf

		 * */
		public function convertDXT5():void
		{


		}

		/** 为skybox 转换cube贴图
		 * png2atf -i snow0.png -c d -m -n -r -o snow.atf
		 * */
		public function convertCube():void
		{

		}
	}
}
