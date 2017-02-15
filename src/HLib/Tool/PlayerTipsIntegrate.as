package HLib.Tool
{
	/**
	 * 玩家提示整合类(升级提示,开放技能等)
	 * @author 李舒浩
	 */	
	import com.greensock.TweenLite;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import HLib.DataUtil.HashMap;
	import HLib.Event.ModuleEventDispatcher;
	import HLib.IResources.IResourceManager;
	import HLib.MapBase.UIScene;
	import HLib.Net.Socket.Connect;
	import HLib.UICom.Away3DUICom.HIcon3D;
	import HLib.UICom.BaseClass.HBaseView;
	import HLib.UICom.BaseClass.HMovieClip;
	import HLib.UICom.BaseClass.HSprite;
	import HLib.UICom.BaseClass.HTopBaseView;
	import HLib.UICom.Component.HSimpleButton;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.HCss;
	import Modules.Common.MsgKey;
	import Modules.Common.SGCsvManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.SFeather.SFTextField;
	import Modules.SFeather.StarlingTextField;
	import Modules.SFeather.StarlingTextFieldExpand;
	import Modules.Wings.WingsSources;
	import Modules.Wizard.WizardActor3D;
	import Modules.Wizard.WizardObject;
	
	import effectEditor.lua__3A__5C_flascc_5C_cygwin_5C_tmp_5C_ccLueNHJ_2E_lto_2E_bc_3A_35ea9c3d_2D_e0aa_2D_47ca_2D_ab62_2D_67038c20928c.clockStart;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	public class PlayerTipsIntegrate extends HSprite
	{
		private var _bgUpImage:Image;						//背景头image
		private var _bgImage:Image;						//背景image
		private var _downImage:Image;						//背景底image
		
		private var _titleImage:Image;						//标题image
		private var _titleText:StarlingTextField;			//标题文本
		
		private var _tipsBGImage:Image;					//提示背景
		private var _tipsText:StarlingTextField;			//提示文本
		private var _contentsText:StarlingTextField;		//内容文本
		private var _lvText:StarlingTextField;				//等级文本
		
		private var _iconBG:Image;							//图片背景
		private var _iconImage:Image;						//技能icon
		private var _titleNameImage:Image;					//称号image
		private var _titleBg:Image;							//称号背景
		private var _titleLeft:Image;
		private var _titleRight:Image;
		private var _titleLine:Image;//称号背景上面标识
		
		private var _tiyanbtn:HSimpleButton;//体验按钮
		private var _peidaibtn:HSimpleButton;//佩戴按钮
		private var _nopeidaibtn:HSimpleButton;//暂不佩戴按钮
		private var _tiyandata:Object;
		private var _peidaidata:Object;//按钮数据
		private var _peidaibtny:int = 170;//佩戴按钮y坐标
		
		private var _effectWing1:HMovieClip;//翅膀特效1
		private var _effectWing2:HMovieClip;//翅膀特效2
		public var _ifPlayWing2:Boolean;//是否播放完成特效1后播放特效2
		
		private var _countdown:StarlingTextFieldExpand;	//倒计时
		
		private var _type:int;								//类型
		
		public var _initx:int;
		public var _inity:int;//初始坐标
		
		private var _wizard:WizardActor3D;
		private var _wizardObject:WizardObject;
		private var _wizardhash:HashMap;
		
		private var ifShowWizard:Boolean;
		private var _offsetx:int=470;
		private var _offsety:int=550;//精灵坐标
		
		private var _bgheight:int = 122;
		private var _ksize:int = 95;//翅膀上面空白位距离
		
		public var role3DNameStr:String;
		public var actor3DPoint:Point;
		private var icon:HIcon3D;
		
		public var _data:Object;
		
		private var _dataAry:Array = [];//未加载完成时存放初始数据
		private var _isLoad:Boolean;
		private var _timeText:SFTextField;
		
		private var _self:PlayerTipsIntegrate;
		
		public function PlayerTipsIntegrate()  { 
			super(); 
			this.myWidth = 480;
			this.myHeight = 300;
			_self = this;
			
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if(!value)
			{
				onRemove()
			}
		}
		
		
		private function onRemove():void
		{
			setTimeout(function ():void
			{
				HTopBaseView.getInstance().hasEvent = false;
			}, 50);
		}
		/**
		 * 设置类型
		 * @param $value	: 0:获得称号 1:等级提升 2:开始挑战时间 3:技能解锁
		 * _showKey 是否需要玩家来操作 0 静默开放 1 不需要操作的静默开放 2 需要操作的静默开放
		 */		
		public function init($value:int,$data:Object = null):void
		{
			_type = $value;
			switch(_type)
			{
				case 0:
					_peidaidata = $data;
					break;
				case 4:
					_tiyandata = $data;
					break;
			}
			//if( !MainInterfaceManage.getInstance().isLoadUI ) return;
			
			if(!this.isInit){
				
				//背景显示
				_bgImage = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/openBg_5") );
				this.addChild(_bgImage);
				_bgImage.width = 512;
				//底部位图
				_downImage = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/openBg_3") );
				this.addChild(_downImage);
				_downImage.x = this.myWidth - _downImage.width >> 1;
				_downImage.y = _bgheight - 2;
				//实例化其他界面
				switch(_type)
				{
					case 0:
						_peidaidata = $data;
						_bgImage.x = this.myWidth * 0.5 - _bgImage.width * 0.5;
						_bgImage.height = 140;
						_bgImage.visible = true;
						_downImage.visible = true;
						initType_0();
						break;
					case 1:
						_bgImage.x = this.myWidth * 0.5 - _bgImage.width * 0.5;
						_bgImage.height = 100;
						_bgImage.visible = true;
						_downImage.visible = true;
						initType_1();
						break;
					case 2:
						_bgImage.height = 122;
						//顶部位图
						var upImageStr:String = ( (_type==0 || _type == 3 || _type==4) ? "openBg_1" : "openBg_2" );
						_bgUpImage = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/"+upImageStr) );
						this.addChild(_bgUpImage);
						_bgUpImage.x = _bgImage.width - _bgUpImage.width >> 1;
						initType_2();
						break;
					case 3:
						_bgImage.visible = false;
						initType_3();
						break;
					case 4:
						_tiyandata = $data;
						_bgImage.visible = false;
						initType_4($data.showKey);
						break;
				}
				
				
				// 0:获得称号 1:等级提升 2:开始挑战时间 3:技能开放 4:功能开放
				if(_type == 3 || _type == 4){
					_bgImage.visible = false;
					_downImage.visible = false;
				}
				
				if(!_peidaibtn){
					_peidaibtn = new HSimpleButton();
					_peidaibtn.setDefaultSkin3();
					_peidaibtn.upColor = 0xffffff;
					_peidaibtn.init("立即佩戴");
					_peidaibtn.isPierce = true;
					_peidaibtn.visible = false;
					_peidaibtn.x = this.myWidth * 0.5 - _peidaibtn.width - 5;
					_peidaibtn.y = _bgheight;
					this.addChild(_peidaibtn);
					_peidaibtn.addEventListener(Event.TRIGGERED,onClick);
				}
				
				if(!_nopeidaibtn){
					_nopeidaibtn = new HSimpleButton();
					_nopeidaibtn.setDefaultSkin3();
					_nopeidaibtn.upColor = 0xffffff;
					_nopeidaibtn.init("暂不佩戴");
					_nopeidaibtn.isPierce = true;
					_nopeidaibtn.visible = false;
					_nopeidaibtn.x = this.myWidth * 0.5 + 5;
					_nopeidaibtn.y = _bgheight;
					this.addChild(_nopeidaibtn);
					_nopeidaibtn.addEventListener(Event.TRIGGERED,onClick);
				}
				
				_effectWing1 = new HMovieClip();
				var textureVec1:Vector.<Texture>;
				textureVec1 = HAssetsManager.getInstance().getMyTextures(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"openfunction/chibang1_0000");
				_effectWing1.setTextureList(textureVec1);
				_effectWing1.IsPlayEvent = true;
				_effectWing1.Stop();
				_effectWing1.visible = false;
				_effectWing1.x = -2;
				this.addChild(_effectWing1);
				this.setChildIndex(_effectWing1,0);
				_effectWing1.addEventListener("PlayerOverOnce",onPlayComplete1);
				
				_effectWing2 = new HMovieClip();
				var textureVec2:Vector.<Texture>;
				textureVec2 = HAssetsManager.getInstance().getMyTextures(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"openfunction/chibangl_0000");
				_effectWing2.setTextureList(textureVec2);
				_effectWing2.playTime = -1;
				_effectWing2.Stop();
				_effectWing2.visible = false;
				_effectWing2.x = _effectWing1.x + _effectWing1.width * 0.5 - _effectWing2.width * 0.5;
				_effectWing2.y = _effectWing1.y + _effectWing1.height * 0.5 - _effectWing2.height * 0.5 - 12;
				this.addChild(_effectWing2);
				this.setChildIndex(_effectWing2,1);
				
				
				_timeText = new SFTextField
				_timeText.myWidth = 100;
				this.addChild(_timeText);
				
				if(!_tiyanbtn){
					_tiyanbtn = new HSimpleButton();
					_tiyanbtn.visible = false;
					_tiyanbtn.setTextureSkin(HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"know_up"),
						HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"know_over"),
						HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"know_down"),
						null,
						HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"know_down")
					);
					_tiyanbtn.init();
					_tiyanbtn.isPierce = true;
					_tiyanbtn.x = (this.myWidth - _tiyanbtn.width >> 1) + 1;
					this.addChild(_tiyanbtn);
					_tiyanbtn.addEventListener(Event.TRIGGERED,onClick);
				}
				
				this.isInit = true;
				
			}else{
				
				switch(_type)
				{
					case 0:
						_peidaidata = $data;
						_bgImage.visible = true;
						_downImage.visible = true;
						initType_0();
						break;
					case 1:
						_bgImage.visible = true;
						_downImage.visible = true;
						initType_1();
						break;
					case 2:
						_bgImage.height = 122;
						initType_2();
						break;
					case 3:
						_bgImage.visible = false;
						initType_3();
						break;
					case 4:
						_tiyandata = $data;
						_bgImage.visible = false;
						initType_4($data.showKey);
						break;
				}
			}
			
			
			//是否需要玩家来操作 0 静默开放 1 不需要操作的静默开放 2 需要操作的静默开放
			switch($data.showKey){
				case 0:
					this.touchable = false;
					break;
				case 1:
					this.touchable = false;
					break;
				case 2:
					this.touchable = true;
					break;
			}
			
		}
		
		private function onClick(e:Event):void{
			removeDi();
			
			if(_tiyanbtn){
				_tiyanbtn.visible = false;
			}
			if(_peidaibtn){
				_peidaibtn.visible = false;
			}
			if(_nopeidaibtn){
				_nopeidaibtn.visible = false;
			}
			_self.touchable = false;
			if(ifShowWizard){
				removeWizardObject();
				ifShowWizard = false;
			}
			switch(e.currentTarget){
				case _tiyanbtn:
					_isTimeclick = true;
					if(_tiyandata){
						if(HSuspendTips._needTiyanCount > 0){
							HSuspendTips._needTiyanCount--;
						}
						TweenLite.to( _self, 0.5, {alpha:0, 
							onComplete:function():void
							{
								_ifPlayWing2 = false;
								stopEffectWing1();
								stopEffectWing2();
								HSuspendTips._openFunctionCount--;
								if(HSuspendTips._openFunctionCount < 0){
									HSuspendTips._openFunctionCount = 0;
								}
								_tiyanbtn.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, new <Touch>[]))
								HSuspendTips._openFunctionPool.push(_self);
								_self.visible = false;
								_self.alpha = 1;
								HTopBaseView.getInstance().removeClickChildWindow(_self);
							}
						} );
						ModuleEventDispatcher.getInstance().ModuleCommunication("tiyanclick",_tiyandata);//点击爷知道了
						//添加关闭3D模型时打开坐骑、翅膀界面
						switch(_tiyandata.Name)
						{
							case "Mount" :ModuleEventDispatcher.getInstance().ModuleCommunication("openWindowByFreshenItem","_roleBtn|1");break;
							case "Wing"  :ModuleEventDispatcher.getInstance().ModuleCommunication("openWindowByFreshenItem","_roleBtn|2");
								WingsSources.getInstance().wingsEquipUpDown(WingsSources.getInstance().maxWingsData.blessLv, 1);
								break;
						}
					}
					break;
				case _peidaibtn:
					if(_peidaidata){
						if(HSuspendTips._needTiyanCount > 0){
							HSuspendTips._needTiyanCount--;
						}
						TweenLite.to( _self, 0.5, {alpha:0,
							onComplete:function():void
							{
								_ifPlayWing2 = false;
								stopEffectWing1();
								stopEffectWing2();
								_self.visible = false;
								_self.alpha = 1;
								_peidaibtn.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, new <Touch>[]))
								HSuspendTips._titlePool.push(_self);
								HTopBaseView.getInstance().removeClickChildWindow(_self);
							}
						} );
						
						if(_peidaidata.titleID > 0){
							Connect.getInstance().sendServer(MsgKey.MsgType_Client, MsgKey.MsgId_Title_PutOnOff, [int(_peidaidata.titleID), 1]);		
						}
					}
					break;
				case _nopeidaibtn:
					if(HSuspendTips._needTiyanCount > 0){
						HSuspendTips._needTiyanCount--;
					}
					TweenLite.to( _self, 0.5, {alpha:0,
						onComplete:function():void
						{
							_ifPlayWing2 = false;
							stopEffectWing1();
							stopEffectWing2();
							_self.visible = false;
							_self.alpha = 1;
							_nopeidaibtn.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, new <Touch>[]))
							HSuspendTips._titlePool.push(_self);
							HTopBaseView.getInstance().removeClickChildWindow(_self);
						}
					} );
					break;
			}
		}
		
		private function onPlayComplete1(e:Event):void{
			if(_effectWing1){
				_effectWing1.Stop();
				_effectWing1.visible = false;
			}
			if(_ifPlayWing2){
				_ifPlayWing2 = false;
				playEffectWing2();
			}
		}
		
		public function playEffectWing1():void{
			stopEffectWing1();
			stopEffectWing2();
			if(_effectWing1){
				_effectWing1.gotoAndPlay(1);
				_effectWing1.visible = true;
			}
		}
		
		public function playEffectWing2():void{
			stopEffectWing1();
			stopEffectWing2();
			if(_effectWing2){
				_effectWing2.gotoAndPlay(1);
				_effectWing2.visible = true;
			}
		}
		
		public function stopEffectWing1():void{
			if(_effectWing1){
				_effectWing1.Stop();
				_effectWing1.visible = false;
			}
		}
		
		public function stopEffectWing2():void{
			if(_effectWing2){
				_effectWing2.Stop();
				_effectWing2.visible = false;
			}
		}
		
		/** 获得称号 **/
		private function initType_0():void
		{
			if(this.isInit){
				return;
			}
			if(_bgImage){
				_bgImage.visible = true;
				_downImage.visible = true;
				_bgImage.height = 140;
				_downImage.x = this.myWidth * 0.5 - _downImage.width * 0.5;
				_downImage.y = _bgImage.height - 1;
				
				_titleLine = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/line_yellow") );
				_titleLine.width = _bgImage.width;
				_titleLine.x = this.myWidth * 0.5 - _titleLine.width * 0.5;
				_titleLine.y = 0;
				this.addChild(_titleLine);
				
				_titleLeft = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/bigChi ") );
				_titleLeft.x = this.myWidth * 0.5 - _titleLeft.width - 60;
				_titleLeft.y = - _titleLeft.height + 13;
				this.addChild(_titleLeft);
				_titleRight = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/bigChi ") );
				_titleRight.scaleX = -1;
				_titleRight.x = this.myWidth * 0.5 + _titleRight.width + 60;
				_titleRight.y = _titleLeft.y;
				this.addChild(_titleRight);
			}
			
			//皇冠
			var texture:Texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/title_tip");
			if(!texture){
				texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/openBg_8");	
			}
			_titleImage = new Image(texture);
			this.addChild(_titleImage);
			_titleImage.x = (this.myWidth - _titleImage.width >> 1) - 2;
			_titleImage.y = - _titleImage.height;
			//提示背景
			_tipsBGImage = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/openBg_4") );
			this.addChild(_tipsBGImage);
			_tipsBGImage.x = this.myWidth - _tipsBGImage.width >> 1;
			_tipsBGImage.y = 10;
			//提示文本
			_tipsText = new StarlingTextField();
			_tipsText.textField.filters = [];
			_tipsText.bold = true;
			_tipsText.width = this.myWidth;
			_tipsText.height = 22;
			_tipsText.size = 18;
			_tipsText.color = 0xFEF1D0;
			_tipsText.algin = "center";
			_tipsText.letterSpacing = 4;
			this.addChild(_tipsText);
			Tool.setDisplayGlowFilter(_tipsText.textField, 0xBE6200, 0.8, 10, 10);
			_tipsText.text = Tg.T("获得新称号");
			_tipsText.x = this.myWidth * 0.5 - _tipsText.width * 0.5;
			_tipsText.y = _tipsBGImage.y + 5;
		}
		/**
		 *更新称号状态 
		 * 
		 */		
		public function updateState0(flag:Boolean = true):void{
			if(!_peidaibtn) return;
//			var _count:int = TitleManager.getInstance().hasGetTitle.length;
//			if(_count <= 1){
//				_peidaibtn.visible = false;
//				_nopeidaibtn.visible = false;
//			}else{
			_self.touchable = true;
			_peidaibtn.visible = true;
			if(flag)
			{
				_nopeidaibtn.visible = true;
				_peidaibtn.x = this.myWidth * 0.5 - _peidaibtn.width - 25;
			}
			else
			{
				_nopeidaibtn.visible = false;
				_peidaibtn.visible = false;
				setTimeout(closechenghao,4000);
				_peidaibtn.x = this.myWidth * 0.5 - (_peidaibtn.width/2);
			}
	
				_peidaibtn.y = _peidaibtny;
				_nopeidaibtn.x = this.myWidth * 0.5 + 25;
				_nopeidaibtn.y = _peidaibtny;
//			}
		}
		
		private function closechenghao():void
		{
			HTopBaseView.getInstance().removeClickChildWindow(_self);
		}
		
		/** 等级提升 **/
		private function initType_1():void
		{
			if(this.isInit){
				return;
			}
			
			if(_bgImage){
				_bgImage.visible = true;
				_downImage.visible = true;
				_bgImage.height = 100;
				_downImage.x = this.myWidth * 0.5 - _downImage.width * 0.5;
				_downImage.y = _bgImage.height - 1;
				
				_titleLeft = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/openBg_2") );
				_titleLeft.x = this.myWidth * 0.5 - _titleLeft.width * 0.5;
				_titleLeft.y = - _titleLeft.height;
				this.addChild(_titleLeft);
			}
			//Level
			_titleImage = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/openBg_6") );
			this.addChild(_titleImage);
			_titleImage.x = this.myWidth * 0.5 - _titleImage.width * 0.5;
			_titleImage.y = -_titleImage.height;
			//提示背景
			_tipsBGImage = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/openBg_4") );
			this.addChild(_tipsBGImage);
			_tipsBGImage.x = this.myWidth - _tipsBGImage.width >> 1;
			_tipsBGImage.y = 5;
			//提示文本
			_tipsText = new StarlingTextField();
			_tipsText.textField.filters = [];
			_tipsText.bold = true;
			_tipsText.width = this.myWidth;
			_tipsText.height = 40;
			_tipsText.size = 18;
			_tipsText.color = 0xFEF1D0;
			_tipsText.algin = "center";
			_tipsText.letterSpacing = 4;
			this.addChild(_tipsText);
			Tool.setDisplayGlowFilter(_tipsText.textField, 0xBE6200, 0.8, 10, 10);
			_tipsText.text = Tg.T("恭喜您等级升至");
			_tipsText.x = this.myWidth * 0.5 - _tipsText.width * 0.5;
			_tipsText.y = _tipsBGImage.y + 5;
			
			//等级文本
			_contentsText = new StarlingTextField();
			_contentsText.textField.filters = [];
			_contentsText.bold = true;
			_contentsText.width = this.myWidth;
			_contentsText.height = 54;
			_contentsText.size = 50;
			_contentsText.color = 0xFEF1D0;
			_contentsText.algin = "center";
			_contentsText.letterSpacing = 4;
			this.addChild(_contentsText);
			_contentsText.x = this.myWidth * 0.5 - _contentsText.width * 0.5;
			_contentsText.y = _tipsBGImage.y + _tipsBGImage.height;
			Tool.setDisplayGlowFilter(_contentsText.textField, 0xBE6200, 0.8, 10, 10);
		}
		/**
		 *更新升级状态 
		 * 
		 */		
		public function updateState1():void{
			
		}
		/** 战斗倒计时 **/
		private function initType_2():void
		{
			if(this.isInit){
				return;
			}
			//标题文本
			_titleText = new StarlingTextField();
			_titleText.textField.filters = [];
			_titleText.bold = true;
			_titleText.width = this.myWidth;
			_titleText.height = 50;
			_titleText.size = 30;
			_titleText.color = 0xFEF1D0;
			_titleText.algin = "center";
			this.addChild(_titleText);
			_titleText.y = -_titleText.height - 10;
			Tool.setDisplayGlowFilter(_titleText.textField, 0xBE6200, 0.8, 10, 10);
			//提示背景
			_tipsBGImage = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/openBg_4") );
			this.addChild(_tipsBGImage);
			_tipsBGImage.x = this.myWidth - _tipsBGImage.width >> 1;
			//提示文本
			_tipsText = new StarlingTextField();
			_tipsText.textField.filters = [];
			_tipsText.bold = true;
			_tipsText.width = this.myWidth;
			_tipsText.height = 30;
			_tipsText.size = 18;
			_tipsText.color = 0xFEF1D0;
			_tipsText.algin = "center";
			_tipsText.letterSpacing = 4;
			this.addChild(_tipsText);
			_tipsText.y = _tipsBGImage.y + ((_tipsBGImage.height - _tipsText.height) >> 1);
			Tool.setDisplayGlowFilter(_tipsText.textField, 0xBE6200, 0.8, 10, 10);
			//倒计时
			_countdown = new StarlingTextFieldExpand();
			_countdown.setSkin({
				 "0":IResourceManager.getInstance().getBitmapData("HPNumberFont","HPNumberFont_TipsNumber_0")
				,"1":IResourceManager.getInstance().getBitmapData("HPNumberFont","HPNumberFont_TipsNumber_1")
				,"2":IResourceManager.getInstance().getBitmapData("HPNumberFont","HPNumberFont_TipsNumber_2")
				,"3":IResourceManager.getInstance().getBitmapData("HPNumberFont","HPNumberFont_TipsNumber_3")
				,"4":IResourceManager.getInstance().getBitmapData("HPNumberFont","HPNumberFont_TipsNumber_4")
				,"5":IResourceManager.getInstance().getBitmapData("HPNumberFont","HPNumberFont_TipsNumber_5")
				,"6":IResourceManager.getInstance().getBitmapData("HPNumberFont","HPNumberFont_TipsNumber_6")
				,"7":IResourceManager.getInstance().getBitmapData("HPNumberFont","HPNumberFont_TipsNumber_7")
				,"8":IResourceManager.getInstance().getBitmapData("HPNumberFont","HPNumberFont_TipsNumber_8")
				,"9":IResourceManager.getInstance().getBitmapData("HPNumberFont","HPNumberFont_TipsNumber_9")
 			});
			this.addChild(_countdown);
			_countdown.algin = StarlingTextFieldExpand.CENTRAL_CENTER;
			_countdown.width = this.myWidth;
			_countdown.height = 80;
			_countdown.y = _tipsBGImage.y + _tipsBGImage.height + 4;
		}
		
		/** 技能开放 **/
		private function initType_3():void
		{
			if(!this.isInit){
				//皇冠
				_titleImage = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/openBg_8") );
				this.addChild(_titleImage);
				_titleImage.x = (this.myWidth - _titleImage.width >> 1) - 2;
				_titleImage.y = _ksize - _titleImage.height;
				//icon背景
				_iconBG = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/openBg_7") );
				this.addChild(_iconBG);
				_iconBG.x = this.myWidth - _iconBG.width >> 1;
				_iconBG.y = _ksize + 35;
				//提示文本
				_tipsText = new StarlingTextField();
				_tipsText.textField.filters = [];
				_tipsText.bold = true;
				_tipsText.width = this.myWidth;
				_tipsText.height = 40;
				_tipsText.size = 20;
				_tipsText.color = 0xFEF1D0;
				_tipsText.algin = "center";
				_tipsText.letterSpacing = 4;
				this.addChild(_tipsText);
				_tipsText.x = this.myWidth * 0.5 - _tipsText.textWidth * 0.5;
				_tipsText.y = _iconBG.y + _iconBG.height + 10;
				Tool.setDisplayGlowFilter(_tipsText.textField, 0xBE6200, 0.8, 10, 10);
			}else{
				
			}
		}
		/**
		 *更新技能状态 
		 * 
		 */		
		public function updateState3():void{
			if(_effectWing1){
				playEffectWing1();
				_ifPlayWing2 = true;
			}
		}
		/** 功能开放 **/
		private function initType_4(_showKey:int = 0):void
		{
			if(!this.isInit){
				//皇冠
				_titleImage = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/openBg_8") );
				this.addChild(_titleImage);
				_titleImage.x = (this.myWidth - _titleImage.width >> 1) - 2;
				_titleImage.y = _ksize - _titleImage.height;
				//icon背景
				_iconBG = new Image( HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "background/openBg_7") );
				this.addChild(_iconBG);
				_iconBG.x = this.myWidth * 0.5 - _iconBG.width * 0.5;
				_iconBG.y = _ksize + 35;
				//提示文本
				_tipsText = new StarlingTextField();
				_tipsText.textField.filters = [];
				_tipsText.bold = true;
				_tipsText.width = this.myWidth;
				_tipsText.height = 40;
				_tipsText.size = 25;
				_tipsText.color = 0xFEF1D0;
				_tipsText.algin = "center";
				_tipsText.letterSpacing = 4;
				this.addChild(_tipsText);
				//_tipsText.text = Tg.T("新功能开启");
				_tipsText.x = this.myWidth * 0.5 - _tipsText.textWidth * 0.5;
				_tipsText.y = _iconBG.y + _iconBG.height + 10;
				Tool.setDisplayGlowFilter(_tipsText.textField, 0xBE6200, 0.8, 10, 10);
				//技能图标
			}else{
				
			}
			//_bgImage.visible = true;
		}
		/**
		 *更新功能开放状态 
		 * @param _showKey
		 * 
		 */		
		public function updateState4():void{
			if(_effectWing1){
				playEffectWing1();
				_ifPlayWing2 = true;
			}
			if(_tiyandata){
				var _showKey:int = _tiyandata.showKey;
				var px:int;
				var py:int;
				var _dwidth:int = 216;
				//if(icon){
					px = HBaseView.getInstance().myWidth >> 1;
					_offsetx =px;
					var addY:int = 350;
					switch(_tiyandata.Name){
						case "WarConcubine"://战姬
							ifShowWizard = true;
							addY = 300;
							showDi(px,_self.y + this.myHeight + addY);
							_offsety =_self.y + this.myHeight + addY;
							addWizard("34120");
							break;
						case "WeaponSoul"://器魂
							ifShowWizard = true;
							addY = 300;
							showDi(px,_self.y + this.myHeight + addY);
							_offsety =_self.y + this.myHeight + addY - 180;
							addWizard("34113");
							break;
						case "Mount"://坐骑
							ifShowWizard = true;
							addY = 300;
							showDi(px,_self.y + this.myHeight + addY);
							_offsety =_self.y + this.myHeight + addY - 32;
							addWizard("50202",0.6);
							break;
						case "Wing"://翅膀
							ifShowWizard = true;
							addY = 300;
							showDi(px,_self.y + this.myHeight + addY);
							_offsety =_self.y + this.myHeight + addY - 150;
							addWizard("50303");
							break;
						case "EquiBlood"://血脉
							addY = 250;
							ifShowWizard = true;
							showDi(px,_self.y + this.myHeight + addY);
							_offsety =_self.y + this.myHeight + addY - 32;
							addWizard("49601");
							break;
					}
				//}
				switch(int(_showKey)){
					case 0:
					case 1:
						if(_tiyanbtn){
							_tiyanbtn.visible = false;
							_timeText.visible = false;
						}
						break;
					case 2:
						if(_tiyanbtn){
							_tiyanbtn.visible = true;
							_timeText.visible = true;
							_isTimeclick = false;
							_tiyanbtn.scaleX = _tiyanbtn.scaleY = 0.9;
							_tiyanbtn.x = (this.myWidth - _tiyanbtn.width >> 1) + 1;
							_tiyanbtn.y = this.myHeight - _tiyanbtn.height;
							if(_tipsText){
								_tiyanbtn.y = _tipsText.y + _tipsText.height - 10;
							}
							//倒计时点击功能开放按钮
							_timeText.x = _tiyanbtn.x+50;
							_timeText.y = _tiyanbtn.y+55;
							switch(_tiyandata.Name){
								case "Mount":
								case "Sign":
								case "EquiBloodPet":
								case "Wing":
									_timeText.visible = false;
									break;
								default:
									addTimeout();
							}
						}
						break;
				}
			}
			
		}
		private var _callTime:int;						//倒计时时间
		private function addTimeout():void
		{
			_callTime = 3;
			_timeText.label = HCss.TipsColor7 + "12( " + _callTime + " S )";
			var minuteTimer:Timer = new Timer(1000, 3); 
			minuteTimer.addEventListener(TimerEvent.TIMER, onTick); 
			minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete); 
			minuteTimer.start(); 
		}
		public function onTick(evt:TimerEvent):void  
		{ 
			_callTime --;
			_timeText.label = HCss.TipsColor7 + "12( " + _callTime + " S )";
		} 
		private var _isTimeclick:Boolean;//如果手动点击了按钮就不要取消倒计时点击
		public function onTimerComplete(evt:TimerEvent):void 
		{
			if(!_isTimeclick)
			   _tiyanbtn.dispatchEvent(new Event(Event.TRIGGERED));
		} 
		/**
		 *显示精灵显示的台子 
		 * @param px
		 * @param py
		 * 
		 */		
		private function showDi(px:int,py:int):void
		{
			icon = UIScene.getInstance().getWizard3dBg(new Point(px,py));
		}
		
		private function removeDi():void
		{
			if(icon && icon.parent)
			{
				UIScene.getInstance().removeWizard3dBg(icon);
				icon = null;
			}
		}
		
		//添加精灵
		
		private function addWizard(_id:String,scale:Number = 1.0,name:String = "openfunctionwizard"):void{
			if(_wizard&&_wizard.parent){
				removeWizardObject();
			}
			if(!_wizardhash){
				_wizardhash = new HashMap();
			}
			_wizardObject = _wizardhash.get(name+_id);
			if(!_wizardObject){
				_wizardObject = new WizardObject();
				_wizardObject.refreshByTable(_id);
				_wizardhash.put(name+_id,_wizardObject);
			}
			_wizard=UIScene.getInstance().CreateWizardByObject(_wizardObject,name+_id);
			this.role3DNameStr=name+_id;
			_wizard.isShowNameUnit=false;
			_wizard.name=name+_id;
			_wizard.visible=true;
			_wizard.scaleX=_wizard.scaleY=_wizard.scaleZ=scale;
			_wizard.rotationY=65;
			if(this.actor3DPoint==null){
				this.actor3DPoint=new Point;
			}
			var p:Point=new Point(_offsetx,_offsety);
			this.actor3DPoint.x=_offsetx;
			this.actor3DPoint.y=_offsety;
			UIScene.getInstance().setWizardPosition(this.role3DNameStr,p);
		}
		
		private function removeWizardObject():void{
			if(_wizard&&_wizard.parent){
				UIScene.getInstance().removeWizard(_wizard);
				this.role3DNameStr="";
				_wizard = null;
			}
		}
		
		private function updateWizardPosition():void{
			if(_wizard&&_wizard.parent){
				var p:Point=new Point(this.x+_offsetx,this.y+_offsety);
				this.actor3DPoint.x=_offsetx;
				this.actor3DPoint.y=_offsety;
				UIScene.getInstance().setWizardPosition(this.role3DNameStr,p);
			}
		}
		
		/**
		 * 设置数据
		 * @param $value	: 数据Object
		 * </br>type=0	: {titleID:称号ID}
		 * </br>type=1	: {level:等级}
		 * </br>type=2	: {titleStr:标题显示文字, tipsStr:提示文字, countdown:倒计时时间}
		 * </br>type=3	: {sourceStr:当前技能图标所在包, name:当前开放的技能图标资源路径, countdown:消失延迟时间, tipsStr:提示文字字符}
		 * </br>type=4	: {sourceStr:当前功能图标所在包, name:当前开放的功能图标资源路径, countdown:消失延迟时间, tipsStr:提示文字字符}
		 */		
		public function set data($value:Object):void
		{
			_data = $value;
			if(!this.isInit) return;
			switch(_type)
			{
				case 0:	//获得称号
					//设置技能图标
					var arr:Array = SGCsvManager.getInstance().table_title.FindRow($value.titleID);
					if(!arr)
					{
						HSuspendTips.ShowTips("称号资源有问题"+$value.titleID);
						return;
					}
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_20, arr[28]);
					if(!texture)
						return;
					if(!_titleNameImage)
					{
						_titleNameImage = new Image( texture);
						this.addChild( _titleNameImage );
					}	else if(_titleNameImage.texture != texture) {
						_titleNameImage.texture = texture;
						_titleNameImage.readjustSize();	
					}
					_titleNameImage.x = this.myWidth * 0.5 - _titleNameImage.width * 0.5;
					_titleNameImage.y = (140 - _tipsBGImage.y + _tipsBGImage.height) * 0.5 - _titleNameImage.height * 0.5;
					_tipsText.text = Tg.T(arr[4]);
					_tipsText.x = this.myWidth * 0.5 - _tipsText.width * 0.5;
					_tipsText.y = _tipsBGImage.y + 3;
					break;
				case 1:	//等级提升
					_contentsText.text = String( $value.level );
					_contentsText.x = this.myWidth * 0.5 - _contentsText.width * 0.5;
					_contentsText.y = _tipsBGImage.y + _tipsBGImage.height;
					break;
				case 2:	//倒计时
					_titleText.text = String( $value.titleStr );
					_tipsText.text = String( $value.tipsStr );
					_countdownNum = $value.countdown;
					_countdown.text = String( _countdownNum );
					HSysClock.getInstance().removeCallBack("PlayerTipsIntegrate");
					HSysClock.getInstance().addCallBack("PlayerTipsIntegrate", onCountdownFunction);
					break;
				case 3:	//技能开启
					texture = HAssetsManager.getInstance().getMyTexture($value.sourceStr, $value.name);
					if(!texture){
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "mainUI/skill_up");
					}
					if(!_iconImage)
					{
						_iconImage = new Image( texture);
						this.addChild( _iconImage );	
					} 	else if(_iconImage.texture != texture) {
						_iconImage.texture = texture;
						_iconImage.readjustSize();
					}
					_iconImage.x = _iconBG.x + (_iconBG.width - _iconImage.width >> 1);
					_iconImage.y = _iconBG.y + (_iconBG.height - _iconImage.height >> 1);
					//功能开启文字
					_tipsText.text = $value.tipsStr;
					_tipsText.x = this.myWidth * 0.5 - _tipsText.width * 0.5;
					_tipsText.y = _iconBG.y + _iconBG.height + 10;
					break;
				case 4:	//功能开启
					var texture:Texture = HAssetsManager.getInstance().getMyTexture($value.sourceStr, $value.name);
					if(!texture)
					{
						texture=HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, $value.name);
					}
					if(!texture){
						texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "activityIcon/first_0_up");
					}

					if(!_iconImage)
					{
						_iconImage = new Image( texture);
						this.addChild( _iconImage );	
					} 	else if(_iconImage.texture != texture) {
						_iconImage.texture = texture;
						_iconImage.readjustSize();
					}
					_iconImage.x = _iconBG.x + (_iconBG.width - _iconImage.width >> 1);
					_iconImage.y = _iconBG.y + (_iconBG.height - _iconImage.height >> 1);
					//功能开启文字
					_tipsText.text = $value.tipsStr;
					_tipsText.x = this.myWidth * 0.5 - _tipsText.width * 0.5;
					_tipsText.y = _iconBG.y + _iconBG.height + 10;
					break;
			}
		}
		private var _countdownNum:int = 0;	//剩余时间
		
		/** 剩余倒计时 **/
		private function onCountdownFunction():void
		{
			if(_countdownNum <= 0)
			{
				HSysClock.getInstance().removeCallBack("PlayerTipsIntegrate");
				return;
			}
			_countdownNum--;
			_countdown.text = String( _countdownNum );
		}
		
	}
}