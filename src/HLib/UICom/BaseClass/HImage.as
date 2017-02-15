package HLib.UICom.BaseClass
{	
	import flash.display.BitmapData;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class HImage extends Image
	{
		private var _myWidth:Number = 0;
		private var _myHeight:Number = 0;
		public function HImage()
		{
			super(Texture.fromBitmapData(new BitmapData(10,10,true,0x0), false));
			_myWidth=texture.width;
			_myHeight=texture.height;
		}
		public function set myWidth(value:Number):void{
			_myWidth=value;
		}
		public function get myWidth():Number{
			return _myWidth;
		}
		public function set myHeight(value:Number):void{
			_myHeight=value;
		}
		public function get myHeight():Number{
			return _myHeight;
		}
		/**
		 * 通过bitmapdata显示图片 
		 * @param _bmd
		 * 
		 */		
		public function myDrawByBmd(_bmd:BitmapData):void{
			if(_bmd == null)
			{
				this.dispose();
				return;
			}
			_myWidth=_bmd.width;
			_myHeight=_bmd.height;
			var _Textuer:Texture=Texture.fromBitmapData(_bmd, false);
			this.texture=_Textuer;
			this.readjustSize();
		}
		/**
		 * 设定 bitmapdata 
		 * @param _bmd
		 * 
		 */		
		public function set bitmapData(_bmd:BitmapData):void{
			if(_bmd == null)
			{
				this.dispose();
				return;
			}
			_myWidth=_bmd.width;
			_myHeight=_bmd.height;
			var _Textuer:Texture=Texture.fromBitmapData(_bmd, false);
			this.texture=_Textuer;
			this.readjustSize();
		}
		/**
		 * 通过纹理显示图片 
		 * @param texture
		 * 
		 */		
		public function myDrawByTexture(texture:Texture):void
		{
			if(texture == null)
			{
				this.dispose();
				return;
			}
			_myWidth=texture.width;
			_myHeight=texture.height;
			this.texture=texture;
			this.readjustSize();
		}
		
		/**
		 * 设定纹理 
		 * @param texture
		 * 
		 */		
		public function set textureSource(texture:Texture):void{
			if(texture == null)
			{
				this.dispose();
				return;
			}
			_myWidth=texture.width;
			_myHeight=texture.height;
			this.texture=texture;
			this.readjustSize();
		}
	}
}