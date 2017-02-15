package HLib.UICom.Component.Icons
{
	import flash.geom.Rectangle;
	
	import HLib.UICom.BaseClass.HXYSprite;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.HCss;
	import Modules.Common.SourceTypeEvent;
	import Modules.DataSources.Buff;
	import Modules.SFeather.SFTextField;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.textures.Texture;

	/**
	 * buff显示tips类 
	 * @author Administrator
	 * 郑利本
	 */	
	public class HBuffTips extends HXYSprite
	{
		private var _backgroundImage:Scale9Image;
		private var _tipsWidth:Number = 180;
		private var _textField:SFTextField;
		private var _txtItemName:SFTextField;
		private var _buff:Buff;					//buff数据
		private var _lineImage:Scale9Image;
		public function HBuffTips()
		{
			super();
		}
		
		public function init():void
		{
			this.touchable = false;
			var texture:Texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"background/tips_background");
			var scale9:Scale9Textures = new Scale9Textures(texture,new Rectangle(6,6,4,4));
			_backgroundImage = new Scale9Image(scale9);
			this.addChild(_backgroundImage);
			_backgroundImage.width = _tipsWidth;
			this.myWidth = _tipsWidth;
			
			_txtItemName = new SFTextField;
			_txtItemName.myWidth = _tipsWidth - 16;
			_txtItemName.x = _txtItemName.y = 8;
			this.addChild(_txtItemName);
			
			_textField = new SFTextField;
			_textField.wordWrap = true;
			_textField.leading = 4;
			_textField.myWidth = _tipsWidth - 12;
			this.addChild(_textField);
			_textField.x = 8;
			_textField.y = 35;
			
			texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"background/tips_line");
			scale9 = new Scale9Textures(texture, new Rectangle(12,1,8,1));
			_lineImage = new Scale9Image(scale9);
			this.addChild(_lineImage);
			_lineImage.x = 8;
			_lineImage.y = 30;
			_lineImage.width = _tipsWidth - 16;
		}
		
		private var isshowTipsTime:Boolean;
		public function refreshBuff(buff:Buff,showTipsTime:Boolean):void
		{
			_buff = buff;
			isshowTipsTime = showTipsTime;
			if(buff == null) return;
			var _ponsitionY:Number;
			var str:String
			if(buff.timeType == 1)
				str = '卡已暂时冻结  '
			else
				str = '';
			_txtItemName.label = HCss.Questcolr2  + "14" + buff.name;
			/*_txtItemName.x = _tipsWidth - _txtItemName.textWidth >> 1;*/
						
			var tips:String;
			if(buff.overlapTimes > 1)
				tips= buff.desc.replace(/d/g,buff.currentTimes * buff.BuffEffectValue);
			else
				tips= buff.desc
			if(isshowTipsTime)
			{
				if(buff.remainTime < 0)
				{
					str = "持续有效";
				} 	else {
					var hours:int = buff.remainTime / 3600;
					if(hours > 9)
						str += hours + ':';
					else
						str += '0' + hours + ':';
					var minutes:int = (buff.remainTime - hours * 3600) / 60;
					if(minutes > 9)
						str += minutes  + ':';
					else
						str += '0' + minutes + ':';
					var seconds:int = buff.remainTime - hours * 3600 - minutes * 60;
					if(seconds > 9)
						str += seconds ;
					else
						str += '0' + seconds;
				}
			}
			_textField.label = HCss.HGeneralColor1 + tips+ "\n#00ff0012" + str ;
			_ponsitionY = _textField.y + _textField.textHeight + 8 ;
			this.myHeight = _backgroundImage.height = _ponsitionY ;
		}
		
		public function updateTipsTime():void
		{
			var hours:int = _buff.remainTime / 3600;
			var str:String = '';
			if(_buff.timeType == 1)
				str = '卡已暂时冻结  '
			else
				str = '';
			if(hours > 9)
				str += hours + ':';
			else
				str += '0' + hours + ':';
			var minutes:int = (_buff.remainTime - hours * 3600) / 60;
			if(minutes > 9)
				str += minutes  + ':';
			else
				str += '0' + minutes + ':';
			var seconds:int = _buff.remainTime - hours * 3600 - minutes * 60;
			if(seconds > 9)
				str += seconds ;
			else
				str += '0' + seconds	;	
			
			var tips:String;
			if(_buff.overlapTimes > 1)
				tips = _buff.desc.replace(/d/g,_buff.currentTimes * _buff.BuffEffectValue);
			else
				tips = _buff.desc
			_textField.label = HCss.HGeneralColor1 + tips + "\n#00ff0012" + str ;
			
		}
	}
}