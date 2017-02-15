package tl.core.DataSources
{
	import tl.Net.Socket.Order;
	import tl.core.old.ModuleEventDispatcher;
	import tl.frameworks.model.CSV.SGCsvManager;

	public class Player extends Creature
	{				
		public var AttrList:Array = [
			
			0,     // Entity_UID                     实体UID
			72,     // WEntity_SceneId                世界实体的场景ID
			73,     // WEntity_PosX                   世界实体位置X
			74,     // WEntity_PosY                   世界实体位置Y
			75,     // Creature_Race                  种族
			76,     // Creature_Vocation              职业(技能系)
			77,     // Creature_Gender                性别
			78,     // Creature_Level                 等级
			79,     // Creature_Bless                 祝福值
			80,     // Creature_WizardId              精灵ID
			81,     // Creature_MasterUID             主人ID
			82,     // Creature_MoveSpeed             移动速度
			83,     // Creature_FightPower            战力
			84,     // Creature_Attack                攻击
			85,     // Creature_Defense               防御
			86,     // Creature_CurHp                 生命值
			87,     // Creature_MaxHp                 生命值上限
			88,     // Creature_Crit                  暴击
			89,     // Creature_Tenacity              韧性
			90,     // Creature_AppendHurt            附加伤害
			91,     // Creature_OutAttack             卓越攻击
			92,     // Creature_AttackPerc            攻击加成
			93,     // Creature_LgnoreDefense         无视防御
			94,     // Creature_AbsorbHurt            吸收伤害
			95,     // Creature_DefenseSuccess        防御成功率
			96,     // Creature_DefensePerc           防御加成
			97,     // Creature_OutHurtPerc           减伤比例
			98,     // Creature_Vampire               吸血 
			99,     // Creature_Hit                   命中
			100,     // Creature_Dodge                 闪避
			101,     // Creature_HatredIncrease        仇恨产生速度
			102,     // Creature_Skill1                当前技能1
			103,     // Creature_Skill2                当前技能2
			104,     // Creature_Skill3                当前技能3
			105,     // Creature_Skill4                当前技能4
			106,     // Creature_Skill5                当前技能5
			107,     // Creature_Skill6                当前技能6
			108,     // Player_UserId                  帐号ID
			109,     // Player_ActorId                 角色ID
			110,     // Player_Exp                     经验
			111,     // Player_Stamina                 体力
			112,     // Player_MaxStamina              体力上限
			113,     // Player_Credit                  声望(荣誉)
			114,     // Player_ArmyLevel               军衔
			115,     // Player_StaminaBuyNum           体力购买次数
			116,     // Player_QuestLevel              主任务级别
			117,     // Player_StoryLevel              剧情级别(未使用)
			118,     // Player_BagSize                 背包栏有效个数
			119,     // Player_Name                    角色名
			120,     // Player_VipCard                 VIP卡
			121,     // Player_Vip                     VIP等级
			122,     // Player_VipExp                  VIP经验值
			123,     // Player_Team                    所在队伍ID
			124,     // Player_Camp                    阵营
			125,     // Player_Right                   玩家权限
			126,     // Player_Pay                     充值总数
			127,     // Player_Money                   元宝(魔晶)
			128,     // Player_Gold                    银两(金币)
			129,     // Player_GiftGold                礼券
			130,     // Player_BakSceneId              备份的场景ID
			131,     // Player_BakPosX                 备份的位置X
			132,     // Player_BakPosY                 备份的位置Y
			133,     // Player_Title                   当前称号
			134,     // Player_Flags1                  标志1
			135,     // Player_Flags2                  标志2
			136,     // Player_Flags3                  标志3
			137,     // Player_WeaponLeft              左手武器(未使用)
			138,     // Player_WeaponRight             右手武器
			139,     // Player_Fetch                   提取元宝数量
			140,     // Player_TeamLeader              是否是队伍队长(1是队长)
			141,     // Player_Val2                    保留值2(未使用)
			
		];
		
		public var Player_UserId                 : uint      ;     // 108 39 Player_UserId                  帐号ID
		public var Player_ActorId                : uint      ;     // 109 40 Player_ActorId                 角色ID
		public var Player_Exp                    : uint      ;     // 110 41 Player_Exp                     经验
		public var Player_Stamina                : uint      ;     // 111 42 Player_Stamina                 体力
		public var Player_MaxStamina             : uint      ;     // 112 43 Player_MaxStamina              体力上限
		public var Player_Credit                 : uint      ;     // 113 44 Player_Credit                  声望(荣誉)
		public var Player_ArmyLevel              : uint      ;     // 114 45 Player_ArmyLevel               军衔
		public var Player_StaminaBuyNum          : uint      ;     // 115 46 Player_StaminaBuyNum           体力购买次数
		public var Player_QuestLevel             : uint      ;     // 116 47 Player_QuestLevel              主任务级别
		public var Player_StoryLevel             : uint      ;     // 117 48 Player_StoryLevel              剧情级别(未使用)
		public var Player_BagSize                : uint      ;     // 118 49 Player_BagSize                 背包栏有效个数
		public var Player_Name                   : String    ;     // 119 50 Player_Name                    角色名
		public var Player_VipCard                : uint      ;     // 120 58 Player_VipCard                 VIP卡
		public var Player_Vip                    : uint      ;     // 121 59 Player_Vip                     VIP等级
		public var Player_VipExp                 : uint      ;     // 122 60 Player_VipExp                  VIP经验值
		public var Player_Team                   : uint      ;     // 123 61 Player_Team                    所在队伍ID
		public var Player_Camp                   : uint      ;     // 124 62 Player_Camp                    阵营
		public var Player_Right                  : uint      ;     // 125 63 Player_Right                   玩家权限
		public var Player_Pay                    : uint      ;     // 126 64 Player_Pay                     充值总数
		public var Player_Money                  : uint      ;     // 127 65 Player_Money                   元宝(魔晶)
		public var Player_Gold                   : uint      ;     // 128 66 Player_Gold                    银两(金币)
		public var Player_GiftGold               : uint      ;     // 129 67 Player_GiftGold                礼券
		public var Player_BakSceneId             : uint      ;     // 130 68 Player_BakSceneId              备份的场景ID
		public var Player_BakPosX                : uint      ;     // 131 69 Player_BakPosX                 备份的位置X
		public var Player_BakPosY                : uint      ;     // 132 70 Player_BakPosY                 备份的位置Y
		public var Player_Title                  : uint      ;     // 133 71 Player_Title                   当前称号
		public var Player_Flags1                 : uint      ;     // 134 72 Player_Flags1                  标志1
		public var Player_Flags2                 : uint      ;     // 135 73 Player_Flags2                  标志2
		public var Player_Flags3                 : uint      ;     // 136 74 Player_Flags3                  标志3
		public var Player_WeaponLeft             : uint      ;     // 137 75 Player_WeaponLeft              左手武器(未使用)
		public var Player_WeaponRight            : uint      ;     // 138 76 Player_WeaponRight             右手武器
		public var Player_Fetch                  : uint      ;     // 139 77 Player_Fetch                   提取元宝数量
		public var Player_TeamLeader             : uint      ;     // 140 78 Player_TeamLeader              是否是队伍队长(1是队长)
		public var Player_Val2                   : uint      ;     // 141 79 Player_Val2                    保留值2(未使用)
		
		
		//---------------配置表基础属性区----------------------------------------
		public var id:String;//#生物编号
		public var name:String;//生物名称
		public var resId:int;//资源ID
		public var level:int;//等级
		public var type:int;//生物类型
		public var aiList:Array;//生物AI
		public var fallTime:int;//倒地时间
		public var skillList:Array;//技能列表
		public var attack:int;//攻击
		public var defense:int;//防御
		public var curHp:int;//生命值
		public var crit:int;//暴击
		public var tenacity:int;//韧性
		public var appendHurt:int;//附加伤害
		public var outAttack:int;//卓越攻击
		public var attackPerc:int;//攻击加成
		public var lgnoreDefense:int;//无视防御
		public var absorbHurt:int;//吸收伤害
		public var defenseSuccess:int;//防御成功率
		public var defensePerc:int;//防御加成
		public var outHurtPerc:int;//减伤比例
		public var vampire:int;//吸血
		public var spoilsQuality:int;//掉落品质
		public var spoils:Array;//掉落组
		public var bindFun:Array;//绑定功能
		public var exp:int;//经验值
		public var say:String;//语言
		public var scaling:int;//缩放比例
		public var alphaBlending:int;//开启透明通道
		public var createEffect:String;//出生特效
		public var deathEffect:String;//死亡特效
		public var wizardTile:String;//精灵称号
		public var spoilsForKiller:Array;//掉落组(最后一刀)
		public var spoilsForHurt:Array;//掉落组(最大伤害)
		public var userType:int;//使用者类型
		public var wizardNameColor:int;//怪物名字颜色标识
		public var PhysicalHoldout:Array;//物理抗性
		public var SpoilsType:int;//掉落类型
		public var RangeEffect:String;//范围特效
		
		public function Player()
		{
		}	
		public function RefreshPlayer(_Order:Order):void {
			this.RefreshCreature(_Order,AttrList);
			
			Player_UserId                 = DataArray[37]; // 108 39 帐号ID
			Player_ActorId                = DataArray[38]; // 109 40 角色ID
			Player_Exp                    = DataArray[39]; // 110 41 经验
			Player_Stamina                = DataArray[40]; // 111 42 体力
			Player_MaxStamina             = DataArray[41]; // 112 43 体力上限
			Player_Credit                 = DataArray[42]; // 113 44 声望(荣誉)
			Player_ArmyLevel              = DataArray[43]; // 114 45 军衔
			Player_StaminaBuyNum          = DataArray[44]; // 115 46 体力购买次数
			Player_QuestLevel             = DataArray[45]; // 116 47 主任务级别
			Player_StoryLevel             = DataArray[46]; // 117 48 剧情级别(未使用)
			Player_BagSize                = DataArray[47]; // 118 49 背包栏有效个数
			Player_Name                   = DataArray[48]; // 119 50 角色名
			Player_VipCard                = DataArray[49]; // 120 58 VIP卡
			Player_Vip                    = DataArray[50]; // 121 59 VIP等级
			Player_VipExp                 = DataArray[51]; // 122 60 VIP经验值
			Player_Team                   = DataArray[52]; // 123 61 所在队伍ID
			Player_Camp                   = DataArray[53]; // 124 62 阵营
			Player_Right                  = DataArray[54]; // 125 63 玩家权限
			Player_Pay                    = DataArray[55]; // 126 64 充值总数
			Player_Money                  = DataArray[56]; // 127 65 元宝(魔晶)
			Player_Gold                   = DataArray[57]; // 128 66 银两(金币)
			Player_GiftGold               = DataArray[58]; // 129 67 礼券
			Player_BakSceneId             = DataArray[59]; // 130 68 备份的场景ID
			Player_BakPosX                = DataArray[60]; // 131 69 备份的位置X
			Player_BakPosY                = DataArray[61]; // 132 70 备份的位置Y
			Player_Title                  = DataArray[62]; // 133 71 当前称号
			Player_Flags1                 = DataArray[63]; // 134 72 标志1
			Player_Flags2                 = DataArray[64]; // 135 73 标志2
			Player_Flags3                 = DataArray[65]; // 136 74 标志3
			Player_WeaponLeft             = DataArray[66]; // 137 75 左手武器(未使用)
			Player_WeaponRight            = DataArray[67]; // 138 76 右手武器
			Player_Fetch                  = DataArray[68]; // 139 77 提取元宝数量
			Player_TeamLeader             = DataArray[69]; // 140 78 是否是队伍队长(1是队长)
			Player_Val2                   = DataArray[70]; // 141 79 保留值2(未使用)
			
			
			ModuleEventDispatcher.getInstance().ModuleCommunication("RefreshPlayer",this);
		}
		/**
		 * 刷新数据 
		 * @param wizardId	: 数据ID
		 */		
		public function refreshByTable(wizardId:String):void
		{
			var args:Array = SGCsvManager.getInstance().table_wizard.FindRow(wizardId);
			if(!args) return;
			//更新数据
			id=args[0];//#生物编号
			name=args[1];//生物名称
			resId=int(args[2]);//资源ID
			level=int(args[3]);//等级
			type=int(args[4]);//生物类型
			aiList=args[5].split("|");//生物AI
			fallTime=int(args[6]);//倒地时间
			skillList=args[7].split("|");//技能列表
			attack=int(args[8]);//攻击
			defense=int(args[9]);//防御
			curHp=int(args[10]);//生命值
			crit=int(args[11]);//暴击
			tenacity=int(args[12]);//韧性
			appendHurt=int(args[13]);//附加伤害
			outAttack=int(args[14]);//卓越攻击
			attackPerc=int(args[15]);//攻击加成
			lgnoreDefense=int(args[16]);//无视防御
			absorbHurt=int(args[17]);//吸收伤害
			defenseSuccess=int(args[18]);//防御成功率
			defensePerc=int(args[19]);//防御加成
			outHurtPerc=int(args[20]);//减伤比例
			vampire=int(args[21]);//吸血
			spoilsQuality=int(args[22]);//掉落品质
			spoils=args[23].split("|");//掉落组
			bindFun=args[24].split("|");//绑定功能
			exp=int(args[25]);//经验值
			say=args[26];//语言
			scaling=int(args[28]);//缩放比例
			alphaBlending=int(args[29]);//开启透明通道
			createEffect=args[30];//出生特效
			deathEffect=args[31];//死亡特效
			wizardTile=args[32];//精灵称号
			spoilsForKiller=args[33].split("|");//掉落组(最后一刀)
			spoilsForHurt=args[34].split("|");//掉落组(最大伤害)
			userType=int(args[35]);//使用者类型
			wizardNameColor=int(args[36]);//怪物名字颜色标识
			PhysicalHoldout=args[37].split("|");//物理抗性
			SpoilsType=int(args[38]);//掉落类型
			RangeEffect=args[39];//范围特效
			
			//生成特殊属性数据
		}
	}
}

