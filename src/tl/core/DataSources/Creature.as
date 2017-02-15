package tl.core.DataSources
{
    import tl.Net.Socket.Order;

    public class Creature extends WEntity
	{
	
    public var Creature_Race                 : uint      ;     // 31  5 Creature_Race                  种族
    public var Creature_Vocation             : uint      ;     // 32  6 Creature_Vocation              职业
    public var Creature_Gender               : uint      ;     // 33  7 Creature_Gender                性别
    public var Creature_Level                : uint      ;     // 34  8 Creature_Level                 等级
    public var Creature_Nation               : uint      ;     // 35  9 Creature_Nation                国家
    public var Creature_WizardId             : uint      ;     // 36 10 Creature_WizardId              精灵ID
    public var Creature_MasterUID            : Number    ;     // 37 11 Creature_MasterUID             主人ID
    public var Creature_PracticeLevel        : uint      ;     // 38 13 Creature_PracticeLevel         修仙等级
    public var Creature_FightPower           : uint      ;     // 39 14 Creature_FightPower            战力
    public var Creature_Attack               : uint      ;     // 40 15 Creature_Attack                攻击
    public var Creature_Defence              : uint      ;     // 41 16 Creature_Defence               防御
    public var Creature_CurHp                : uint      ;     // 42 17 Creature_CurHp                 当前生命
    public var Creature_MaxHp                : uint      ;     // 43 18 Creature_MaxHp                 生命值上限
    public var Creature_Speed                : uint      ;     // 44 19 Creature_Speed                 速度
    public var Creature_Fatal                : uint      ;     // 45 20 Creature_Fatal                 暴击
    public var Creature_Tenacity             : uint      ;     // 46 21 Creature_Tenacity              韧性
    public var Creature_Vampire              : uint      ;     // 47 22 Creature_Vampire               吸血
    public var Creature_CutHurt              : uint      ;     // 48 23 Creature_CutHurt               减伤
    public var Creature_ReflexHurt           : uint      ;     // 49 24 Creature_ReflexHurt            反伤
    public var Creature_LgnoreDefense        : uint      ;     // 50 25 Creature_LgnoreDefense         无视防御
    public var Creature_OutAttack            : uint      ;     // 51 26 Creature_OutAttack             卓越攻击
    public var Creature_AttackPerc           : uint      ;     // 52 27 Creature_AttackPerc            攻击加成
    public var Creature_AppendHurt           : uint      ;     // 53 28 Creature_AppendHurt            附加伤害
    public var Creature_RegainHp             : uint      ;     // 54 29 Creature_RegainHp              每秒回血
    public var Creature_Hit                  : uint      ;     // 55 30 Creature_Hit                   命中
    public var Creature_Dodge                : uint      ;     // 56 31 Creature_Dodge                 闪避
    public var Creature_HatredIncrease       : uint      ;     // 57 32 Creature_HatredIncrease        仇恨产生速度
    public var Creature_Skill1               : uint      ;     // 58 33 Creature_Skill1                当前技能1
    public var Creature_Skill2               : uint      ;     // 59 34 Creature_Skill2                当前技能2
    public var Creature_Skill3               : uint      ;     // 60 35 Creature_Skill3                当前技能3
    public var Creature_Skill4               : uint      ;     // 61 36 Creature_Skill4                当前技能4
    public var Creature_Skill5               : uint      ;     // 62 37 Creature_Skill5                当前技能5
    public var Creature_Skill6               : uint      ;     // 63 38 Creature_Skill6                当前技能6

		
		public function Creature()
		{
		}
		
		public function RefreshCreature(_Order:Order,_AttrList:Array):void{
			this.RefreshWEntity(_Order,_AttrList);
			
        Creature_Race                 = DataArray[ 4]; // 31  5 种族
        Creature_Vocation             = DataArray[ 5]; // 32  6 职业
        Creature_Gender               = DataArray[ 6]; // 33  7 性别
        Creature_Level                = DataArray[ 7]; // 34  8 等级
        Creature_Nation               = DataArray[ 8]; // 35  9 国家
        Creature_WizardId             = DataArray[ 9]; // 36 10 精灵ID
        Creature_MasterUID            = DataArray[10]; // 37 11 主人ID
        Creature_PracticeLevel        = DataArray[11]; // 38 13 修仙等级
        Creature_FightPower           = DataArray[12]; // 39 14 战力
        Creature_Attack               = DataArray[13]; // 40 15 攻击
        Creature_Defence              = DataArray[14]; // 41 16 防御
        Creature_CurHp                = DataArray[15]; // 42 17 当前生命
        Creature_MaxHp                = DataArray[16]; // 43 18 生命值上限
        Creature_Speed                = DataArray[17]; // 44 19 速度
        Creature_Fatal                = DataArray[18]; // 45 20 暴击
        Creature_Tenacity             = DataArray[19]; // 46 21 韧性
        Creature_Vampire              = DataArray[20]; // 47 22 吸血
        Creature_CutHurt              = DataArray[21]; // 48 23 减伤
        Creature_ReflexHurt           = DataArray[22]; // 49 24 反伤
        Creature_LgnoreDefense        = DataArray[23]; // 50 25 无视防御
        Creature_OutAttack            = DataArray[24]; // 51 26 卓越攻击
        Creature_AttackPerc           = DataArray[25]; // 52 27 攻击加成
        Creature_AppendHurt           = DataArray[26]; // 53 28 附加伤害
        Creature_RegainHp             = DataArray[27]; // 54 29 每秒回血
        Creature_Hit                  = DataArray[28]; // 55 30 命中
        Creature_Dodge                = DataArray[29]; // 56 31 闪避
        Creature_HatredIncrease       = DataArray[30]; // 57 32 仇恨产生速度
        Creature_Skill1               = DataArray[31]; // 58 33 当前技能1
        Creature_Skill2               = DataArray[32]; // 59 34 当前技能2
        Creature_Skill3               = DataArray[33]; // 60 35 当前技能3
        Creature_Skill4               = DataArray[34]; // 61 36 当前技能4
        Creature_Skill5               = DataArray[35]; // 62 37 当前技能5
        Creature_Skill6               = DataArray[36]; // 63 38 当前技能6

		}
	}
}