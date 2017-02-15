package HLib.UICom.BaseClass
{
	import Modules.Common.HAssetsManager;
	
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * 计时器位图显示类 
	 * @author Administrator
	 * 郑利本
	 */
	public class HTimeText extends HSprite
	{
		private var _timeType:int;											//文本显示显类型 0、h:m:s ; 1、m:s
		private var _intervalTexture:Texture;								//间隔图片
		private var _textureVector:Vector.<Texture> = new Vector.<Texture>; 	//数字图片0-9
		private var _imageVector:Array = [];
		public function HTimeText()
		{
			textureSource();
		}

		public function set timeType(value:int):void
		{
			_timeType = value;
		}

		public function set intervalTextur(value:Texture):void
		{
			_intervalTexture = value;
		}

		/**
		 * 0-9数字资源 
		 * @param source
		 * @param name
		 * 
		 */		
		public function textureSource(source:String="mainInterfaceSource", name:String="number/time_text_", intervalT:String="number/time_text_"):void
		{
			var vx:int;
			var image:Image;
			var texture:Texture;
			_textureVector.length = 0;
			for(var i:int=0; i<10; i++)
			{
				texture = HAssetsManager.getInstance().getMyTexture(source, name + i);
				_textureVector.push(texture);
				if(i < 8)
				{
					image = _imageVector[i];
					if(!image)
					{
						image = new Image(texture);
						_imageVector.push(image);
					}
					this.addChild(image);
				}
			}
			if(intervalT)
				_intervalTexture = HAssetsManager.getInstance().getMyTexture(source, intervalT);
		}
		/**更新时间*/		
		public function updateTime(allTime:int):void
		{
			var arr:Array ;
			var typeStr:String ;
			var hour:uint = allTime/3600;
			var minute:uint = allTime%3600/60;
			var second:uint = allTime%3600%60;
			var image:Image;
			var texture:Texture;
			var vx:int;
			if(_timeType == 0)
			{
				typeStr = "h:m:s";
				typeStr = typeStr.replace('h',hour<10?'0'+hour:hour).replace('m',minute<10?'0'+minute:minute).replace('s',second<10?'0'+second:second);
				arr = typeStr.split("");
				for(var i:int=0; i<8; i++)
				{
					if(arr[i] == ":")
						texture = _intervalTexture;
					else 
						texture = _textureVector[int(arr[i])];
					image = _imageVector[i];
					if(image.texture != texture)
					{
						image.texture = texture;
						image.readjustSize();
					}
					image.x = vx;
					if(arr[i] == ":")
						vx += 6;
					else
						vx += 12;
				}
				this.myWidth = vx;
			}
		}
	}
}