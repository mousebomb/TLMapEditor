package HLib.UICom.Component.Icons
{
	import HLib.Event.ModuleEventDispatcher;
	import HLib.UICom.BaseClass.HTopBaseView;
	import HLib.UICom.Component.HAlertItem;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.view.roleEquip.ItemIconTipsManage;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	

	public class HGemItem extends HItemIcon
	{
		private var _mIsDown:Boolean;				//鼠标按下标识
		private var _isShow:Boolean;				//显示tips标识
		private var _mIsMove:Boolean;				//鼠标移动标识
		private var _halert:HAlertItem;			//弹出框
		private var _selectBg:Texture;				//锁定选择背景
		public var getShowStrCall:Function;		//回调函数
		
		public function HGemItem()
		{
			super();
		}
		/**经过*/
		override protected function onMouseEvent(e:TouchEvent):void
		{
			if(HTopBaseView.getInstance().hasEvent && !isPierce) 
			{
				if(_isShow)
				{
					_isShow = false;
					ItemIconTipsManage.getInstance().hideItemTips();
				}
				return; //顶层是否添加UI了
			}
			var touch:Touch = e.getTouch(this);
			
			if(!isShowTips || item == null) 
			{
				if(this.itemType != HIconData.IconGemInfoType)
					return;
			}
			if(touch)
			{
				if (touch.phase == TouchPhase.HOVER)//鼠标移动
				{
					if(!this.isLock)
					{
						if(!_mIsDown && !_isShow) {
							_isShow = true;
							ItemIconTipsManage.getInstance().showItemTips(this.item,touch.globalX + 20,touch.globalY, isMy );
						} 	else {
							ItemIconTipsManage.getInstance().moveTips(touch.globalX + 20,touch.globalY );
						}
					}	else {
						if(getShowStrCall)
						{
							var showStr:String = getShowStrCall();
							if(showStr)
							{
								if(!_mIsDown && !_isShow) {
									_isShow = true;
									ItemIconTipsManage.getInstance().showIconTimeTips(-4, this.Idx,touch.globalX + 20,touch.globalY, showStr );
								}	else {
									ItemIconTipsManage.getInstance().moveTips(touch.globalX + 20,touch.globalY );
								}
							}
							
						}
					}
					if(this.itemType == HIconData.IconGemInfoType)
					{
						this.flagIconTexture = selectBg;	
					}	else {
						this.flagIconTexture = flagTexture;
					}
				}
				if (touch.phase == TouchPhase.BEGAN && !_mIsDown)//第一次按下
				{
					_mIsDown = true;
					this.flagIconTexture = null;
					if(_isShow)
					{
						ItemIconTipsManage.getInstance().hideItemTips();
					}
				}
				if (touch.phase == TouchPhase.ENDED) {
					var str:String = "", price:Object;
					if(_mIsDown)
					{
						_mIsDown = false;
						if(this.itemType == HIconData.IconGemInfoType) {
							this.dispatchEventWith('ClickGemitem');
						}	else {
							
							if(item && touch.tapCount >= 2)
							{
								if(!_mIsMove)
								{
									if(this.itemType == HIconData.IconGemInfoType)
									{
										;
									}	else if(this.itemType == HIconData.GemItemType) {
										ModuleEventDispatcher.getInstance().ModuleCommunication("doubleClickGemitem", item);
									}	else if(itemType == HIconData.IconDecompType) {
										ModuleEventDispatcher.getInstance().ModuleCommunication("doubleClickDecompItem", item);
									}
								}	
							}
						}
					}
				}
			}	else {
				_mIsDown = false;
				this.flagIconTexture = null;
				if(_mIsMove)
				{
					_mIsMove = false;
				}
				if(_isShow)
				{
					_isShow = false
					ItemIconTipsManage.getInstance().hideItemTips();
				}
			}
		}
		
		override public function set flagIconTexture(value:Texture):void
		{
			/*if(_isLock)
			{*/
				if(value == null)
				{
					if(_flagIcon)
						_flagIcon.visible = false;
				}	else {
					if(_flagIcon == null)
					{
						_flagIcon = new Image(value);
						_flagIcon.touchable = false;
						this.addChild(_flagIcon);
					}	else if(_flagIcon.texture != value){
						_flagIcon.texture = value;
						_flagIcon.readjustSize();
					}
					if(!_flagIcon.visible)
						_flagIcon.visible = true;
					_flagIcon.x = (this.myWidth - value.width >> 1) + reviseX;
					_flagIcon.y = (this.myHeight - value.height >> 1) + reviseY;
				}
			/*}	else {
				super.flagIconTexture = value;
			}*/
			
		}
		
		
		/** 是否锁上了(true:锁 false:开锁) **/
		override public function set isLock(value:Boolean):void
		{
			_isLock = value;
			//判断是否上锁了,上锁了就显示锁的图片,没有的显示正常背景
			var texture:Texture;
			if(_isLock)
			{
				if(getShowStrCall())
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4,"equiptStrong/icon_lock");
				else 
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4,"equiptStrong/icon_lock_1");
			} 	else {//不是锁住状态显示对应背景
				if(itemType == HIconData.GemItemType || itemType == HIconData.IconDecompType)
					texture = HAssetsManager.getInstance().getMyTexture("itemIconSoruce","Icon_Open")
				else
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4,"equiptStrong/icon_open");
				
			}
			if(!this.myImage || this.myImage.texture != texture)
			{
				myBackTexture = texture;
				this.myDrawByTexture(texture);
			}
		}

		public function get selectBg():Texture
		{
			_selectBg ||= HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4,"equiptStrong/select_bg");
			return _selectBg;
		}

	}
}