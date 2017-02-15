/**
 * Created by gaord on 2016/12/23.
 */
package away3d.materials
{
	import away3d.materials.passes.TLTileGridPass;

	public class TLTileGridMaterial extends MaterialBase
	{
		private var _screenPass:TLTileGridPass;

		public function TLTileGridMaterial(thickness:Number = 1.25)
		{
			super();
			bothSides = false;
			addPass(_screenPass = new TLTileGridPass(thickness));
			_screenPass.material = this;
		}
	}
}
