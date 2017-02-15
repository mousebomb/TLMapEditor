
package HLib.UICom.Component.Icons
{
	/**
	 * 技能Icon类
	 * @author 李舒浩
	 * 
	 * 用法：
	 * 		var skillIcon:HSkillIcon = new HSkillIcon();
	 *		this.addChild(skillIcon);
	 *		skillIcon.initSkill();
	 *		skillIcon.skillData = skill;
	 * 
	 * 		var time:Timer = new Timer(100);
	 *		time.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void
	 *		{
	 *				if(skill.isCDMove) skill.actionCDMove();
	 *		});
	 * 		time.start();
	 * 
	 * 属性与方法：
	 * 		initSkill()		: 初始化方法, 参数为技能背景, 不需要背景的可以不传, 如果是自定义背景图片必须要用copy后的bitmapdata,
	 * 						  因为调用skillClear()时会dispose()掉, 如果不会调用itemClear()方法可不copy;
	 * 		direction		: 技能CD转动方向, (-1:顺时针 1:逆时针)
	 * 		actionCDMove()	: 执行CD动画方法, 由于可能会有多个技能同时实例, 为了节省内存把内置timer的方法修改为一个公用方法,再外部统一使用timer执行,如上例
	 * 		isGray			: 是否灰化, 当MP不足无法使用技能时, 调用此方法可灰化图标
	 * 		select			: 是否选中, 当选择技能使用时可发光, 或鼠标移入时发光可调用此方法
	 * 		angle			: get,当前CD时间旋转角度
	 * 		nowCDTime		: set|get, 当前技能剩余CD时间
	 * 		cdTime			: get, 当前技能使用后的CD时间(总冷却时间)
	 * 		isCDTime		: get, 是否在CD动画中(true:是 false:否)
	 * 		skillClear()	: 释放内存方法
	 * 		isShowTimerText	: 是否显示CD时间文本
	 * 		skillData		: 设置技能对象数据, 设置后会自动生成技能对应的图标显示
	 * 
	 * 事件:
	 * 		ClearComponent	: 清除该按钮时派发,一般用于清除内部样式后在外部移除相关事件,从父对象中移除,清空索引等
	 * 		Skill_CD_Over	: 当CD时间动画播放完派发
	 */


	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import HLib.Net.Socket.DataType;
	import HLib.Tool.HSuspendTips;
	import HLib.Tool.Tool;
	import HLib.UICom.BaseClass.HBaseView;
	import HLib.UICom.BaseClass.HTopBaseView;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.Common.Tool.TipsTool;
	import Modules.DataSources.ChatDataSource;
	import Modules.DataSources.ItemSources;
	import Modules.DataSources.Skill;
	import Modules.MainFace.MainFace_ToolBar;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.MainFace.SendMessageManage;
	import Modules.Map.HMapSources;
	import Modules.Map.InitLoaderMapResControl;
	import Modules.SFeather.SFTextField;
	import Modules.skill2.view.SimpleSkillTips;
	import Modules.view.roleEquip.PowerItem;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class HSkillIcon extends HIcon
	{
		public var moveType:int = 0;					//技能拖动类型(0:技能栏 1:设置面板)
		
		private var _skinWidth:int = 42;
		private var _skinHeight:int = 42;
		
		//private var _maskShape:Shape;					//CD时间黑色块
		private var _timePoer:PowerItem;				//CD时间显示
		//private var _cdTimeText:SFTextField;			//CD时间显示文本
		private var _maskWidth:int = 0;				//遮罩扇形宽度
		private var _maskHeight:int = 0;				//遮罩扇形高度
		private var _maskRadii:int = 0;				//遮罩扇形半径
		private var _skill:Skill;						//技能数据
		
		private var _direction:int = 0;				//当前方向
		private var _isGray:Boolean = false;			//是否灰化
		private var _isClear:Boolean = false;			//是否清除
		
		private var _angle:int;						//当前CD旋转角度
		private var _nowCDTime:int;					//执行CD时间
		private var _isCDTime:Boolean = false;		//是否CD动画中
		
		private var _isShowTimerText:Boolean = false;	//是否显示剩余CD时间
		private var _backTexture:Texture;				//背景图
		
		private var lineSize:int = 1;
		private var lineColor:uint = 0x0ffaa00;
		private var lineAlpha:Number = 1;
		private var _showEffectNum:int;				//发光次数
		private var startFrom:Number = 270;
		private var _maskSpr:Image;
		private var _skillArr:Vector.<Skill>;					//技能数组
		private var _skillIndex:int;					//技能数组下标
		private var _texture:Texture;
		private var _isDisposed:Boolean;
		private var _mIsDown:Boolean;					//鼠标按下标识
		private var _mIsMove:Boolean;					//鼠标移动标识
		public var isDown:Boolean;						//是否长按
		public var skillNum:int;						//技能数字
		public var isShowBack:Boolean = true;			//是否显示背景
		public var isDispost:Boolean = true;			//是否释放内存
		public var isDispatch:Boolean = false;		//是否cd事件结束后派发事件
		public var skillIconId:int;					//技能位置
		private var _timer:Timer;						//计时器
		private var _oldCoolDown:int;					//原冷却时间
		private var _txtNum:SFTextField ;				//剩余数量显示文本
		private var _second:Number;						//剩余时间
		private var _index:Number = 18;
		private var _itemNum:int;						//
		public var severPoint:Object;					//临时数据
		public function HSkillIcon()  {  super(); }
		
		public function get itemNum():int
		{
			return _itemNum;
		}

		/**
		 * 初始化 
		 * @param backBtmd	: 背景地图
		 */		
		override public function init():void
		{
			//设置默认背景
			if(isShowBack)
			{
				myBackTexture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","itemBack");
			}
			super.init();
			this.myWidth = this.myHeight = 60;
			//添加CD滚动遮罩
			_maskWidth = this.myWidth - 18 >> 1;
			_maskHeight = this.myHeight - 18 >> 1
			_maskRadii = _skinWidth/2+15;
			_texture = HAssetsManager.getInstance().getAngTexture(_angle, _maskWidth, _maskHeight, _maskRadii, myWidth-_index, myHeight-_index);
			_maskSpr = new Image(_texture);
			this.addChild(_maskSpr);
			_maskSpr.touchable = false;
			_maskSpr.x = 9;
			_maskSpr.y = 9;
			_direction = 1;	//设置默认方向
			
			_txtNum = new SFTextField;
			_txtNum.myWidth = 20;
			this.addChild(_txtNum);
			_txtNum.visible = false;
			_txtNum.y = this.myHeight - 25;

		}
		
		override protected function onMouseEvent(e:TouchEvent):void
		{
			if(InitLoaderMapResControl.getInstance().isInitLoading)
				return;
			if(HTopBaseView.getInstance().hasEvent) return;
			var touch:Touch = e.getTouch(this);
			if(touch == null)
			{
				if(_mIsMove)
				{
					_mIsMove = false;
					DragIcon.getInstance().hideItemIcon();
				}
				_mIsDown = false;
				this.flagIconTexture = null;
			}	else {
				if(_skill)
				{
					if (touch.phase == TouchPhase.HOVER)
					{
						this.flagIconTexture = flagTexture 
					}
					if (touch.phase == TouchPhase.BEGAN && !_mIsDown)
					{
						_mIsDown = true;
					}
					if(touch.phase == TouchPhase.MOVED && _mIsDown)
					{
						if(_mIsMove)
						{
							DragIcon.getInstance().movePonsition(touch.globalX ,touch.globalY);
						}	else {
							if(_skillArr)
								DragIcon.getInstance().showSkillIcon(_skillArr[0], touch.globalX ,touch.globalY);
							else
								DragIcon.getInstance().showSkillIcon(_skill, touch.globalX ,touch.globalY);
						}
						_mIsMove = true;
						this.alpha = .3;
						this.flagIconTexture = null;
					}
					
					if(touch.phase == TouchPhase.ENDED)
					{
						if(_mIsMove)
						{
							var obj:DisplayObject = HBaseView.getInstance().hitTest(new Point(touch.globalX,touch.globalY),true);
							if(moveType == 0 && obj && obj is HSkillIcon)
							{
								if(obj != this && obj.parent is MainFace_ToolBar)
									SendMessageManage.getMyInstance().sendMoveSkillToSever([DataType.Byte(this.skillNum), DataType.Byte(HSkillIcon(obj).skillNum), DataType.Byte(moveType)]);
							}	
							else if(moveType == 1)
							{
								if(obj != this && obj is HSkillIcon)
									SendMessageManage.getMyInstance().sendMoveSkillToSever([DataType.Byte(this.skillNum), DataType.Byte(HSkillIcon(obj).skillNum), DataType.Byte(moveType)]);
							}
							else {
								if(HMapSources.getInstance().mapData&&HMapSources.getInstance().mapData.type < 3)
									SendMessageManage.getMyInstance().sendRemoveSkillToSever([DataType.Byte(this.skillNum)]);
								else
									HSuspendTips.ShowTips("此场景不可丢弃技能");
							}
							this.alpha = 1;
							_mIsDown = _mIsMove = false;
							DragIcon.getInstance().hideItemIcon();
						}	else  if(_mIsDown && _skill) {
							_mIsDown = false
							this.dispatchEventWith(Event.TRIGGERED);
						}
						
					}
				}
			}
		}
		/**
		 * 设置技能数据 
		 * @param skill	: 技能数据
		 */		
		public function set skillData(skill:Skill):void
		{
			//赋值当前技能数据
			_skill = skill;
			if(_timePoer)
				_timePoer.visible = false;
			_maskSpr.visible = false;
			if(!_skill || !_skill.isRefresh)
			{
				_nowCDTime = 0;
				this.data = null;
				_isCDTime = false;
				_txtNum.visible = false;
				onCDCallBack(false);			//刷新一下显示,但不显示光效
				TipsTool.getInstance().destoryTips(this);
				return;
			}
			_nowCDTime = _skill.overCd;			//赋值当前cd时间
			_skill.cdCallBack = onCDCallBack;	//赋值技能对应的回调
			//显示技能内容
			if(_skillArr)
			{
				_oldCoolDown = _skillArr[0].coolDown;
				this.data = { Item_IconPack:SourceTypeEvent.MAIN_INTERFACE_SOURCE, Item_IconName:_skillArr[0].iconName };
			}	else {
				_oldCoolDown = _skill.coolDown;
				this.data = { Item_IconPack:SourceTypeEvent.MAIN_INTERFACE_SOURCE, Item_IconName:_skill.iconName };
			}
				
			this.setChildIndex(_maskSpr,this.numChildren-1);
			if(_timePoer)
				this.setChildIndex(_timePoer,this.numChildren-1);

			TipsTool.getInstance().setTips(this, SimpleSkillTips.getInstance(), _skill);
			if(_skill.level < 1)
			{
				_txtNum.visible = false;
				if(!this.filter)
				{
					this.filter = Tool.getGrayColorMatrixFilter();
				}
			}	else {
				if(skill.type == 5)
				{
					if(ItemSources.getInstance().isCreateItemSkep)
						showItemNum();
					else
						ItemSources.getInstance().addEventListener("ItemSkepComplete0", ItemSkepComplete);
				}	else {
					_txtNum.visible = false;
					if(this.filter)
					{
						this.filter.dispose();
						this.filter = null;
					}
					if(skill.isUseNumber)
					{
						updateTxtNum(this.skillData.useNumberTime);
						skill.useNumberRecall = useNumberRecall;
					}
				}
			}
		}
		
		/**显示可播放技能数量*/
		private function useNumberRecall():void
		{
			updateTxtNum(this.skillData.useNumberTime);
		}
		/**数据创建事件*/
		private function ItemSkepComplete(e:Event):void
		{
			ItemSources.getInstance().removeEventListener("ItemSkepComplete0", ItemSkepComplete);
			showItemNum();
		}
		/**显示血瓶数量*/
		public function showItemNum():void
		{
			_itemNum = ItemSources.getInstance().getBagItemNum(_skill.baseValue.toString());
			updateTxtNum(_itemNum);
		}
		
		/**更新文本数量*/
		private function updateTxtNum(num:int):void
		{
			if(num < 1)
			{
				if(!this.filter)
				{
					this.filter = Tool.getGrayColorMatrixFilter();
				}
			} 	else {
				if(this.filter)
				{
					this.filter.dispose();
					this.filter = null;
				}
			}
			_txtNum.visible = true;
			if(_txtNum.label != "#ffffff12" + num)
			{
				_txtNum.label = "#ffffff12" + num;
				_txtNum.x = this.myWidth - _txtNum.textWidth - 5;
			}
		}
		
		public function get skillData():Skill  { return _skill; }
		
		public function set SkillArr(value:Vector.<Skill>):void
		{
			if(value && value.length > 1) 
			{
				_skillArr = value;
				_skillIndex = 1;
				this.skillData = _skillArr[_skillIndex];
				if(_timer == null)
				{
					_timer = new Timer(2000);
					_timer.addEventListener(TimerEvent.TIMER, onTimer)
				}
			}	else {
				if(_timer)
					_timer.stop()
				_skillArr = null;
			}
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			_timer.stop()
			_skillIndex = 1;
			this.skillData = _skillArr[_skillIndex];
		}
		/**
		 * 技能冷却执行效果
		 * @param isShow	: 是否显示光效
		 */		
		private function onCDCallBack(isShow:Boolean = true):void
		{
			if(!MainInterfaceManage.getInstance().isLoadUI) return;
			if(ChatDataSource.getMyInstance().isDisposed || Starling.context.driverInfo=="Disposed") return;
			if(!_skill || _isDisposed) 
			{
				if(_timePoer)
					_timePoer.visible = false;
				_maskSpr.visible = false;
				return;
			}
			if(!_maskSpr.visible)
			{
				_maskSpr.visible = true;
				if(!_timePoer)
				{
					_timePoer = new PowerItem;
					_timePoer.y = this.myHeight - 12 >> 1;
					_timePoer.setSourceName("role/power", "number/time_", SourceTypeEvent.MAIN_INTERFACE_SOURCE, SourceTypeEvent.MAIN_INTERFACE_SOURCE, 8);
					this.addChild(_timePoer);
				}	else {
					_timePoer.visible = true;
				}
			}
			_nowCDTime = _skill.overCd;
			_isCDTime = _nowCDTime>0;
			var cdTime:int = _skill.coolDown;
			if(_nowCDTime < 0) _nowCDTime = 0;
			var n:Number = _nowCDTime/cdTime;
			if(_nowCDTime > 0)
			{
				_second = Number(_nowCDTime/1000)
				if(_second > 1)
				{
					_timePoer.power = _second;
					//_cdTimeText.label = "#ffffff12" +  int(_second+1);//是为了屏蔽显示0秒问题
				}
				else
				{
					//var str:String = String(_second).substr(0,3);
					_timePoer.updateBuffTime = _second;
					//_cdTimeText.label = "#ffffff12" +  str;//+1是为了屏蔽显示0秒问题
					//_cdTimeText.label = "#ffffff12" +  _second .toFixed(1);//+1是为了屏蔽显示0秒问题
				}
				var vx:int = this.myWidth - _timePoer.myWidth >> 1;
				if(_timePoer.x != vx)
					_timePoer.x = vx;
			}	else {
				if(_timePoer)
					_timePoer.visible = false;
				_maskSpr.visible = false;
			}
			_angle = _skill.overCd * _skill.useTime// n*360;//计算扇形角度
			_texture = HAssetsManager.getInstance().getAngTexture(_angle, _maskWidth, _maskHeight, _maskRadii, myWidth-_index, myHeight-_index);
			
			_maskSpr.texture = _texture;
			_maskSpr.readjustSize();
			//CD时间为0时执行对应操作
			if(_nowCDTime <= 0 && isShow)
			{
				_nowCDTime = 0;
				if(_timePoer)
					_timePoer.visible = false;
				_isCDTime = false;
				if(_skill.type == 5)
				{
					var num:int = ItemSources.getInstance().getBagItemNum(_skill.baseValue.toString());
					if(num < 1)
					{
						if(!this.filter)
							this.filter = Tool.getGrayColorMatrixFilter();
					}
					if(_txtNum.label != "#ffffff12" + num)
					{
						_txtNum.label = "#ffffff12" + num;
						_txtNum.x = this.myWidth - _txtNum.textWidth - 5;
					}
				}
				if(_skillArr)
				{
					_skillIndex ++;
					if(_skillIndex >= _skillArr.length)
						_skillIndex = 1;
					this.skillData = _skillArr[_skillIndex];
				}
				if(isDispatch)
					this.dispatchEvent(new Event("Skill_CD_Over",false, severPoint));
			}
		}
		
		public function resetSkill():void
		{
			if(!isDown)
				_skillIndex = 1;
			
			if(_skillArr)
			{
				_timer.reset();
				_timer.start();
			}
			if(_skill.isUseNumber)
			{
				if(_skill.overCd < 1)
					_skill.reset();
				else
					_skill.updateUseNumber();
			} 	else {
				_skill.reset();
			}
				
		}
		
		/**
		 * 设置旋转方向
		 * @param value	: 方向(-1:顺时针 1:逆时针)
		 */		
		public function set direction(value:int):void
		{
			_direction = value;
			_maskSpr.scaleX = value;
			_maskSpr.x = ( value == -1 ? _skinWidth : (this.myWidth - _skinWidth)/2);
		}
		public function get direction():int  {  return _direction;  }
		/**
		 * 是否灰化(MP不足时灰化)
		 * @param value	: true:灰化 false:不灰化
		 */
		public function set isGray(value:Boolean):void
		{
			_isGray = value;
			/*if(_isGray)
				Tool.grayDisplayObject(super.iconBtm);
			else
				Tool.removeFilterObject(super.iconBtm);*/
		}
		public function get isGray():Boolean  {  return _isGray;  }
		/**
		 * 是否显示技能CD时间文本 
		 * @param value	: true:显示 false:不显示
		 */
		public function set isShowTimerText(value:Boolean):void
		{
			_isShowTimerText = value;
			if(_timePoer)
				_timePoer.visible = _isShowTimerText;
		}
		public function get isShowTimerText():Boolean  {  return _isShowTimerText;  }
		
		/** 获取当前CD旋转角度 **/
		public function get angle():int { return _angle; }
		/** 是否在技能CD动画中 **/
		public function get isCDTime():Boolean  {  return _isCDTime;  }
		
		/**  清除内容 **/		
		public function clearContent():void
		{
			if(_isClear) return;
			this.data = null;
			_timePoer.visible = false;
		}
		
		/** 技能清除方法 **/
		override public function dispose():void
		{
			if(_isClear) return;
			//清空内容图片
			super.dispose();
			//移出父类容器
			while(this.numChildren)
			{
				this.removeChildAt(0);
			}
			//判断是否dispost掉
			if(isDispost)
			{
				if(myBackTexture) 
				{
					myBackTexture.dispose();
					_backTexture.dispose();
				}
			}
			//清空内容
			clearContent();
			
			//_maskShape = null;
			myBackTexture = null;
			_timePoer = null;
			_backTexture = null;
			_skill = null;
			
			_isClear = true;
			this.dispatchEvent(new Event("ClearComponent"));
		}
		
		/** 获取技能组*/
		public function get SkillArr():Vector.<Skill>
		{
			return _skillArr;
		}

		/** 获取技能id*/		
		public function get firstSkill():Skill
		{
			var sk:Skill = _skillArr == null ? _skill : _skillArr[0];
			return sk;
		}
	}
}