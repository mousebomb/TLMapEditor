package HLib.UICom.Component.Icons
{
	/**
	 * 物品Icon基本显示类
	 * (在HIcon的基础上增加了物品数量显示,锁主物品等功能,如果只是单纯的显示图像请调用HIcon类)
	 * @author 李舒浩
	 * 
	 * 用法:
	 * 		var itemIcon:HItemIcon = new HItemIcon();
	 *		itemIcon.init();
	 *		this.addChild(itemIcon);
	 *		var item:Item = new Item();
	 *		item.refresh("11001");
	 *		itemIcon.item = item;
	 * 		itemIcon.text = 100;
	 * 
	 * 属性与方法:
	 * 		myBackTexture	: 自定义背景图片(如要自定义背景图片需要init方法调用前设置赋值)
	 * 		isDispost	: 在调用clear()方法时是否把改类的所有biemapdata全部dispost掉,如不需要请设置为false
	 * 		init()		: 初始化方法
	 * 		item		: set/get方法,设装备物品数据,设置后物品显示为对应的图品
	 * 		isLock		: 物品锁住状态,调用后显示为锁状(true:锁 false:开锁)
	 * 		qualityBtm	: get方法,物品品质位图
	 * 		itemIconBtm	: get,物品位图
	 * 		text		: set/get方法,物品数量
	 * 		clearContent: 清除内容方法(只清除物品的内容与图片,没有dispost)
	 * 		clear		: 销毁物品内容(完全销毁并dispost)
	 * 
	 * 事件:
	 * 		ClearComponent	: 清除该按钮时派发,一般用于清除内部样式后在外部移除相关事件,从父对象中移除,清空索引等
	 */	
	import flash.geom.Point;
	import flash.text.TextFormatAlign;
	
	import HLib.Event.ModuleEventDispatcher;
	import HLib.Net.Socket.DataType;
	import HLib.Tool.HSuspendTips;
	import HLib.UICom.BaseClass.HBaseView;
	import HLib.UICom.BaseClass.HMovieClip;
	import HLib.UICom.BaseClass.HTopBaseView;
	
	import Modules.Beast.BeastSources;
	import Modules.Common.ComEventKey;
	import Modules.Common.HAssetsManager;
	import Modules.Common.HKeyboardManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.Common.window.BuyWindow;
	import Modules.DataSources.Item;
	import Modules.DataSources.ItemSkep;
	import Modules.DataSources.ItemSources;
	import Modules.HpopMenu.HpopMenuManage;
	import Modules.MainFace.MainFace_ToolBar;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.MainFace.SendMessageManage;
	import Modules.Map.HMapSources;
	import Modules.Mount.MountSources;
	import Modules.SFeather.SFTextField;
	import Modules.Shop.model.ShopVo;
	import Modules.view.IconBag;
	import Modules.view.MyRolePanel;
	import Modules.view.roleEquip.BagItemIcon;
	import Modules.view.roleEquip.EquipItemIcon;
	import Modules.view.roleEquip.ItemIconTipsManage;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class HItemIcon extends HIcon
	{
		protected var _item:Item;					//物品item数据
		private var _itemIndex:int = -1;			//当前格子所在位置
		
		private var _SkepId:int = -1;				//初始化赋值防止与背包第一个格子冲突
		private var _Idx:int = -1;					//初始化赋值防止与背包第一个格子冲突
		
		private var _mIsDown:Boolean;
		protected var _isShow:Boolean;
		private var _mIsMove:Boolean;
		private var _isShowText:Boolean = true	//显示文本
			
		private var _qualityImage:Image;			//品质显示层bitmap
		private var _redBg:Image;					//红色蒙版
		private var _numTextField:SFTextField;		//物品数量
		private var _effect:HMovieClip;			//物品特效
		protected var _isLoad:Boolean;
		private var _numText:String;   			//显示文本
		private var _effectArr:Array = [];			//品质特效数组
		private var _canShowEffect:Boolean = true;//是否显示品质特效
		private var _isClear:Boolean;				//是否清除数据
		private var _isLockOpen:Boolean;			//是否倒计时开启状态
		private var _redTexture:Texture;			//无法使用图标
		private var _lockImage:Image;				//锁定图标
		private var _useTexture:Texture;			//等级不足标志
		
		public var overCallBack:Function;			//移入回调
		public var outCallBack:Function;			//移出回调
		public var clickCallBack:Function;			//点击回调
		
		public var isMy:Boolean = true ;			//是否自己的装备
		public var isShowTips:Boolean = true;		//鼠标经过时是否显示tips
		public var isDispost:Boolean = true;		//在调用clear()方法时是否把改类的所有biemapdata全部dispost掉,如不需要请设置为false
		/**是否显示加锁图标*/
		public var isShowLock:Boolean = false;	//
		public var canMove:Boolean = false;		//是否可拖动
		public var numTextReviseX:int = 0;			//数量文本 X修正值
		public var numTextReviseY:int = 0;			//数量文本 Y修正值
		private var _itemNumColor:String = "#b0d9f113";//数量文本颜色
		private var _IdentIconBack:IdentIconBack;				//鉴定标识
		public var _identOffsetx:int;
		public var _identOffsety:int;	//鉴定标识偏移量
		private var _isNew:Boolean;		//创建标志
		private var _iconTopImage:Image;
	    private var _immolationIconBack:ImmolationIconBack;
		private var _isImmolation:Boolean;
		public function HItemIcon()  {  super();  }
		override public function init():void
		{
			//资源存储
			if(!HAssetsManager.getInstance().isIconItemComloete)
			{
				this.myWidth = this.myHeight = 48;
				ModuleEventDispatcher.getInstance().addEventListener(ComEventKey.HAS_LOAD_COMPLETE,onLoadComplete);
				return;
			}
			_isLoad = true;
			if(this._isNew) return;
			this._isNew = true;
			//初始化设置背景图
			super.init();
			var texture:Texture = HAssetsManager.getInstance().getMyTexture("itemIconSoruce","WP_BG_0")
			_qualityImage = new Image(texture);
			_qualityImage.touchable = false;
			this.addChild(_qualityImage);
			_qualityImage.x = (this.myWidth - 48)/2 + reviseX;
			_qualityImage.y = (this.myHeight - 48)/2 + reviseY;
			_qualityImage.visible = false;
			
			//添加到舞台时执行
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//移出舞台时执行
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoverFromStage);
		}
		private function onAddedToStage(e:Event):void			
		{ 
			playQualityEffect();
		}
		private function onRemoverFromStage(e:Event):void		
		{ 
			stopQualityEffect();
			
			if(_isShow)
			{
				ItemIconTipsManage.getInstance().hideItemTips();
				_isShow = false
			}
		}
		/** 根据id更新物品 **/
		public function refreshById(itemid:int):void{
			if(itemid==0) return;
			var _item:Item=new Item();
			_item.Item_ItemId=itemid;
			_item.RefreshItem(null);
			this.item=_item;
		}
		
		/**
		 * 设置/获取物品数据
		 * @param value	: 物品item
		 */	
		public function set item(value:Item):void
		{
			if(!_isClear && _isLoad && _item == value) 
			{
				if(this.SkepId == ItemSkep.SKEP_ID_0 ) 
					updateRedBg()
				else 
					updateLockImage();
				if(value)
					updateShowItemNum();
				updateIdentImage();
				if(_isShow)
					ItemIconTipsManage.getInstance().showItemTips(this._item,Starling.current.nativeStage.mouseX + 20, Starling.current.nativeStage.mouseY + 20 , isMy, this.SkepId);
				return;
			}
			_item = value;
			if(!this._isLoad)
			{
				ModuleEventDispatcher.getInstance().addEventListener(ComEventKey.HAS_LOAD_COMPLETE,onLoadComplete);
				return;
			}
			if(!_item) 
			{
				super.data = null;
				if(_isShow)
				{
					_isShow = false;
					ItemIconTipsManage.getInstance().hideItemTips();
				}
				hideIdentImage();
				hideIconTop();
				return;
			}
			//设置显示内容图片
			super.data = { Item_IconPack:_item.Item_IconPack, Item_IconName:_item.Item_IconName };
			_isClear = false;
			//设置品质
			var itemQuality:int = _item.Item_Quality-1;
			if(itemQuality >= 0)
			{
				if(itemQuality == 4)
					itemQuality = 5;
				var texture:Texture = HAssetsManager.getInstance().getMyTexture("itemIconSoruce","WP_BG_"+itemQuality);
				if(texture && _qualityImage.texture != texture)
				{
					_qualityImage.texture.dispose();
					_qualityImage.texture = texture;
					_qualityImage.readjustSize();
				}
				if(!_qualityImage.visible)	
					_qualityImage.visible = true;	
				showQualityEffect();
			}	else {
				
				if(_effect && _effect.parent)
				{
					_effect.Stop();
					_effect.parent.removeChild(_effect);
				}
				if(_qualityImage)	
					_qualityImage.visible = false;	
			}
				
			updateShowItemNum()
			updateIdentImage();
			if(this.SkepId == ItemSkep.SKEP_ID_0 || _itemType == HIconData.IconDecompType) 
			{
				updateRedBg();
				if(item.Item_expire)
				{
					this.isDisabled = true;
				}	else {
					this.isDisabled = false;
				}
			}	else  {
				updateLockImage()
				if(SkepId == -5)
					updateRedBg();
			}
		}
		/**更新物品数量显示*/
		private function updateShowItemNum():void
		{
			if(_isShowText)
			{
				if(_numText || (_item.Item_OverlapCount != 1 && _item.Item_Num > 1))
				{
					//物品数量
					getNumTextField();
					if(_numText)
					{
						_numTextField.label = _numText;
						_numText = null;
					} 	else{
						_numTextField.label = _itemNumColor + getNumberFormat(_item.Item_Num);
					} 
					_numTextField.x = this.myWidth - _numTextField.textWidth - 2 + numTextReviseX;
				}	else {
					if(_numTextField)
						_numTextField.visible = false;
				}
			}	else {
				if(_numTextField)
					_numTextField.visible = false;
			}
		}
		/**更新鉴定标识*/
		private function updateIdentImage():void
		{
			if(_item && _item.Item_iconTop > 0)
			{
				var texture:Texture = HAssetsManager.getInstance().getMyTexture("itemIconSoruce","icon_top_" + _item.Item_iconTop);
				if(!_iconTopImage)
				{
					_iconTopImage = new Image(texture);
					_iconTopImage.x = (this.myWidth - texture.width >> 1) + 3
					_iconTopImage.y = (this.myHeight - texture.height >> 1) - 5 
				}
				if(_iconTopImage.texture != texture)
				{
					_iconTopImage.texture = texture;
					_iconTopImage.readjustSize();
				}
				if(!_iconTopImage.parent)
				{
					var index:int = 2;
					if(_effect && _effect.parent)
						index = this.getChildIndex(_effect);
					this.addChild(_iconTopImage);
				}
			}	else {
				hideIconTop();
			}
			
			if(_item && _item.isItemIdentification)
			{
				if(!_IdentIconBack)
				{
					_IdentIconBack = new IdentIconBack;
					_IdentIconBack.skepId = this.SkepId
					_IdentIconBack.x = (this.myWidth - _IdentIconBack.myWidth >> 1) + _identOffsetx;
					_IdentIconBack.y = (this.myHeight - _IdentIconBack.myHeight >> 1) + _identOffsety;
				}
				if(!_IdentIconBack.parent)
					this.addChildAt(_IdentIconBack,3);
			}	else {
				hideIdentImage();
			}
		}
		/**隐藏横幅图标*/
		private function hideIconTop():void
		{
			if(_iconTopImage && _iconTopImage.parent)
				_iconTopImage.parent.removeChild(_iconTopImage);
		}
		/**清除鉴定标识*/
		private function hideIdentImage():void
		{
			if(_IdentIconBack && _IdentIconBack.parent)
				_IdentIconBack.parent.removeChild(_IdentIconBack);
		}
		/**更新背包显示标志*/
		private function updateRedBg():void
		{
			if(_redBg == null)
			{
				_redTexture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","gem_small_icon_5")
				_redBg = new Image(_redTexture);
				_redBg.touchable = false;
				this.addChild(_redBg);
				_redBg.x = this.myWidth - _redBg.width -2;
				_redBg.y = 2 
			}
			_redBg.visible = false;
			if(_item == null) return;
			//显示物品使用标识
			if(_item.Item_JobLimit != 0 && HMapSources.getInstance().mainWizardObject.Creature_Race != _item.Item_JobLimit)
			{//种族限制
				_redBg.visible = true;
				if(_redBg.texture != _redTexture)
				{
					_redBg.texture = _redTexture;
					_redBg.readjustSize();
					_redBg.x = this.myWidth - _redBg.width -2;
				}
			} 	else {
				var isShow:Boolean;
				//坐骑装备
				if(item.Item_Type > 59 && item.Item_Type < 64)
				{
					if(MountSources.getInstance().getMountLevel() < item.Item_LevelLimit )
						isShow= true;
					else
						isShow =false;
				}	else if(item.Item_Type > 64 && item.Item_Type < 69) {
					if(BeastSources.getInstance().petLevel < item.Item_LevelLimit )
						isShow= true;
					else
						isShow =false;
				}else {
					if(HMapSources.getInstance().mainWizardObject.Creature_Level < _item.Item_LevelLimit )
						isShow= true;
					else
						isShow =false;
				}
				_redBg.visible = isShow;
				if(isShow)
				{
					if(!_useTexture)
						_useTexture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","gem_small_icon_6");
					if(_redBg.texture != _useTexture)
					{
						_redBg.texture = _useTexture;
						_redBg.readjustSize();
						_redBg.x = this.myWidth - _redBg.width -2;
					}
				}
			}
			if(_item.Item_NotToSell)
			{//绑定限制
				showLockImage()
			}	else {
				if(_lockImage)
					_lockImage.visible = false;
			}
		}
		/**更新绑定标志*/
		private function updateLockImage():void
		{
			if(_item && isShowLock && _item.Item_NotToSell)
			{//绑定限制
				showLockImage()
			}	else {
				if(_lockImage)
					_lockImage.visible = false;
			}
		}
		/**显示绑定图标*/
		private function showLockImage():void
		{
			if(_lockImage == null)
			{
				var texture:Texture = HAssetsManager.getInstance().getMyTexture("itemIconSoruce","lock")
				_lockImage = new Image(texture);
				this.addChild(_lockImage)
				_lockImage.touchable = false;
				if(_itemType == HIconData.IconGemInfoType)
				{
					_lockImage.y = 15
					_lockImage.x = 15;
				}	else {
					_lockImage.y = 3
					_lockImage.x = 3;
				}
			}	else
				_lockImage.visible = true;
		}
		
		private function onLoadComplete(e:starling.events.Event):void
		{
			// TODO Auto Generated method stub
			if(String(e.data) != "itemIconSoruce")	return;
			_isClear = true;
			_isLoad = true;
			ModuleEventDispatcher.getInstance().removeEventListener(ComEventKey.HAS_LOAD_COMPLETE,onLoadComplete);
			isLock = _isLock;
			init();
			if(_item)
				this.item = _item;
			
		}
		public function get item():Item  {  return _item;  }
		/** 是否开启格子标志(true:锁 false:开锁) **/
		public function set isLock(value:Boolean):void
		{
			/*if(_isLock == value) return;*/
			_isLock = value;
			//判断是否上锁了,上锁了就显示锁的图片,没有的显示正常背景
			if(_isLock)
			{
				if(_isLockOpen)
					backTexture = HAssetsManager.getInstance().getMyTexture("itemIconSoruce","icon_lock_open");
				else
					backTexture = HAssetsManager.getInstance().getMyTexture("itemIconSoruce","Icon_Lock");
			}
			else
				backTexture = HAssetsManager.getInstance().getMyTexture("itemIconSoruce","Icon_Open");
			this.myDrawByTexture(backTexture);
		}
		/**经过*/
		override protected function onMouseEvent(e:TouchEvent):void
		{
			if(!MainInterfaceManage.getInstance().isLoadUI) return;
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
			if(!isShowTips || _item == null) return;
			if(touch)
			{
				if(HIconAlertWindow.getInstance().parent && !isPierce) return;
				if (touch.phase == TouchPhase.HOVER)
				{
					if(!_mIsDown)
					{
						if(!_isShow) {
							_isShow = true;
							ItemIconTipsManage.getInstance().showItemTips(this._item,touch.globalX + 20,touch.globalY + 20 , isMy, this.SkepId);
							if(overCallBack != null) overCallBack(this);
						} 	else {
							ItemIconTipsManage.getInstance().moveTips(touch.globalX + 20,touch.globalY + 20 );
						}	
					}
					
					this.flagIconTexture = flagTexture;
					
				}
				if (touch.phase == TouchPhase.BEGAN && !_mIsDown)
				{
					_mIsDown = true;
					this.flagIconTexture = null;
					if(_isShow)
					{
						//_isShow = false;
						ItemIconTipsManage.getInstance().hideItemTips();
					}
				}
				if (touch.phase == TouchPhase.ENDED) {
					if(_mIsDown)
					{
						_mIsDown = false;
						if(HKeyboardManager.getInstance().isShift)
						{
							ModuleEventDispatcher.getInstance().ModuleCommunication(ComEventKey.MAI_SHOW_GOODS,this.item);
						}	else {
							if(touch.tapCount == 2 && !IconBag.isClickSell && isMy)
							{
								switch(this.SkepId)
								{
									case ItemSkep.SKEP_ID_0 :
										if(ItemSources.getInstance().isOpenStallWindow)
										{
											ModuleEventDispatcher.getInstance().ModuleCommunication("stallAddItem", {item:this.item, idx:this.Idx, bagIdx:-1})
										}	else {
											if( item.Item_Type == 44 ){
												if(HBaseView.getInstance()._MyRolePanel && HBaseView.getInstance()._MyRolePanel.parent)
													HBaseView.getInstance().HideObject("_MyRolePanel");
												else if(HBaseView.getInstance()._MountWindow && HBaseView.getInstance()._MountWindow.parent) 
													HBaseView.getInstance().HideObject("_MountWindow");
												else if(HBaseView.getInstance()._CheckStallWindow && HBaseView.getInstance()._CheckStallWindow.parent) 
													HBaseView.getInstance().HideObject("_CheckStallWindow");
												else if(HBaseView.getInstance()._StallWindow && HBaseView.getInstance()._StallWindow.parent)
													HBaseView.getInstance().HideObject("_StallWindow");
												
												var shopId:int = item.Item_PrivateData[0];
												var disCount:int = item.Item_PrivateData[1];
												var num:int = item.Item_PrivateData[2];
												var uid:Number = item.Item_Guid;
												BuyWindow.getInstance().curGuid = uid;
												BuyWindow.getInstance().disCountItemId = int(item.Item_Id);
												BuyWindow.getInstance().isUsingDisCount = true;
												BuyWindow.getInstance().closeFunc = function():void{
													BuyWindow.getInstance().isUsingDisCount = false;
													BuyWindow.getInstance().curGuid = 0;
													BuyWindow.getInstance().disCountItemId = 0;
												}
												BuyWindow.getInstance().showBuy2("_IconBag", shopId, num, false, false, 0, false, -1, false, true, true, item.Item_PrivateData.length > 2?item.Item_PrivateData[2]:-1,disCount);
											}	else if(item.Item_Type > 64 && item.Item_Type < 69) {////灵兽穿上或者替换
												var peiSkep:int;
												if(BeastSources.getInstance().jionPetId != 0)
													peiSkep =ItemSkep["SKEP_ID_" + (BeastSources.getInstance().jionPetId - 369995)];
												else if(BeastSources.getInstance().currentPetId != 0)
													peiSkep =ItemSkep["SKEP_ID_" + (BeastSources.getInstance().currentPetId - 369995)];
												if(peiSkep == 0) 
												{
													HSuspendTips.ShowTips("请选择出战灵兽！");
													return;
												}
												sendMoveSkepItemMesg(0,this._Idx,peiSkep, _item.Item_Position);
											}	else if(item.Item_Type > 59 && item.Item_Type < 64) {
												sendMoveSkepItemMesg(0,this._Idx, 3, _item.Item_Position );
											}	else if(_item.Item_Type > 21) {
												ItemSources.getInstance().useItem(_item);
											}	else if(_item.Item_Type > 9) {
												if(_item.isItemIdentification)
												{
													if( ItemSources.getInstance().getBagItemNum("110823") < 1 )
													{
														if(HBaseView.getInstance()._MountWindow && HBaseView.getInstance()._MountWindow.parent)
														HBaseView.getInstance().HideObject("_MountWindow");
														if(HBaseView.getInstance()._MyRolePanel && HBaseView.getInstance()._MyRolePanel.parent)
															HBaseView.getInstance().HideObject("_MyRolePanel")
														var vo:ShopVo = new ShopVo;
														vo.reflesh("100110823");
														BuyWindow.getInstance().showBuy("_IconBag",vo);
														HSuspendTips.ShowTips("背包缺少辨识卷轴,可在商城购买");
													} 	else {
														SendMessageManage.getMyInstance().sendIdentMergeGemToSever([_item.Item_Guid]);
													}
												} 	else {
													sendMoveSkepItemMesg(0,this._Idx, 1, _item.Item_Position );
												}
											}
										}
										break;
									case ItemSkep.SKEP_ID_1 :
										if(HBaseView.getInstance()._IconBag && HBaseView.getInstance()._IconBag.parent)//打开背包时
											sendMoveSkepItemMesg(1,_item.Item_Position, 0, ItemSources.getInstance().getBagSpaceIndex());
										else
											HpopMenuManage.getInstance().dispatchEventByType(ComEventKey.CLICK_EQUIPT_WINDOW_0);
										break;
									case ItemSkep.SKEP_ID_3 :
										sendMoveSkepItemMesg(3,_item.Item_Position, 0, ItemSources.getInstance().getBagSpaceIndex());
										break;
									case ItemSkep.SKEP_ID_4 :
										sendMoveSkepItemMesg(4,this._Idx, 0, ItemSources.getInstance().getBagSpaceIndex());
										break;
									case ItemSkep.SKEP_ID_5 ://双击交易栏物品
										SendMessageManage.getMyInstance().sendRemoveTransactIconToSever([this.Idx]);
										break;
									case ItemSkep.SKEP_ID_117 ://双击摆摊栏物品
										SendMessageManage.getMyInstance().sendStallDeleteItemToSever([this.item.Item_Guid]);
										break;
									//灵兽脱下
									case ItemSkep.SKEP_ID_6 :
									case ItemSkep.SKEP_ID_7 :
									case ItemSkep.SKEP_ID_8 :
									case ItemSkep.SKEP_ID_9 :
									case ItemSkep.SKEP_ID_10 :
									case ItemSkep.SKEP_ID_11 :
									case ItemSkep.SKEP_ID_12 :
									case ItemSkep.SKEP_ID_13 :
									case ItemSkep.SKEP_ID_14 :
										sendMoveSkepItemMesg(this.SkepId,this._Idx,0, ItemSources.getInstance().getBagSpaceIndex());
										break;
								}
							}
						}
						if(clickCallBack != null) clickCallBack(this);
					}
					if(_mIsMove)
					{
						var obj:DisplayObject = HBaseView.getInstance().hitTest(new Point(touch.globalX,touch.globalY),true);
						if(obj && obj != this)
						{
							var bag:BagItemIcon
							if(this is EquipItemIcon)//如果是拖动角色界面中的装备
							{
								if(obj is BagItemIcon && obj.parent is IconBag)//在背包中松开
								{
									bag = obj as BagItemIcon;
									if(bag && bag.isLock == false)
									{
										if(bag.item == null )
										{
											if(this.SkepId == ItemSkep.SKEP_ID_3||(this.SkepId >= ItemSkep.SKEP_ID_6 && this.SkepId <= ItemSkep.SKEP_ID_14))	//坐骑装备或者灵兽卸下到背包
												sendMoveSkepItemMesg(this.SkepId, DragIcon.getInstance().item.Item_Position, 0, bag.Idx );
//												MountSources.getInstance().mountSkepDown(ItemSkep.SKEP_ID_3, DragIcon.getInstance().item.Item_Position);
											else									//人物装备卸下到背包
												sendMoveSkepItemMesg(1,DragIcon.getInstance().item.Item_Position, 0, bag.Idx );
										}	else if(DragIcon.getInstance().item.Item_Position == bag.item.Item_Position) {
											if(this.SkepId == ItemSkep.SKEP_ID_3||(this.SkepId >= ItemSkep.SKEP_ID_6 && this.SkepId <= ItemSkep.SKEP_ID_14))	//两个格子间交换装备(坐骑)
												sendMoveSkepItemMesg(this.SkepId,this.item.Item_Position, 0, bag.Idx );
//												MountSources.getInstance().mountSkepDown(ItemSkep.SKEP_ID_3, DragIcon.getInstance().item.Item_Position);
											else									//两个格子间交换装备(人物)
												sendMoveSkepItemMesg(1,DragIcon.getInstance().item.Item_Position, 0, bag.item.Item_Position );
										}
									}
								}
							}	else if(this is BagItemIcon) {//如果是拖动背包中的物品
								if(obj is BagItemIcon)
								{
									if(this.SkepId == ItemSkep.SKEP_ID_0)//拖动背包物品
									{
										bag = obj as BagItemIcon;
										if(bag.SkepId == ItemSkep.SKEP_ID_0)//在背包中松开
										{
											if(bag.isLock == false)
											{
												sendMoveSkepItemMesg(0,this._Idx, 0, bag.Idx );
												sentMoveItemEvent(this,bag);
											}	
										} 	else if(bag.SkepId == ItemSkep.SKEP_ID_4) {//在仓库中松开
											if(bag.isLock == false)
											{
												sendMoveSkepItemMesg(0,this._Idx, 4, bag.Idx );
											}	
										}	else if(bag.SkepId == ItemSkep.SKEP_ID_5) {//在交易栏松开
											if(bag.isLock == false)
											{
												SendMessageManage.getMyInstance().sendAddTransctIconToSever([this._Idx] );
											}	
										}	else if(bag.SkepId == ItemSkep.SKEP_ID_117)	{//在摊位栏松开
											if(bag.isLock == false)
											{
												if(bag.item)
													HSuspendTips.ShowTips("该格子已有物品了");
												else {
													if(this.item.Item_NotToSell)
														HSuspendTips.ShowTips("锁定物品无法上架");
													else
														ModuleEventDispatcher.getInstance().ModuleCommunication("stallAddItem", {item:this.item, idx:this.Idx, bagIdx:bag.Idx})
												}
											}	
										}	else if(bag.SkepId >= ItemSkep.SKEP_ID_6 && bag.SkepId <= ItemSkep.SKEP_ID_14&&this.item.Item_Type > 64 && this.item.Item_Type < 69
										&&this.item.Item_Position == bag.Idx)//灵兽松开
										{
											sendMoveSkepItemMesg(0,this._Idx,bag.SkepId, bag.Idx);
										}	
									}
									else if(this.SkepId == ItemSkep.SKEP_ID_4) {//拖动仓库物品
										bag = obj as BagItemIcon;
										if(bag.SkepId == ItemSkep.SKEP_ID_0)//在背包中松开
										{
											if(bag && bag.isLock == false)
											{
												sendMoveSkepItemMesg(4,this._Idx, 0, bag.Idx );
											}	
										}
										if(bag.SkepId == ItemSkep.SKEP_ID_4)//在仓库中松开
										{
											if(bag && bag.isLock == false)
											{
												sendMoveSkepItemMesg(4,this._Idx, 4, bag.Idx );
											}	
										}
									}	else if(this.SkepId == ItemSkep.SKEP_ID_5) {//拖动交易栏
										bag = obj as BagItemIcon;
										if(bag.SkepId == ItemSkep.SKEP_ID_0)//在背包中松开
										{
											if(bag && bag.isLock == false)
											{
												SendMessageManage.getMyInstance().sendRemoveTransactIconToSever([this.Idx]);
											}	
										}
									}
									
								}
								if(this.SkepId == ItemSkep.SKEP_ID_0 && obj is EquipItemIcon )//在角色界面中松开
								{
									if(EquipItemIcon(obj).SkepId == ItemSkep.SKEP_ID_3)
									{
										//装备坐骑装备
//										MountSources.getInstance().mountSkepUp(DragIcon.getInstance().item.Entity_UID, ItemSkep.SKEP_ID_3, DragIcon.getInstance().item.Item_Position);
										sendMoveSkepItemMesg(0,this._Idx, ItemSkep.SKEP_ID_3, DragIcon.getInstance().item.Item_Position );
									}	else if(obj.parent is MyRolePanel) {
										var equipt:BagItemIcon = obj as EquipItemIcon;
										if(equipt && equipt.Idx == DragIcon.getInstance().item.Item_Position)
										{
											if(DragIcon.getInstance().item.isItemIdentification)
												HSuspendTips.ShowTips("未辨识装备无法穿戴");
											else
												sendMoveSkepItemMesg(0,this._Idx, 1, DragIcon.getInstance().item.Item_Position );
										}
									}
								}
								//拖动物品到技能栏
								if(this.SkepId == ItemSkep.SKEP_ID_0 && obj is HSkillIcon && _item.Item_Type == 30 && obj.parent is MainFace_ToolBar)
								{
									if(_item.Item_PrivateData.length > 1)
									{
										if(_item.Item_LevelLimit > HMapSources.getInstance().mainWizardObject.Creature_Level)
										{
											HSuspendTips.ShowTips("你的等级不够，无法使用该物品");
										}	else
											SendMessageManage.getMyInstance().sendAddSkillToSever([int(_item.Item_PrivateData[1]),DataType.Byte(HSkillIcon(obj).skillNum)]);
									}
									
								}
							}
						}
						this.item = DragIcon.getInstance().item;
						_mIsMove = false;
						DragIcon.getInstance().hideItemIcon();
					}
				}
				if(canMove && touch.phase == TouchPhase.MOVED && _mIsDown)
				{
					if(!IconBag.isClickSell)
					{
						if(this.SkepId == ItemSkep.SKEP_ID_1 && !this.isMy)
						{
						}	else {
							_mIsMove = true;
							DragIcon.getInstance().showItemIcon(this._item,touch.globalX ,touch.globalY);
							this.clearIcon();
						}
					}
				}
			}	else {
				_mIsDown = false;
				this.flagIconTexture = null;
				if(_mIsMove)
				{
					_mIsMove = false;
					DragIcon.getInstance().hideItemIcon();
				}
				if(_isShow)
				{
					_isShow = false;
					ItemIconTipsManage.getInstance().hideItemTips();
					if(outCallBack != null) outCallBack(this);
				}
			}
		}
		
		public function get isLock():Boolean		{  return _isLock;  }
		/** 物品品质位图 **/
		public function get qualityImage():Image	{  return _qualityImage;  }
		/** 设置物品数量显示文字 **/
		public function set text(value:String):void	{ 
			if(_isLoad)
			{
				if(_isShowText)
				{
					getNumTextField();
					if(value.indexOf("/") > -1 || value.indexOf("?") > -1)
						_numTextField.label = _itemNumColor + value;
					else
						_numTextField.label = _itemNumColor + getNumberFormat(Number(value));
					_numTextField.x = this.myWidth - _numTextField.textWidth - 2 + numTextReviseX;
				}	else {
					if(_numTextField)
						_numTextField.visible = false;
				}
			}	else {
				_numText = _itemNumColor +  value;
			}
		}
		public function get text():String			
		{  
			if(_numTextField)
				return _numTextField.label;	
			else if(_numText)
				return _numText;
			else
				return ''
		}
		
		/**  清除内容 **/		
		public function clearContent():void
		{
			if(_isDispose) return;
			if(_mIsMove)
			{
				_mIsMove = false;
				DragIcon.getInstance().hideItemIcon();
			}
			if(_isShow)
			{
				_isShow = false
			}
			this.clearIcon();
		}
		
		override public function clearIcon():void
		{
			_isClear = true;
			super.clearIcon();
			if(_qualityImage) 
				_qualityImage.visible = false;
			if(_numTextField)
				_numTextField.visible = false;
			if(_redBg)
				_redBg.visible = false;
			if(_lockImage)
				_lockImage.visible = false;
			hideIconTop()
			hideQualityEffect();
			hideIdentImage();
		}
		
		
		/** 清除数据 **/
		override public function dispose():void
		{
			if(_isDispose) return;
			//清空内容图片
			super.dispose();
			//移出父类容器
			//制空释放内存
			_item = null;
			_effectArr = null;
			if(_numTextField)
				_numTextField.dispose();
			_numTextField = null;
			if(_redBg)
			{
				_redBg.texture.dispose();
				_redBg.dispose();
				_redBg = null;
			}
			if(_lockImage)
			{
				_lockImage.texture.dispose();
				_lockImage.dispose();
				_lockImage = null;
			}
			if(_qualityImage)
			{
				_qualityImage.texture.dispose();
				_qualityImage.dispose();
				_qualityImage = null;
			}
			if(_effect)
			{
				_effect.Stop();
				_effect.dispose();
				_effect = null;
			}
			this.dispatchEvent(new Event("ClearComponent"));
		}
		

		/**
		 * 当前itemIcon是什么哪里的Icon
		 * @param value	: 与HItemData类对应
		 */		
		public function set itemType(value:int):void  {  _itemType = value;  }
		public function get itemType():int  {  return _itemType;  }

		/**
		 * 当前格子所在位置
		 * @param value	: 格子位置(0~n...)
		 */
		public function set itemIndex(value:int):void  {  _itemIndex = value; }
		public function get itemIndex():int  {  return _itemIndex;  }
		
		/** 对应角色的skepID **/
		public function set SkepId(index:int):void		{  _SkepId=index;		}
		public function get SkepId():int					{  return _SkepId;		}
		/** index(位置) **/
		public function set Idx(index:int):void			{  _Idx=index;			}
		public function get Idx():int						{  return _Idx;			}
		public function get isShowText():Boolean
		{
			return _isShowText;
		}
		/**
		 *　设定文本显示 
		 * @param value
		 * 
		 */
		public function set isShowText(value:Boolean):void
		{
			_isShowText = value;
			if(_isShowText) 
			{
				if(item && _item.Item_Num > 1)
				{
					getNumTextField();
					_numTextField.label = _itemNumColor + getNumberFormat(_item.Item_Num);
					_numTextField.x = this.myWidth - _numTextField.textWidth - 2 + numTextReviseX;
				}	else {
					if(_numTextField)
						_numTextField.visible = false;
				}
			}	else {
				if(_numTextField)
					_numTextField.visible = false;
			}
		}
		private function getNumTextField():void
		{
			if(!_numTextField)
			{
				_numTextField = new SFTextField();
				_numTextField.myWidth = this.myWidth - 6
				_numTextField.hAlign = TextFormatAlign.RIGHT;
				_numTextField.touchable = false;
				this.addChild(_numTextField);
				_numTextField.y = this.myHeight - 17 + numTextReviseY;	
			}	else {
				_numTextField.visible = true;
			}
		}
		
		private function getNumberFormat(num:uint):String
		{
			var str:String =  String(num);
			var len:int = str.length;
			if(len < 6)	return str;
			if(len < 9)	return int(num/10000)+"万";
			if(len > 8)	return int(num/100000000)+"亿";
			return str;
		}
		
		/** 显示物品品质特效 */		
		private function showQualityEffect():void
		{
			if(!_canShowEffect) 
			{
				hideQualityEffect();
				return;
			}
			if(!HAssetsManager.getInstance().getTextureAtlas(SourceTypeEvent.SOURCE_EFFECT_C))
			{	
				ModuleEventDispatcher.getInstance().addEventListener(ComEventKey.HAS_LOAD_COMPLETE, onEffectLoadComplete);
			}	else {
				showIconEffect()
			}
		}
		private function onEffectLoadComplete(event:Event):void
		{
			if(event.data == SourceTypeEvent.SOURCE_EFFECT_C)
			{
				ModuleEventDispatcher.getInstance().removeEventListener(ComEventKey.HAS_LOAD_COMPLETE, onEffectLoadComplete);
				showIconEffect();
			}
		}
		private function showIconEffect():void
		{
			if(!_item) return;
			var textures:Vector.<Texture>;
			var index:int = _effectArr.indexOf(_item.Item_Quality);
			if(index < 0)
			{
				textures = HAssetsManager.getInstance().getMyTextures(SourceTypeEvent.SOURCE_EFFECT_C,"effect/Item_Quality_" + _item.Item_Quality);
			}	else 
				textures = _effectArr[index];
			if(textures==null || textures.length == 0)
			{
				textures = HAssetsManager.getInstance().getMyTextures(SourceTypeEvent.SOURCE_EFFECT_C,"effect/Item_Quality_" + _item.Item_Quality);
			}
			if(!textures) return;
			if(_effect == null)
			{
				_effect = new HMovieClip;
				_effect.PlaySpeed = 5
				_effect.touchGroup = true;
				_effect.touchable = false;
			}
			_effect.setTextureList(textures);
			if(!_effect.parent || _effect.parent != this)
			{
				this.addChildAt(_effect, 3);
			}
			_effect.Play();
			var vy:int = 56;
			if(_item.Item_Quality == 5)
				vy = 64
			_effect.x = (this.myWidth - vy >> 1) + reviseX;
			_effect.y = (this.myHeight - vy >> 1) + reviseY;
				
		}
		/** 隐藏物品品质特效 */		
		public function hideQualityEffect():void
		{
			if(_effect)
			{
				_effect.Stop();
				if(_effect.parent)
					_effect.parent.removeChild(_effect);
			}
		}
		/**播放特效*/
		public function playQualityEffect():void
		{
			if(_effect && _effect.parent && !_effect.IsornotPlay)
				_effect.Play();
		}
		/**停止特效*/
		public function stopQualityEffect():void
		{
			if(_effect && _effect.IsornotPlay)
				_effect.Stop();
		}
		/** 移动物品		 */
		protected function sendMoveSkepItemMesg(startSkepID:int, startIdx:int, endSkepID:int, endIdx:int):void
		{
			if(endIdx == -1)
				HSuspendTips.ShowTips("背包没有多余格子，请先清理");
			else
				SendMessageManage.getMyInstance().sendMoveSkepItemToSever([startSkepID, startIdx, endSkepID, endIdx]);
		}
		/** 移动物品派发事件给当前的提示窗口		 */
		private function sentMoveItemEvent(_this:HItemIcon,_bag:BagItemIcon):void
		{
			/*if(EquipmentPromptWindow.getIntance().isOpen)
			{
				 var MoveItems:Array = new Array(_this,_bag);
				  ModuleEventDispatcher.getInstance().dispatchEventWith("MOVEITEMLOCATIONEVENT",false,MoveItems);	
			}*/
			  
		}

		public function get isLoad():Boolean
		{
			return _isLoad;
		}

		public function set isLoad(value:Boolean):void
		{
			_isLoad = value;
		}

		public function get canShowEffect():Boolean
		{
			return _canShowEffect;
		}

		public function set canShowEffect(value:Boolean):void
		{
			_canShowEffect = value;
			if(!value)
			{
				this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoverFromStage);
			}
		}

		public function get isLockOpen():Boolean
		{
			return _isLockOpen;
		}
		
		/** 是否开启状态 **/
		public function set isLockOpen(value:Boolean):void
		{ 
			_isLockOpen = value;
			this.isLock = _isLock;
		}

		/**
		 * 物品数量文本颜色
		 * @param value
		 * 
		 */
		public function set itemNumColor(value:String):void
		{
			_itemNumColor = value;
		}

		public function get isImmolation():Boolean
		{
			return _isImmolation;
		}

		public function set isImmolation(value:Boolean):void
		{
			_isImmolation = value;
			if(_isImmolation){
				if(!_immolationIconBack)
					_immolationIconBack = new ImmolationIconBack;
					_immolationIconBack.x = (this.myWidth - _immolationIconBack.myWidth >> 1) + _identOffsetx;
					_immolationIconBack.y = (this.myHeight - _immolationIconBack.myHeight >> 1) + _identOffsety;
					
				    if(!_immolationIconBack.parent)
					    this.addChildAt(_immolationIconBack,3);
			}else
			{
				if(_immolationIconBack && _immolationIconBack.parent)
					_immolationIconBack.parent.removeChild(_immolationIconBack);
			}
		}


	}
}