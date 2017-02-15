package HLib.UICom.BaseClass
{
	/**
	 * 窗口基类,窗口显示对象需要继承此类
	 * 
	 * 属性与方法:
	 * 	initAddEvent()	: 当前窗口如果需要添加到舞台或移除出舞台时自动调用
	 * 					  重写方法addToStage()与removeFromStage()时调用此方法
	 * addToStage()		: 添加到舞台时调用的方法,需要用到时请重写此方法
	 * removeFromStage(): 移除出舞台时调用的方法,需要用到时请重写此方法
	 * HWindowShow()	: 窗口初始化数据,窗口初始化设置样式需要调用此方法
	 * myWidth			: 获取当前窗口的宽度
	 * myHeight			: 获取当前窗口的宽度
	 * IsInIt			: 设置与获取是否初始化完成,当窗口初始化完成后请设置此标识为true
	 * TileSize			: 标题文字大小
	 * TileColor		: 标题文字颜色
	 * SetTile			: 标题文字
	 * CloseHSBtn		: 关闭按钮,有时需要获取关闭按钮控制操作时可用
	 * TileTF			: 标题文本,有时需要获取文本做相应的样式修改可用
	 */	
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import HLib.Event.Dispatcher_F;
	import HLib.Event.ModuleEvent;
	import HLib.Event.ModuleEventDispatcher;
	import HLib.MapBase.UIScene;
	import HLib.UICom.Component.HSimpleButton;
	
	import Modules.Common.ComEventKey;
	import Modules.Common.HAssetsManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.Common.window.BuyWindow;
	import Modules.DataSources.ChatDataSource;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.MainFace.MouseCursorManage;
	import Modules.Mall.view.MallWindow;
	import Modules.NewFortress.Window.NewFortressSupportModel;
	import Modules.view.equiptStrong.HelpWindow;
	
	import feathers.display.Scale9Image;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import tool.StageFrame;
	
	public class HWindow extends HSprite
	{
		private var _IsInIt:Boolean = false;							//是否初始化
		private var _Type:int = -1;									//当前窗口类型
		private var _myWwidth:Number;									//窗口宽度
		private var _myWheight:Number;									//窗口高度
		protected var _TitleTF:HTextField;
		//标题文本
		private var _TitleSize:int = 12;								//标题字体大小
		private var _TitleColor:uint = 0xFEFF89;						//标题字体颜色
		private var _title:String;										//标题
		private var _isMove:Boolean ;									//是否移动
		private var _movePoint:Point;									//移动点
		private var _moveX:Number = 0;									//移动距离
		private var _moveY:Number = 0; 
		private var _backgroundImg:Scale9Image						   	//背景图
		private var _isCanDrag:Boolean = true;						//是否可拖动
		protected var _isClose:Boolean = false;							//窗口是否在关闭中
		private var _bgSource:Texture;									//背景纹理
		private var _nowPoint:Point = new Point();						//当前鼠标点
		protected var _txtImage:Image;									//窗口标题文字
		private var _backImage:Image;									//标题背景
		private var _signImage:Image 									//符号背景
		private var _openPoint:Point = new Point(0, 0);				//打开点
		protected var myRectangle:Rectangle;							//3d模型显示区域
		protected var _windowsBorderWidth:int;							//窗口边框宽度
		protected var _windowsTitleHeight:int;							//窗口标题的高度,用于排版定位用
		
		public var actor3DPoint:Point;									//是否显示3d模型
		public var role3DNameStr:String;								//３Ｄ模型名称
		public var actor3DPointArr:Array;								//是否显示3d模型
		public var role3DNameStrArr:Array;								//３Ｄ模型名称
		public var _CloseHSBtn:HSimpleButton = new HSimpleButton();	//关闭按钮
		public var isChangeScale:Boolean = true;						//是否改变位置标志
		
		protected var _bgTexture:Texture;
		protected var titlePack:String;									//标题资源包
		protected var titleName:String;									//标题图片名
		protected var _closeTweenLite:TweenLite;						//关闭界面缓动管理
		public function HWindow() {  }
		/**
		 * 是否可拖动
		 * @param value
		 */		
		public function set isCanDrag(value:Boolean):void
		{
			_isCanDrag = value;
			if(!_TitleTF) return;
			if(_isCanDrag)
				_TitleTF.addEventListener(TouchEvent.TOUCH,onTouch);
			else
				_TitleTF.removeEventListener(TouchEvent.TOUCH,onTouch);
		}
		public function get isCanDrag():Boolean  {  return _isCanDrag;  }
		public function get isClose():Boolean  {  return _isClose;  }
		/** 初始化添加指定 **/
		public function initAddEvent():void
		{
			//添加到舞台时执行
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			//移出舞台时执行
			this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, onRemoverFromStage);
			ModuleEventDispatcher.getInstance().addEventListener("stageResizeChange3Dposition", change3DPosition);
		}
		
		private function onAddedToStage(e:starling.events.Event):void			{ 
			Starling.current.nativeStage.focus = null;
			
			addToStage();  
		}
		private function onRemoverFromStage(e:starling.events.Event):void		{ 
			removeFromStage(); 
			role3DNameStrArr = null;
			actor3DPointArr = null;
			if(this is MallWindow || this is NewFortressSupportModel)
				BuyWindow.getInstance().hide();
		}
		
		/** 初始化添加到场景执行,如果窗口需要每次打开时都执行某个操作可重写此方法 **/
		protected function addToStage():void  {  }
		/** 每次移除出舞台执行,如果窗口需要每次关闭时都执行某个操作可重写此方法 **/
		protected function removeFromStage():void  {  }
		
		/**
		 * 窗口样式
		 * @param width		: 窗口宽度
		 * @param height	: 窗口高度
		 * @param tile		: 标题
		 * @param type		: 窗口类型 1、带有标题背景图和标题标志　２、带有标题背景图　３、都不带
		 * @param source	: 自定义背景
		 */		
		public function HWindowShow(width:Number, height:Number, title:String=null, type:int=1, bgSource:Texture = null):void
		{
			_title = title;
			_Type = type;
			_bgSource = bgSource;
			this.myWidth = _myWwidth = width;
			 this.myHeight = _myWheight = height;			
			onUIComplete();
		}
		
		/**数据找回时刷新*/
		private function onRestoreLoad(event:flash.events.Event):void
		{
			Dispatcher_F.getInstance().removeEventListener(ComEventKey.CONTEXT_CREATED, onRestoreLoad); 
			onUIComplete();
		}
		/**显示UI窗口背景*/
		private function onUIComplete():void
		{
			if(_IsInIt) return;
			
			if(ChatDataSource.getMyInstance().isDisposed || Starling.context.driverInfo == "Disposed") 
			{ 
				Dispatcher_F.getInstance().addEventListener(ComEventKey.CONTEXT_CREATED, onRestoreLoad); 
				return; 
			}
			var btnx:int, btny:int;
			var texture:Texture;				//背景底图
			var rectang:Rectangle				//九宫格放大矩形
			//设置窗口的起始坐标用于排版用
			_windowsBorderWidth = 8;
			_windowsTitleHeight = 54;
			var isShow:Boolean;
			if(_bgSource != null)
			{
				if(_Type == 2)
					btny = 100;
				else if(_title == "qqexchange")
					btny = 13;
				else
					btny = 5;
				
				texture = _bgSource
				
			} 	else {
				btny = 11;
				switch(_title)
				{
					case "worldMap":
						texture  = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_16, "map_792X600");
						break;
					case "getgift":
					case "fish":
					case "dugeon_cteate":
					case "camp_aouunt":
						texture  = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_FACE_SOURCE, "reminder_362X260");
						break;
					case "equipt":
						texture  = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4, "equiptStrong/back_3");
						break;
					case "vip":
						texture  = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_11, "NewVip/dikuangBg");
						break;
					case "invest" :
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_6, 'invest/bg')
						break;
					case "festival":
