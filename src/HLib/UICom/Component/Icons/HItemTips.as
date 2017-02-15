package HLib.UICom.Component.Icons
{
	import flash.geom.Rectangle;
	
	import HLib.MapBase.HMapData;
	import HLib.Tool.HSysClock;
	import HLib.Tool.Tool;
	import HLib.UICom.BaseClass.HXYSprite;
	
	import Modules.Beast.BeastSources;
	import Modules.Common.HAssetsManager;
	import Modules.Common.HCss;
	import Modules.Common.SGCsvManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.DataSources.Bless;
	import Modules.DataSources.Item;
	import Modules.DataSources.Skill;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.Map.HMapSources;
	import Modules.Mount.MountSources;
	import Modules.Qihun.controller.QihunController;
	import Modules.SFeather.SFTextField;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * 物品图标显示类 
	 * @author Administrator
	 * 郑利本
	 */	
	public class HItemTips extends HXYSprite
	{
		private var _backgroundImage:Scale9Image;		//背景图标
		private var _itemIcon:HItemIcon;				//图标显示
		private var _textField:SFTextField;			//展示文本
		private var _txtItemName:SFTextField;			//物品名称
		private var _txtInfo:SFTextField;				//物品说明
		private var _tipsStr_1:String = "";
		private var _tipsStr_2:String = "";
		private var _tipsWidth:int = 246;
		private var _inlayProperty:InlayProperty;		//镶嵌属性
		private var _txtAddProperty:SFTextField;		//附加属性
		private var _txtOtherProperty:SFTextField;　　	//鉴定属性
		protected var _lineHeight:int = 6;				//线条间隔
		protected var _lineArr:Vector.<Scale9Image>	//间隔线
		protected var _lineID:int;						//间隔线id
		protected var _ponsitionY:Number=0;			//定位值
		protected var _txtProperty:SFTextField;		//物品属性
		protected var _txtStrongProperty:SFTextField;
		private var _isShowSell:Boolean = true;		//显示出售价格
		private var _equiptIcon:Image;					//已装备图标
		private var _txtExpire:SFTextField;
		private var _qihunLine:Scale9Image;
		private var _txtQihun:SFTextField;
		private var _skill:Skill;
		private var _info:Object;
		private var _identifyInfoArr:Array;
		private var _maxRecoinTimes:int;
		private var _maxStrongLevel:int;
		//protected var _textPower:SFTextField;		//战斗力
		protected var _equiptPower:EquiptPower
		private var _hmapData:HMapData;				//地图数据
		public function HItemTips()
		{
			super();
			this.touchable = false;
			this.touchGroup = true;
		}
		
		/**鉴定最大值*/
		public function maxIdentifyTimes(itemLevel:int):int
		{
			if(!_identifyInfoArr)
			{
				_identifyInfoArr = String(info.Param2).split("|");
			}
			var leng:int = _identifyInfoArr.length;
			for(var i:int=0; i<leng; i+=2){
				if(itemLevel < int(_identifyInfoArr[i])){
					return int(_identifyInfoArr[i+1]);
				}
			}
			return int(_identifyInfoArr[_identifyInfoArr.length - 1]);
		}
		/**最大重铸次数*/
		public function get maxRecoinTimes():int
		{
			if(_maxRecoinTimes == 0)
			{
				_maxRecoinTimes = int(info.Param3);
			}
			return _maxRecoinTimes
		}
		/**最大强化次数*/
		public function get maxStrongLevel():int
		{
			if(_maxStrongLevel == 0)
			{
				_maxStrongLevel = int(info.Param1);
			}
			return _maxStrongLevel
		}

		public function get info():Object
		{
			_info ||= SGCsvManager.getInstance().table_coef.FindToObject("Item_Strong_Info");
			return _info;
		}

		public function get isShowSell():Boolean
		{
			return _isShowSell;
		}

		public function set isShowSell(value:Boolean):void
		{
			_isShowSell = value;
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
			_txtItemName.y = 10;
			this.addChild(_txtItemName);
			//物品使用等级
			_textField = new SFTextField;
			_textField.leading = 4;
			_textField.myWidth = _tipsWidth - 16;
			this.addChild(_textField);
			_textField.x = 8;
			_textField.y = 48;
			_textField.hAlign = "right";
			//物品图标
			_itemIcon = new HItemIcon;
			_itemIcon.isShowText = false;
			_itemIcon.myBackTexture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"mainUI/equip_9");
			_itemIcon.init();
			this.addChild(_itemIcon);
			_itemIcon.x = 20;
			_itemIcon.y = 48;
			//物品基础属性
			_txtProperty = new SFTextField;
			_txtProperty.leading = 5;
			_txtProperty.myWidth = _tipsWidth - 28;
			this.addChild(_txtProperty);
			_txtProperty.x = 20;
			_txtProperty.y = 114;
			//物品强化基础属性
			_txtStrongProperty = new SFTextField;
			_txtStrongProperty.leading = 5;
			_txtStrongProperty.myWidth = 80;
			this.addChild(_txtStrongProperty);
			_txtStrongProperty.y = 137;
			//物品附加属性
			_txtAddProperty = new SFTextField;
			_txtAddProperty.leading = 5;
			_txtAddProperty.myWidth = _tipsWidth - 28;
			this.addChild(_txtAddProperty);
			_txtAddProperty.x = 20;
			//物品鉴定属性
			_txtOtherProperty = new SFTextField;
			_txtOtherProperty.leading = 5;
			_txtOtherProperty.myWidth = _tipsWidth - 28;
			this.addChild(_txtOtherProperty);
			_txtOtherProperty.x = 20;
			
			//镶嵌属性
			_inlayProperty = new InlayProperty;
			_inlayProperty.myWidth = _tipsWidth - 28;
			_inlayProperty.init();
			this.addChild(_inlayProperty);
			_inlayProperty.x = 20;
			
			_txtInfo = new SFTextField;
			_txtInfo.wordWrap = true;
			_txtInfo.leading = 5;
			_txtInfo.myWidth = _tipsWidth - 28;
			_txtInfo.x = 20;
			this.addChild(_txtInfo);
			
			_equiptPower = new EquiptPower;
			this.addChild(_equiptPower);
			_equiptPower.x = 16;
			
			var scale9I:Scale9Image;
			_lineArr  = new <Scale9Image>[];
			texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"background/tips_line");
			scale9 = new Scale9Textures(texture, new Rectangle(12,1,8,1));
			for(var i:int=0; i<7; i++)
			{
				scale9I = new Scale9Image(scale9);
				scale9I.width = _tipsWidth - 16;
				scale9I.x = 8;
				this.addChild(scale9I);
				_lineArr.push(scale9I);
			}
			_lineArr[0].y = 39;
			_lineArr[1].y = 108;
			
			_info ||= SGCsvManager.getInstance().table_coef.FindToObject("Item_Strong_Info");
		}
		/**
		 * 设置tips显示数据
		 * @param _Item			: 物品数据
		 * @param isMy			: 是否是自已的装备对比
		 * @param compareValue	: 背包对比项的总属性值
		 * @param isMyEquip		: 是否为自己的物品
		 * @param skepId		: 当前tips所在的skepID是什么
		 */	
		public function RefreshData(item:Item,isMy:Boolean=false, skepId:int = -1,compareValue:Number=0, isMyEquip:Boolean = true):void
		{
			for(var i:int=2; i<7; i++)
			{
				_lineArr[i].visible = false;
			}
			if(!item.Item_ItemExp) return;
			_itemIcon.item = item;
			if(item.Item_Type == 105){
				_tipsStr_1 = HCss.QualityColorArray[item.Item_Quality] + "15bn00" + item.Item_Name + " " + (item.Item_RecoinTimes > 0?item.Item_RecoinTimes:1) + "级";
			}else{
				_tipsStr_1 = HCss.QualityColorArray[item.Item_Quality] + "15bn00" + item.Item_Name + " ";
				if(item.Item_StrongLevel > 0)
					_tipsStr_1 += "+" + item.Item_StrongLevel;
			}
			
			_txtItemName.eventLabel = _tipsStr_1;
			_txtItemName.x = this.myWidth - _txtItemName.textWidth >> 1;
			
			/*_tipsStr_2 = HCss.TipsColor1 + "13──────────────────"+ "\n";*/
			var colorStr:String = "";
			/*if(item.Item_LevelLimit < 1)
				item.Item_LevelLimit = 1;*/
			var headStr:String ;
			//坐骑装备
			if(item.Item_Type > 59 && item.Item_Type < 64)
			{
				if(MountSources.getInstance().getMountLevel() < item.Item_LevelLimit )
					colorStr = HCss.TipsColor9 + "13"+ item.Item_LevelLimit + "   \n ";
				if(colorStr == "")
				{
					if(item.Item_LevelLimit == 0)
						colorStr = "无限制\n ";
					else
						colorStr = item.Item_LevelLimit + "   \n ";
				}
				headStr = HCss.TipsColor1 + "13需要坐骑等级：";
			}	else if(item.Item_Type > 64 && item.Item_Type < 69) {
				if(BeastSources.getInstance().petLevel < item.Item_LevelLimit )
					colorStr = HCss.TipsColor9 + "13"+ item.Item_LevelLimit + "   \n ";
				if(colorStr == "")
				{
					if(item.Item_LevelLimit == 0)
						colorStr = "无限制\n ";
					else
						colorStr = item.Item_LevelLimit + "   \n ";
				}
				headStr = HCss.TipsColor1 + "13需要宠物等级：";
			}	else if(item.Item_Type == 105) {
				headStr = HCss.TipsColor1 + "13需要等级："
				colorStr = "无限制\n ";
			}	else {
				if(HMapSources.getInstance().mainWizardObject.Creature_Level < item.Item_LevelLimit )
					colorStr = HCss.TipsColor9 + "13"+ item.Item_LevelLimit + "   \n ";
				if(colorStr == "")
				{
					if(item.Item_LevelLimit == 0)
						colorStr = "无限制\n ";
					else
						colorStr = item.Item_LevelLimit + "   \n ";
				}
				headStr = HCss.TipsColor1 + "13需要等级："
			}
			_tipsStr_2 = headStr + colorStr + 
				getItemType(item.Item_JobLimit,"Item_JobLimit") + "  " + getItemType(item.Item_Type,"Item_Type") + "   \n" + 
				HCss.QualityColorArray[item.Item_Quality] + "13品质：" + HCss.QualityStringArray[item.Item_Quality] + "\n";
			
			_textField.label = _tipsStr_2;
			_textField.x = this.myWidth - _textField.textWidth - 18;
			_lineID = 2;
			_ponsitionY = 114;
			
			if(item.Item_Type > 9 && item.Item_Type < 22 || item.Item_Type > 59 && item.Item_Type < 70 || (item.Item_Type == 70 && item.Item_Position > 0))
				showItemPower(_itemIcon.item);
			else 
				_equiptPower.visible = false;
			var itemExp:String = item.Item_ItemExp.replace(/\\n/g,"\n")
			var str:String;
			_txtProperty.y = _ponsitionY;
			if(item.Item_Type == 86 && _itemIcon.item.Item_Attack > 0)
			{
				//藏宝图显示修改
				showTreasureMap();
			} 	else if((item.Item_Type == 70 && item.Item_Position == 0) || item.Item_Type < 10) {
				_txtStrongProperty.visible = false;
				_inlayProperty.visible = _txtOtherProperty.visible = _txtAddProperty.visible = false;
				str= HCss.TipsColor8 + "13物品说明：" + itemExp;
				_txtProperty.wordWrap = true;
				_txtProperty.label = str;
				_ponsitionY += _txtProperty.textHeight + _lineHeight;
				_backgroundImage.height = _ponsitionY;
			}	else if((item.Item_Type > 9 && item.Item_Type < 22) || (item.Item_Type > 59 && item.Item_Type < 64) || (item.Item_Type > 64 && item.Item_Type < 69) || (item.Item_Type == 70)) {
				_txtProperty.wordWrap = false;
				baseProperty(item);
				addProperty(item)
				if(getItem_Slot())
				{
					_inlayProperty.visible = true;
					_inlayProperty.y = _ponsitionY;
					_inlayProperty.updateItem(item, isMy, skepId);
					_lineArr[_lineID].visible = true;
					_ponsitionY += _inlayProperty.myHeight + _lineHeight;
					_lineArr[_lineID].y =  _ponsitionY;
					_ponsitionY += _lineHeight;	
				}	else 
					_inlayProperty.visible = false;
				
			}	else {
				if(item.Item_Type == 161)
				{
					_txtProperty.wordWrap = false;
					gamItemProperty(item);
					_inlayProperty.visible = false;
				}	else {
					_txtStrongProperty.visible = false;
					_inlayProperty.visible = _txtOtherProperty.visible = _txtAddProperty.visible = false;
					str= HCss.TipsColor8 + "13物品说明：" + itemExp;
					_txtProperty.wordWrap = true;
					_txtProperty.label = str;
					_lineArr[_lineID].visible = true;
					_ponsitionY += _txtProperty.textHeight + _lineHeight;
					_lineArr[_lineID].y =  _ponsitionY;
					_ponsitionY += _lineHeight;
					_lineID ++;
				}
			}
			if(item.Item_Position == 5)
			{
				showQihun();
			}	else {
				hideQihun();
			}
			if((item.Item_Type == 70 && item.Item_Position == 0) || item.Item_Type < 10)
			{
				_txtInfo.visible = false;
			}	else {
				str = "";
				_txtInfo.visible = true;
				if((item.Item_Type > 9 && item.Item_Type < 22) || (item.Item_Type > 59 && item.Item_Type < 64) || (item.Item_Type > 64 && item.Item_Type < 69) || (item.Item_Type == 70))
				{
					str= HCss.TipsColor8 + "13物品说明：" + itemExp + "\n"
				}
				if(item.Item_Type == 161 || item.Item_Type == 86 && _itemIcon.item.Item_Attack > 0)
				{
					str= HCss.TipsColor8 + "13物品说明：" + itemExp + "\n";
				}
					
				if(_isShowSell)
				{	
					if(item.Item_OutputExp == "0")
					{
						if(item.Item_UseExp == "0")
							str +=  HCss.TipsColor1 + "13出售单价：" + item.Item_SellPrice  ;	
						else
							str +=  HCss.TipsColor3 + "13使用方式：" + item.Item_UseExp + "\n" + HCss.TipsColor1 + "13出售单价：" + item.Item_SellPrice  ;	
					} 	else {
						if(item.Item_UseExp == "0")
							str += HCss.TipsColor7 + "13获得途径：" + item.Item_OutputExp + "\n"+ HCss.TipsColor1 + "13出售单价：" + item.Item_SellPrice 	
						else
							str += HCss.TipsColor7 + "13获得途径：" + item.Item_OutputExp + "\n" + HCss.TipsColor3 + "13使用方式：" + item.Item_UseExp + "\n" + HCss.TipsColor1 + "13出售单价：" + item.Item_SellPrice 	
					}
				}	else {
					str += HCss.TipsColor7 + "13获得途径：" + item.Item_OutputExp  +"\n" ;	
				}
				_txtInfo.label = str;
				_txtInfo.y = _ponsitionY;
				_ponsitionY += _txtInfo.textHeight + 10;
				_backgroundImage.height = _ponsitionY;
			}
			
			this.myHeight = _ponsitionY;
			if(item.Item_ExpiredTime > 0 && item.Item_Expire > 0)
			{
				if(!_txtExpire)
				{
					_txtExpire = new SFTextField;
					_txtExpire.hAlign = "right"
					_txtExpire.myWidth = _tipsWidth - 28;
					this.addChild(_txtExpire);
				}	else
					_txtExpire.visible = true;
				var time:int = item.Item_Expire - HSysClock.getInstance().getSysTimer();
				if(time <=0 )
					_txtExpire.label = HCss.TipsColor9 + 13 + "该物品已经过期";
				else {
					var timeStr:String = Tool.convertTimeToConciseStr(time)
					if(timeStr)
					{
						if(HSysClock.getInstance().isHasCallBack("showIconItemTips"))
						{
							HSysClock.getInstance().removeCallBack("showIconItemTips");
						}
						_txtExpire.label = HCss.TipsColor9 + 13 + timeStr + "后到期";
					} 	else {
						_txtExpire.label = HCss.TipsColor9 + 13 + time + "秒后到期";
						if(!HSysClock.getInstance().isHasCallBack("showIconItemTips"))
						{
							HSysClock.getInstance().addCallBack("showIconItemTips", showIconItemTips);
						}
					}
				}
				_txtExpire.x = this.myWidth -  _txtExpire.textWidth - 12;
				_txtExpire.y = _txtInfo.y + _txtInfo.textHeight - _txtExpire.textHeight;
				
			}	else {
				if(HSysClock.getInstance().isHasCallBack("showIconItemTips"))
				{
					HSysClock.getInstance().removeCallBack("showIconItemTips");
				}
				if(_txtExpire)
					_txtExpire.visible = false;
			}
		}
		/**显示战斗力*/
		protected function showItemPower(item:Item):void
		{
			_equiptPower.visible = true;
			_equiptPower.y = _ponsitionY;
			_equiptPower.showPower(item);
			_ponsitionY += _equiptPower.myHeight + 2;
			_lineArr[_lineID].visible = true;
			_lineArr[_lineID].y = _ponsitionY;
			_lineID ++;
			_ponsitionY += _lineHeight
		}
		/**显示器魂数据*/
		private function showQihun():void
		{
			if(!_txtQihun)
			{
				_txtQihun = new SFTextField;
				_txtQihun.wordWrap = true;
				_txtQihun.leading = 5;
				_txtQihun.myWidth = _tipsWidth - 28;
				_txtQihun.x = 20;
				this.addChild(_txtQihun);
				
				_skill = new Skill;
				
				var texture:Texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"background/tips_line");
				var scale9:Scale9Textures = new Scale9Textures(texture, new Rectangle(12,1,8,1));
				_qihunLine = new Scale9Image(scale9);
				_qihunLine.width = _tipsWidth - 16;
				_qihunLine.x = 8;
				this.addChild(_qihunLine);	
			}	else {
				_txtQihun.visible = true;
				_qihunLine.visible = true;
			}
			var bless:Bless = QihunController.myInstance.blessHash.get(_itemIcon.item.Item_Qihun+'');
			if(bless)
			{
				_skill.refresh(bless.privateData[3]);
				var str:String = HCss.TipsColor2 + "14器魂属性\n" + HCss.GeneralColor1 + 13 + _skill.name;
				_txtQihun.label = str;
				_txtQihun.y = _ponsitionY;
				_ponsitionY += _txtQihun.textHeight + 10;
				_qihunLine.y =  _ponsitionY;
				_ponsitionY += _lineHeight;	
			}	else {
				_txtQihun.visible = false;
				_qihunLine.visible = false;
			}
			
		}
		/**隐藏器魂数据*/
		private function hideQihun():void
		{
			if(_txtQihun)
			{
				_txtQihun.visible = false;
				_qihunLine.visible = false;
			}
		}
		/**是否镶嵌宝石*/
		private function getItem_Slot():Boolean
		{
			if( _itemIcon.item.Item_Slot0 != 100 && _itemIcon.item.Item_Slot0 > 0 )
				return true;
			else  if( _itemIcon.item.Item_Slot0 != 100 && _itemIcon.item.Item_Slot0 > 0 )
				return true;
			else  if( _itemIcon.item.Item_Slot1 != 100 && _itemIcon.item.Item_Slot1 > 0 )
				return true;
			else  if( _itemIcon.item.Item_Slot2 != 100 && _itemIcon.item.Item_Slot2 > 0 )
				return true;
			else  if( _itemIcon.item.Item_Slot3 != 100 && _itemIcon.item.Item_Slot3 > 0 )
				return true;
			else  if( _itemIcon.item.Item_Slot4 != 100 && _itemIcon.item.Item_Slot4 > 0 )
				return true;
			return false;
		}
		/**宝石属性显示*/
		private function gamItemProperty(item:Item):void
		{
			var str:String = HCss.TipsColor2 + "14宝石属性\n";
			if(item.Item_CurHp > 0)
				str += HCss.TipsColor8 + "13　生命　" + item.Item_CurHp + "\n";
			if(item.Item_Attack > 0)
				str += HCss.TipsColor8 + "13　攻击　" + item.Item_Attack + "\n";
			if(item.Item_Defense > 0)
				str += HCss.TipsColor8 + "13　防御　" + item.Item_Defense + "\n";
			if(item.Item_Crit > 0)
				str += HCss.TipsColor8 + "13　暴击　" + item.Item_Crit + "\n";
			if(item.Item_Tenacity > 0)
				str += HCss.TipsColor8 + "13　韧性　" + item.Item_Tenacity + "\n";
			if(item.Vampire[0] != "0")
				str += HCss.TipsColor3 + "13　吸  血  值　" + item.Vampire[0] + "\n";
			if(item.OutHurtPerc[0] != "0")
				str += HCss.TipsColor4 + "13　减  伤  值　" + item.OutHurtPerc[0] + "\n";
			if(item.OutAttack[0] != "0")
				str += HCss.TipsColor5 + "13　卓越攻击　" + item.OutAttack[0] + "\n";
			if(item.AttackPerc[0] != "0")
				str += HCss.TipsColor5 + "13　攻击加成　" + item.AttackPerc[0] + "\n";
			if(item.AppendHurt[0] != "0")
				str += HCss.TipsColor5 + "13　附加伤害　" + item.AppendHurt[0] + "\n";
			if(item.LgnoreDefense[0] != "0")
				str += HCss.TipsColor6 + "13　无视防御　" + item.LgnoreDefense[0] + "\n";
			if(item.AbsorbHurt[0] != "0")
				str += HCss.TipsColor6 + "13　吸收伤害　" + item.AbsorbHurt[0] + "\n";
			if(item.DefensePerc[0] != "0")
				str += HCss.TipsColor6 + "13　防御加成　" + item.DefensePerc[0] + "\n";
			if(item.DefenseSuccess[0] != "0")
				str += HCss.TipsColor6 + "13　防御成功率　" + item.DefenseSuccess[0] + "\n";
			_txtStrongProperty.visible = false;
			_txtOtherProperty.visible = false;
			_txtAddProperty.visible = false;
			_txtProperty.label = str;
			_ponsitionY += _txtProperty.textHeight + _lineHeight;
			_lineArr[_lineID].visible = true;
			_lineArr[_lineID].y = _ponsitionY;
			_lineID ++;
			_ponsitionY += _lineHeight
		}
		private function showIconItemTips():void
		{
			var time:int = _itemIcon.item.Item_Expire - HSysClock.getInstance().getSysTimer();
			if(time <= 0)
			{
				if(HSysClock.getInstance().isHasCallBack("showIconItemTips"))
				{
					HSysClock.getInstance().removeCallBack("showIconItemTips");
				}
				_txtExpire.label = HCss.TipsColor9 + 13 + "该物品已到期";
			}
			else
				_txtExpire.label = HCss.TipsColor9 + 13 + time + "秒后到期";
			_txtExpire.x = this.myWidth -  _txtExpire.textWidth - 12;
		}
		/**藏宝任务坐标显示*/
		protected function showTreasureMap():void
		{
			_hmapData ||= new HMapData
			_hmapData.refresh(_itemIcon.item.Item_Attack+'');	
			var str:String = HCss.TipsColor7 + '13使用地图：' + _hmapData.name + "\n使用坐标：" + _itemIcon.item.Item_Defense + "，" + _itemIcon.item.Item_CurHp;
			_txtProperty.wordWrap = false;
			_txtProperty.label = str;
			_txtStrongProperty.visible = false;
			_inlayProperty.visible = _txtOtherProperty.visible = _txtAddProperty.visible = false;
			_ponsitionY += _txtProperty.textHeight + _lineHeight;
			_lineArr[_lineID].visible = true;
			_lineArr[_lineID].y = _ponsitionY;
			_lineID ++;
			_ponsitionY += _lineHeight
		}
		
		protected function baseProperty(item:Item):void
		{
			var str:String = HCss.TipsColor2 + "14基础属性\n";
			var strongStr:String = ""
			var isShow:Boolean;
			var isI:Boolean = item.isItemIdentification;
			if(isI)
			{
				if(item.CurHp > 0)
					str += HCss.TipsColor8 + "13　生命　?\n";
				if(item.Attack > 0)
					str += HCss.TipsColor8 + "13　攻击　?\n";
				if(item.Defense > 0)
					str += HCss.TipsColor8 + "13　防御　?\n";
				if(item.Crit > 0)
					str += HCss.TipsColor8 + "13　暴击　?\n";
				if(item.Tenacity > 0)
					str += HCss.TipsColor8 + "13　韧性　?\n";
				str += HCss.GeneralColor1 + "13　未辨识，辨识后才能使用\n　需要："　+ HCss.QualityColor3 + "13辨识卷轴*1";
			}	else {
				if(item.Item_CurHp > 0)
				{
					if(item.Item_StrongCurHp)
					{
						strongStr += HCss.TipsColor6 + "13 +" + item.Item_StrongCurHp + "\n";
						isShow = true;
					} 	else
						strongStr += "\n";
					str += HCss.TipsColor8 + "13　生命　" + item.Item_CurHp + "\n";
				}
				if(item.Item_Attack > 0)
				{
					if(item.Item_StrongAttack)
					{
						strongStr += HCss.TipsColor6 + "13 +" + item.Item_StrongAttack + "\n";
						isShow = true;
					} 	else
						strongStr += "\n";
					str += HCss.TipsColor8 + "13　攻击　" + item.Item_Attack + "\n";
				}
				if(item.Item_Defense > 0)
				{
					if(item.Item_StrongDefense)
					{
						strongStr += HCss.TipsColor6 + "13 +" + item.Item_StrongDefense + "\n";
						isShow = true;
					} 	else
						strongStr += "\n";
					str += HCss.TipsColor8 + "13　防御　" + item.Item_Defense + "\n";
				}
				if(item.Item_Crit > 0)
				{
					if(item.Item_StrongCrit)
					{
						strongStr += HCss.TipsColor6 + "13 +" + item.Item_StrongCrit + "\n";
						isShow = true;
					} 	else
						strongStr += "\n";
					str += HCss.TipsColor8 + "13　暴击　" + item.Item_Crit + "\n";
				}
				if(item.Item_Tenacity > 0)
				{
					if(item.Item_StrongTenacity)
					{
						strongStr += HCss.TipsColor6 + "13 +" + item.Item_StrongTenacity + "\n";
						isShow = true;
					} 	else
						strongStr += "\n";
					str += HCss.TipsColor8 + "13　韧性　" + item.Item_Tenacity + "\n";
				}
			}
			_txtProperty.label = str;
			if(isShow)
			{
				_txtStrongProperty.visible = true;
				_txtStrongProperty.label = strongStr;
				_txtStrongProperty.x = _txtProperty.x + _txtProperty.textWidth ;
				
			}	else 
				_txtStrongProperty.visible = false;
			_txtStrongProperty.y = _txtProperty.y + 23;
			_ponsitionY += _txtProperty.textHeight + _lineHeight;
			_lineArr[_lineID].visible = true;
			_lineArr[_lineID].y = _ponsitionY;
			_lineID ++;
			_ponsitionY += _lineHeight
		}
		private function addProperty(item:Item):void
		{
			_txtAddProperty.y = _ponsitionY;
			var str:String;
			var isNot:Boolean = true;
			if(item.Item_RecoinTimes > 0)
			{
				_maxRecoinTimes = maxRecoinTimes;
				str = HCss.TipsColor2 + "14附加属性　" + HCss.TipsColor3  + "13重铸（" + item.Item_RecoinTimes + "/ " + _maxRecoinTimes + "）" + HCss.TipsColor2 + "13"+ "" + "\n";
				if(item.Item_RecoinVampire || item.Item_Vampire)
				{
					isNot = false;
					if(item.Item_RecoinVampire)
						str += HCss.TipsColor3 + "13　吸  血  值　　" + item.Item_Vampire+"　+　"+ item.Item_RecoinVampire + "\n";
					else
						str += HCss.TipsColor3 + "13　吸  血  值　　" + item.Item_Vampire + "\n";
				}
				if(item.Item_RecoinOutHurtPerc > 0 || item.Item_OutHurtPerc)
				{
					isNot = false;
					if(item.Item_RecoinOutHurtPerc)
						str += HCss.TipsColor4 + "13　减  伤  值　　" + item.Item_OutHurtPerc+"　+　"+ item.Item_RecoinOutHurtPerc + "\n";
					else
						str += HCss.TipsColor4 + "13　减  伤  值　　" + item.Item_OutHurtPerc + "\n";
				}
				if(item.Item_RecoinOutAttack || item.Item_OutAttack)
				{
					isNot = false;
					if(item.Item_RecoinOutAttack)
						str += HCss.TipsColor5 + "13　卓越攻击　　" + item.Item_OutAttack+"　+　"+ item.Item_RecoinOutAttack + "\n";
					else
						str += HCss.TipsColor5 + "13　卓越攻击　　" + item.Item_OutAttack + "\n";
				}
				if(item.Item_RecoinAttackPerc || item.Item_AttackPerc)
				{
					isNot = false;
					if(item.Item_RecoinAttackPerc)
						str += HCss.TipsColor5 + "13　攻击加成　　" + item.Item_AttackPerc+"　+　"+ item.Item_RecoinAttackPerc + "\n";
					else
						str += HCss.TipsColor5 + "13　攻击加成　　" + item.Item_AttackPerc  + "\n";
				}
				if(item.Item_RecoinAppendHurt || item.Item_AppendHurt)
				{
					isNot = false;
					if(item.Item_RecoinAppendHurt)
						str += HCss.TipsColor5 + "13　附加伤害　　" + item.Item_AppendHurt+"　+　" + item.Item_RecoinAppendHurt + "\n";
					else
						str += HCss.TipsColor5 + "13　附加伤害　　" + item.Item_AppendHurt + "\n";
				}
				if(item.Item_RecoinLgnoreDefense || item.Item_LgnoreDefense)
				{
					isNot = false;
					if(item.Item_RecoinLgnoreDefense)
						str += HCss.TipsColor6 + "13   无视防御　　" + item.Item_LgnoreDefense+ "　+　" + item.Item_RecoinLgnoreDefense+ "\n" ;
					else
						str += HCss.TipsColor6 + "13   无视防御　　" + item.Item_LgnoreDefense + "\n" ;
				}
				if(item.Item_RecoinAbsorbHurt || item.Item_AbsorbHurt)
				{
					isNot = false;
					if(item.Item_RecoinAbsorbHurt)
						str += HCss.TipsColor6 + "13　吸收伤害　　" + item.Item_AbsorbHurt+"　+　"+item.Item_RecoinAbsorbHurt + "\n";
					else
						str += HCss.TipsColor6 + "13　吸收伤害　　" + item.Item_AbsorbHurt + "\n";
				}
				if(item.Item_RecoinDefensePerc || item.Item_DefensePerc)
				{
					isNot = false;
					str += HCss.TipsColor6 + "13　防御加成　　" + item.Item_DefensePerc+"　+　"+item.Item_RecoinDefensePerc + "\n";
				}
				if(item.Item_RecoinDefenseSuccess || item.Item_DefenseSuccess)
				{
					isNot = false;
					if(item.Item_RecoinDefenseSuccess)
						str += HCss.TipsColor6 + "13　防御成功率　" + item.Item_DefenseSuccess+"　+　"+item.Item_RecoinDefenseSuccess + "\n";
					else
						str += HCss.TipsColor6 + "13　防御成功率　" + item.Item_DefenseSuccess + "\n";
				}
					
			}	else {
				str = HCss.TipsColor2 + "14附加属性\n";
				if(item.Item_Vampire> 0)
				{
					isNot = false;
					str += HCss.TipsColor3 + "13　吸  血  值　　" + item.Item_Vampire + "\n";
				}
				if(item.Item_OutHurtPerc > 0)
				{
					isNot = false;
					str += HCss.TipsColor4 + "13　减  伤  值　　" + item.Item_OutHurtPerc + "\n";
				}
				if(item.Item_OutAttack)
				{
					isNot = false;
					str += HCss.TipsColor5 + "13　卓越攻击　　" + item.Item_OutAttack + "\n";
				}
				if(item.Item_AttackPerc)
				{
					isNot = false;
					str += HCss.TipsColor5 + "13　攻击加成　　" + item.Item_AttackPerc + "\n";
				}
				if(item.Item_AppendHurt)
				{
					isNot = false;
					str += HCss.TipsColor5 + "13　附加伤害　　" + item.Item_AppendHurt + "\n";
				}
				if(item.Item_LgnoreDefense)
				{
					isNot = false;
					str += HCss.TipsColor6 + "13　无视防御　　" + item.Item_LgnoreDefense + "\n";
				}
				if(item.Item_AbsorbHurt)
				{
					isNot = false;
					str += HCss.TipsColor6 + "13　吸收伤害　　" + item.Item_AbsorbHurt + "\n";
				}
				if(item.Item_DefensePerc)
				{
					isNot = false;
					str += HCss.TipsColor6 + "13　防御加成　　" + item.Item_DefensePerc + "\n";
				}
				if(item.Item_DefenseSuccess)
				{
					isNot = false;
					str += HCss.TipsColor6 + "13　防御成功率　　" + item.Item_DefenseSuccess + "\n";
				}
			}
			if(!isNot && !item.isItemIdentification)
			{
				_txtAddProperty.visible = true;
				_txtAddProperty.label = str;
				_ponsitionY += _txtAddProperty.textHeight + _lineHeight;
				_lineArr[_lineID].visible = true;
				_lineArr[_lineID].y = _ponsitionY ;
				_lineID ++;
				_ponsitionY += _lineHeight;
			}	else
				_txtAddProperty.visible = false;
			_txtOtherProperty.y = _ponsitionY;
			if(item.Item_IdentifyTimes > 0)
			{
				var maxLevel:int = maxIdentifyTimes(item.Item_LevelLimit);
				str = HCss.TipsColor2 + "14鉴定属性　" + HCss.TipsColor3 + "13（" + item.Item_IdentifyTimes + "/" + maxLevel + "）\n";
				if(item.Item_IdentifyCurHp > 0)
				{
					str += HCss.TipsColor3 + "13　生命　" + item.Item_IdentifyCurHp + "\n";
				}
				if(item.Item_IdentifyAttack > 0)
				{
					str += HCss.TipsColor3 + "13　攻击　" + item.Item_IdentifyAttack + "\n";
				}
				if(item.Item_IdentifyDefense > 0)
				{
					str += HCss.TipsColor3 + "13　防御　" + item.Item_IdentifyDefense + "\n";
				}
				if(item.Item_IdentifyCrit > 0)
				{
					str += HCss.TipsColor3 + "13　暴击　" + item.Item_IdentifyCrit + "\n";
				}
				if(item.Item_IdentifyTenacity > 0)
				{
					str += HCss.TipsColor3 + "13　韧性　" + item.Item_IdentifyTenacity + "\n";
				}
				
				_txtOtherProperty.label = str;
				_ponsitionY +=_txtOtherProperty.textHeight + _lineHeight;
				_lineArr[_lineID].visible = true;
				_lineArr[_lineID].y = _ponsitionY;
				_lineID ++;
				_ponsitionY += _lineHeight;
				_txtOtherProperty.visible = true
			}	else
				_txtOtherProperty.visible = false;
			
		}
		/**类型判断*/
		private function getItemType(value:int, type:String):String
		{
			var str:String = "";
			var typeV:String = type + "_" + value;
			switch(typeV)
			{
				/*case "Item_Type_1" : str = "魔晶"; break;
				case "Item_Type_2" : str = "金币"; break;
				case "Item_Type_3" : str = "礼券"; break;
				case "Item_Type_4" : str = "经验"; break;
				case "Item_Type_5" : str = "荣誉"; break;
				case "Item_Type_6" : str = "体力"; break;*/
				case "Item_Type_10" : str = "头盔"; break;
				case "Item_Type_11" : str = "胸甲"; break;
				case "Item_Type_12" : str = "护腿"; break;
				case "Item_Type_13" : str = "护手"; break;
				case "Item_Type_14" : str = "战靴"; break;
				case "Item_Type_15" : str = "武器"; break;
				case "Item_Type_16" : str = "项链"; break;
				case "Item_Type_17" : str = "手镯"; break;
				case "Item_Type_18" : str = "戒指"; break;
				case "Item_Type_19" : str = "饰品"; break;
				case "Item_Type_20" : str = "护符"; break;
				case "Item_Type_21" : str = "勋章"; break;
				case "Item_JobLimit_0" : 
					str = HCss.TipsColor1 + "13" + "通用"; 
					break;
				case "Item_JobLimit_1" : 
					if(HMapSources.getInstance().mainWizardObject.Creature_Race != _itemIcon.item.Item_JobLimit)
						str = HCss.TipsColor9 + "13兽人 " +　HCss.TipsColor1 + "13"; 
					else
						str = HCss.TipsColor1 + "13兽人 "; 
					break;
				case "Item_JobLimit_2" : 
					if(HMapSources.getInstance().mainWizardObject.Creature_Race != _itemIcon.item.Item_JobLimit)
						str = HCss.TipsColor9 + "13巫妖 " +　HCss.TipsColor1 + "13"; 
					else
						str = HCss.TipsColor1 + "13巫妖 "; 
					break;
				case "Item_JobLimit_3" : 
					if(HMapSources.getInstance().mainWizardObject.Creature_Race != _itemIcon.item.Item_JobLimit)
						str = HCss.TipsColor9 + "13精灵 " +　HCss.TipsColor1 + "13"; 
					else
						str = HCss.TipsColor1 + "13精灵 "; 
					break;
				case "Item_JobLimit_4" : 
					if(HMapSources.getInstance().mainWizardObject.Creature_Race != _itemIcon.item.Item_JobLimit)
						str = HCss.TipsColor9 + "13人族 " +　HCss.TipsColor1 + "13"; 
					else
						str = HCss.TipsColor1 + "13人族 " ; 
					break;
			}
			return str;
		}
		public function showEquiptIcon(flg:Boolean):void
		{
			if(!MainInterfaceManage.getInstance().isLoadUI) return;
			if(flg && _equiptIcon == null)
			{
				_equiptIcon = new Image(HAssetsManager.getInstance().getMyTexture("mainFaceSource","role/icon_equipt"));
				this.addChild(_equiptIcon);
				_equiptIcon.touchable = false;
				_equiptIcon.x = 80;
				_equiptIcon.y = 45;
			}
			if(_equiptIcon)
				_equiptIcon.visible = flg;
		}
		/**物品品质特效显示修改*/
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if(_itemIcon)
			{
				if(value)
					_itemIcon.playQualityEffect();
				else
					_itemIcon.stopQualityEffect();
			}
		}
		
		
		public function hidItemTips():void
		{
			if(_itemIcon && _itemIcon.item)
				_itemIcon
		}
	}
}