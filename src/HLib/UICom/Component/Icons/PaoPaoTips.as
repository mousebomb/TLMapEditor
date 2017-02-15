package HLib.UICom.Component.Icons
{
	import flash.geom.Rectangle;
	
	import HLib.UICom.BaseClass.HSprite;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.SGCsvManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.SFeather.SFTextField;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.textures.Texture;

	/**通用泡泡tips*/
	public class PaoPaoTips extends HSprite
	{
		private static var _instance:PaoPaoTips
		private var _txt:SFTextField;
		private var _minX:int = 55;
		private var _paoPaoType:int;
		private var _bgScale:Scale9Image;
		private var _leftSide:Scale9Image;
		private var _rightSide:Scale9Image;
		private var _upSide:Scale9Image;
		private var _downSide:Scale9Image;
		public function PaoPaoTips()
		{
			
		}
		
		private function init():void
		{
			this.isInit = true;
			var texture:Texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_FACE_SOURCE, 'background/paopao_0')
			//this.myDrawByTexture(texture);
			var scale9:Scale9Textures = new Scale9Textures(texture, new Rectangle(16, 16, 30, 29));
			_bgScale = new Scale9Image(scale9);
			this.addChild(_bgScale);
			this.myWidth = _bgScale.width = 148;
			this.myHeight = _bgScale.height = 65;
			
			texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_FACE_SOURCE, 'background/paopao_1')
			scale9 = new Scale9Textures(texture, new Rectangle(16, 0, 23, 2));
			_upSide = new Scale9Image(scale9);
			this.addChild(_upSide);
			_downSide = new Scale9Image(scale9);
			this.addChild(_downSide);
			_upSide.x = _downSide.x = 6
			_upSide.width = _downSide.width = this.myWidth - 13;
			_downSide.y = this.myHeight - 2 ;
			
			texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_FACE_SOURCE, 'background/paopao_3')
			scale9 = new Scale9Textures(texture, new Rectangle(0, 8, 6, 33));
			_leftSide = new Scale9Image(scale9);
			this.addChild(_leftSide);
			_leftSide.x = 0; 
			_leftSide.height = myHeight;
			
			texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_FACE_SOURCE, 'background/paopao_4')
			scale9 = new Scale9Textures(texture, new Rectangle(0, 8, 23, 49));
			_rightSide = new Scale9Image(scale9);
			this.addChild(_rightSide);
			_rightSide.height = this.myHeight;
			_rightSide.x = this.myWidth - 7;
			
			
			_txt = new SFTextField;
			_txt.wordWrap = true;
			_txt.myWidth = this.myWidth - 8; 
			this.addChild(_txt);
			this.touchable = false;
		}
		
		public static function get myInstance():PaoPaoTips
		{
			_instance ||= new PaoPaoTips;
			return _instance;
		}
		
		public function showTips(label:String):void
		{
			if(!this.isInit)
				init();
			_txt.label = label;
			_txt.x = this.myWidth - _txt.textWidth >> 1;
			_txt.y = (this.myHeight - _txt.textHeight >> 1) + 1
		}

		public function set paoPaoType(value:int):void
		{
			_paoPaoType = value;
			var str:String = SGCsvManager.getInstance().table_tipsitem.FindCell(value.toString(),"Info").replace(/&/g,"\n");
			showTips(str);
		}

	}
}