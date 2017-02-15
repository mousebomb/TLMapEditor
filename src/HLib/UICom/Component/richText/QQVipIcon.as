package HLib.UICom.Component.richText
{
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class QQVipIcon extends Image
	{
		private var _myWidth:int;

		public function QQVipIcon(texture:Texture)
		{
			super(texture);
		}
		
		public function get myWidth():int
		{
			return _myWidth;
		}

		public function set myWidth(value:int):void
		{
			_myWidth = value;
		}
	}
}