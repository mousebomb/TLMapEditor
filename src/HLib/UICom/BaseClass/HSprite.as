package HLib.UICom.BaseClass
{
	/**
	 * 对象sprite基类,所有继承Sprite类都继承此类方便以后扩张 
	 */	
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class HSprite extends Sprite
	{
		public var isInit:Boolean = false;
		
		private var _myWidth:Number = 0;
		private var _myHeight:Number = 0;
		private var _Image:Image;
		private var _clickRectangle:Rectangle;			//事件穿透点击区域
		/**是否事件穿透*/
		public var isPierce:Boolean;					//
		public var isLongShow:Boolean = false;
		/**贴图混合标志true为开启，默认关闭*/
		public var needBlendMode:Boolean;				//是否需要贴图混合标志
		public function HSprite()
		{
			super();
		}
		public function set myWidth(value:Number):void
		{
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
		 * 通过一个纹理创建图片 
		 * @param _Textuer
		 * 
		 */		
		public function myDrawByTexture(_Textuer:Texture):void{
			if(_Textuer)
			{
				_myWidth=_Textuer.width;
				_myHeight=_Textuer.height;
				if(!_Image){ 
					_Image=new Image(_Textuer);
					this.addChildAt(_Image,0);
					/*if(needBlendMode)
						_Image.blendMode = BlendMode.SCREEN;*/
				}else{
					/*if(_Image.texture !=_Textuer)
					{*/
						_Image.texture=_Textuer;
						_Image.readjustSize();	
					/*}*/
				}
			}
			isInit = true;
		}
		
		public override function dispose():void
		{
			if(_Image && !(this is HWindow))
			{
				_Image.texture.dispose();
				_Image.dispose();
			}
			super.dispose();
		}

		public function disposeMyImage():void
		{
			if(_Image)
			{
				_Image.texture.dispose();
				_Image.dispose();
				_Image = null;
			}
		}
		public function get myImage():Image
		{
			return _Image;
		}

		public function set myImage(value:Image):void
		{
			_Image = value;
		}
		
		public function get clickRectangle():Rectangle
		{
			return _clickRectangle;
		}
		/**事件穿透点击区域*/
		public function set clickRectangle(value:Rectangle):void
		{
			_clickRectangle = value;
		}
	}
}