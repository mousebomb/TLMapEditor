package HLib.UICom.Away3DUICom
{
	import flash.utils.Dictionary;
	
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.Texture2DBase;
	
	public class ReuseIcon3D extends HIcon3D
	{
		private static var def_geos:Dictionary = new Dictionary();
		
		public function ReuseIcon3D()
		{
			super();
		}
		
		override protected function createGeo():void
		{
			var tmpGeo:PlaneGeometry = def_geos[_type];
			if (tmpGeo == null)
			{
				def_geos[_type] = tmpGeo = new PlaneGeometry(1, 1);
			}
			geometry = _planeGeo = tmpGeo;
		}
		
		override public function setTexture(texture:Texture2DBase):void
		{
			if (_planeGeo.width == 1 || _planeGeo.height == 1)
			{
				super.setTexture(texture);
			}
			else
			{
				_textureMateral.texture = texture;
			}
		}
		
		override protected function disposeGeo():void
		{
			_planeGeo = null;
		}
	}
}