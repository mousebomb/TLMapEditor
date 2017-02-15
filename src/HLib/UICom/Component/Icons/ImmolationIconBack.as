package HLib.UICom.Component.Icons
{
	import HLib.UICom.BaseClass.HSprite;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.SourceTypeEvent;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class ImmolationIconBack extends HSprite
	{
		private var _effectImage:Image;
		public function ImmolationIconBack()
		{
			init();
		}
		private function init():void
		{
			this.touchable = false;
			var texture:Texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_19,"immolation/xjget");
			this.myDrawByTexture(texture);
			_effectImage = new Image(texture);
			_effectImage.pivotX = 24;
			_effectImage.pivotY = 24;
			_effectImage.x = 24;
			_effectImage.y = 24
			this.addChild(_effectImage)
		}
	}
}