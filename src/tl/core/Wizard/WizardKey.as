package tl.core.Wizard
{
	import tl.frameworks.model.CSV.SGCsvManager;

	/**
	 * AI计算/设置 数据对象
	 * @author 李舒浩
	 */	
	public class WizardKey
	{
		public function WizardKey()  {  }
		
		/** 警戒范围半径 **/
		public static const scopeNum:int = 200;
		/** 跟随位置坐标X **/
		public static const locationXArr:Array = [ [-50, -50, -100], [-50, 10, -60], [-50, 50, 0], [10, 60, 55], [50, 50, 100]	//右, 右上, 上, 左上, 左
													,[10 , 50, 60], [-50, 50, 0], [10, -50, -60]									//左下,下,右下
												];
		/** 跟随位置坐标Y **/
		public static const locationYArr:Array = [ [-30, 30, 0], [0, 40, 35], [30, 30, 60], [35, 0, 35], [-30, 30, 0]				//右, 右上, 上, 左上, 左
													,[-40, 0, -35], [-30, -30, -60], [-40, 0, -35]									//左下, 下, 右下
												];
		
//		/** 受伤数字皮肤数组 **/
//		public static const addHpBitmapdata:Array = [
//													 IResourceManager.getInstance().getTextureFromBitmapData("Skin", "Skin_NumA_0")
//													,IResourceManager.getInstance().getTextureFromBitmapData("Skin", "Skin_NumA_1")
//													,IResourceManager.getInstance().getTextureFromBitmapData("Skin", "Skin_NumA_2")
//													,IResourceManager.getInstance().getTextureFromBitmapData("Skin", "Skin_NumA_3")
//													,IResourceManager.getInstance().getTextureFromBitmapData("Skin", "Skin_NumA_4")
//													,IResourceManager.getInstance().getTextureFromBitmapData("Skin", "Skin_NumA_5")
//													,IResourceManager.getInstance().getTextureFromBitmapData("Skin", "Skin_NumA_6")
//													,IResourceManager.getInstance().getTextureFromBitmapData("Skin", "Skin_NumA_7")
//													,IResourceManager.getInstance().getTextureFromBitmapData("Skin", "Skin_NumA_8")
//													,IResourceManager.getInstance().getTextureFromBitmapData("Skin", "Skin_NumA_9")
//													,IResourceManager.getInstance().getTextureFromBitmapData("Skin", "Skin_NumA_point")
//													,IResourceManager.getInstance().getTextureFromBitmapData("Skin", "Skin_NumA_add")
//													,IResourceManager.getInstance().getTextureFromBitmapData("Skin", "Skin_NumA_deduct")
//												];
		/** 伤害计算cofe参数数组 **/
//		public static const cofeParam1Arr:Array = SGCsvManager.getInstance().table_coef.DataArray;
		private static var _cofeParam1Arr:Array;
		public static function get cofeParam1Arr():Array
		{
			_cofeParam1Arr ||= SGCsvManager.getInstance().table_coef.DataArray;
			return _cofeParam1Arr;
		}
		
		//---------------英雄职业偏向
		public static const FirJob_Null:int = 0;				//无偏向
		public static const FirJob_Tank:int = 1;				//坦克类型
		public static const FirJob_Dps:int = 2;				//输出类型
		public static const FirJob_Pastor:int = 3;			//牧师类型
		public static const FirJob_Control:int = 4;			//控制类型
		//职业类型偏向数组(一般用于点击分类标题按钮通过下标获取指定类型用)
		public static const FirJobArr:Array = [FirJob_Null, FirJob_Tank, FirJob_Dps, FirJob_Pastor, FirJob_Control];
		//----------------精灵关系
		public static const TargetType_MySelf:int = 0;		//自已
		public static const TargetType_Enemy:int = 1;			//敌人
		public static const TargetType_Friends:int = 2;		//友方
		//----------------精灵类型
		public static const Actor_Heor:int = 0;			//英雄
		public static const Actor_Npc:int = 1;			//Npc
		public static const Actor_SkillEffect:int = 2;   //技能特效
		public static const Actor_Moster:int = 3;			//小怪
		public static const Actor_EliteMoster:int = 4;	//精英怪
		public static const Actor_Boss:int = 5;			//Boss怪
		public static const Actor_Item:int = 6;			//掉落物品
		public static const Actor_Box:int = 7;			//箱子
		
		public static const WizardUnit_Body:String = "WizardUnit_Body";				//主体部件
		public static const WizardUnit_LeftArms:String = "WizardUnit_LeftArms";	//右手武器部件
		public static const WizardUnit_RightArms:String = "WizardUnit_RightArms";	//右手武器部件
		public static const WizardUnit_Mount:String = "WizardUnit_Mount";			//坐骑部件
		public static const WizardUnit_Wing:String = "WizardUnit_Wing";				//翅膀部件
		
		public static const Item_God:int = 50801;			//金币物品
		public static const Mouse_Range:String = "18001";			//鼠标选范围特效
		public static const Mouse_Effect:String = "18000";			//鼠标点地特效
		public static const EffectFileName:String = "SpecialEfficacy";			//特效文件夹名
		//-------------------------运动行为类型字义------------------------------------------
		public static const Action_ActionPlayOver:String = "Action_ActionPlayOver";	 //非循环动作播放完毕
		public static const Action_DiecChange:String = "Action_DiecChange";	             //改变方向
		public static const Action_MoveChange:String = "Action_MoveChange";	             //走与跑转换
		public static const Action_MoveStart:String = "Action_MoveStart";	             //开始移动
		public static const Action_Destination:String = "Action_Destination";	         //到达指定地点
		public static const Action_ChangeStatus:String = "Action_ChangeStatus";	         //切换动作模式(城市/战斗)
		public static const Action_BindingUnit:String = "Action_BindingUnit";	         //绑定部件
		public static const Action_RemoveBindingUnit:String = "Action_RemoveBindingUnit";	 //移除绑定部件
		public static const Action_EffectOver:String = "Action_EffectOver";	             //特效播放一次完成
		
		//-------------------------战斗行为类型字义------------------------------------------
		public static const FirAction:String = "FirAction";	                             //战斗关键字
		public static const FirAction_MoveToTarget:String ="FirAction_MoveToTarget";	 //跑向目标
		public static const FirAction_StopMove:String ="FirAction_StopMove";	         //停止移动
		public static const FirAction_UseSkill:String ="FirAction_UseSkill";		     //使用技能 sikll,目标位置(可选)
		public static const FirAction_cancelSkill:String ="FirAction_cancelSkill";		 //取消技能
		public static const FirAction_AssignOrigin:String ="FirAction_AssignOrigin";	 //设置技能
		public static const FirAction_Damage:String ="FirAction_Damage";			     //受到伤害
		public static const FirAction_CallHelp:String ="FirAction_CallHelp";		     //呼号协助
		public static const FirAction_CallFollow:String ="FirAction_CallFollow";		 //呼叫跟随
		public static const FirAction_Dead:String ="FirAction_Dead";			         //死亡
		public static const FirAction_AddHp:String = "FirAction_AddHp";			         //受到加血
		public static const FirAction_AddBuff:String = "FirAction_AddBuff";		         //加Buff
		public static const FirAction_RemoveBuff:String = "FirAction_RemoveBuff";		 //加Buff
		public static const FirAction_PlayAction:String = "FirAction_PlayAction";		 //播放指定的动作
		public static const FirAction_PlayEffect:String = "FirAction_PlayEffect";		 //播放指定的特效
		public static const FirAction_Fall:String = "FirAction_Fall";		             //坠落
		public static const FirAction_Bounce:String = "FirAction_Bounce";		         //弹起
		public static const FirAction_Earthquake:String = "FirAction_Earthquake";		 //地板振动
		public static const FirAction_FlashLight:String = "FirAction_FlashLight";		 //闪光效果
		public static const FirAction_StruckBroken:String = "FirAction_StruckBroken";	 //受击破碎
		public static const FirAction_StruckBlood:String = "FirAction_StruckBlood";	 //受击溅血
		public static const FirAction_RemoveBroken:String = "FirAction_RemoveBroken";	 //受击破碎
		public static const FirAction_PlySound:String = "FirAction_PlySound";	         //播放音效
		public static const FirAction_WizardClear:String = "FirAction_WizardClear";	 //精灵对象消失
		
		//-------------------------精灵状态类型字义------------------------------------------
		public static const Status_Move:String = "Status_Move";	                             //移动中
		public static const Status_Stand:String = "Status_Stand";	                         //站立中
		public static const Status_Attack:String = "Status_Attack";	                         //攻击中
		public static const Status_Struck:String = "Status_Struck";	                         //受击中
		public static const Status_StruckBack:String = "Status_StruckBack";	                 //击退中
		public static const Status_StruckPly:String = "Status_StruckPly";	                 //击飞中
		public static const Status_StruckFall:String = "Status_StruckFall";	                 //击倒中
		public static const Status_Dead:String = "Status_Dead";	                             //死亡
		
		public static const Refresh_WizardObject:String = "Refresh_WizardObject";			//精灵数据刷新
		
		//-------------------------BUFF类型字义------------------------------------------
		public static const BuffType_PropAdd:int =1;	//属性增益
		public static const BuffType_PropCut:int =2;	//属性减益
		public static const BuffType_HoldHarm:int =3;	//持续伤害:间隔时间|每次掉血
		public static const BuffType_HoldHp:int =4;	//持续回血:间隔时间|每次回血
		public static const BuffType_SkillCd:int =5;	//技能时间
		public static const BuffType_NoMoveAttack:int =6;	//定身可攻击
		public static const BuffType_NomoveNoAttack:int =7;	//定身不可攻击
		public static const BuffType_NoAttack:int =8;	//不可攻击
		public static const BuffType_BeControl:int =9;	//被控制
		public static const BuffType_Hatred:int =10;	//增减仇恨
		public static const BuffType_NoHarm:int =11;	//免疫伤害
		public static const BuffType_AbsorbHarm:int =12;	//吸收伤害
		public static const BuffType_ReflexHarm:int =13;	//反射伤害
		public static const BuffType_AbsorbHp:int =14;	//吸血
		public static const BuffType_NoNoMove:int =15;	//反制定身
		public static const BuffType_LockTarget:int =16;	//目标锁定
		public static const BuffType_NoBadBuff:int =17;	//反制减益BUFF
		public static const BuffType_ExpAdd:int =30;	//经验加成
		public static const BuffType_ItemAdd:int =31;	//掉落加成
	}
}