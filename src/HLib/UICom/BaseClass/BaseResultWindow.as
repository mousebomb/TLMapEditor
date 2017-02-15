package HLib.UICom.BaseClass
{
	import HLib.Tool.Tool;
	
	import starling.textures.Texture;

	public class BaseResultWindow extends HSprite
	{
		private var _effectMov:HMovieClip;
		public function BaseResultWindow()
		{
		}
		
		public function init():void
		{
			
		}
		
		public function showBg(texture:Texture):void
		{
			this.myDrawByTexture(texture);
		}
		
		public function showResultEffect(vector:Vector.<Texture>, isShowFilter:Boolean):void
		{
			if(!_effectMov)
				_effectMov = new HMovieClip;
			_effectMov.setTextureList(vector);
			this.addChildAt(_effectMov, 0);
			_effectMov.x = this.myWidth - _effectMov.myWidth >> 1;
			_effectMov.y = this.myHeight - _effectMov.myHeight >> 1;
			_effectMov.Play();
			if(isShowFilter)
			{
				if(!_effectMov.filter)
				{
					_effectMov.filter = Tool.getGrayColorMatrixFilter();
				}	
			}	else {
				if(_effectMov.filter)
				{
					_effectMov.filter.dispose();
					_effectMov.filter = null;
				}
			} 
		}
	}
}