//						_title="";
//						texture  = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_28, "hallowmas/hallowmas_bg_0");
//						break;
					case "achieve" :
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_12, '792X600');
						break;
					case "pictureReward" :
					case "goodActivity" :
					case 'zhinan':
					case 'newSeverRank':
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_12, '792X600');
						break;
//					case "dayActivity" :
//						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_2, 'activity/dailyActivityBg');
//						break;
					case "camp" :
						_title = ""
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_12, '848X600');
						break;
					case 'suipEquipt' :
					case "privateCompition" :
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_12, '848X600');
						break;
					case "campTitle" :
					case "steam" :
					case "strom" :
					case "lava" :	
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_17, 'campTitle');
						break;
					case "sevenDay" :
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_1, 'seven_day_800X570');
						break;
					case "rank" :
					case "title":
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_16, 'rank_706X570');
						break;
					case 'CampZcMobaiWindow':
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_6,'campZc/mobaiBg');
						break;
					case "dugeon_hall" :
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_4, 'dungeon/dungeonBg');
						break;
					case 'setting' :
					case "dayActivity" :
					case 'dayActivity' ://器魂	
					case 'construction3' :
					case 'soulbook' ://图鉴
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_12, 'ectypal_848x570');
						break;
					case "xuemai" :
					case "fortress" :
					case "mount" :
					case "wings" :
					case "packaging" :
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_16, 'wing432x570');
						break;
					case "tabbedPanel":
					case "roleinfo" :
					case "alchemist" :
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_16, 'role432x570');
						break;
					case "support_bg":
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_0, 'support_bg');
						break;
					case "voidTrace" :
					case 'stararray':
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_16, 'qiHun_848X570');
						break;
					case 'becketWindow' :
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_12, '792X600');
						break;
					case "crossBattle" :
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_11, 'crossBattle/crossBattleBg');
						break;
					case "bag" :
					case "items_2" :
					case "qihunadvance":
					case 'worldkingrank' :
					case 'becketrank':
					case "activity_celebration" :
					case "upgradeStar" :
					case "soulbookExchange":
					case "mount_upgrade" :
					case "wings_upgrade" :
					case "grade" :
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_FACE_SOURCE, 'BG340X570');
						break;
					case "pluginUpdate" :
					case "soulgrade" :
					case "mount_shop":
					case "mountIll" :
					case "wingIll" :
					case "chibangCulativt":
					case "rideCulativt":
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_16, 'culativate');
						break;
					case "enterEctype" :
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_10, 'ectypalBG');
						break;
					case "email" :
					case "activity" :
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_3, 'email_680x520');
						break;
					case "immolationNPC" :
						if(_Type == 1)
							texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_12, '432X570');
						break;
					case "teamMenber" :
					case "material" :
					case "learnSkill" :
					case 'followshop' :
					case 'buy_290X570' :
					case 'items_to_buy' :
					case "wargrilskill": 
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, 'buy_290X570');
						break;
					case 'qihun' ://器魂
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_9, 'qiHun_1320X686')
						break;
					case 'qqyellow' ://qq黄钻
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_26, 'yellowDimandBg')
						break;
					case 'wargril' ://战姬
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_9, 'wargril/wargril')
						break;
					case "stall_1" :
					case 'dialogue' ://npc对话
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, 'NPC_dialogue_360X570')
						break;
					case 'skill'://技能
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_3, 'skill/skill_bg');
						break;
					case "self_chat" :
					case 'chat_556x504' :
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_12, 'chat_556x504');
						break;
					case 'shop':
					case "管理员窗口":
					case 'NPC_shop_444X570' :
					case "equConversion":
					case 'ExperiencedPrayWindow':
		
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_12, 'NPC_shop_444X570');
						break;
					case 'estore' :
					case 'fortressWar' :
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_12, 'camp_escort_844x494');
						break;
					case 'master':
					case "giveItem":
					case "weekBuy":
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_12, 'gift_492X390')
						break;
					case 'camp_want' :
					case 'hangItem' :
					case "help" :
					case "searchTeam" :
					case "createTeam" :	
					case "system_mesg":
					case "gm":
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_12, 'release_430X346')
						break;
					case 'bossfamily' ://器魂
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_7, 'bossfamily')
						break;
					case 'campWarTitle':
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_16, 'qiHun_848X570');
						break;
					default ://
						if(_Type == 1)
						{
							isShow = true;
							if(_myWwidth < 420)
							{
								_Type = 2;
							} 	else if(_myWwidth < 300) {
								_Type = 3;
								isShow = false;
							}
							texture = MainInterfaceManage.getInstance().getWindowBackground(_myWwidth,_myWheight,null)
						}	else if(_Type == 2) {
							isShow = true;
							texture = MainInterfaceManage.getInstance().getWindowBackground(_myWwidth,_myWheight,null)
						}	else if(_Type ==  3) {//
							isShow = false;
							texture = MainInterfaceManage.getInstance().getWindowBackground(_myWwidth,_myWheight,null)
						}	else if(_Type == 4) {//
							btny = 13;
							isShow = false;
							texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, 'reminder_362X240')
						} 	else {
							isShow = false;
							texture = MainInterfaceManage.getInstance().getWindowBackground(_myWwidth,_myWheight,null)
						}
					break;
				}
				if(texture == null)
				{
					if(_Type == 4)
						btny = 13;
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, 'reminder_362X240')
					if(_Type > 2)
						isShow = false;
					else
						isShow = true;
					if(texture == null)
						texture = Texture.fromColor(_myWwidth,_myWheight,0xFF000000);
				}
			}
			_bgTexture = texture;
			this.myDrawByTexture(texture);

			if(isShow)
			{
				if(_Type < 3)
				{
					_backImage = new Image(HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/title_background"));
					_backImage.touchable = false;
					this.addChild(_backImage);
					_backImage.x = this.myWidth - _backImage.width >> 1;
					_backImage.y = 8;
				}
				if(_Type < 2)
				{
					_signImage = new Image(HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/window_sign"));
					_signImage.touchable = false;
					this.addChild(_signImage);
					_signImage.x = _backImage.x >> 1;
				}
			}
			if(this.titlePack && this.titleName)
			{
				texture = HAssetsManager.getInstance().getMyTexture(this.titlePack, this.titleName);
			}	else {
				if(_title == "dialogue")
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"background/title_" + _title);
				else if(_title == "activity")
					texture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","title_text/txt_activity");
		
				else if(_title == "qihun")
					texture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","title_text/txt_qihun");
				else if(_title == "qihunadvance")
					texture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","title_text/txt_qihun_upgrade");
				else if(_title == "wargril")
					texture = HAssetsManager.getInstance().getMyTexture("source_activityIcon_9","wargril/war");
				else if(_title == "wargrilskill")
					texture = HAssetsManager.getInstance().getMyTexture("source_activityIcon_9","wargril/wargrilskill");
				else if(_title == "soulbook")
					texture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","title_text/txt_soulbook");
				else if(_title == "becketWindow")
					texture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","title_text/title_zztx");
				else if(_title == "becketrank")
					texture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","title_text/title_zztx_kfph");
				else if(_title == "qqexchange")
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_21, 'qq_shop_bg_8');
				else if(_title == "equConversion")
					texture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","title_text/txt_equConversion");
				else if(_title == "bossfamily")
					texture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","title_text/bossfamily");
				else if(_title == "CampZcMobaiWindow")
					texture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","title_text/txt_CampZcMobaiWindow");
				else
					texture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","title_text/title_" + _title);
			}
			_TitleTF=new HTextField(_myWwidth,25,'',"宋体",14);
			if(texture)
			{
				_txtImage = new Image(texture);
				this.addChild(_txtImage);
				_txtImage.touchable = false;
				_txtImage.x = (this.myWidth - texture.width >> 1)+_txtImageXOffset;
				if(_Type == 4)
					_txtImage.y = 23;
				else
					_txtImage.y = 16;
				//战姬坐标调整
				if(_title == "wargril")
				{
					_txtImage.visible = false;
					_TitleTF.height = 70;
				}else if(_title == "qihun")
				{
					_txtImage.visible = false;
					_TitleTF.x=450;
					_TitleTF.height = 60;
				}
				else if(_title == "vip")
				{
					_txtImage.visible = false;
				}
				else if(_title == "campWarTitle")
				{
					_txtImage.visible = false;
				}
				
				
			}	else {
				//标题文本
				_TitleTF.color = _TitleColor;
				_TitleTF.hAlign = "center";
				_TitleTF.bold = true;
				_TitleTF.label = _title;
			}
			this.addChild(_TitleTF);
			if(_Type == 4)
				_TitleTF.y = 23;
			else
				_TitleTF.y = 16;
			//标题点击事件
			isCanDrag = isCanDrag;
			//关闭按钮
			_CloseHSBtn.setCloseSkin();
			_CloseHSBtn.init();
			this.addChild(_CloseHSBtn);
			_CloseHSBtn.addEventListener(starling.events.Event.TRIGGERED,onClickClose);
			_CloseHSBtn.x = this._myWwidth - _CloseHSBtn.myWidth - btny- 1;;
			_CloseHSBtn.y = btny 
			_IsInIt = true;
			
			//战姬坐标调整
			if(_title == "wargril")
			{
				_CloseHSBtn.x = 1100;
				_CloseHSBtn.y = btny + 45;
			}else if(_title == "qihun")
			{
				_CloseHSBtn.x = 1148;
				_CloseHSBtn.y = btny + 41;
			}	else if(_title == "airClient") {
				_CloseHSBtn.x = 770;
				_CloseHSBtn.y = 90;
				_TitleTF.y = 65;
				_TitleTF.height = 50
				_TitleTF.label = ''
			}else if(_title == "immolation")
			{
				_CloseHSBtn.y = 70;
				_CloseHSBtn.x = 430;
				_TitleTF.label="";
				if(_backImage)
				    _backImage.visible = false;
			}
			
			this.addEventListener("dispatchCloseWindow",dispatchCloseWindow)
			//this.addEventListener(Event.ADDED_TO_STAGE, onAddUpdateBg);
		}
		
		private function onAddUpdateBg():void
		{
			//this.myDrawByTexture(_bgTexture);
		}
		
		private function dispatchCloseWindow(e:starling.events.Event):void
		{
			onClose();
		}
		/**
		 * 点击关闭界面 
		 * @param e
		 * 
		 */		
		protected function onClickClose(e:starling.events.Event):void
		{
			onClose();
		}
			
		/** 鼠标down标题文本 **/
		private function onTouch(e:TouchEvent):void
		{
			if(HTopBaseView.getInstance().hasEvent && !isPierce) return; //顶层是否添加UI了
			Starling.current.nativeStage.focus = null;
			var touch:Touch = e.getTouch(_TitleTF);
			if(!touch || !this.stage)
				return;
			if(touch.phase == TouchPhase.BEGAN)//down
			{
				_movePoint = touch.getLocation(this.stage,_movePoint);
				_moveX = _movePoint.x - this.x;
				_moveY = _movePoint.y - this.y;
				_isMove = true;
				if(this.parent != null)
				{
					this.parent.setChildIndex(this, this.parent.numChildren - 1);
				}
			}
			if(touch.phase == TouchPhase.ENDED)//click
				_isMove = false;
			if(_isMove && touch.phase == TouchPhase.MOVED)//over
			{
				_movePoint = touch.getLocation(this.stage,_movePoint);
				var addx:Number = _movePoint.x - _moveX ;
				var addy:Number = _movePoint.y - _moveY;
				if(addx < -(this.myWidth >> 1)) addx = -(this.myWidth >> 1);
				if(addy < 0) addy = 0;
				if(addx > HBaseView.getInstance().myWidth - (this.myWidth >> 1)) addx = HBaseView.getInstance().myWidth - (this.myWidth >> 1);
				if(addy > HBaseView.getInstance().myHeight - (this.myHeight >> 1)) addy = HBaseView.getInstance().myHeight - (this.myHeight >> 1)
				this.x = addx;
				this.y = addy;
			}
		}
		
		protected function moveXY():void
		{
			var p:Point;
			var length:int;
			if(role3DNameStrArr)
			{
				length = role3DNameStrArr.length;
				for(var i:int;i < length;i++)
				{
					p =  new Point(actor3DPointArr[i].x+this.x,actor3DPointArr[i].y+this.y);
					UIScene.getInstance().setWizardPosition(role3DNameStrArr[i], p);
				}
			}
			else if(actor3DPoint)
			{
				p =  new Point(actor3DPoint.x+this.x,actor3DPoint.y+this.y);
				if(p.equals(_nowPoint)) return;
				_nowPoint.x = p.x;
				_nowPoint.y = p.y;
				UIScene.getInstance().setWizardPosition(role3DNameStr, _nowPoint);
			}
		}
		
		/**隐藏3d模型*/
		public function hide3DWizard():void
		{
			
		}
		
		/**添加3d模型*/		
		public function add3DWizard():void
		{
			
		}
		/** 点击关闭按钮时执行 **/
		public function onClose():void 
		{
			if(HelpWindow.myInstance.isShow && HelpWindow.myInstance.parent == this)
				HelpWindow.myInstance.parent.removeChild(HelpWindow.myInstance);
			if(_isClose) return;
			_isClose = true;
			//添加保护,避免出现关闭后没有把_isClose设置回false导致无法关闭窗口问题
			var timeout:uint = setTimeout(function():void
			{
				_isClose = false;
				clearTimeout(timeout);
			}, 1000);
			hide3DWizard();
			if(openPoint && (openPoint.x != 0 || openPoint.y != 0))
				_closeTweenLite = TweenLite.to(this, .3, {scaleX:.1, scaleY:.1, x:openPoint.x, y:openPoint.y,onComplete:myCompleteFunction, onCompleteParams:[this]});
			else 
				_closeTweenLite = TweenLite.to(this, .3, {alpha:0, onComplete:myCompleteFunction, onCompleteParams:[this]});
			function myCompleteFunction(_t:HWindow):void
			{
				_closeTweenLite.kill();
				_closeTweenLite = null;
				_t.alpha=1;
				_t.touchable = true;
				if(_t.parent)
					_t.parent.removeChild(_t);
				_isClose = false;
				MouseCursorManage.getInstance().showCursor();
				setTimeout(function ():void{
					HBaseView.getInstance().clearMOuseCursor();
				}, 50);
			}
			
		}
		
		public override function dispose():void
		{
			if(_txtImage)
				_txtImage.dispose();
			if(_backImage)
				_backImage.dispose();
			if(_signImage)
				_signImage.dispose();
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			this.removeEventListener(starling.events.Event.REMOVED_FROM_STAGE, onRemoverFromStage);
			if(_TitleTF)
				_TitleTF.removeEventListener(TouchEvent.TOUCH,onTouch);
			_CloseHSBtn.removeEventListener(starling.events.Event.TRIGGERED,onClickClose);
			super.dispose();
		}
