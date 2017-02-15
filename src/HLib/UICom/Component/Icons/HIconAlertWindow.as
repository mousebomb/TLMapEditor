package HLib.UICom.Component.Icons
{
	import com.greensock.TweenLite;
	
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import HLib.Tool.MyError;
	import HLib.UICom.BaseClass.HBaseView;
	import HLib.UICom.BaseClass.HSprite;
	import HLib.UICom.BaseClass.HTopBaseView;
	import HLib.UICom.Component.HSimpleButton;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.HCss;
	import Modules.Common.SourceTypeEvent;
	import Modules.DataSources.Item;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.SFeather.SFNumericStepper;
	import Modules.SFeather.SFTextField;
	import Modules.view.equiptStrong.IconInputRenderer;
	import Modules.view.roleEquip.ItemIconTipsManage;
	
	import feathers.display.Scale9Image;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * 弹出带物品图标提示框 
	 * @author Administrator
	 * 郑利本
	 */	
	public class HIconAlertWindow extends HSprite
	{
		private var _confirmBtn:HSimpleButton;					//确定按钮
		private var _cancelBtn:HSimpleButton;					//取消按钮
		private var _closeBtn:HSimpleButton;					//关闭按钮
		private var _maxBtn:HSimpleButton;						//最大按钮
		private var _SFNumer:SFNumericStepper;					//数字选择器
		private var _itemIcon:HItemIcon;						//物品图标
		private var _titleImage:Image;							//标题图标
		private var _titleText:String = "title_text/title_extend"
		private var _txtShow:SFTextField;
		private var _txtMoney:SFTextField;
		private var _isClose:Boolean;
		private var _type:int = -1;
		private var _textureArr:Array = [];
		private var _item:Item;
		
		private static var _hIconAlertWindow:HIconAlertWindow;
		private var _txtSpr:Sprite;
		private var _txtSprW:int = 130;
		private var _iconY:int = 97;
		private var _inputRenderer:IconInputRenderer;
		public var sellNum:int;
		private var _sellNum:Number;
		
		public function HIconAlertWindow()
		{
			if(_hIconAlertWindow) throw new MyError();
			_hIconAlertWindow = this;
		}

		public static function getInstance():HIconAlertWindow
		{
			if(!_hIconAlertWindow)
			{
				_hIconAlertWindow = new HIconAlertWindow();
			}
			return _hIconAlertWindow;
		}

		private function Init():void
		{
			var texture:Texture;
			texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, 'reminder_362X240');
			this.myDrawByTexture(texture);
			this.myImage.height = 265;
			
			var bg:Scale9Image = MainInterfaceManage.getInstance().getBackground2Image(309,104);
			bg.touchable = false;
			this.addChild(bg);
			bg.x = this.myWidth - bg.width >> 1;
			bg.y = 72;
			
			texture = HAssetsManager.getInstance().getMyTexture("mainFaceSource",_titleText);
			_textureArr.push(texture);
			_titleImage = new Image(texture);
			this.addChild(_titleImage);
			_titleImage.touchable = false;
			_titleImage.y = 32;
			_titleImage.x = this.myWidth - _titleImage.width >> 1;
			
			_txtShow = new SFTextField;
			_txtShow.leading = 8;
			_txtShow.myWidth = 260;
			this.addChild(_txtShow);
			_txtShow.label = "显示信息";
			_txtShow.y = 93;
			
			_txtMoney = new SFTextField;
			this.addChild(_txtMoney);
			_txtMoney.myWidth = 210;
			_txtMoney.label = "";
			
			_itemIcon = new HItemIcon;
			_itemIcon.myBackTexture = HAssetsManager.getInstance().getMyTexture('mainFaceSource', 'role/equip_9');
			_itemIcon.isPierce = true;
			_itemIcon.isShowText = false;
			_itemIcon.init();
			this.addChild(_itemIcon);
			_itemIcon.x = 50;
			_itemIcon.y = _iconY;
			
			_txtSpr = new Sprite;
			this.addChild(_txtSpr);
			_txtSpr.x = 130;
			_txtSpr.y = 115;
			_SFNumer = new SFNumericStepper;
			_SFNumer.align = TextFormatAlign.CENTER;
			_SFNumer.myExplicitWidth = 90
			_SFNumer.textColor = 0x3988b7;
			_txtSpr.addChild(_SFNumer);
			_SFNumer.minimum = 1;
			_SFNumer.maximum = 999;
			_SFNumer.value = 1;
			_SFNumer.step = 1;
			_SFNumer.addEventListener(SFNumericStepper.CHANGESTARLINGTEXT, changeValue);
			
			_maxBtn = new HSimpleButton;
			_maxBtn.isPierce = true;
			_maxBtn.setAssetsSkin("mainFaceSource","button/btn_max");
			_maxBtn.init();
			_txtSpr.addChild(_maxBtn);
			_maxBtn.x = 95 ;
			_maxBtn.addEventListener(Event.TRIGGERED, onClickMax);
			
			_confirmBtn = new HSimpleButton;
			_confirmBtn.isclearMOuseCursor = _confirmBtn.isPierce = true;
			_confirmBtn.setDefaultSkin();
			_confirmBtn.init("确定");
			this.addChild(_confirmBtn);
			_confirmBtn.addEventListener(Event.TRIGGERED, onClickConfirm);
			_confirmBtn.x = this.myWidth  - _confirmBtn.myWidth >> 1;
			/*_cancelBtn = new HSimpleButton;
			_cancelBtn.isclearMOuseCursor = _cancelBtn.isPierce = true;
			_cancelBtn.setDefaultSkin1();
			_cancelBtn.init("取消");
			this.addChild(_cancelBtn);
			_cancelBtn.addEventListener(Event.TRIGGERED, onClickCancel);
			_cancelBtn.x = this.myWidth * .66 - _cancelBtn.myWidth * .5;
			
			_cancelBtn.y = */
			
			_closeBtn = new HSimpleButton;
			_closeBtn.isclearMOuseCursor = _closeBtn.isPierce = true;
			_closeBtn.setCloseSkin();
			_closeBtn.init();
			this.addChild(_closeBtn);
			_closeBtn.addEventListener(Event.TRIGGERED,onClickClose);
			_closeBtn.x = this.myWidth - _closeBtn.myWidth - 23;
			_closeBtn.y = 23 ;
			
			_inputRenderer = new IconInputRenderer;
			this.addChild(_inputRenderer);
			_inputRenderer.x = 170;
			_inputRenderer.y = 130;
			_inputRenderer.inputHeight = 20;
			_inputRenderer.inputWidth = 90;
			_inputRenderer.restrict = "0-9";
			_inputRenderer.textColor = 0x3988b7;
			_inputRenderer.maxChars = 8;
			_inputRenderer.wordWrap = false;
			this.x = HBaseView.getInstance().myWidth - this.myWidth >> 1;
			this.y = HBaseView.getInstance().myHeight - this.myHeight >> 1;
		}
		
		private function changeValue(e:Event):void
		{
			if(_item == null) return;
			
			if(int(_SFNumer.value) > _item.Item_Num)
				_SFNumer.value = _item.Item_Num;
			var money:int
			if(_type == 2)
			{
				money = _item.Item_ItemValue * int(_SFNumer.value);
				_txtMoney.label = HCss.GeneralColor1 + "14物品总价：" + HCss.HGeneralColor2 + money　;
			} 	else if(_type == 3){
				money = _item.Item_SellPrice * int(_SFNumer.value);
				_txtMoney.label = HCss.GeneralColor1 + "14出售价格 " + HCss.GeneralColor2 + '14' + money　+ HCss.GeneralColor1 + "14 金币";
			}
			
		}
		/**
		 * 装备提示 
		 * @param str
		 * @param type　2、购买物品　3、物品出售　4、物品拆分 5、物品上架 6、物品改价 7、批量使用
		 * @param item
		 * 
		 */		
		public function updateTitleType(str:String,type:int=1,item:Item=null):void
		{
			if(!this.isInit)
				Init()
			var money:int;
			_type = type;
			_item = item;
			if(item)
			{
				_itemIcon.item = item;
				_itemIcon.isShowText = item.Item_OverlapCount > 1 ? true : false;
			}
			if(_inputRenderer.visible)
				_inputRenderer.visible = false;
			_SFNumer.value = 1;
			_itemIcon.x = 50;
			/*_maxBtn.x = 95 ;
			_SFNumer.myExplicitWidth = 90*/
			_confirmBtn.y = 203;
			/*_confirmBtn.y = this.myHeight - 60;*/
			switch(type)
			{
				case 1 ://扩展背包格子
					_txtShow.label = str;
					_txtShow.x = this.myWidth -  _txtShow.textWidth >> 1;
					_txtShow.y = 65 + (104 -  _txtShow.textHeight >> 1);
					_titleText = "title_text/title_extend"
					_txtSpr.visible = _itemIcon.visible = _txtMoney.visible = false;
					break;
				case 2 ://购买物品
					_itemIcon.x = 32;
					_titleText = "title_text/title_items_to_buy";
					if(item == null) break;
					_txtShow.label = HCss.GeneralColor1 + "14物品单价：" + HCss.GeneralColor2 + "14" + item.Item_ItemValue+ "\n" +  HCss.GeneralColor1 + "14购买数量：";
					money = item.Item_ItemValue * int(_SFNumer.value);
					_txtMoney.label = HCss.GeneralColor1 + "14物品总价：" + HCss.GeneralColor2 + "14" + money;
					_sellNum = item.Item_ItemValue;
					/*_SFNumer.myExplicitWidth = _iconY*/
					_txtMoney.x = _txtShow.x = 100;
					_SFNumer.maximum = 99;
					_txtShow.y = 85;
					_txtSpr.y = 110;
					_txtMoney.y = 135;
					_txtSpr.x = 170;
					_txtSpr.visible = true;
					_txtMoney.visible = _itemIcon.visible = true;
					break;
				case 3 ://物品出售
					_titleText = "title_text/title_sell_item";
					_SFNumer.maximum = _item.Item_OverlapCount > 99?_item.Item_OverlapCount:99;
					if(item == null) break;
					_SFNumer.value = _item.Item_Num;
					_txtShow.label = HCss.QualityColorArray[item.Item_Quality] + "14" + item.Item_Name;
					money = item.Item_SellPrice * int(_SFNumer.value);
					_txtMoney.label = HCss.GeneralColor1 + "14出售价格 " + HCss.GeneralColor2 + '14' + money　+ HCss.GeneralColor1 + "14 金币";
					_txtShow.x = _txtSpr.x = _txtSprW;
					if(item.Item_OverlapCount > 1)
					{
						_txtSpr.y = 130;
						_txtShow.y = _iconY;
						_txtSpr.visible = true;
					}	else {
						_txtShow.y = 110;
						_txtSpr.visible = false
					}
					_itemIcon.visible = _txtMoney.visible = true;
					_txtMoney.y = 185
					_confirmBtn.y = 215;
					_txtMoney.x = this.myWidth - _txtMoney.textWidth >> 1;
					break;
				case 4 ://物品拆分
					_titleText = "title_text/title_items_1";
					_SFNumer.maximum = _item.Item_OverlapCount > 99?_item.Item_OverlapCount:99;
					if(item == null) break;
					_txtShow.label =  HCss.QualityColorArray[item.Item_Quality] + "14" + item.Item_Name;
					_txtShow.y = _iconY;
					_txtShow.x = _txtSpr.x = _txtSprW;
					_txtSpr.y = 130;
					_txtSpr.visible = true;
					_itemIcon.visible = true;
					_txtMoney.visible = false;
					break;
				case 5 ://物品上架
					if(item == null) break;
					_itemIcon.x = 32;
					_txtMoney.x = _txtShow.x = 100;
					_titleText = "title_text/title_stall_4";
					/*_SFNumer.myExplicitWidth = 90
					_maxBtn.x = 95 ;*/
					_SFNumer.maximum = _item.Item_OverlapCount > 99?_item.Item_OverlapCount:99;
					_SFNumer.value = _item.Item_Num;
					_txtShow.label = HCss.GeneralColor1 + "14上架数量：";
					_txtMoney.label = HCss.GeneralColor1 + "14物品单价： " 
					_txtSpr.y = _txtShow.y = 97;
					_txtSpr.x = 170;
					_txtSpr.visible = true;
					_txtMoney.visible = _itemIcon.visible = true;
					_txtMoney.y = 130;
					if(!_inputRenderer.isInit)
					{
						_inputRenderer.Init();
						_inputRenderer.iconImage = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "mainUI/player_giftgold");
					}
					if(!_inputRenderer.visible)
						_inputRenderer.visible = true;
					_inputRenderer.inputType = 1;
					_inputRenderer.inputText = "10"
					break;
				case 6 ://物品改价
					_txtMoney.x = _txtShow.x = 100;
					_titleText = "title_text/title_stall_5";
					if(item == null) break;
					_itemIcon.x = 32;
					_txtShow.label = HCss.GeneralColor1 + "14上架数量：" + HCss.GeneralColor2 + "14" + item.Item_Num;
					_txtMoney.label = HCss.GeneralColor1 + "14物品单价： " 
					_txtShow.y = _iconY;
					_txtSpr.visible = false;
					_txtMoney.visible = _itemIcon.visible = true;
					_txtMoney.y = 130;
					if(!_inputRenderer.isInit)
					{
						_inputRenderer.Init();
						_inputRenderer.iconImage = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "mainUI/player_giftgold");
					}
					if(!_inputRenderer.visible)
						_inputRenderer.visible = true;
					_inputRenderer.inputType = 2;
					_inputRenderer.inputText = sellNum + "";
					break;
				
				case 7 ://批量使用
					_titleText =　"title_use" ;// "title_text/title_items_1";
					_SFNumer.maximum = _item.Item_OverlapCount > 99?_item.Item_OverlapCount:99;
					if(item == null) break;
					_txtShow.label = HCss.QualityColorArray[item.Item_Quality] + "14" + item.Item_Name;
					_txtShow.y = _iconY;
					_txtShow.x = _txtSpr.x = _txtSprW;
					_txtSpr.y = 130;
					_txtSpr.visible = true;
					_itemIcon.visible = true;
					_txtMoney.visible = false;
					break;
				case 8 ://物品兑换
					_titleText = "title_text/title_convertNum";
					_SFNumer.value = _item.Item_Num;
					_SFNumer.maximum = _item.Item_OverlapCount > 99?_item.Item_OverlapCount:99;
					if(item == null) break;
					_txtShow.label = HCss.QualityColorArray[item.Item_Quality] + "14" + item.Item_Name;
					_txtShow.y = _iconY;
					_txtShow.x = _txtSpr.x = _txtSprW;
					_txtSpr.y = 130;
					_txtSpr.visible = true;
					_itemIcon.visible = true;
					_txtMoney.visible = false;
					_txtMoney.visible = false;
					break;
			}
			if(_textureArr[type-1] == null)
			{
				var texture:Texture;
				if(type == 7)
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,_titleText);
				else
				 	texture = HAssetsManager.getInstance().getMyTexture("mainFaceSource",_titleText)
				_textureArr[type-1] = texture;
			}
			_titleImage.texture = _textureArr[type-1];
			_titleImage.readjustSize();
			var vx:Number = HBaseView.getInstance().myWidth - _hIconAlertWindow.myWidth >> 1;
			var vy:Number = HBaseView.getInstance().myHeight - _hIconAlertWindow.myHeight >> 1;
			HTopBaseView.getInstance().showFullScreenBg(true);
			HTopBaseView.getInstance().addClickChildWindow(_hIconAlertWindow)
			_hIconAlertWindow.x = vx;
			_hIconAlertWindow.y = vy;
		}
		
		/**点击关闭按钮*/	
		private function onClickClose(e:Event):void
		{
			onClose();
			this.dispatchEventWith("clickAlertClose");
		}
		
		/**点击最大按钮*/	
		private function onClickMax(e:Event):void
		{
			var money:int
			if(_type == 2)
			{
				money = _item.Item_ItemValue * int(_SFNumer.value);
				_txtMoney.label = HCss.GeneralColor1 + "14物品总价：" + HCss.GeneralColor2 + "14" + money;
			} 	else if(_type == 3) {
				money = _item.Item_SellPrice * int(_SFNumer.value);
				_txtMoney.label = HCss.GeneralColor1 + "14出售价格 " + HCss.GeneralColor2 + '14' + money　+ HCss.GeneralColor1 + "14 金币";
			}
			_SFNumer.value = _item.Item_Num;
		}
		
		/**点击确定按钮*/	
		private function onClickConfirm(e:Event):void
		{
			onClose();
			var sellValue:Number = 0;
			if(_type == 5 || _type == 6 || _type == 7 || _type == 8)
				sellValue = int(_inputRenderer.inputText);
			else if(_type == 2)
				sellValue = _sellNum
			else
				sellValue = _item.Item_ItemValue
			this.dispatchEventWith("clickAlertConfirm",false,{type:_type, item:_item, num:_SFNumer.value, sellNum:sellValue});
		}
		
		/**点击取消按钮 */	
		private function onClickCancel(e:Event):void
		{
			onClose();
			this.dispatchEventWith("clickAlertCancel");
		}
		/**关闭界面 */	
		public function onClose():void
		{
			HTopBaseView.getInstance().showFullScreenBg(false);
			if(_isClose) return;
			_isClose = true;
			var timeout:uint = setTimeout(function():void
			{
				_isClose = false;
				clearTimeout(timeout);
			}, 1000);
			
			var tweenLite:TweenLite = TweenLite.to(this, .2, {alpha:0.1,onComplete:myCompleteFunction, onCompleteParams:[this]});
			function myCompleteFunction(_t:HIconAlertWindow):void
			{
				tweenLite.kill();
				_t.alpha=1;
				if(_t.parent)
				{
					_t.parent.removeChild(_t);
					HBaseView.getInstance().clearMOuseCursor()
				}
				_isClose = false;
			}
		}
		
	}
}