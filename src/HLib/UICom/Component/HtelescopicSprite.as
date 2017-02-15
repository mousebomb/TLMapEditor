package HLib.UICom.Component
{
	import HLib.UICom.BaseClass.HBaseView;
	import HLib.UICom.BaseClass.HSprite;
	import HLib.UICom.BaseClass.HTextField;
	
	import Modules.Common.HAssetsManager;
	import Modules.view.equiptStrong.HelpWindow;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class HtelescopicSprite extends HSprite
	{
		public var lanImg:Image;
		private var _hideBtn:HSimpleButton;
		private var _showBtn:HSimpleButton;
		public var sprite:HSprite;
		private var _txtImage:Image;
		private var _TitleTF: HTextField;
		private var _title:String;
		private var mySprite:HSprite;
		private var _helpBtn:HSimpleButton;
		public function HtelescopicSprite(title:String ="")
		{
			_title = title;
			init();
			addEvent();
		}
		
		private function init():void
		{
			mySprite = new HSprite();
			addChild(mySprite);
			
			lanImg = new Image(HAssetsManager.getInstance().getMyTexture('mainFaceSource', 'battle/battleLanBg'));
			mySprite.addChild(lanImg);
			lanImg.width = 190;
			lanImg.x = 50;
			lanImg.y = 16;
			
			if(_title !="")
			{
				var texture:Texture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","title_text/title_" + _title);
				if(texture)
				{
					_txtImage = new Image(texture);
					mySprite.addChild(_txtImage);
					_txtImage.touchable = false;
					_txtImage.x = lanImg.x + (lanImg.width - _txtImage.width >> 1);
					_txtImage.y = 20;
					_TitleTF=new HTextField(lanImg.width,25,'',"宋体",14);
				}	else {
					_TitleTF=new HTextField(lanImg.width,25,_title,"宋体",14);
					//标题文本
					_TitleTF.color = 0xFEFF89;
					_TitleTF.hAlign = "center";
					_TitleTF.bold = true;
				}
				mySprite.addChild(_TitleTF);
			}
			
			_hideBtn = new HSimpleButton;
			_hideBtn.setAssetsSkin("mainFaceSource","button/roll_in");
			_hideBtn.init("");
			this.addChild(_hideBtn);
			
			
			_showBtn = new HSimpleButton;
			_showBtn.setAssetsSkin("mainFaceSource","button/roll_out");
			_showBtn.init("");
			this.addChild(_showBtn);
			_showBtn.visible = false;
			_hideBtn.x = _showBtn.x = lanImg.width - _hideBtn.width + 80;
			
			_helpBtn = HelpWindow.myInstance.getHelpBtn();
			this.addChild(_helpBtn);
			_helpBtn.x = 74;
			_helpBtn.y = 21;
			_helpBtn.visible = false;
			_helpBtn.addEventListener(Event.TRIGGERED, openHelpWindow);
			
			sprite = new HSprite();
		}
		
		private var helpId:int;
		public function setHelpWindowId(_helpId:int):void
		{
			helpId = _helpId;
			_helpBtn.visible = true;
		}
		
		private function openHelpWindow(e:Event):void
		{
			
			HelpWindow.myInstance.showText(helpId);
			HelpWindow.myInstance.addOwner( HBaseView.getInstance());
		}
		
		public function closeHelpWindow():void
		{
			if(HelpWindow.myInstance.isShow)
				HelpWindow.myInstance.onClose();
			_helpBtn.visible = false;
			helpId = 0;
		}
		
		public function setWidth(num:int):void
		{
			lanImg.width = num;
			_hideBtn.x = _showBtn.x = lanImg.width - _hideBtn.width + 80;
			if(_txtImage)
				_txtImage.x = lanImg.x + (lanImg.width - _txtImage.width >> 1);
		}
		
		public function setTitle(str:String,msg:String):void
		{
			var texture:Texture = HAssetsManager.getInstance().getMyTexture(str,msg);
			_txtImage.texture = texture;
			_txtImage.readjustSize();
		}
		
		private function addEvent():void
		{
			_showBtn.addEventListener(Event.TRIGGERED, onClickBtn);
			_hideBtn.addEventListener(Event.TRIGGERED, onClickBtn);
		}
		
		private function removeEvent():void
		{
			_showBtn.removeEventListener(Event.TRIGGERED, onClickBtn);
			_hideBtn.removeEventListener(Event.TRIGGERED, onClickBtn);
		}
		
		private function onClickBtn(e:Event):void
		{
			if(e.currentTarget == _showBtn)
			{
				_hideBtn.visible = true;
				_showBtn.visible = false;	
				sprite.visible = true;
				mySprite.visible = true;
				if(helpId > 0)
					_helpBtn.visible = true;
				
			}	else {
				_showBtn.visible = true;
				_hideBtn.visible = false;
				sprite.visible = false;
				mySprite.visible = false;
				_helpBtn.visible = false;
			}
		}
	}
}