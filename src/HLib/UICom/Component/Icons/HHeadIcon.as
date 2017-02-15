package HLib.UICom.Component.Icons
{
	/**
	 * 头像类,内置添加背景图与头像图
	 * @author 李舒浩
	 */	
	import HLib.UICom.BaseClass.HSprite;
	
	import Modules.Common.HAssetsManager;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class HHeadIcon extends HSprite
	{
		private var _headImage:Image;	//头像Image
		
		private var _bgTexture:starling.textures.Texture;
		
		public function HHeadIcon()  {  super();  }
		
		/**
		 * 设置背景
		 * @param $name			: 图片路径
		 * @param $sourceStr	: 
		 */		
		public function setBackground($name:String, $sourceStr:String = "mainInterfaceSource"):void
		{
			if(_bgTexture) _bgTexture.dispose();
			_bgTexture =  HAssetsManager.getInstance().getMyTexture($sourceStr, $name);
			this.myDrawByTexture(_bgTexture);
			updatePosition();
		}
		/**
		 * 设置头像
		 * @param $name			: 头像路径
		 * @param $sourceStr	: 
		 */		
		public function setHead($name:String, $sourceStr:String = "mainInterfaceSource"):void
		{
			var texture:Texture = HAssetsManager.getInstance().getMyTexture($sourceStr, $name);
			if(!texture) return;
			if(_headImage) 
			{
				if(_headImage.texture != texture);
				{
					_headImage.texture = texture;
					_headImage.readjustSize();
				}
			}	else {
				_headImage = new Image(texture);
				this.addChild(_headImage);
			}
			updatePosition();
		}
		/**
		 * 更新位置
		 */		
		private function updatePosition():void
		{
			if(_headImage)
			{
				_headImage.x = (this.myWidth - _headImage.width) >> 1;
				_headImage.y = (this.myHeight - _headImage.height) >> 1;
			}
		}

		

		
	}
}