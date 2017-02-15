package tl.core.DataSources
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	import tl.frameworks.model.CSV.SGCsvManager;

	public class Skill extends EventDispatcher
	{
		public var id:String;//#技能编号
		public var name:String;//技能名称
		public var desc:String;//技能说明
		public var level:int;//技能等级
		public var type:int;//技能类型
		public var series:Array;//系
		public var PrivateData:Array;//倒计时数据
		public var masterConds:Array;//学习条件
		public var castConds:Array;//施放条件
		public var leadTime:int;//引导时间
		public var showProgress:int;//是否显示进度条
		public var castTime:int;//施法时间
		public var lastTime:int;//持续时间
		public var effectInterval:int;//作用间隔
		public var needLead:int;//是否需要引导
		public var range:int;//作用范围
		public var rangeParams:Array;//范围参数
		public var combo:Array;//组合技
		public var flyerSpeed:int;//飞行物速度
		public var targetType:int;//目标类型
		public var targetsCount:int;//目标个数
		public var changePos:int;//改变位置
		public var physical:Array;//物理效果
		public var baseValue:int;//加成比例
		public var extraValue:int;//附加数值
		public var coolDown:int;//冷却时间
		public var buff:Array;//附加状态及几率
		public var threat:int;//威胁值
		public var iconPack:String;//图标资源包
		public var iconName:String;//图标类名
		public var earthQuake:Array;//附带振屏
		public var flashLight:Array;//闪光效果
		public var action:String;//技能动作
		public var myEffect:Array;//自身特效
		public var middleEffect:Array;//飞行特效
		public var struckEffect:Array;//受击特效
		public var rangeEffect:Array;//范围特效
		public var castEffect:Array;//施法特效
		public var weaponEffect:Array;//武器效果
		public var mySound:String;//自身音效
		public var middleSound:String;//过程音效
		public var struckSound:String;//目标音效
		public var rangeSound:String;//范围音效
		
		public var angle:int;//技能作用角度
		public var distance:int;//技能作用距离
		
		private var _useNumberTime:int;			//可用次数
		private var _useNumberType:int;			//类型  0、玩家的技能使用次数>0,则可继续使用;使用次数为0了; 则开始CD时间禁止使用; CD完后还原所有次数 1、玩家的技能使用次数>0,则可继续使用;使用次数为0了,则不允许使用; 使用一次则开启CD时间后还原次数一次;
		private var _isUseNumber:Boolean;			//倒计时受次数影响
		private var _overCd:int = 0;				//剩余的冷却时间
		private var _isRefresh:Boolean = false;	//是否有更新过数据
		private var _isFirstPlay:Boolean				//是否快速播放
		private var _useTime:Number;			//消耗时间
		private var _isReset:Boolean;
		public var cdCallBack:Function;			//回调函数
		public var useNumberRecall:Function;		//倒计时回调
		public var sUID:Number;
		public var tUID:Number;
		public var sPoint:Point=new Point();
		public var tPoint:Point=new Point();
		
		/**
		 *	是否需要学习 
		 */		
		public var isNeedStudy:Boolean;
		public var attackAngle:int;			//攻击角度
		
		public function Skill()
		{
		}
		public function refresh(skillID:String):void
		{
			if(id == skillID) return;
			var args:Array = SGCsvManager.getInstance().table_skill.FindRow(skillID);
			if(!args) return;
			id=args[0];//#技能编号
			name=args[1];//技能名称
			desc=args[2];//技能说明
			level=int(args[3]);//技能等级
			type=args[4];//技能类型
			series=args[5].split("|");//系
			PrivateData=args[6].split("|");;//是否受攻速影响
			masterConds=args[7].split("|");//学习条件
			castConds=args[8].split("|");//施放条件
			leadTime=args[9].split("|");//施放消耗
			showProgress=args[10];//是否显示进度条
			castTime=int(args[11]);//施法时间
			lastTime=int(args[12]);//持续时间
			effectInterval=int(args[13]);//作用间隔
			needLead=int(args[14]);//是否需要引导
			range=int(args[15]);//作用范围
			rangeParams=args[16].split("|");//范围参数
			combo=args[17].split("|");//组合技
			flyerSpeed=int(args[18]);//飞行物速度
			targetType=args[19];//目标类型
			targetsCount=args[20];//目标个数
			changePos=args[21];//改变位置
			physical=args[22].split("|");//物理效果
			baseValue=int(args[23]);//加成比例
			extraValue=int(args[24]);//附加数值
			coolDown=int(args[25]);//冷却时间
			buff=args[26].split("|");//附加状态及几率
			threat=int(args[27]);//威胁值
			iconPack=args[28];//图标资源包
			iconName=args[29];//图标类名
			earthQuake=args[30].split("|");//附带振屏
			flashLight=args[31].split("|");//闪光效果
			action=args[32];//技能动作
			myEffect=args[33].split("|");//自身特效
			middleEffect=args[34].split("|");//飞行特效
			struckEffect=args[35].split("|");//受击特效
			rangeEffect=args[36].split("|");//范围特效
			castEffect=args[37].split("|");//施法特效
			weaponEffect=args[38].split("|");//武器效果
			mySound=args[39];//自身音效
			middleSound=args[40];//过程音效
			struckSound=args[41];//目标音效
			rangeSound=args[42];//范围音效
			
			if(PrivateData.length > 1)
			{
				_isUseNumber = true;
				_useNumberTime = int(PrivateData[1]);
				_useNumberType = int(PrivateData[0]);
			}	else {
				_isUseNumber = false;
			}
			_useTime = 360/coolDown;
			distance=int(rangeParams[0]);
			if(rangeParams.length>1){
				angle=int(rangeParams[1]);
			}	
			_isRefresh = true;
		}
		/** 设置cd时间剩余 **/
		public function set overCd(value:int):void
		{
			_overCd = value;
			if(_overCd == 0)
			{
				if(_isUseNumber)
				{
					if(_useNumberType == 0)
					{
						_useNumberTime = int(PrivateData[1])
					}	else if( _useNumberType == 1 ) {
						_useNumberTime ++;
						if(_useNumberTime < int(PrivateData[1]))
						{
							this.overCd=coolDown;
							_isReset = true;	
						}
					}
					if(useNumberRecall)
						useNumberRecall();
				}
			}
		}
		public function get overCd():int { 
			return _overCd; 
		}
		public function reset():void{
			if(_isUseNumber)
			{
				if(_useNumberType == 0)
				{
					if(_useNumberTime <= 1)
					{
						this.overCd=coolDown;
						_isReset = true;	
					} 	else {
						_useNumberTime --;
					}
				}	else {
					_useNumberTime --;
					this.overCd=coolDown;
					_isReset = true;	
				}
				if(useNumberRecall)
					useNumberRecall();
			}	else {
				this.overCd=coolDown;
				_isReset = true;	
			}
			
		}
		
		public function clear():void
		{
			_isRefresh = false;
		}
		
		/** 是否有更新过数据 **/
		public function get isRefresh():Boolean  {  return _isRefresh;  }
		/**
		 * 克隆技能数据
		 * @param $skill	: 要覆盖当前数据的skill
		 */		
		public function cloneSkillData($skill:Skill):void
		{
			this.refresh($skill.id);
			
			angle = $skill.angle;//技能作用角度
			distance = $skill.distance;//技能作用距离
			
			cdCallBack = $skill.cdCallBack;			//回调函数
			sUID = $skill.sUID;
			tUID = $skill.tUID;
			sPoint.x = $skill.sPoint.x;
			sPoint.y = $skill.sPoint.y;
			tPoint.x = $skill.tPoint.x;
			tPoint.y = $skill.tPoint.y;
		}
		
		/**刷新消耗时间*/
		public function updateTime(_continueTimer:int):void
		{
			if(_isReset) 
			{
				_isReset = false;
				if(cdCallBack)
					cdCallBack();
				return;
			}
			if(isFirstPlay)
				_overCd -= 300;
			else
				_overCd -= _continueTimer;
			
			if(_overCd <= 0) 
			{
				isFirstPlay = false;
				overCd = 0;
			}
			if(cdCallBack)
				cdCallBack();
		}
		/**每一角度所需时间*/
		public function get useTime():Number
		{
			return _useTime;
		}
		/**倒计时是否受次数影响*/
		public function get isUseNumber():Boolean
		{
			return _isUseNumber;
		}
		
		public function set isUseNumber(value:Boolean):void
		{
			_isUseNumber = value;
		}
		
		
		/** 释放skill **/
		public function dispose():void
		{
			series.length = 0;//系
			masterConds.length = 0;//学习条件
			castConds.length = 0;//施放条件
			rangeParams.length = 0;//范围参数
			combo.length = 0;//组合技
			physical.length = 0;//物理效果
			buff.length = 0;//附加状态及几率
			earthQuake.length = 0;//附带振屏
			flashLight.length = 0;//闪光效果
			myEffect.length = 0;//自身特效
			middleEffect.length = 0;//飞行特效
			struckEffect.length = 0;//受击特效
			rangeEffect.length = 0;//范围特效
			castEffect.length = 0;//施法特效
			weaponEffect.length = 0;//武器效果
			
			cdCallBack = null;			//回调函数
			sPoint = null;
			tPoint = null;
			
			series = null;//系
			masterConds = null;//学习条件
			castConds = null;//施放条件
			rangeParams = null;//范围参数
			combo = null;//组合技
			physical = null;//物理效果
			buff = null;//附加状态及几率
			earthQuake = null;//附带振屏
			flashLight = null;//闪光效果
			myEffect = null;//自身特效
			middleEffect = null;//飞行特效
			struckEffect = null;//受击特效
			rangeEffect = null;//范围特效
			castEffect = null;//施法特效
			weaponEffect = null;//武器效果
		}
		
		public function get useNumberTime():int
		{
			return _useNumberTime;
		}
		
		public function get canUseSkill():Boolean
		{
			var flg:Boolean;
			if(_isUseNumber)
			{
				if(_useNumberType == 0)
					flg = _overCd < 1 ? true : false;
				else
					flg = _useNumberTime < 1 ? false : true;
			}	else {
				flg = _overCd < 1 ? true : false;
			}
			
			return flg;
		}
		
		public function updateUseNumber():void
		{
			if(_useNumberTime > 0 )
				_useNumberTime --; 
			if(useNumberRecall)
				useNumberRecall();
		}
		
		public function get isFirstPlay():Boolean
		{
			return _isFirstPlay;
		}
		
		public function set isFirstPlay(value:Boolean):void
		{
			_isFirstPlay = value;
		}
		
	}
}