/******************************************** set/get ***************************************************/
		/** 是否初始化完成 **/
		public function set IsInIt(value:Boolean):void{
			_IsInIt = value;
		}
		public function get IsInIt():Boolean{
			return _IsInIt;
		}
		public function get TileSize():int{
			return _TitleSize;
		}
		/** 设置标题文本字体颜色 **/
		public function set TileColor(value:uint):void{
			_TitleTF.color = value;
		}
		public function get TileColor():uint{
			return _TitleColor;
		}
		/** 设置标题文本内容 **/
		public function SetTile(tiletxt:String):void{
			_TitleTF.text = tiletxt;
		}
		/** 获取关闭按钮进行控制 **/
		public function get CloseHSBtn():HSimpleButton{
			return _CloseHSBtn;
		}
		/** 获取标题文本 **/
		public function get TitleTF():HTextField{
			return _TitleTF;
		}
		
		public function set TitleTF(value:HTextField):void
		{
			_TitleTF = value;
		}
		/** 浏览器窗口大小改变时刷新3d模型位置  */		
		protected function change3DPosition(e:starling.events.Event=null):void
		{
			if (role3DNameStrArr || actor3DPoint)
				StageFrame.addNextFrameFun(updatePosition);
		}
		
		private function updatePosition():void
		{
			if (role3DNameStrArr) 
			{
				var leng:uint = role3DNameStrArr.length;
				for(var i:int;i < leng;i++)
				{
					p =  new Point(actor3DPointArr[i].x+this.x,actor3DPointArr[i].y+this.y);
					UIScene.getInstance().setWizardPosition(role3DNameStrArr[i], p);
				}
			}	
			else  if(actor3DPoint) 
			{
				var p:Point =  new Point(actor3DPoint.x+this.x,actor3DPoint.y+this.y);
				_nowPoint.x = p.x;
				_nowPoint.y = p.y;
				UIScene.getInstance().setWizardPosition(role3DNameStr, _nowPoint);
			}
		}
		
		override public function set y(value:Number):void
		{
			if(value % 2 != 0)
				value = value - value%2;
			super.y = value;
			
			moveXY();
		}
		
		override public function set x(value:Number):void
		{
			if(value % 2 != 0)
				value = value - value%2;
			super.x = value;
			
			moveXY();
		}

		public function get openPoint():Point
		{
			return _openPoint;
		}

		public function set openPoint(value:Point):void
		{
			_openPoint = value;
			if(value && isChangeScale)
			{
				this.x = value.x;
				this.y = value.y;
				this.scaleX = this.scaleY = 0.1;
			}	else {
				this.scaleX = this.scaleY = 1;
			}
		}
		/** 更新标题文本图片 */
		public function updateTxtImage(texture:Texture):void
		{
			if(texture)
			{
				if(!_txtImage)
				{
					_txtImage = new Image(texture);
					this.addChild(_txtImage);
					_txtImage.touchable = false;
					if(_Type == 4)
						_txtImage.y = 23;
					else
						_txtImage.y = 16;
					_txtImage.x = (this.myWidth - texture.width >> 1)+_txtImageXOffset;
				}	else {
					if(_txtImage.texture != texture)
					{
						_txtImage.texture = texture;
						_txtImage.readjustSize();
						_txtImage.x = (this.myWidth - texture.width >> 1)+_txtImageXOffset;
					}
				}
				_TitleTF.text = '';
			}	else {
				if(!_txtImage)
					_TitleTF.text = _title;
			}
		}

		// 修正美术做的底图歪了的问题 坚定让改的
		/** 标题图（如有） 的x偏移 */
		protected var _txtImageXOffset:Number = 0;
	}
}