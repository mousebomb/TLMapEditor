package HLib.Tool
{
	
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	
	import HLib.Event.Dispatcher_F;
	import HLib.Event.ModuleEvent;
	import HLib.Event.ModuleEventDispatcher;
	import HLib.UICom.BaseClass.HTopBaseView;
	import HLib.UICom.Component.TweenEffectText;
	
	import Modules.CampBattle.ui.CampCountdown;
	import Modules.Common.ComEventKey;
	import Modules.Common.HAssetsManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.DataSources.ChatDataSource;
	import Modules.DataSources.PromptInfo;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.Map.MapTips.AreaTypeTips;
	import Modules.view.FunctionOpenWindow;
	import Modules.view.taskGuide.DriftType;
	import Modules.view.taskGuide.FootEffectText;
	import Modules.view.taskGuide.ScreenTextEffect;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	import tool.Away3DConfig;

	public class HSuspendTips
	{
		public static const InfoPos_MsgBox:uint			= 0x1;		/// 居中弹窗 (可用)
		public static const InfoPos_ChatWindow:uint		= 0x2;		/// 聊天框 (可用)
		public static const InfoPos_ScreenTopAD:uint		= 0x4;		/// 置顶广告栏 (可用)
		public static const InfoPos_MsgDida:uint			= 0x8;		/// 滴答信息提示 (可用)
		public static const InfoPos_ActorAbove:uint		= 0x10;		/// 角色上方 (可用)
		public static const InfoPos_MsgBoxEx:uint		    = 0x20;		/// 带确认和取消按钮的提示窗口 (可用)
		public static const InfoPos_CenterTip:uint		= 0x40;		/// 屏幕中间飘字 (可用)
		public static const InfoPos_ScreenRight:uint		= 0x80;		/// 屏幕右方
		public static const InfoPos_MouseTrack:uint		= 0x100;	/// 鼠标跟踪位置 (可用)
		public static const InfoPos_ScreenCenter:uint	    = 0x200;	/// 屏幕中上方活动条提示信息 (可用)
		public static const InfoPos_CDOver:uint		    = 0x400;	/// 即时提示信息 (可用)	
		public static const InfoPos_MonsterBoss:uint		= 0x800;	/// 世界BOSS、家族BOSS、怪物攻城、仙域战提示信息 （可用）
		public static const InfoPos_Max:uint				= 0xFFF;	/// 最大位置数
		
		public static const TipType_System:uint=0;			/// 系统提示
		public static const TipType_Operate:uint=1;		    /// 操作提示
		public static const TipType_CombineJewel:uint=2;	    /// 宝石合成提示-
		public static const TipType_Friend:uint=3;			/// 好友提示
		public static const TipType_Attr:uint=4;			    /// 属性提示
		

		public static const Effect_AcceptQuest:int=0;			//接任务
		public static const Effect_SubmitQuest:int=1;			//接任务
		public static const Effect_Path:int=2;				//寻路
		public static const Effect_LevelUp:int=3;				//升级
		public static const Effect_Medicine:int=4;			//制作成功
		public static const Effect_Meridians:int=5;			//冲脉成功
		public static const Effect_StrengSuc:int=6;			//强化成功
		public static const Effect_StrengFail:int=7;			//强化失败
		public static const Effect_Jineng:int=8;				//升级图腾技能
		public static const Effect_Home:int=9;				//洞府升级
		public static const Effect_Wave:int=10;				//水波特效
		public static const Effect_Flower:int=11;				//送花效果
		public static const Effect_StrongItem:int=12;			//强化物品效果
		public static const Effect_power:int=13;				//战力提升效果
		
		public static var _EffectHmcArgs:Array=[];
		public static var EffectNumArgs:Array=[10,17,16,15,16,15,19,24,20,11,12,8,14,6];
		private static var _effectArr:Array = [];				//图片文字特效数组
		public static var canStart:Boolean;					//播放特效字控制器
		//** 文字缓动特效 **//
		private static var _effTextArr:Array = [];			//效果文字显示存储数组
		private static var _textInfoArr:Array = [];			//特效字显示文字
		private static var _isMove:Boolean = false;			//是否在播放效果中
		private static var specialTextArgs:Array = [];		//特殊文字飘字
		private static var isSpecialMove:Boolean = false;	//是否在播放效果中
		private static var _textCreditList:Array = [];		//美术字荣誉数据
		private static var _isPlayCredit:Boolean;				//播放荣誉标志
		private static var _textExpList:Array = [];			//美术字经验数据
		private static var _isPlayExp:Boolean;				//播放经验标志
		private static var _textGoldList:Array = [];			//美术字金币数据
		private static var _isPlayGold:Boolean;				//播放金币标志
		public static var _textSroceList:Array = [];			//美术字积分数据
		public static var _isPlaySroce:Boolean;				//播放积分标志
		private static var _effect4Vector:Vector.<TweenEffectText> = new <TweenEffectText>[];
		private static var _effect5Vector:Vector.<TweenEffectText> = new <TweenEffectText>[];
		private static var _effect8Vector:Vector.<TweenEffectText> = new <TweenEffectText>[];
		
		public static var _needTiyanCount:int;//需要体验的数量
		public static var _openFunctionCount:int;//功能开放数量
		public static var _openFunctionPool:Array = [];//功能开放池
		public static var _titlePool:Array = [];//称号池
		
		public function HSuspendTips()  {  }
		
		/**
		 * 显示提示文字 
		 * @param tipsStr	 : 显示的提示文字
		 * @param effectType : 显示效果类型
		 * @param $x		 : 提示文字X坐标位置
		 * @param $y		 : 提示文字Y坐标位置
		 */	
		public static function ShowTips(tipsStr:String, effectType:int = 1, $x:Number = -1, $y:Number = -1,isHtml:Boolean=false):void
		{
			if(ChatDataSource.getMyInstance().isDisposed || Starling.context.driverInfo == "Disposed")  return;
			$x = $x == -1 ? (HTopBaseView.getInstance().myWidth >> 1) : $x;
			$y = $y == -1 ? ((HTopBaseView.getInstance().myHeight >> 1) - 200) : $y;
			if(effectType == 0)//淡现后往上推,之后再淡出
			{
				if(_textInfoArr.length > 10) return;
				_textInfoArr.push( {tipsStr:tipsStr, $x:$x, $y:$y, isHtml:isHtml} );
				//执行播放效果(只在不是播放的前提下才执行)
				if(!_isMove) actionEffectText();
			}else if(effectType==4){
				//元宝，银两，精气，声望，体力     飘字
				if(specialTextArgs.length<20){
					specialTextArgs.push({tipsStr:tipsStr, $x:$x, $y:$y});
					if(!isSpecialMove)specialEffectText();
				}
			}else{
				//添加显示效果文字sprite
				var tweenEffectText:TweenEffectText = HObjectPool.getInstance().popObj(TweenEffectText) as TweenEffectText;
				tweenEffectText.init();
				HTopBaseView.getInstance().addChild(tweenEffectText);
				tweenEffectText.setX($x);
				$y += 50;
				//判断效果类型
				switch(effectType)
				{
					case 1://淡出显示后再往上移动并淡出中上飘字
						tweenEffectText.y = $y;
						tweenEffectText.setY(0);
						tweenEffectText.setTextEff4(tipsStr, 0.4, .5, 2, -20,isHtml);
						tweenEffectText.complete = onEffect4Complete;
						_effect4Vector.unshift(tweenEffectText);
						textEffect4($y);
						break;
					case 2://缓动向上后,再缓动向上淡出效果
						tweenEffectText.setY($y);
						tweenEffectText.setTextEff2(tipsStr, 2, 1, -80, -100);
						break;
					case 3://显示后,缓动淡出
						_effTextArr.push(tweenEffectText);
						if(_effTextArr.length>0)
							tweenEffectText.setY($y+(_effTextArr.length-1)*25);
						else
							tweenEffectText.setY($y);
						tweenEffectText.setTextEff3(tipsStr, 4);
						break;
					case 5://淡出显示后再往上移动并淡出中下飘字
						tweenEffectText.y = $y;
						tweenEffectText.setY(0);
						tweenEffectText.setTextEff4(tipsStr, 1, 0.4, 1, -30,isHtml);
						tweenEffectText.complete = onEffect5Complete;
						_effect5Vector.unshift(tweenEffectText);
						/*if(_effect5Vector.length > 3)
						{
							tweenEffectText = _effect5Vector.shift();
							tweenEffectText.playTextEff4();
						}
						textEffect5();*/
						break;
					case 8://淡出显示后再往上移动并淡出中下飘字
						tweenEffectText.y = $y;
						tweenEffectText.setY(0);
						tweenEffectText.setTextEff8(tipsStr);
						tweenEffectText.complete = onEffect8Complete;
						_effect8Vector.unshift(tweenEffectText);
						break;
					default://往下排列,淡入,延迟后淡出
						_effTextArr.push(tweenEffectText);
						if(_effTextArr.length>0)
							tweenEffectText.setY($y+(_effTextArr.length-1)*25);
						else
							tweenEffectText.setY($y);
						tweenEffectText.setTextEff4(tipsStr, 0.5, 0.5, 0.1, -30,isHtml);
						break;
				}
			}
		}
		/**移除引用*/
		private static function onEffect4Complete(text:TweenEffectText):void
		{ 
			var ind:int = _effect4Vector.indexOf(text)
			if(ind > -1)
			{
				_effect4Vector.splice(ind, 1);
			}
		}
		/**重新排列位置*/
		private static function textEffect4(vy:int):void
		{
			var len:int = _effect4Vector.length ;
			for(var i:int=0; i<len; i++)
			{
				_effect4Vector[i].y = vy - (20*i)
			}
		}
		/**移除引用*/
		private static function onEffect5Complete(text:TweenEffectText):void
		{ 
			var ind:int = _effect5Vector.indexOf(text)
			if(ind > -1)
			{
				_effect5Vector.splice(ind, 1);
			}
		}
		/**移除引用*/
		private static function onEffect8Complete(text:TweenEffectText):void
		{ 
			var ind:int = _effect8Vector.indexOf(text)
			if(ind > -1)
			{
				_effect8Vector.splice(ind, 1);
			}
		}
		/**重新排列位置*/
		private static function textEffect5():void
		{
			var len:int = _effect5Vector.length ;
			var vy:int = HTopBaseView.getInstance().myHeight - 200
			for(var i:int=0; i<len; i++)
			{
				_effect5Vector[i].y = vy - (20*i)
			}
		}
		/**  执行显示效果文字(向上推效果) **/		
		private static function actionEffectText():void
		{
			if(_textInfoArr.length == 0)  {  _isMove = false;  return;  }
			_isMove = true;
			var obj:Object = _textInfoArr.shift();	//去第一条信息
			//添加显示效果文字sprite
			var tweenEffectText:TweenEffectText = HObjectPool.getInstance().popObj(TweenEffectText) as TweenEffectText;
			tweenEffectText.init();
			HTopBaseView.getInstance().addChild(tweenEffectText);
			_effTextArr.push(tweenEffectText);
			//添加完成后执行
			tweenEffectText.addComplete = function():void  {  actionEffectText();  };
			//效果完成后执行移除
			tweenEffectText.complete = function(effText:TweenEffectText):void
			{
				var index:int = _effTextArr.indexOf(effText);
				_effTextArr.splice(index, 1);
				if(tweenEffectText == effText) tweenEffectText = null;
				effText = null;
				if(_effTextArr.length == 0) actionEffectText();
			};
			//设置坐标
			tweenEffectText.setX(obj.$x);
			tweenEffectText.setY(obj.$y);
//			tweenEffectText.setY(350);
			//设置显示效果(飘字文字, 向上推显示的速度, 向上推消失的速度, 停留延迟的时间, 淡入距离, 淡出距离)
			tweenEffectText.setTextEff1(obj.tipsStr, 0.4, 0.2, 1.6, -80, -30, obj.isHtml);
			
			//执行排列循序
			var len:int = _effTextArr.length;
			var Y:int = 0;
			for(var i:int = 0; i < len; i++)
			{
				Y = -((len-i-1)*_effTextArr[i].textFieldHeight);
				var tweenLite:TweenLite = TweenLite.to(_effTextArr[i], 0.8, { y:Y, onComplete:function():void  {  tweenLite.kill();  }  });
			}
		}
		/**  特殊文字飘字 **/		
		private static function specialEffectText():void
		{
			if(specialTextArgs.length == 0)  {  isSpecialMove = false;  return;  }
			isSpecialMove = true;
			var obj:Object = specialTextArgs.shift();	//去第一条信息
			var tweenEffectText:TweenEffectText = HObjectPool.getInstance().popObj(TweenEffectText) as TweenEffectText;
			tweenEffectText.init();
			HTopBaseView.getInstance().addChild(tweenEffectText);
			tweenEffectText.addComplete = function():void  {  specialEffectText();  };
			//设置坐标
			tweenEffectText.setX(obj.$x);
			tweenEffectText.setY(obj.$y);
			//			tweenEffectText.setY(350);
			//设置显示效果
			tweenEffectText.setTextEff5(obj.tipsStr, 0.2, 0.4, 0.5, -35);
		}
		public static function judgeHtml(value:String):String{
			return value.replace(/<.*?>/g,"");
		}
		
		/**战场倒计时*/		
		public static function campCountDown(num:int):void
		{
			CampCountdown.getinstance().setNum(num);
		}
		/**美术字飘字效果*/		
		public static function ShowEffectText(key:String, num:int):void
		{
			if(ChatDataSource.getMyInstance().isDisposed || Starling.context.driverInfo == "Disposed")  return;
			if(!HAssetsManager.getInstance().titleLoad) 
			{
				HAssetsManager.getInstance().getTextureAtlas(SourceTypeEvent.SOURCE_ACTIVITYICON_20);
				return;//资源未加载完不显示
			}
			switch(key)
			{
				case "Py_AddCre":
				case "JL_Tips_rongyu":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player16384Effect(DriftType.type2);
					break;
				case "Py_AddExp":
				case "JL_Tips_jingyan":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player16384Effect(DriftType.type1);
					break;
				case "Py_AddGold":
				case "JL_Tips_jinbi":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player16384Effect(DriftType.type3);
					break;
				case "Py_AddSroce":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						playerSroceEffect();
					break;
				case "JL_Tips_mojing":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player16384Effect(DriftType.type20);
					break;
				case "JL_Tips_lijuan":
				
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player16384Effect(DriftType.type21);
					break;
				case "SX_Tips_shengming":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type5);
					break;
				case "SX_Tips_gongji":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type6);
					break;
				case "SX_Tips_fangyu":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type7);
					break;
				case "SX_Tips_baoji":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type8);
					break;
				case "SX_Tips_jianren":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type9);
					break;
				case "SX_Tips_fujiashanghai":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type10);
					break;
				case "SX_Tips_xishoushanghai":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type11);
					break;
				case "SX_Tips_xixuelv":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type12);
					break;
				case "SX_Tips_jianshanglv":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type13);
					break;
				case "SX_Tips_zhuoyuegongji":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type14);
					break;
				case "SX_Tips_gongjijiacheng":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type15);
					break;
				case "SX_Tips_wushifangyu":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type16);
					break;
				case "SX_Tips_fangyujiacheng":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type17);
					break;
				case "SX_Tips_fangyuchenggonglv":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type18);
					break;
				case "SX_Tips_yidongsudu":
					_textSroceList.push(num);
					if(!_isPlaySroce )
						player8192Effect(DriftType.type19);
					break;
			}
		}
		
		/**积分飘字*/
		private static function playerSroceEffect():void
		{
			if(_textSroceList.length < 1)
			{
				_isPlaySroce = false;
				return;
			}
			
			//飘字类型１、经验　２、荣誉　３、金币 4.积分
			var effect:ScreenTextEffect = HObjectPool.getInstance().popObj(ScreenTextEffect) as ScreenTextEffect;
			effect.type = 1;
			effect.init();
			var num:int = _textSroceList.shift();
			effect.playEffect(num);
			_isPlaySroce = true;
			effect.addComplete = function ():void{
				playerSroceEffect();
			}
		}
		/**8192一类飘字*/
		private static function player8192Effect(type:int):void
		{
			if(_textSroceList.length < 1)
			{
				_isPlaySroce = false;
				return;
			}
			
			var effect:ScreenTextEffect = HObjectPool.getInstance().popObj(ScreenTextEffect) as ScreenTextEffect;
			effect.key = 8192;
			effect.type = type;
			effect.init();
			var num:int = _textSroceList.shift();
			effect.playEffect(num);
			_isPlaySroce = true;
			effect.addComplete = function ():void{
				player8192Effect(type);
			}
		}
		/**16384一类飘字*/
		private static function player16384Effect(type:int):void
		{
			if(_textSroceList.length < 1)
			{
				_isPlaySroce = false;
				return;
			}
			var effect:ScreenTextEffect;
			var i:int;	
			var len:int = _textSroceList.length
			var arr:Array = [];
			
			if(len > 5)
			{
				arr = _textSroceList.slice(0, 5);
			}else
			{
				arr = _textSroceList;
			}
			len = arr.length;
			for(i=0;i<len;i++)
			{
				effect = HObjectPool.getInstance().popObj(ScreenTextEffect) as ScreenTextEffect;
				effect.key = 16384;
				effect.type = type;
				effect.init();
				effect.y = i*(effect.height + 20);
				var num:int = _textSroceList.shift();
				effect.playEffect(num);
				if(i==len-1)
				{
					_isPlaySroce = true;
					effect.addComplete = function ():void{
						player16384Effect(type);
					}
				}
			}	
		}
		/**
		 * 显示玩家提示
		 * @param $key	: 类型
		 * @param $data	: 数据对象
		 * </br>如下:
		 * </br>HSuspendTips.showPlayerTips("Py_GetTitle", {titleID:2});
		 * </br>HSuspendTips.showPlayerTips("Py_LevelUp", {level:10});
		 * </br>HSuspendTips.showPlayerTips("Py_Countdown", {titleStr:"封印之地", tipsStr:"即将开始挑战", countdown:20});
		 * </br>HSuspendTips.showPlayerTips("Py_OpenSkill", {sourceStr:SourceTypeEvent.MAIN_FACE_SOURCE,
		 *     name:"skillIcon/skillicon03_04", countdown:2});
		 * </br>HSuspendTips.showPlayerTips("Py_OpenFunction", {sourceStr:SourceTypeEvent.MAIN_INTERFACE_SOURCE,
		 *     name:"activityIcon/ectype_0_over", countdown:2});
		 */		
		public static function showPlayerTips($key:String, $data:Object):void
		{
			if(ChatDataSource.getMyInstance().isDisposed || Starling.context.driverInfo == "Disposed")  
			{
				_contextArr.push([$key, $data]);
				Dispatcher_F.getInstance().addEventListener(ComEventKey.CONTEXT_CREATED, onContextReLoad); 
				return;
			}
			switch($key)
			{
				case "Py_GetTitle":		//获得称号
					
					if(HAssetsManager.getInstance().getTextureAtlas(SourceTypeEvent.SOURCE_ACTIVITYICON_20) == null)
					{
						_data = $data;
						ModuleEventDispatcher.getInstance().addEventListener(ComEventKey.HAS_LOAD_COMPLETE,onLoadComplete);
					} 	else {
						onPlayerGetTitle( $data );
					}
						
					break;
				case "Py_LevelUp":		//角色升级
					onPlayerLevelUp( $data );
					break;
				case "Py_Countdown":		//倒计时
					onPlayerCountdown( $data );
					break;
				case "Py_OpenSkill":		//开启技能
					onPlayerOpenSkill( $data );
					break;
				case "Py_OpenFunction":	//开启功能
					onPlayerOpenFunction( $data );
					break;
			}
		}
		private static function onContextReLoad(event:flash.events.Event):void
		{
			var arr:Array;
			Dispatcher_F.getInstance().removeEventListener(ComEventKey.CONTEXT_CREATED, onContextReLoad); 
			while(_contextArr.length)
			{
				arr = _contextArr.shift();
				showPlayerTips(arr[0], arr[1]);
			}
		}
		/**加载称号资源完成*/
		private static function onLoadComplete(e:starling.events.Event):void
		{
			if(e.data == SourceTypeEvent.SOURCE_ACTIVITYICON_20)
			{
				ModuleEventDispatcher.getInstance().removeEventListener(ComEventKey.HAS_LOAD_COMPLETE, onLoadComplete);
				onPlayerGetTitle(_data);
			}
		}
		/**
		 * 获得称号
		 * @param $data
		 */		
		private static function onPlayerGetTitle($data:Object):void
		{
			var _titleTips:PlayerTipsIntegrate;
			if(_titlePool.length > 0){
				_titleTips = _titlePool[0];
				_titlePool.splice(0,1);
			}else{
				_titleTips = new PlayerTipsIntegrate();
			}
			_titleTips ||= new PlayerTipsIntegrate();
			_titleTips.init(0,$data);
			_titleTips.data = $data;
			if(!_titleTips.parent){
				HTopBaseView.getInstance().addClickChildWindow(_titleTips);
				_titleTips.x = (Away3DConfig.myStage.stageWidth - _titleTips.myWidth) >> 1;
			}
			_titleTips.y = 150;
			_titleTips.alpha = 0;
			_titleTips.visible = true;
			if($data.titleID ==51 || $data.titleID ==50)//战争胜利或者失败隐藏取消佩戴按钮
			{
				_titleTips.updateState0(false);
			}
			else
			{
				_titleTips.updateState0(true);
			}
		
			TweenLite.to( _titleTips,0.5,{
				alpha:1.0,
				y:_titleTips.y - 50
			});
//			var _count:int = TitleManager.getInstance().hasGetTitle.length;
//			if(_count <= 1){
//				TweenLite.to( _titleTips, 0.5, {alpha:0, delay:2
//					,onComplete:function(_of:PlayerTipsIntegrate):void
//					{
//						_of._ifPlayWing2 = false;
//						_of.stopEffectWing1();
//						_of.stopEffectWing2();
//						_of.visible = false;
//						_of.alpha = 1;
//						_titlePool.push(_of);
//						HTopBaseView.getInstance().removeClickChildWindow(_of);
//					},onCompleteParams:[_titleTips]
//				} );
//			}else{
				_needTiyanCount++;
//			}
		}
		private static var _titleTips:PlayerTipsIntegrate;	//获得称号
		private static var _titleTweenLite:TweenLite;			//获得称号效果tweenLite
		
		/**
		 * 角色升级显示提示
		 * @param $nun	: 等级数字
		 */		
		private static function onPlayerLevelUp($data:Object):void
		{
			_levelUpTips ||= new PlayerTipsIntegrate();
			_levelUpTips.init(1,$data);
			_levelUpTips.data = $data;
			if(!_levelUpTips.parent){
				HTopBaseView.getInstance().addChild(_levelUpTips);
			}
			_levelUpTips.x = (Away3DConfig.myStage.stageWidth - _levelUpTips.myWidth) >> 1;
			_levelUpTips.y = (Away3DConfig.myStage.stageHeight - _levelUpTips.myHeight) + 100;
			_levelUpTips.touchable = false;
			_levelUpTips.touchGroup = true;
			_levelUpTips.alpha = 0;
			_levelUpTips.visible = true;
			_levelUpTips.updateState1();
			TweenLite.to( _levelUpTips,0.5,{
				alpha:1.0,
				y:_levelUpTips.y - 50
			});
			if(_levelUpTweenLite) _levelUpTweenLite.kill();
			_levelUpTweenLite = TweenLite.to( _levelUpTips, 0.5, {alpha:0, delay:2
				,onComplete:function():void
				{
					_levelUpTips._ifPlayWing2 = false;
					_levelUpTips.stopEffectWing1();
					_levelUpTips.stopEffectWing2();
					_levelUpTweenLite.kill();
					_levelUpTweenLite = null;
					_levelUpTips.visible = false;
					_levelUpTips.alpha = 1;
				}
			} );
		}
		private static var _levelUpTips:PlayerTipsIntegrate;	//等级提升
		private static var _levelUpTweenLite:TweenLite;		//等级提升效果tweenLite
		/**
		 * 玩家倒计时
		 * @param $data
		 */		
		private static function onPlayerCountdown($data:Object):void
		{
			_countdown ||= new PlayerTipsIntegrate();
			_countdown.init(2,$data);
			if(!_countdown.parent)
				HTopBaseView.getInstance().addChild(_countdown);
			_countdown.data = $data;
			_countdown.x = (Away3DConfig.myStage.stageWidth - _countdown.width) >> 1;
			_countdown.y = Away3DConfig.myStage.stageHeight - _countdown.height - 60;
			_countdown.touchable = false;
			_countdown.touchGroup = true;
			_countdown.alpha = 1;
			_countdown.visible = true;
			if(_countdownTweenLite) _countdownTweenLite.kill();
			_countdownTweenLite = TweenLite.to( _countdown, 0.5, {alpha:0, delay:$data.countdown
				,onComplete:function():void
				{
					_countdownTweenLite.kill();
					_countdownTweenLite = null;
					_countdown.visible = false;
					_countdown.alpha = 1;
				}
			} );
		}
		private static var _countdown:PlayerTipsIntegrate;	//倒计时
		private static var _countdownTweenLite:TweenLite;		//倒计时效果tweenLite
		/**
		 * 玩家开启技能
		 * @param $data
		 */		
		private static function onPlayerOpenSkill($data:Object):void
		{
			_openSkill ||= new PlayerTipsIntegrate();
			_openSkill.init(3,$data);
			_openSkill.data = $data;
			if(!_openSkill.parent){
				HTopBaseView.getInstance().addChild(_openSkill);
			}
			_openSkill.y = 200;
			_openSkill.x = (Away3DConfig.myStage.stageWidth - _openSkill.myWidth) >> 1;
			_openSkill.alpha = 0;
			_openSkill.touchable = false;
			_openSkill.touchGroup = true;
			_openSkill.visible = true;
			_openSkill.updateState3();
			TweenLite.to( _openSkill,0.5,{
				alpha:1.0,
				y:_openSkill.y - 50
			});
			if(_openSkillTweenLite) _openSkillTweenLite.kill();
			_openSkillTweenLite = TweenLite.to( _openSkill, 0.5, {alpha:0, delay:$data.countdown
				,onComplete:function():void
				{
					_openSkill._ifPlayWing2 = false;
					_openSkill.stopEffectWing1();
					_openSkill.stopEffectWing2();
					_openSkillTweenLite.kill();
					_openSkillTweenLite = null;
					_openSkill.visible = false;
					_openSkill.alpha = 1;
				}
			} );
		}
		private static var _openSkill:PlayerTipsIntegrate;	//开放技能
		private static var _openSkillTweenLite:TweenLite;		//开放技能效果tweenLite
		/**
		 * 玩家开启功能
		 * @param $data
		 */		
		private static function onPlayerOpenFunction($data:Object):void
		{
			var _openFunction:PlayerTipsIntegrate;
			if(_openFunctionPool.length > 0){
				_openFunction = _openFunctionPool[0];
				_openFunctionPool.splice(0,1);
			}else{
				_openFunction = new PlayerTipsIntegrate();
			}
			_openFunction.init(4,$data);
			_openFunction.data = $data;
			if(!_openFunction.parent){
				HTopBaseView.getInstance().addClickChildWindow(_openFunction);
				_openFunction.x = (Away3DConfig.myStage.stageWidth - _openFunction.myWidth) >> 1;
				_openFunction.y = 50;
				if(_openFunction._initx <= 0){
					_openFunction._initx = _openFunction.x;
					_openFunction._inity = _openFunction.y;
				}
			}
			//如果展示精灵则坐标为初始值
			if($data.Name == "WarConcubine" || $data.Name == "WeaponSoul" ||
				$data.Name == "Mount" || $data.Name == "Wing" ||
				$data.Name == "EquiBlood"){
				_openFunction.y = _openFunction._inity;
			}else{
				_openFunction.y = _openFunction._inity + _openFunctionCount * 100;
			}
			
			if(_openFunction.y > Away3DConfig.myStage.stageHeight - _openFunction.height){
				_openFunction.y = Away3DConfig.myStage.stageHeight - _openFunction.height;
			}
			if(_openFunction.y < _openFunction._inity){
				_openFunction.y = _openFunction._inity;
			}
			HTopBaseView.getInstance().setChildIndex(_openFunction,HTopBaseView.getInstance().numChildren - 1);
			_openFunction.updateState4();
			_openFunction.alpha = 0;
			_openFunction.visible = true;
			
			_openFunctionCount++;
			
			TweenLite.to( _openFunction,0.5,{
				alpha:1.0,
				y:_openFunction.y - 50
			});
			
			switch($data.showKey){
				case 0:
				case 1:
					//if(_openFunctionTweenLite) _openFunctionTweenLite.kill();
					TweenLite.to( _openFunction, 0.5, {alpha:0, delay:$data.countdown
					,onComplete:function(_of:PlayerTipsIntegrate):void
					{
					_openFunctionCount--;
					if(_openFunctionCount < 0){
						_openFunctionCount = 0;
					}
					FunctionOpenWindow.getMyInstance().doCloseWindow(_of._data);
					_openFunctionPool.push(_of);
					//_openFunctionTweenLite.kill();
					//_openFunctionTweenLite = null;
					_of.visible = false;
					_of.alpha = 1;
					HTopBaseView.getInstance().removeClickChildWindow(_of);
					},onCompleteParams:[_openFunction]
					} );
					break;
				case 2:
					_needTiyanCount++;
					break;
			}
			
		}
		//private static var _openFunction:PlayerTipsIntegrate;		//放开功能
		private static var _openFunctionTweenLite:TweenLite;		//开放功能效果tweenLite
		/**
		 * 设置区域状态提示
		 * @param $type	: 区域类型(0 进入安全区域; 1离开安全区域; 2进入pk区域; 3离开pk区域)
		 * 				  区域类型(0 你已进入安全区域; 1 你已进入非安全区域; 2 你已进入切磋区域; 3 你已进入非安全区域, 4、彩蛋物品拾取提示)
		 */		
		public static function showAreaTypeTips($type:int):void
		{
			if( !MainInterfaceManage.getInstance().isLoadUI ) return;//资源未加载完不显示
			if(ChatDataSource.getMyInstance().isDisposed || Starling.context.driverInfo == "Disposed") return
			if(!_areaTypeTips)
			{
				_areaTypeTips = new AreaTypeTips();
				_areaTypeTips.init()
			}
			if(!_areaTypeTips.parent)
				HTopBaseView.getInstance().addChild(_areaTypeTips);
			_areaTypeTips.areaType = $type;
			_areaTypeTips.x = (Away3DConfig.myStage.stageWidth - _areaTypeTips.width) >> 1;
			_areaTypeTips.y = Away3DConfig.myStage.stageHeight - _areaTypeTips.height - 160;
			
			var delayTime:Number = 2.5;
			if($type == 4)
				delayTime = 4;
			_areaTypeTips.alpha = 1;
			_areaTypeTips.visible = true;
			if(_areaTypeTweenLite) _areaTypeTweenLite.kill();
			_areaTypeTweenLite = TweenLite.to( _areaTypeTips, 0.5, {alpha:0, delay:2.5
				,onComplete:function():void
				{
					_areaTypeTips.visible = false;
					_areaTypeTips.alpha = 1;
					_areaTypeTweenLite.kill();
					_areaTypeTweenLite = null;
				}
			} );
		}
		public static function showDownEffectText(info:PromptInfo):void
		{
			if(_isPlayEffect)
			{
				var prompt:PromptInfo = new PromptInfo;
				prompt.id = info.id;
				prompt.showStr = info.showStr;
				_showStr.push(prompt);
			}	else {
				_isPlayEffect = true;
				var effect:FootEffectText;
				if(_effectTectArr.length)
					effect = _effectTectArr.pop();
				else 
					effect = new FootEffectText;
				effect.setTextEff(info);
				effect.delayCall = showEffectDelayCall;
				effect.removeCall = showEffectRemoveCall;
			}
			
		}
		/**播放 下一个特效*/
		private static function showEffectDelayCall():void
		{
			_isPlayEffect = false;
			if(_showStr.length)
				showDownEffectText(_showStr.shift());
		}
		/**回收特效*/
		private static function showEffectRemoveCall(effect:FootEffectText):void
		{
			_effectTectArr.push(effect);
		}
		/**特效提示，类似区域提示*/
		public static function showAreaTypeTipsMsg(msg:String, id:String=''):void
		{
			if( !MainInterfaceManage.getInstance().isLoadUI ) return;//资源未加载完不显示
			if(ChatDataSource.getMyInstance().isDisposed || Starling.context.driverInfo == "Disposed") return
			if(!_areaTypeTips)
			{
				_areaTypeTips = new AreaTypeTips();
				_areaTypeTips.init()
			}
			if(!_areaTypeTips.parent)
				HTopBaseView.getInstance().addChild(_areaTypeTips);
			_areaTypeTips.setlabel(msg);
			_areaTypeTips.x = (Away3DConfig.myStage.stageWidth - _areaTypeTips.width) >> 1;
			_areaTypeTips.y = Away3DConfig.myStage.stageHeight - _areaTypeTips.height - 160;
			var delayTime:Number = 2.5;
			_areaTypeTips.alpha = 1;
			_areaTypeTips.visible = true;
			var delay:Number = 2.5
			if(id == 'Ts_FT_Item') 
				delay = 8;
			if(_areaTypeTweenLite) _areaTypeTweenLite.kill();
			_areaTypeTweenLite = TweenLite.to( _areaTypeTips, 0.5, {alpha:0, delay:delay
				,onComplete:function():void
				{
					_areaTypeTips.visible = false;
					_areaTypeTips.alpha = 1;
					_areaTypeTweenLite.kill();
					_areaTypeTweenLite = null;
				}
			} );
		}
		
		public static function removeAreaTypeTips():void
		{
			if(_areaTypeTips && _areaTypeTips.visible)
			{
				_areaTypeTips.visible = false;
				_areaTypeTips.alpha = 1;
			}
		}
		
		private static var _areaTypeTips:AreaTypeTips;
		private static var _areaTypeTweenLite:TweenLite;
		private static var _data:Object;				//称号提示数据
		private static var _showStr:Array = [];			//飘字数据
		private static var _isPlayEffect:Boolean;		//特效播放状态
		private static var _effectTectArr:Array = [];	//特效文本
		private static var _contextArr:Array= [];		//设备丢失显示数据
		
		public static function ShowStrongTips(tipsStr:String, param1:DisplayObjectContainer, vx:Number, vy:Number):void
		{
			if(ChatDataSource.getMyInstance().isDisposed || Starling.context.driverInfo == "Disposed")  return;
			var tweenEffectText:TweenEffectText = HObjectPool.getInstance().popObj(TweenEffectText) as TweenEffectText;
			tweenEffectText.init();
			param1.addChild(tweenEffectText);
			tweenEffectText.setX(vx);
			//判断效果类型
			tweenEffectText.y = vy;
			tweenEffectText.setY(0);
			tweenEffectText.setTextEff4(tipsStr, 0.4, .5, 2, -20,false);
		}
	}
}