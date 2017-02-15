package tl.core.Wizard
{
	import Modules.Map.SpecialTitleHelper;

	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import HLib.Event.Dispatcher_F;
	import HLib.Event.ModuleEventDispatcher;
	import HLib.MapBase.HMapData;
	import HLib.Net.Socket.DataType;
	import HLib.Tool.HSuspendTips;
	import HLib.Tool.HSysClock;
	import HLib.Tool.Tg;
	import HLib.Tool.WizardEffectPool;
	import HLib.UICom.Away3DUICom.HIcon3D;
	import HLib.UICom.Away3DUICom.HProgressBar3D;
	import HLib.UICom.Away3DUICom.ReuseIcon3D;
	import HLib.UICom.BaseClass.HBaseView;
	import HLib.UICom.BaseClass.HSprite3D;
	import HLib.UICom.BaseClass.HTextField3D;
	import HLib.UICom.BaseClass.HTopBaseView;
	import HLib.UICom.BaseClass.NameTextField3D;
	import HLib.WizardBase.HObject3DPool;
	import HLib.WizardBase.WizardEffect;
	
	import Modules.CampBattle.CampBattleManager;
	import Modules.Common.HCss;
	import Modules.Common.SGCsvManager;
	import Modules.DataSources.Item;
	import Modules.DataSources.Quest;
	import Modules.DataSources.QuestSources;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.MainFace.SendMessageManage;
	import Modules.Map.HMap3D;
	import Modules.Map.HMapSources;
	import Modules.NewFortress.FortressEvent;
	import Modules.NewFortress.FortressModel;
	import Modules.NewFortress.NewFortressControl;
	import Modules.NewFortress.NewFortressSceneManage;
	import Modules.NewFortress.FortressData.NewFortressVo;
	import Modules.Patrols.controller.PatrolController;
	import Modules.Setting.Configuration;
	import Modules.Setting.SettingSources;
	import Modules.Wizard.NameBar.WizardTitle;
	
	import away3d.events.MouseEvent3D;
	import away3d.materials.TextureMaterial;
	
	import starling.events.Event;

	import tl.core.old.WizardObject;

	import tool.StageFrame;

	public class WizardNameUnit extends HSprite3D
	{
		public var isMain:Boolean = false;

		private var _wizardObject:WizardObject;		//精灵数据对象
		private var _actor3d:WizardActor3D;		//精灵数据对象
		private var _npcQuest:Quest;						//NPC任务数据,只有NPC才有此数据
		public var clickStallCallBack:Function;			//点击摆摊回调
		/** 名字文本 **/
		public function get nameTF3D():NameTextField3D
		{
			return _nameTF3D;
		}
		/**名字*/
		private var _nameTF3D:NameTextField3D;
		/**名字包围条*/
		private var _nameBoxIcon:HIcon3D;

		//-------------------------------------------------------------------
		/** 要塞 资源收获按钮 */
		public function get fortressOutputIcon():HIcon3D
		{
			return _fortressOutputIcon;
		}
		/**要塞 资源收获按钮*/
		private var _fortressOutputIcon:HIcon3D;
		/**要塞 可以升级提示*/
		private var _fortressUpLvIcon:HIcon3D;

		public function get fortressUpLvIcon():HIcon3D
		{
			return _fortressUpLvIcon;
		}
		/**要塞 资源收获按钮上的光效 */
		private var _fortressOutputWizardEffect:WizardEffect;
		//-------------------------------------------------------------------
		/** 血条 **/
		private var _hpProgressBar3D:HProgressBar3D;//血条
		public function get hpBar3d():HProgressBar3D
		{
			return _hpProgressBar3D;
		}
		/** VIP图标 **/
		public function get vipIcon():ReuseIcon3D
		{
			return _vipIcon1;
		}
		private var _vipIcon1:ReuseIcon3D;//VIP标识Icon
		private var _vipIcon2:ReuseIcon3D;//VIP标识Icon	
		private var _vipIcon3:ReuseIcon3D;//VIP标识Icon	
		private var _vipIcon4:ReuseIcon3D;//VIP标识Icon	

		private var _qqVipIcon:HIcon3D;//VIP标识Icon		


		/** 军阶图标 **/
		public function get rankIcon():ReuseIcon3D
		{
			return _rankIcon;
		}
		private var _rankIcon:ReuseIcon3D;//军阶标识Icon

		/** 任务状态Icon **/
		private var _taskStatusIcon:HIcon3D;//任务状态Icon		
		/** boss标识icon **/
		private var _bossIcon:ReuseIcon3D;//boss标识icon	

		/** 摆摊Icon **/
		private var _stallNickIcon:HIcon3D;
		/** 献祭中 **/
		private var _worshipIcon:HIcon3D;
		/** 巡城中 **/
		private var _patrolIcon:HIcon3D;
		/** 引导箭头 **/
		private var _arrowIcon:HIcon3D;
		/** 战场归属标志 **/
		private var _flgIcon:HIcon3D;
		/** 称号特效 **/
		private var _titleWizardEffect:WizardTitle;			//称号特效
		/** 战斗力 **/
		private var _poserTF3D:HTextField3D;	//战斗力
		/** 排名文本 **/
		private var _rankTF3D:HTextField3D;	//排名文本
		//红色，绿色，浅蓝色，黄色，白色，紫色/0红色，1绿色，2浅蓝色，3黄色，4白色，5紫色
		private var _colorArgs:Array = [0xdf140a, 0x17ef01, 0x88d0e8, 0xffcd21, 0xeef1f4, 0xfe21e7];

		public function WizardNameUnit()
		{
			super();

			mouseChildren = mouseEnabled = true;

			Dispatcher_F.getInstance().addEventListener(Configuration.hideTitle, onHideTitle);
		}

		private function onHideTitle(evt:flash.events.Event):void
		{
			refreshUnit_Title();
		}

		public function init(wizardObject:WizardObject, actor3d:WizardActor3D):void
		{
			if(_firstRefresh)
			{
				return;
			}

			_wizardObject = wizardObject;
			_actor3d = actor3d;
//			trace(StageFrame.renderIdx,"WizardNameUnit/init",_wizardObject.name);

			refreshDisplayOjbects();
			refreshLayout();

			if(_wizardObject.questNow)
			{//刷新任务
				refreshUnit_Quest(_wizardObject.questNow);
			}

			_wizardObject.hpFun.addFun(refreshUnit_HProgressBar3D);
			_wizardObject.propMonitor.addMonitor("Player_Camp", refreshUnit_NameLabel);
			_wizardObject.propMonitor.addMonitor("Creature_TmpGroup", refreshUnit_NameLabel);
			_wizardObject.propMonitor.addMonitor("Player_PKModle", refreshUnit_NameLabel);
			_wizardObject.propMonitor.addMonitor("isOccupation", refreshUnit_NameLabel);
			_wizardObject.propMonitor.addMonitor("Creature_Flag", refreshUnit_NameLabel);
			if(_wizardObject.Creature_OwnerActorId!=0 || _wizardObject.Creature_MasterUID!=0)
			{
				_wizardObject.propMonitor.addMonitor("Creature_Level",refreshUnit_NameLabel);
				_wizardObject.propMonitor.addMonitor("masterName",refreshUnit_NameLabel);
				_wizardObject.propMonitor.addMonitor("Creature_OwnerActorName",refreshUnit_NameLabel);
			}
			if(_wizardObject.type==WizardKey.TYPE_32 || _wizardObject.type==WizardKey.TYPE_33)
			{
				addFortressEvent();
			}
			if(_wizardObject.type == WizardKey.TYPE_0)
			{
				_wizardObject.propMonitor.addMonitor("isSanto", refreshUnit_NameLabel);
				_wizardObject.propMonitor.addMonitor("Player_VipCard", refreshUnit_VipIcon);
				_wizardObject.propMonitor.addMonitor("Player_Stamina", refreshUnit_VipIcon);
				_wizardObject.propMonitor.addMonitor("Player_MaxStamina", refreshUnit_VipIcon);
				_wizardObject.propMonitor.addMonitor("Player_Vip", refreshUnit_VipIcon);

				_wizardObject.propMonitor.addMonitor("isVipSilver", refreshUnit_VipIcon2);
				_wizardObject.propMonitor.addMonitor("isVipGold", refreshUnit_VipIcon3);
				_wizardObject.propMonitor.addMonitor("isVipDiamond", refreshUnit_VipIcon4);

				_wizardObject.propMonitor.addMonitor("Player_ArmyLevel", refreshUnit_Rank);
				_wizardObject.propMonitor.addMonitor("Player_Camp", refreshUnit_Rank);
				_wizardObject.propMonitor.addMonitor("Player_Title", refreshUnit_Title);
				_wizardObject.propMonitor.addMonitor("isWorship", refreshUnit_Worship);
				_wizardObject.propMonitor.addMonitor("isStallNick", refreshUnit_StallNick);
				_wizardObject.propMonitor.addMonitor("patrolType", refreshUnit_PatrolIcon);

				_wizardObject.propMonitor.addMonitor("Player_Stamina", refreshUnit_QQVipIcon);
				_wizardObject.propMonitor.addMonitor("Player_MaxStamina", refreshUnit_QQVipIcon);
			}
			if(_wizardObject.type == WizardKey.TYPE_31)
			{
				//可占领的；看阵营 （注意这里只是想控制阵营战地图上建筑物归属（2016-11-25）
				_wizardObject.propMonitor.addMonitor("Player_Camp", refreshUnit_RankForCamp);
			}
		}

		private function refreshUnit_VipIcon():void
		{
			refreshUnit_VipIcon1();
			refreshUnit_VipIcon2();
			refreshUnit_VipIcon3();
			refreshUnit_VipIcon4();
		}

		/**刷新名字条内容*/
		public function refreshUnit_NameLabel():void
		{
			if(!_wizardObject)
			{
				return;
			}

			if(_flgIcon)
			{
				_flgIcon.visible=false;
			}

			var mapData:HMapData = HMapSources.getInstance().mapData;
			if(_wizardObject.Creature_TmpGroup > 0 &&( _wizardObject.type==WizardKey.TYPE_0 || _wizardObject.type==WizardKey.TYPE_31) && mapData && mapData.type >= 19 && mapData.type <= 21)
			{
				if(!_flgIcon)
				{
					_flgIcon =HObject3DPool.getInstance().getHIcon3D();
					_flgIcon.mouseEnabled = true;
					if(_wizardObject.Creature_TmpGroup == 1)
					{
						_flgIcon.type = "redflg";//已满
					}
					else
					{
						_flgIcon.type = "blueflg";
					}
					this.addChild(_flgIcon);
				}
				else{
					if(_wizardObject.Creature_TmpGroup == 1)
					{
						_flgIcon.type = "redflg";//已满
					}
					else
					{
						_flgIcon.type = "blueflg";
					}
					_flgIcon.visible = true;
				}
			}

			if(!_nameTF3D)
			{
				_nameTF3D = HObject3DPool.getInstance().getNameTxt3D();
				_nameTF3D.init();
				if(_wizardObject.type == WizardKey.TYPE_32 || _wizardObject.type == WizardKey.TYPE_33)
				{
					_nameTF3D.size = 20;
				}
				else
				{
					_nameTF3D.size = 14;
				}
				_nameTF3D.algin = "center";
				this.addChild(_nameTF3D);
			}

			var tmpColor:uint = getNameColor();
			var tmpTxt:String = getNameStr();
			_nameTF3D.setTxtAndColor(tmpTxt, tmpColor);
			refreshLayout();
		}

		/**刷新名字包围条*/
		public function refreshUnit_NameBox():void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(_wizardObject.Player_Camp != HMapSources.getInstance().mainWizardObject.Player_Camp)
			{
				return;
			}
			if(_wizardObject.type==WizardKey.TYPE_32 || _wizardObject.type==WizardKey.TYPE_33)
			{
				if(!_nameBoxIcon)
				{
					_nameBoxIcon = HObject3DPool.getInstance().getHIcon3D();
					_nameBoxIcon.mouseEnabled = true;
					_nameBoxIcon.name = "MainUI_FortressDefense";
					this.addChild(_nameBoxIcon);
					_nameBoxIcon.addEventListener(MouseEvent3D.CLICK, onFortressClick);
					_nameBoxIcon.addEventListener(MouseEvent3D.MOUSE_OVER, onFortressOver);
					_nameBoxIcon.addEventListener(MouseEvent3D.MOUSE_OUT, onFortressOut);
				}
				_nameBoxIcon.type ="MainUI_FortressDefense_up";
				refreshLayout();
			}
		}


		/**刷新QQVIP图标*/
		public function refreshUnit_QQVipIcon():void
		{
			if(!_wizardObject)
			{
				return;
			}

			//HObject3DPool.getInstance().getHIcon3D("MainUI_VIP_"+Tool.getVipCardIndex(_wizardObject));
			_qqVipIcon = MainInterfaceManage.getInstance().getQQvipHIcon3D(_qqVipIcon, _wizardObject);
			if (_qqVipIcon)
			{
				this.addChild(_qqVipIcon);
			}
			refreshLayout();
		}

		/**刷新VIP图标*/
		public function refreshUnit_VipIcon1():void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(_wizardObject.type != WizardKey.TYPE_0)
			{
				return;
			}
			if(_wizardObject.Player_Vip == 0 || _wizardObject.isVipCard)
			{
				recoverVipIcon3d(_vipIcon1);
				_vipIcon1 = null;
			}
			else
			{
				if(!_vipIcon1)
				{
					_vipIcon1 = new ReuseIcon3D();//HObject3DPool.getInstance().getHIcon3D();//"MainUI_VIP_"+Tool.getVipCardIndex(_wizardObject)
					this.addChild(_vipIcon1);
				}
				_vipIcon1.type = "MainUI_VIP_1";
			}
			refreshLayout();
		}

		private function recoverVipIcon3d(icon3d:HIcon3D):void
		{
			if (icon3d)
			{
				icon3d.clearIcon3D();
				HObject3DPool.getInstance().recoverHIcon3D(icon3d);
			}
		}

		public function refreshUnit_VipIcon2():void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(_wizardObject.type != WizardKey.TYPE_0)
			{
				return;
			}
			if(_wizardObject.isVipSilver == false)
			{
				recoverVipIcon3d(_vipIcon2);
				_vipIcon2 = null;
			}
			else
			{
				if(!_vipIcon2)
				{
					_vipIcon2 = new ReuseIcon3D();//HObject3DPool.getInstance().getHIcon3D();//"MainUI_VIP_"+Tool.getVipCardIndex(_wizardObject)
					this.addChild(_vipIcon2);
				}
				_vipIcon2.type = "MainUI_VIP_3";// + Tool.getVipCardIndex(_wizardObject);
			}
			refreshLayout();
		}
		public function refreshUnit_VipIcon3():void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(_wizardObject.type != WizardKey.TYPE_0)
			{
				return;
			}
			if(_wizardObject.isVipGold == false)
			{
				recoverVipIcon3d(_vipIcon3);
				_vipIcon3 = null;
			}
			else
			{
				if(!_vipIcon3)
				{
					_vipIcon3 = new ReuseIcon3D();//HObject3DPool.getInstance().getHIcon3D();//"MainUI_VIP_"+Tool.getVipCardIndex(_wizardObject)
					this.addChild(_vipIcon3);
				}
				_vipIcon3.type = "MainUI_VIP_2";// + Tool.getVipCardIndex(_wizardObject);
			}
			refreshLayout();
		}
		public function refreshUnit_VipIcon4():void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(_wizardObject.type != WizardKey.TYPE_0)
			{
				return;
			}
			if(_wizardObject.isVipDiamond == false)
			{
				recoverVipIcon3d(_vipIcon4);
				_vipIcon4 = null;
			}
			else
			{
				if(!_vipIcon4)
				{
					_vipIcon4 = new ReuseIcon3D();//HObject3DPool.getInstance().getHIcon3D();//"MainUI_VIP_"+Tool.getVipCardIndex(_wizardObject)
					this.addChild(_vipIcon4);
				}
				_vipIcon4.type = "MainUI_VIP_4";// + Tool.getVipCardIndex(_wizardObject);
			}
			refreshLayout();
		}

		/**刷新血条*/
		public function refreshUnit_HProgressBar3D():void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(_wizardObject.wizardNameColor[6] == 1)
			{
				return;
			}
			if(!_hpProgressBar3D)
			{
				_hpProgressBar3D = HObject3DPool.getInstance().getHProgressBar3D(_wizardObject);
				this.addChild(_hpProgressBar3D);

				if (_wizardObject.type == WizardKey.TYPE_0)
				{
					_hpProgressBar3D.visible = true;//_wizardObject.isDead == false;
				}
				else
				{
					_hpProgressBar3D.visible = false;//_wizardObject.isDead == false && val;
				}
			}
			_hpProgressBar3D.max = _wizardObject.Creature_MaxHp;
			_hpProgressBar3D.now = _wizardObject.Creature_CurHp;
		}

		/**刷新任务符号*/
		public function refreshUnit_Quest(value:Quest):void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(_wizardObject.type!=WizardKey.TYPE_1)
			{
				return;
			}
			_npcQuest = value;
			if(!_npcQuest && !_taskStatusIcon)
			{
				return;
			}

			if(_npcQuest &&!_taskStatusIcon)
			{
				_taskStatusIcon = HObject3DPool.getInstance().getHIcon3D();
				this.addChild(_taskStatusIcon);
			}
			else if(!_npcQuest && _taskStatusIcon)
			{
				_taskStatusIcon.visible=false;
				return;
			}
			else if(_npcQuest && _taskStatusIcon)
			{
				/*0，NPC交接
				1，界面交接
				2，界面接,NPC交
				3，NPC接，界面交
				4，非任务对话界面交接*/
				if(_npcQuest.UIQuest == 0)
				{
					_taskStatusIcon.visible=false;
				}	else if(_npcQuest.questState == 0 && _npcQuest.UIQuest == 2) {
					_taskStatusIcon.visible=false;
				}	else if(_npcQuest.questState == 2 && _npcQuest.UIQuest == 3) {
					_taskStatusIcon.visible=false;
				}	else {
					_taskStatusIcon.visible=true;
				}
			}
			//判断等级是否到了
			if(_npcQuest.isLevelEnough)
			{
				//等级到了
				//判断是否有为提交任务
				switch(_npcQuest.questState)
				{
					case 2:	//已完成
						if(_npcQuest.Type != 2)	_taskStatusIcon.type = "MainUI_Task_2";
						else					_taskStatusIcon.type = "MainUI_Task_12";
						break;
					case 0:	//可接
						if(_npcQuest.Type != 2)	_taskStatusIcon.type = "MainUI_Task_0";
						else					_taskStatusIcon.type = "MainUI_Task_10";
						break;
					case 1:	//未完成
						_taskStatusIcon.type = "MainUI_Task_1";
						break;
				}
			}
			else
			{
				//等级未到
				_taskStatusIcon.type = "MainUI_Task_3";
			}
			refreshLayout();
		}

		/**刷新军阶等级*/
		public function refreshUnit_Rank():void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(_wizardObject.type != WizardKey.TYPE_0)
			{
				return;
			}
			if(_wizardObject.Player_Camp == 0)
			{
				return;
			}
			if( _wizardObject.Player_ArmyLevel < 1)
			{
				return;
			}
			var _type:String = "MainUI_Rank_" + _wizardObject.Player_Camp + "_" + _wizardObject.Player_ArmyLevel;
			if(!_rankIcon )
			{
				_rankIcon = new ReuseIcon3D();//HObject3DPool.getInstance().getHIcon3D();
				this.addChild(_rankIcon);
			}
			_rankIcon.type = _type;
			refreshLayout();
		}

		/** 建筑被阵营占领而归属阵营变化 */
		public function refreshUnit_RankForCamp():void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(_wizardObject.type != WizardKey.TYPE_31)
			{
				return;
			}
			if(_wizardObject.Player_Camp == 0)
			{
				if(_rankIcon) {
					removeChild(_rankIcon);
					_rankIcon.dispose();
					_rankIcon = null;
				}
				return;
			}
