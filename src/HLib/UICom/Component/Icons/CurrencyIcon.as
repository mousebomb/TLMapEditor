package HLib.UICom.Component.Icons
{
	/**
	 * 货币icon
	 * @author 李舒浩
	 */	
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.DataSources.Item;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class CurrencyIcon extends Image
	{
		/**
		 * 更新货币ID
		 * @param value	: item表ID
		 */		
		public function set currencyID(value:int):void
		{
			_currencyID = value;
			
			if(_texture) _texture.dispose();
			var index:int = _currencyID/100000 - 1;
			_texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, _textureVec[index]);
			updateTexture();
		}
		public function get currencyID():int  {  return _currencyID;  }
		private var _currencyID:int;

		
		private var _item:Item;
		private var _texture:Texture;
		private var _textureVec:Vector.<String> = Vector.<String>(["mainUI/player_giftgold", "mainUI/player_money", "mainUI/player_gold"]);
		/**
		 * 
		 * @param $id	: item表ID
		 */		
		public function CurrencyIcon($id:int)
		{
			var index:int = $id/100000 - 1;
			_texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, _textureVec[index]);
			super(_texture);
		}
		
		private function updateTexture():void
		{
			this.texture = _texture;
		}
	}
}