//			var _type:String = "MainUI_Camp_" + _wizardObject.Player_Camp;
			var _type:String = "MainUI_Rank_" + _wizardObject.Player_Camp + "_0";
			if(!_rankIcon )
			{
				_rankIcon = new ReuseIcon3D();//HObject3DPool.getInstance().getHIcon3D();
				this.addChild(_rankIcon);
			}
			_rankIcon.type = _type;
			refreshLayout();
		}

		/**刷新称号*/
		public function refreshUnit_Title():void
		{
			if (SettingSources.getInstance().isHideTitle && isMain == false)
			{
				if (_titleWizardEffect)
				{
					_titleWizardEffect.dispose();
					_titleWizardEffect = null;
				}
			}
			else
			{
				if(!_wizardObject || _wizardObject.Player_Title == 0)
				{
					if (_titleWizardEffect)
					{
						_titleWizardEffect.dispose();
						_titleWizardEffect = null;
					}
					return;
				}

				//获得称号资源类型
				var tableArr:Array = SGCsvManager.getInstance().table_title.FindRow(String(_wizardObject.Player_Title));
				if(!tableArr)return;
				var type:String = tableArr[6];
				var arr:Array = type.split("|");
				if(arr[0] == "0")
				{
					return;
				}
				if(!_titleWizardEffect)
				{
					WizardKey.titleEffectResArgs.length = 0;
					WizardKey.titleEffectResArgs.push(arr[0]);

					_titleWizardEffect = new WizardTitle();
					this.addChild( _titleWizardEffect );
				}
				_titleWizardEffect.initData(type);
				_titleWizardEffect.visible = true;
			}
			refreshLayout();
		}

		/**刷新Boss图标*/
		public function refreshUnit_Boss():void
		{
			if(!_wizardObject)
			{
				return;
			}

			if(WizardKey.isBoss(_wizardObject.type))
			{
				if(!_bossIcon)
				{
					_bossIcon = new ReuseIcon3D();//HObject3DPool.getInstance().getHIcon3D();
					this.addChild(_bossIcon);
				}
				if (_wizardObject.type == WizardKey.TYPE_41)
				{
					_bossIcon.type = "MainUI_EliteSign";
				}
				else
				{
					//					_bossIcon.type = "MainUI_EliteSign";
					_bossIcon.type = "MainUI_BossSign";
				}

				refreshLayout();
			}
		}

		/**刷新献祭图标*/
		public function refreshUnit_Worship():void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(!_wizardObject.isWorship)
			{
				if(_worshipIcon)
				{
					_worshipIcon.visible = false;
				}
			}
			else
			{
				if(_worshipIcon)
				{
					_worshipIcon.visible = true;
				}
				else
				{
					_worshipIcon = HObject3DPool.getInstance().getHIcon3D();
					_worshipIcon.type = "MainUI_Worship";
					this.addChild(_worshipIcon);
				}
			}
			refreshLayout();
		}

		/**刷新摆摊图标*/
		public function refreshUnit_StallNick():void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(!_wizardObject.isStallNick)
			{
				if(_stallNickIcon)
				{
					_stallNickIcon.visible = false;
					return;
				}
			}
			if(_stallNickIcon)
			{
				_stallNickIcon.visible = true;
				return;
			}
			if(!_stallNickIcon)
			{
				_stallNickIcon = HObject3DPool.getInstance().getHIcon3D();
				this.addChild(_stallNickIcon);
			}
			_stallNickIcon.type = "MainUI_StallNickTitle_Up";
			refreshLayout();
		}

		/**刷新引导箭头*/
		public function refreshUnit_ArrowIcon(type:String,index:int=0):void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(type==null)
			{
				if(_arrowIcon)
				{
					this.removeChild(_arrowIcon);
					_arrowIcon.clearIcon3D();
					HObject3DPool.getInstance().recoverHIcon3D(_arrowIcon);
					_arrowIcon=null;
				}
				isGuideFortressName=false;
			}
			else
			{
				if(!_arrowIcon)
				{
					_arrowIcon = HObject3DPool.getInstance().getHIcon3D();
					_arrowIcon.mouseChildren = _arrowIcon.mouseEnabled = false;
					this.addChild(_arrowIcon);
				}
				_arrowIcon.type = type;
				if(index == 0)
				{
					_arrowIcon.x = 128;
					_arrowIcon.y = 5;
					if(_nameBoxIcon)
					{
						_arrowIcon.z = _nameBoxIcon.z;
					}
				}
				else
				{
					_arrowIcon.x = 190;
					_arrowIcon.y = 5;
					_arrowIcon.z = _fortressOutputIcon.z;
				}
				//				_arrowIcon.rotationX = this.rotationX
				// 要塞的引导，可能是隐藏中
				isGuideFortressName=true;
				isShowFortressName(true);
			}
		}

		/**刷新战力文本内容*/
		public function refreshUnit_PoserLabel():void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(_wizardObject.type != WizardKey.TYPE_25)
			{
				return;
			}
			if(!_poserTF3D)
			{
				_poserTF3D = HObject3DPool.getInstance().getHTextField3D();
				_poserTF3D.setDefaultSkin(8);
				_poserTF3D.init();
				_poserTF3D.algin = "center";
				this.addChild(_poserTF3D);
			}
			_poserTF3D.text = "ArenaPower" + _wizardObject.Creature_FightPower;
			refreshLayout();
		}

		/**刷新竞技场排名文本内容*/
		public function refreshUnit_RankLabel():void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(_wizardObject.type != WizardKey.TYPE_25)
			{
				return;
			}
			if(!_rankTF3D)
			{
				_rankTF3D = HObject3DPool.getInstance().getHTextField3D();
				_rankTF3D.setDefaultSkin(9);
				_rankTF3D.init();
				_rankTF3D.algin = "center";
				this.addChild(_rankTF3D);
			}
			_rankTF3D.text = "Di" + _wizardObject.arenaRank + "Ming";
			refreshLayout();
		}

		private var _firstRefresh:Boolean = false;
		/**刷新显示对象*/
		private function refreshDisplayOjbects():void
		{
			_firstRefresh = true;
			refreshUnit_HProgressBar3D();
			refreshUnit_NameLabel();
			refreshUnit_NameBox();
			refreshUnit_Boss();
			refreshUnit_VipIcon();
			refreshUnit_Rank();
			refreshUnit_RankForCamp();
			refreshUnit_Title();
			refreshUnit_PoserLabel();
			refreshUnit_RankLabel();
			refreshUnit_QQVipIcon();
		}

		/**刷新所有显示对象布局*/
		public function refreshLayout():void
		{
			if(!_wizardObject)
			{
				return;
			}
			/*if (_wizardObject.isMainActor)
			{
			this;
			}*/
			var tmpY:Number=0;
			var tmpZ:Number=0;
			var nameWidthHalf:int = 0;
			if(_hpProgressBar3D)
			{
				//				_hpProgressBar3D.x = 16;
				_hpProgressBar3D.y = 0;
				tmpY += 0;
				tmpZ += 24;
			}
			if(_nameTF3D)
			{
				_nameTF3D.x = 0;
				_nameTF3D.y = tmpY;
				_nameTF3D.z = tmpZ;
				tmpY += 12;
				tmpZ += 30;
				nameWidthHalf = _nameTF3D.myWidth >> 1;
			}
			if(_flgIcon)
			{
				_flgIcon.x = -nameWidthHalf - 15;
				_flgIcon.y = _nameTF3D.y;
				_flgIcon.z = _nameTF3D.z;
			}
			if(_nameBoxIcon)
			{
				_nameBoxIcon.x = 0;
				_nameBoxIcon.y = _nameTF3D.y-2;
				_nameBoxIcon.z=_nameTF3D.z;
				_nameBoxIcon.visible=true;
			}
			/*if(_stallNickIcon && _wizardObject.isStallNick)
			{
			_stallNickIcon.x = 0;
			_stallNickIcon.y = _nameTF3D.y-6;
			_stallNickIcon.z=_nameTF3D.z;
			_stallNickIcon.visible=true;
			if(_hpProgressBar3D)
			{
			_hpProgressBar3D.visible=false;
			}
			if(_vipIcon1)
			{
			_vipIcon1.visible=false;
			}
			if(_rankIcon)
			{
			_rankIcon.visible=false;
			}
			if(_titleWizardEffect)
			{
			_titleWizardEffect.visible=false;
			}
			return;
			}*/
			if(_bossIcon)
			{
				_bossIcon.x = nameWidthHalf + 15;
				_bossIcon.y = _nameTF3D.y;
				_bossIcon.z = _nameTF3D.z;
				_bossIcon.visible = true;
			}
			var tmpVipX:Number = nameWidthHalf;
			if(_qqVipIcon)
			{
				var qqVipHalfW:uint = (_qqVipIcon.myWidth >> 1) + 3;
				tmpVipX += qqVipHalfW;
				_qqVipIcon.x = tmpVipX;//nameWidthHalf + 10;
				_qqVipIcon.y = _nameTF3D.y;
				_qqVipIcon.z = _nameTF3D.z;
				_qqVipIcon.visible = true;
				tmpVipX += qqVipHalfW;
			}
			/*if (_wizardObject.isMainActor)
			{
			this;
			}
			*/
			tmpVipX -= 10;
			if(_vipIcon1)
			{
				_vipIcon1.x = tmpVipX += 20;
				_vipIcon1.y = _nameTF3D.y;
				_vipIcon1.z = _nameTF3D.z;
				_vipIcon1.visible = true;
			}
			if(_vipIcon2)
			{
				_vipIcon2.x = tmpVipX += 20;
				_vipIcon2.y = _nameTF3D.y;
				_vipIcon2.z = _nameTF3D.z;
				_vipIcon2.visible = true;
			}
			if(_vipIcon3)
			{
				_vipIcon3.x = tmpVipX += 20;
				_vipIcon3.y = _nameTF3D.y;
				_vipIcon3.z = _nameTF3D.z;
				_vipIcon3.visible = true;
			}
			if(_vipIcon4)
			{
				_vipIcon4.x = tmpVipX += 20;
				_vipIcon4.y = _nameTF3D.y;
				_vipIcon4.z = _nameTF3D.z;
				_vipIcon4.visible = true;
			}
			if(_taskStatusIcon)
			{
				_taskStatusIcon.x = 0;
				_taskStatusIcon.y = tmpY;
				_taskStatusIcon.z = tmpZ;
				_taskStatusIcon.visible=true;
			}
			if(_rankIcon)
			{
				_rankIcon.x = 0;
				_rankIcon.y = tmpY;
				_rankIcon.z = tmpZ;
				tmpY+=20;
				tmpZ+=40;
				_rankIcon.visible=true;
			}
			if(_titleWizardEffect)
			{
				_titleWizardEffect.x = 0;
				_titleWizardEffect.y = tmpY;
				_titleWizardEffect.z = tmpZ + 20;
				tmpY += 20;
				tmpZ += 40;
				_titleWizardEffect.visible = true;
			}
			if(_patrolIcon && _patrolIcon.visible)
			{
				_patrolIcon.x = 0;
				_patrolIcon.y = tmpY;
				_patrolIcon.z = tmpZ;
			}
			if(_worshipIcon && _worshipIcon.visible)
			{
				_worshipIcon.x = 0;
				_worshipIcon.y = tmpY;
				_worshipIcon.z = tmpZ;
			}
			if(_poserTF3D)
			{
				_poserTF3D.x = 0;
				_poserTF3D.y = tmpY;
				_poserTF3D.z = tmpZ;
				tmpY += 12;
				tmpZ += 30;
			}
			if(_rankTF3D)
			{
				_rankTF3D.x = 0;
				_rankTF3D.y = tmpY;
				_rankTF3D.z = tmpZ;
				tmpY+=12;
				tmpZ+=30;
			}

			myHeight = tmpY;
			rotationX = rotationX;
		}

		/*
		override public function set rotationX(val:Number):void
		{
		if(this.rotationX == val)
		{
		return;
		}
		if(_nameTF3D)
		{
		_nameTF3D.rotationX = val;
		}
		if(_hpProgressBar3D)
		{
		_hpProgressBar3D.rotationX = val;
		}
		if(_vipIcon)
		_vipIcon.rotationX = val;
		if(_rankIcon)
		_rankIcon.rotationX = val;
		if(_taskStatusIcon)
		_taskStatusIcon.rotationX = val;
		if(_bossIcon)
		_bossIcon.rotationX = val;
		if(_titleWizardEffect)
		_titleWizardEffect.rotationX = val;
		if(_stallNickIcon)
		_stallNickIcon.rotationX = val;
		if(_worshipIcon)
		_worshipIcon.rotationX = val;
		if(_nameBoxIcon)
		_nameBoxIcon.rotationX = val;
		if(_fortressOutputIcon)
		_fortressOutputIcon.rotationX = val;
		if(_arrowIcon)
		_arrowIcon.rotationX = val
		if(_patrolIcon)
		_patrolIcon.rotationX = val;
		if(_fortressUpLvIcon)
		_fortressUpLvIcon.rotationX = val;
		if(_fortressOutputWizardEffect)
		_fortressOutputWizardEffect.rotationX = val;
		if(_fortressRewardWizardEffect)
		_fortressRewardWizardEffect.rotationX = val;
		if(_poserTF3D)
		_poserTF3D.rotationX = val;
		if(_rankTF3D)
		_rankTF3D.rotationX = val;
		}*/

		/**透明值*/
		public function set alpha(value:Number):void
		{
			_alpha = value;
			if(_nameTF3D)
			{
				TextureMaterial( _nameTF3D.material ).alpha = _alpha;
			}
			if(_hpProgressBar3D)
			{
				_hpProgressBar3D.alpha = _alpha;
			}
			if(_vipIcon1)
			{
				TextureMaterial( _vipIcon1.material ).alpha = _alpha;
			}
			if(_vipIcon2)
			{
				TextureMaterial( _vipIcon2.material ).alpha = _alpha;
			}
			if(_vipIcon3)
			{
				TextureMaterial( _vipIcon3.material ).alpha = _alpha;
			}
			if(_vipIcon4)
			{
				TextureMaterial( _vipIcon4.material ).alpha = _alpha;
			}

			if(_rankIcon)
			{
				TextureMaterial( _rankIcon.material ).alpha = _alpha;
			}
			if(_taskStatusIcon)
			{
				TextureMaterial( _taskStatusIcon.material ).alpha = _alpha;
			}
			if(_bossIcon)
			{
				TextureMaterial( _bossIcon.material ).alpha = _alpha;
			}
			if(_worshipIcon)
			{
				TextureMaterial( _worshipIcon.material ).alpha = _alpha;
			}
			if(_patrolIcon)
			{
				TextureMaterial( _patrolIcon.material ).alpha = _alpha;
			}
			if(_qqVipIcon)
			{
				TextureMaterial( _qqVipIcon.material ).alpha = _alpha;
			}
		}
		public function get alpha():Number { return _alpha; }
		private var _alpha:Number = 1;

		/** 是否显示血条*/
		public function set isShowHp(value:Boolean):void
		{
			if(_hpProgressBar3D == null || _hpProgressBar3D.max == 0)
			{
				return;
			}

			_hpProgressBar3D.visible = value;
		}

		/**获取名字条字符串*/
		public function getNameStr():String
		{
			var _nameStr:String = "";
			if(int(_wizardObject.id) > 11013 && int(_wizardObject.id) < 11019)
			{
				if(CampBattleManager.getInstance().castleInfoObj.castellanId == 0)
					_nameStr = "大城主：虚位以待";
				else
					_nameStr = "大城主：" + CampBattleManager.getInstance().castleInfoObj.name;
				
				return _nameStr;
			}
			if(_wizardObject.type && _wizardObject.type == WizardKey.TYPE_13)
			{
				//镖车
				_nameStr = _wizardObject.Creature_OwnerActorName + " " + Tg.T("的") + _wizardObject.name;
				return _nameStr;
			}

			if(_wizardObject.type && _wizardObject.type == WizardKey.TYPE_99)
			{
				//掉落物品
				itemCountDown()
				HSysClock.getInstance().addCallBack(this, itemCountDown);
				return _nameStr;
			}

			if(_wizardObject.type && _wizardObject.type==WizardKey.TYPE_33 || _wizardObject.type==WizardKey.TYPE_32)
			{
				//要塞建筑
				_nameStr = _wizardObject.name +_wizardObject.Creature_Level + "级";
				return _nameStr;
			}
			if(_wizardObject.type && _wizardObject.type==WizardKey.TYPE_25)
			{//竞技场
				_nameStr = _wizardObject.Player_Name + "（Lv" + _wizardObject.Creature_Level + "）";
				return _nameStr;
			}

			if(_wizardObject.Creature_MasterUID && _wizardObject.Creature_MasterUID != 0)
			{
				if(_wizardObject.masterName == "null" || _wizardObject.masterName==null)
				{
					_wizardObject.masterName="";
				}
				if(int(_wizardObject.id)>68000 && int(_wizardObject.id)<68200)
				{
					_wizardObject.masterName="";//要塞内的种不显示招唤者的名称
				}
				_nameStr += _wizardObject.masterName == "" ? "" : (_wizardObject.masterName+ " " + Tg.T("的"))
				if(_wizardObject.Creature_OwnerActorName && _wizardObject.Creature_OwnerActorName!="")
				{
					_nameStr+=_wizardObject.Creature_OwnerActorName+ "  " +_wizardObject.Creature_Level + "级";
				}
				else
				{
					_nameStr+=_wizardObject.name+ "  " +_wizardObject.Creature_Level + "级";
				}
				return _nameStr;
			}
			

			if(_wizardObject.type && _wizardObject.type==WizardKey.TYPE_1)
			{
				_nameStr=_wizardObject.name;
				return _nameStr;
			}
			if(_wizardObject.isShowCurWorldId && _wizardObject.type==WizardKey.TYPE_0 )
			{
				_nameStr+="["+_wizardObject.Player_CurWorldId+"]";
			}
			if(_wizardObject.Player_Name)
			{
				_nameStr+="  "+_wizardObject.Player_Name;
			}
			else
			{
				_nameStr+="  "+_wizardObject.name;
			}
			if(_wizardObject.ischengzhu)
			{
				_nameStr += "（城主）"
			}
			else
			{
				if(_wizardObject.isOccupation && _wizardObject.isSanto)
				{
					_nameStr += "（大领主）"
				}
			}
		

			if (_nameStr == "")
			{
				this;
			}
			return _nameStr;
		}

		/**获取名字条颜色
		 |名字颜色:0红色，1绿色，2浅蓝色，3黄色，4白色，5紫色*/
		public function getNameColor():uint
		{
			var colorIdx:int = 4;
			var mainObj:WizardObject = HMapSources.getInstance().mainWizardObject;

			/*if (_wizardObject.Player_Name && _wizardObject.Player_Name.indexOf("潘妮") != -1)
			{
				this;
			}*/
			if (_wizardObject.isUI)
			{
				return _colorArgs[4];
			}

			if(_wizardObject.isMainActor)
			{
				return _colorArgs[colorIdx];
			}
			if(_wizardObject.Creature_MasterUID == mainObj.Entity_UID)
			{
				//宠物
				return _colorArgs[1];
			}

			var tmpObj:WizardObject = _wizardObject;
			/*if (tmpObj.Creature_MasterUID)
			{
				if (_wizardObject.masterObject)
				{
					tmpObj = _wizardObject.masterObject;
				}
			}*/

			if (tmpObj.type == WizardKey.TYPE_13)
			{
				if (tmpObj.Creature_OwnerActorId == mainObj.Player_ActorId)
				{
					return _colorArgs[1];
				}
				else
				{
					if(tmpObj.Player_Camp == mainObj.Player_Camp)
					{
						return _colorArgs[2];
					}
					else
					{
						return _colorArgs[0];
					}
				}
			}


			if (mainObj.Player_Camp == 0 && tmpObj.type == WizardKey.TYPE_0)
			{
				return _colorArgs[4];
			}

			/** 大乱斗场景  */
			var curMapId:uint = uint(HMap3D.getInstance().mapData.mapId);
			//			var tmpmapType:uint = uint(HMap3D.getInstance().mapData.type);
			if (curMapId == 41040 || (curMapId >= 29300  && curMapId < 29400) || curMapId == 41101)
				//			if (tmpmapType == 2)
			{
				return _colorArgs[0];
			}

			//			if (_wizardObject.type >= WizardKey.TYPE_31 && _wizardObject.type <= WizardKey.TYPE_34)

			colorIdx = int(tmpObj.wizardNameColor[3]);
//			if(_wizardObject.name == "中立复活点" )
//			{//		 |名字颜色:0红色，1绿色，2浅蓝色，3黄色，4白色，5紫色*
//				trace(StageFrame.renderIdx,"WizardNameUnit/getNameColor",tmpObj.wizardNameColor);
//			}
			//没有临时分组
			if(tmpObj.Creature_TmpGroup == 0)
			{
				if(tmpObj.type == WizardKey.TYPE_1)
				{
					colorIdx = 1;
				}
				else
				{
					if (mainObj.Player_Camp != 0)
					{
						if(tmpObj.Player_Camp == mainObj.Player_Camp)
						{//阵营
							if (tmpObj.wizardNameColor[4]==1)// 分阵营影响
							{
								colorIdx = 2;
							}else if (tmpObj.type >= WizardKey.TYPE_31 && tmpObj.type <= WizardKey.TYPE_34)
							{
								colorIdx = 1;
							}
							else if (tmpObj.type == WizardKey.TYPE_39)//阵营物资镖车
							{
								colorIdx = 1;
							}
							else
							{
								colorIdx = 4;
							}
						}
						else
						{
							if (tmpObj.type == WizardKey.TYPE_0)
							{
								if(tmpObj.Player_PKModle != 0 || mainObj.Player_PKModle != 0)
								{
									colorIdx = 0;
								}
								else
								{
									colorIdx = 2;
								}
							}else if (tmpObj.wizardNameColor[4]==1  && tmpObj.Player_Camp!=0)// 分阵营影响 要显示 且是敌对阵营
							{
								colorIdx = 0;
							}
							else if (tmpObj.type == WizardKey.TYPE_39)//阵营物资镖车
							{
								colorIdx = 0;
							}
						}
					}
					else
					{
						if (tmpObj.type == WizardKey.TYPE_0)
						{
							colorIdx = 4;
						}
					}
				}
			}
			else
			{
				// 有临时分组
				if(tmpObj.Creature_TmpGroup == mainObj.Creature_TmpGroup)
				{
					colorIdx = 1;
				}
				else
				{
					colorIdx = 0;
				}
			}
			//			_wizardObject.nameColor=_colorIdx;
//			trace(StageFrame.renderIdx,"WizardNameUnit/getNameColor",_wizardObject.name ,"type:", _wizardObject.type ,"camp:",_wizardObject.Player_Camp ,"group:",_wizardObject.Creature_TmpGroup,"colorIdx",colorIdx);
			return _colorArgs[colorIdx];
		}

		private function itemCountDown():void
		{
			if(_actor3d == null || _wizardObject == null)
			{
				HSysClock.getInstance().removeCallBack(this);
				return;
			}

			if(_wizardObject.itemProtectionTimeLeft > 0)
			{
				_wizardObject.itemProtectionTimeLeft--;
			}
			_wizardObject.itemTimeLeft--;
			if(_wizardObject.itemTimeLeft < 0)
			{
				HSysClock.getInstance().removeCallBack(this);
				return;
			}

			if(_actor3d.isMyEyes == false)
			{
				return;
			}

			var _nameStrColor:String = "";
			if(_wizardObject.itemProtectionTimeLeft > 0 && _wizardObject.downItemIsPick == false)
			{
				_nameStrColor = "#C41B1214";
			}
			else
			{
				_nameStrColor = "#00FF0014";
			}
			var _nameStr:String = "";
			if(_wizardObject.type == WizardKey.TYPE_99)
			{
				//掉落物品
				if(_wizardObject.itemMasterName != "")
				{
					_nameStr += _wizardObject.itemMasterName + " " + Tg.T("的");
				}
				_nameStr =  HCss.QualityColorArray[_wizardObject.level] + "14" + _wizardObject.name;
			}
			_nameStr += "  " + _nameStrColor + "[" + _wizardObject.itemTimeLeft + "s]";
			_nameTF3D.label = _nameStr;
		}

		private function addFortressEvent():void
		{
			if(FortressModel.getInstance().mapType != 16)
			{
				return;
			}
			updateFortressItem();
			ModuleEventDispatcher.getInstance().addEventListener(FortressEvent.FORTRESS_UPDATE_RESERVES, updateFortressItem);
			if(_wizardObject.resId == 3317 )
			{
				updateHallInfo();
				ModuleEventDispatcher.getInstance().addEventListener(FortressEvent.FORTRESS_HALLINFO_UPDATED, updateHallInfo);		//,堡垒容量更新);
			}
			if(_wizardObject.resId == 3319 )
			{
				updateResFactoryInfo();
				ModuleEventDispatcher.getInstance().addEventListener(FortressEvent.FORTRESS_RESFACTORYINFO_UPDATED, updateResFactoryInfo);	//, 资源工厂容量更新);
			}
		}

		/** 要塞等级变化后、要塞收获资源后 刷新可升级信息 */
		private function updateFortressItem(e:starling.events.Event=null):void
		{
			var id:String = _wizardObject.bindFun[1];
			var nextId:String = (int(_wizardObject.bindFun[1]) + 1) + '';
			var vo:NewFortressVo = FortressModel.getInstance().voHash.get(id);
			var nextVo:NewFortressVo = FortressModel.getInstance().voHash.get(nextId);
			if(!nextVo)
			{
				if(_fortressUpLvIcon)
				{
					_fortressUpLvIcon.visible = false;
				}
				return;
			}
			if(!nextVo.bless.needItems) return;
			// 需要物品
			var _item:Item= new Item;
			_item.RefreshItemById(nextVo.bless.needItems[0]);
			_item.Item_Num = int(nextVo.bless.needItems[1]);
			var haveReserves:int = FortressModel.getInstance().reserves;
//			trace(getTimer(),"WizardNameUnit/updateFortressItem",_wizardObject.name);
//			trace("战争物资",haveReserves , _item.Item_Num , haveReserves < _item.Item_Num);
//			trace("等级要求",FortressModel.getInstance().fortressLevel , nextVo.bless.blessLv , FortressModel.getInstance().fortressLevel < nextVo.bless.blessLv);
//			trace("金币要求",HMapSources.getInstance().mainWizardObject.Player_Gold , nextVo.bless.needGold , HMapSources.getInstance().mainWizardObject.Player_Gold < nextVo.bless.needGold);
			if(haveReserves < _item.Item_Num
			|| (FortressModel.getInstance().fortressLevel < nextVo.bless.blessLv) //要塞等级要求
			||  HMapSources.getInstance().mainWizardObject.Player_Gold < nextVo.bless.needGold //需要金币
			)
			{
//				trace(getTimer(),"WizardNameUnit/updateFortressItem false");
				if(_fortressUpLvIcon)
				{
					_fortressUpLvIcon.visible = false;
				}
				return;
			}
//			trace(getTimer(),"WizardNameUnit/updateFortressItem true");
			if(!_fortressUpLvIcon)
			{
				_fortressUpLvIcon = HObject3DPool.getInstance().getHIcon3D();
				_fortressUpLvIcon.type= "MainUI_Fortress_up";
				this.addChild(_fortressUpLvIcon);
			}
			else
			{
				_fortressUpLvIcon.visible = true;
			}
			_fortressUpLvIcon.x =  _nameTF3D.x + (_nameTF3D.myWidth >> 1) + 16;
			_fortressUpLvIcon.y = _nameTF3D.y;
			_fortressUpLvIcon.z = _nameTF3D.z - this.y;
			//			_fortressUpLvIcon.y = 62;
			//			_fortressUpLvIcon.x = 80;
		}

		private function get isTriggerMouseEvt():Boolean
		{
			return HBaseView.getInstance().isMoveStarling || HTopBaseView.getInstance().hasEvent || HTopBaseView.getInstance().isShowFull;
		}

		/** 点击要塞名字 **/
		private function onFortressClick(e:MouseEvent3D):void
		{
			if(isTriggerMouseEvt)
			{
				return;
			}

			var icon:HIcon3D = e.currentTarget as HIcon3D;
			if(
				icon.name == "MainUI_StallNickTitle" ||
				icon.name == "MainUI_FortressDefense"
			){
				//如果是堡垒的名字条
				if(_wizardObject.resId == 3317)
				{
					var _functionObj1:Object = QuestSources.getInstance().functionObjHash.get("Fortress");
					var _functionObj2:Object = QuestSources.getInstance().functionObjHash.get("Fortress1");
					if(_functionObj1.currentStep == 99 && _functionObj2.currentStep == 99)
					{
						var _functionObj:Object = QuestSources.getInstance().functionObjHash.get("Fortress2");
						if(_functionObj.currentStep == 0)
						{
							_functionObj.currentStep = 1;
							SendMessageManage.getMyInstance().sendOpenFunctionToSever([DataType.Short(_functionObj.FunIndex), DataType.Byte(_functionObj.currentStep)]);
						}
						if(_functionObj.currentStep < 99){
							ModuleEventDispatcher.getInstance().ModuleCommunication("showBaoLeiGradeClick");
						}
					}
				}
				else if(_wizardObject.resId == 3322)
				{//如果是兵营的名字条
					var _functionObj0:Object = QuestSources.getInstance().functionObjHash.get("Fortress");
					_functionObj1 = QuestSources.getInstance().functionObjHash.get("Fortress1");
					_functionObj2 = QuestSources.getInstance().functionObjHash.get("Fortress2");
					if(_functionObj0.currentStep == 99 && _functionObj1.currentStep == 99 && _functionObj2.currentStep == 99)
					{
						var _functionObj3:Object = QuestSources.getInstance().functionObjHash.get("Fortress3");
						if(_functionObj3.currentStep == 0)
						{
							_functionObj3.currentStep = 1;
							SendMessageManage.getMyInstance().sendOpenFunctionToSever([DataType.Short(_functionObj3.FunIndex), DataType.Byte(_functionObj3.currentStep)]);
						}
						if(_functionObj3.currentStep < 99)
						{
							ModuleEventDispatcher.getInstance().ModuleCommunication("showBingYinClick");
						}
					}
				}
				else if(_wizardObject.resId == 3323)
				{//如果是战争研究院名字条
					var object1:WizardObject = HMapSources.getInstance().fortressYanObject;
					var object2:WizardObject = HMapSources.getInstance().fortressSoldierObject;
					if(object1 && object2 && object1.level >= 2 && object2.level >= 2)
					{
						_functionObj0 = QuestSources.getInstance().functionObjHash.get("Fortress");
						_functionObj1 = QuestSources.getInstance().functionObjHash.get("Fortress1");
						_functionObj2 = QuestSources.getInstance().functionObjHash.get("Fortress2");
						_functionObj3 = QuestSources.getInstance().functionObjHash.get("Fortress3");
						if(_functionObj0.currentStep == 99 && _functionObj1.currentStep == 99 && _functionObj2.currentStep == 99 && _functionObj3.currentStep == 99)
						{
							var _functionObj5:Object = QuestSources.getInstance().functionObjHash.get("Fortress5");
							if(_functionObj5.currentStep == 0)
							{
								_functionObj5.currentStep = 1;
								SendMessageManage.getMyInstance().sendOpenFunctionToSever([DataType.Short(_functionObj5.FunIndex), DataType.Byte(_functionObj5.currentStep)]);
							}
							if(_functionObj5.currentStep < 99)
							{
								ModuleEventDispatcher.getInstance().ModuleCommunication("showYanClick");
							}
						}
					}
				}
				NewFortressSceneManage.MyInstance.showBuild(_wizardObject);
			}
		}

		/** 要塞名字移入 **/
		private function onFortressOver(e:MouseEvent3D):void
		{
			if(isTriggerMouseEvt)
			{
				return;
			}
			var icon:HIcon3D = e.currentTarget as HIcon3D;
			icon.type = icon.name + "_over";
		}

		/** 要塞名字移出 **/
		private function onFortressOut(e:MouseEvent3D):void
		{

			var icon:HIcon3D = e.currentTarget as HIcon3D;
			icon.type = icon.name + "_up";
		}
		/** 达成一倍容量的百分之多少才显示产出搜集图标 */
		public static const SHOW_HARVESTICON_PERCENT :Number = 0.6;
		/**更新堡垒产出信息后，刷新要塞产出图标*/
		private function updateHallInfo(e:starling.events.Event=null):void
		{
			var obj:Object = FortressModel.getInstance().hallInfo;
			if(obj)
			{
				var id:String = _wizardObject.bindFun[1];
				var vo:NewFortressVo = FortressModel.getInstance().voHash.get(id);
				// 第一次服务器发来的harvestTime为当前unix时间戳，太大了，必须用Number
				var num:Number = obj.resource + int(vo.produce[0]) * (obj.harvestTime/60);
//				var capacity1x : int = int(vo.capacity[0]);
//				// 2016-10-26 改成如果小于60% 基准库存量 就先不显示
//				if(num<capacity1x* SHOW_HARVESTICON_PERCENT )
//				{
//					if(_fortressOutputIcon)
//					{
//						_fortressOutputIcon.visible = false;
//						_fortressOutputWizardEffect.stop();
//						_fortressOutputWizardEffect.visible = false;
//					}
//					return;
//				}
				// 2016-11-21 改成如果小于1小时产出 就不显示
				if(obj.harvestTime < 3600)
				{
					if(_fortressOutputIcon)
					{
						_fortressOutputIcon.visible = false;
						_fortressOutputWizardEffect.stop();
						_fortressOutputWizardEffect.visible = false;
					}
					return;
				}
				//
				var expand:int = 0;
				if(obj.expand > 0)//扩容量
					expand = int(SGCsvManager.getInstance().table_fortresscapacity.FindToObject("" + (10000 + int(obj.expand))).Capacity);
				if(!_fortressOutputIcon)
				{
					_fortressOutputIcon =HObject3DPool.getInstance().getHIcon3D();
					_fortressOutputIcon.mouseEnabled = true;
					if(( int(vo.capacity[0]) + expand) <= num)
					{
						_fortressOutputIcon.type = "fortressGoldFull";//已满
					}
					else
					{
						_fortressOutputIcon.type = "fortressGold";
					}
					_fortressOutputIcon.addEventListener(MouseEvent3D.CLICK, onFortressHarvestClick);
					this.addChild(_fortressOutputIcon)
					_fortressOutputWizardEffect=WizardEffectPool.getInstance().getWizardEffect("ef_cj_yaosai_shouji01", "effectall");
					this.addChild(_fortressOutputWizardEffect)
				}
				else
				{
					if(( int(vo.capacity[0]) + expand) <= num)
					{
						_fortressOutputIcon.type = "fortressGoldFull";//已满
					}
					else
					{
						_fortressOutputIcon.type = "fortressGold";
					}
					_fortressOutputIcon.visible = true;
					_fortressOutputWizardEffect.play();
					_fortressOutputWizardEffect.visible = true;
				}
				_fortressOutputIcon.z = 160;
				_fortressOutputWizardEffect.z = 159;
				//判断要塞指引是否完成 如果未完成则指引堡垒金币
				var _functionObj:Object = QuestSources.getInstance().functionObjHash.get("Fortress");
				var _fortressAry:Array = SGCsvManager.getInstance().table_function.FindRow("310");
				if(_functionObj.currentStep == 1)
				{
					ModuleEventDispatcher.getInstance().ModuleCommunication("showbaoleijinbi");
				}
			}
		}

		/**更新了资源工厂产出信息 刷新显示*/
		private function updateResFactoryInfo(e:starling.events.Event=null):void
		{
			var obj:Object = FortressModel.getInstance().factoryInfo[_wizardObject.Entity_UID];
			if(obj)
			{

				var id:String = _wizardObject.bindFun[1];
				var vo:NewFortressVo = FortressModel.getInstance().voHash.get(id);
				// 当前未收集的产出 				// 第一次服务器发来的harvestTime为当前unix时间戳，太大了，必须用Number
				var num:Number = obj.resource + int(vo.produce[0]) * (obj.harvestTime/360);
				//trace("WizardNameUnit/updateResFactoryInfo" , "当前产出"+num , "普通容量:" +int(vo.capacity[0]));
				var capacity1x : int = int(vo.capacity[0]);
//				// 2016-10-26 改成如果小于60% 基准库存量 就先不显示
//				if( num < capacity1x * SHOW_HARVESTICON_PERCENT )
//				{
//					if(_fortressOutputIcon)
//					{
//						_fortressOutputIcon.visible = false;
//						_fortressOutputWizardEffect.stop();
//						_fortressOutputWizardEffect.visible = false;
//					}
//					return;
//				}
				// 2016-11-21 改成如果小于1小时产出 就不显示
				if(obj.harvestTime < 3600)
				{
					if(_fortressOutputIcon)
					{
						_fortressOutputIcon.visible = false;
						_fortressOutputWizardEffect.stop();
						_fortressOutputWizardEffect.visible = false;
					}
					return;
				}

				var expand:int = 0;
				if(obj.expand > 0)//扩容量
					expand = int(SGCsvManager.getInstance().table_fortresscapacity.FindToObject("" + (20000 + int(obj.expand))).Capacity);
				if(!_fortressOutputIcon)
				{
					_fortressOutputIcon = HObject3DPool.getInstance().getHIcon3D();
					_fortressOutputIcon.mouseEnabled = true;
					this.addChild(_fortressOutputIcon);
					if(( int(vo.capacity[0]) + expand) <= num)
						_fortressOutputIcon.type = "fortressWuZiFull";//已满
					else
						_fortressOutputIcon.type = "fortressWuZi";
					_fortressOutputIcon.addEventListener(MouseEvent3D.CLICK, onFortressHarvestClick);
					_fortressOutputWizardEffect=WizardEffectPool.getInstance().getWizardEffect("ef_cj_yaosai_shouji01", "effectall");
					this.addChild(_fortressOutputWizardEffect)
				}	else {
					if((int(vo.capacity[0]) + expand )<= num)
						_fortressOutputIcon.type = "fortressWuZiFull";//已满
					else
						_fortressOutputIcon.type = "fortressWuZi";
					_fortressOutputIcon.visible = true;
					_fortressOutputWizardEffect.play();
					_fortressOutputWizardEffect.visible = true;
				}
				_fortressOutputWizardEffect.z = 159;
				_fortressOutputIcon.z = 160;
			}
		}

		/**要塞收集资源*/
		private function onFortressHarvestClick(e:MouseEvent3D):void
		{
//			trace("WizardNameUnit/onFortressHarvestClick");
			if(isTriggerMouseEvt)
			{
//				trace("WizardNameUnit/onFortressHarvestClick  but isTriggerMouseEvt return");
				return;
			}
//			var tmpEff:WizardEffect;
			//  uncomment debug code
			_fortressOutputIcon.visible = false;
			_fortressOutputWizardEffect.stop();
			_fortressOutputWizardEffect.visible = false;
			// 是金币还是物资
			var isJinBi:Boolean = _wizardObject.resId == 3317;
			NewFortressControl.myInstance.harvest(_wizardObject , isJinBi);

			//判断要塞指引是否完成 如果未完成则完成指引
			if(_fortressOutputIcon)
			{
				if(_fortressOutputIcon.type == "fortressGold"||_fortressOutputIcon.type == "fortressGoldFull")
				{
					var _functionObj:Object = QuestSources.getInstance().functionObjHash.get("Fortress");
					if(_functionObj.currentStep == 1)
					{
						_functionObj.currentStep = 99;
						SendMessageManage.getMyInstance().sendOpenFunctionToSever([DataType.Short(_functionObj.FunIndex), DataType.Byte(_functionObj.currentStep)]);
						ModuleEventDispatcher.getInstance().ModuleCommunication("showbaoleijinbicomplete");
					}
				}
				else if(_fortressOutputIcon.type == "fortressWuZiFull" || _fortressOutputIcon.type == "fortressWuZi")
				{//资源工厂
					refreshUnit_ArrowIcon(null);
				}
			}
		}

		//--------------------------------------------------------------------------------------------------------------------------------------------------------
		/**更新巡城奖励图标*/
		private function refreshUnit_PatrolIcon():void
		{
			if(!_wizardObject)
			{
				return;
			}
			if(_wizardObject.patrolType < 1)
			{
				if(_patrolIcon)
				{
					_patrolIcon.visible = false;
				}
				return;
			}
			if(!_patrolIcon)
			{
				_patrolIcon = HObject3DPool.getInstance().getHIcon3D();
				_patrolIcon.mouseEnabled = true;
				this.addChild(_patrolIcon);
				_patrolIcon.addEventListener(MouseEvent3D.CLICK, onGetPatrolAward);
				_patrolIcon.addEventListener(MouseEvent3D.MOUSE_OVER, onFortressOver);
				_patrolIcon.addEventListener(MouseEvent3D.MOUSE_OUT, onFortressOut);
			}
			else
			{
				_patrolIcon.visible = true;
			}
			switch(_wizardObject.patrolType)
			{
				case 1:
					_patrolIcon.name = "patrol_gold"
					if(_patrolIcon.type != "patrol_gold_up")
					{
						_patrolIcon.type = "patrol_gold_up";
					}
					break;
				case 2:
					_patrolIcon.name = "patrol_exp"
					if(_patrolIcon.type != "patrol_exp_up")
					{
						_patrolIcon.type = "patrol_exp_up";
					}
					break;
				case 3:
					_patrolIcon.name = "patrol_blood";
					if(_patrolIcon.type != "patrol_blood_up")
					{
						_patrolIcon.type = "patrol_blood_up";
					}
					break;
			}
			refreshLayout();
		}

		private function onGetPatrolAward(evt:MouseEvent3D):void
		{
			if(isTriggerMouseEvt)
			{
				return;
			}
			if(PatrolController.myInstance().interactecount>=PatrolController.myInstance().maxActCount){
				HSuspendTips.ShowTips('你的互动次数已经用完');
				return
			}

			var icon:HIcon3D = evt.currentTarget as HIcon3D;
			//巡城收获特效播放
			//				overPlay(_fortressRewardWizardEffect);
			var patrolEff:WizardEffect;
			switch(_wizardObject.patrolType)
			{
				case 1:
					patrolEff = WizardEffectPool.getInstance().getWizardEffect("ef_cj_xuncheng_jinbi","effectall");
					break;
				case 2:
					patrolEff = WizardEffectPool.getInstance().getWizardEffect("ef_cj_xuncheng_jingyan","effectall");
					break;
				case 3:
					patrolEff = WizardEffectPool.getInstance().getWizardEffect("ef_cj_xuncheng_xueqi","effectall");
					break;
			}
			this.addChild(patrolEff);
			patrolEff.z = icon.z;
			patrolEff.y = icon.y;
			setTimeout(function($wizardEffect:WizardEffect):void
			{
				WizardEffectPool.getInstance().recoverWizardEffect(patrolEff);
				removePatrol();
			}, patrolEff.maxOccurTime, patrolEff);

			ModuleEventDispatcher.getInstance().ModuleCommunication("Patrol_Actor_Get_Gain", _wizardObject.Player_ActorId);
		}

		private function removePatrol():void
		{
			if(_patrolIcon)
			{
				_patrolIcon.removeEventListener(MouseEvent3D.CLICK, onGetPatrolAward);
				_patrolIcon.removeEventListener(MouseEvent3D.MOUSE_OVER, onFortressOver);
				_patrolIcon.removeEventListener(MouseEvent3D.MOUSE_OUT, onFortressOut);
				_patrolIcon.clearIcon3D();
				HObject3DPool.getInstance().recoverHIcon3D(_patrolIcon);
				_patrolIcon=null;
			}
		}

		//--------------------------------------------------------------------------------------------------------------------------------------------------------
		override public function dispose():void
		{
			//			_wizardObject.removeEventListener(WizardEvent.UPDATE_HP, refreshUnit_HProgressBar3D);
			_firstRefresh = false;
			clickStallCallBack=null;
			if(_nameTF3D)
			{
				_nameTF3D.clearHTF3D();
				HObject3DPool.getInstance().recoverNameTxt3D(_nameTF3D);
				_nameTF3D = null;
			}

			if(_hpProgressBar3D)
			{
				_hpProgressBar3D.clearHPBar3D();
				HObject3DPool.getInstance().recoverHProgressBar3D(_hpProgressBar3D);
				_hpProgressBar3D = null;
			}

			if(_vipIcon1)
			{
				_vipIcon1.dispose();
				//				HObject3DPool.getInstance().recoverHIcon3D(_vipIcon1);
				_vipIcon1 = null;
			}

			if(_vipIcon2)
			{
				_vipIcon2.dispose();
				//				HObject3DPool.getInstance().recoverHIcon3D(_vipIcon2);
				_vipIcon2 = null;
			}

			if(_vipIcon3)
			{
				_vipIcon3.dispose();
				//				HObject3DPool.getInstance().recoverHIcon3D(_vipIcon3);
				_vipIcon3 = null;
			}

			if(_vipIcon4)
			{
				_vipIcon4.dispose();
				//				HObject3DPool.getInstance().recoverHIcon3D(_vipIcon4);
				_vipIcon4 = null;
			}

			if(_rankIcon)
			{
				_rankIcon.dispose();
				//				HObject3DPool.getInstance().recoverHIcon3D(_rankIcon);
				_rankIcon=null;
			}

			if(_taskStatusIcon)
			{
				_taskStatusIcon.clearIcon3D();
				HObject3DPool.getInstance().recoverHIcon3D(_taskStatusIcon);
				_taskStatusIcon=null;
			}

			if(_bossIcon)
			{
				_bossIcon.clearIcon3D();
				HObject3DPool.getInstance().recoverHIcon3D(_bossIcon);
				_bossIcon=null;
			}

			if(_worshipIcon)
			{
				_worshipIcon.clearIcon3D();
				HObject3DPool.getInstance().recoverHIcon3D(_worshipIcon);
				_worshipIcon=null;
			}
			if(_stallNickIcon)
			{
				_stallNickIcon.clearIcon3D();
				HObject3DPool.getInstance().recoverHIcon3D(_stallNickIcon);
				_stallNickIcon=null;
			}
			if(_poserTF3D)
			{
				_poserTF3D.clearHTF3D();
				HObject3DPool.getInstance().recoverHTextField3D(_poserTF3D);
				_poserTF3D=null;
			}

			if(_rankTF3D)
			{
				_rankTF3D.clearHTF3D();
				HObject3DPool.getInstance().recoverHTextField3D(_rankTF3D);
				_rankTF3D=null;
			}

			if(_titleWizardEffect)
			{
				_titleWizardEffect.dispose();
				_titleWizardEffect = null;
			}

			if(_nameBoxIcon)
			{
				_nameBoxIcon.removeEventListener(MouseEvent3D.CLICK, onFortressClick);
				_nameBoxIcon.removeEventListener(MouseEvent3D.MOUSE_OVER, onFortressOver);
				_nameBoxIcon.removeEventListener(MouseEvent3D.MOUSE_OUT, onFortressOut);
				_nameBoxIcon.clearIcon3D();
				HObject3DPool.getInstance().recoverHIcon3D(_nameBoxIcon);
				_nameBoxIcon=null;
			}

			if(_arrowIcon)
			{
				_arrowIcon.clearIcon3D();
				HObject3DPool.getInstance().recoverHIcon3D(_arrowIcon);
				_arrowIcon=null;
			}

			if(_fortressOutputIcon)
			{
				_fortressOutputIcon.removeEventListener(MouseEvent3D.CLICK, onFortressHarvestClick);
				_fortressOutputIcon.clearIcon3D();
				HObject3DPool.getInstance().recoverHIcon3D(_fortressOutputIcon);
				_fortressOutputIcon=null;
			}

			if(_flgIcon)
			{
				_flgIcon.clearIcon3D();
				HObject3DPool.getInstance().recoverHIcon3D(_flgIcon);
				_flgIcon=null;
			}

			removePatrol();

			if(_fortressUpLvIcon)
			{
				_fortressUpLvIcon.clearIcon3D();
				HObject3DPool.getInstance().recoverHIcon3D(_fortressUpLvIcon);
				_fortressUpLvIcon=null;
			}

			if(_fortressOutputWizardEffect)
			{
				WizardEffectPool.getInstance().recoverWizardEffect(_fortressOutputWizardEffect);
				_fortressOutputWizardEffect = null;
			}

			if (_wizardObject)
			{
				_wizardObject.hpFun.removeFun(refreshUnit_HProgressBar3D);
			}
			ModuleEventDispatcher.getInstance().removeEventListener(FortressEvent.FORTRESS_UPDATE_RESERVES, updateFortressItem);
			ModuleEventDispatcher.getInstance().removeEventListener(FortressEvent.FORTRESS_HALLINFO_UPDATED, updateHallInfo)	;	//,堡垒容量更新);
			ModuleEventDispatcher.getInstance().removeEventListener(FortressEvent.FORTRESS_RESFACTORYINFO_UPDATED, updateResFactoryInfo)	;//, 资源工厂容量更新);

			_wizardObject = null;
			_actor3d = null;
			_npcQuest = null;

			Dispatcher_F.getInstance().removeEventListener(Configuration.hideTitle, onHideTitle);

			super.dispose();
		}

		/** 玩家鼠标移上要塞建筑，要塞名字 是否显示 */
		public function isShowFortressName(b :Boolean ):void
		{
			if(_nameTF3D)_nameTF3D.visible = b ||isGuideFortressName;
			if (_nameBoxIcon)_nameBoxIcon.visible = b||isGuideFortressName;
		}
		/** 是否因为引导功能 而要求要塞名字显示 */
		private var isGuideFortressName:Boolean = false;
	}
}