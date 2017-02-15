package tl.core.DataSources
{
    

    /// ʵض
    public class Attr
    {
        public static const Entity_UID                    :int =  0;   /// 实体UID
        public static const Item_ItemId                   :int =  1;   /// 物品ID
        public static const Item_Guid                     :int =  2;   /// 唯一标识
        public static const Item_BindFlags                :int =  3;   /// 绑定标志
        public static const Item_Num                      :int =  4;   /// 物品数量
        public static const Item_StrongLevel              :int =  5;   /// 强化等级
        public static const Item_MagicId                  :int =  6;   /// 阵纹ID
        public static const Item_Slots                    :int =  7;   /// 插槽数
        public static const Item_Slot1                    :int =  8;   /// 插槽1
        public static const Item_Slot2                    :int =  9;   /// 插槽2
        public static const Item_Slot3                    :int = 10;   /// 插槽3
        public static const Item_Slot4                    :int = 11;   /// 插槽4
        public static const Item_Slot5                    :int = 12;   /// 插槽5
        public static const Item_RecoinTimes              :int = 13;   /// 重铸次数
        public static const Item_RecoinForceAttack        :int = 14;   /// 重铸武力攻击
        public static const Item_RecoinSpellAttack        :int = 15;   /// 重铸法术攻击
        public static const Item_RecoinForceDefense       :int = 16;   /// 重铸武力防御
        public static const Item_RecoinSpellDefense       :int = 17;   /// 重铸法术防御
        public static const Item_RecoinPresent            :int = 18;   /// 重铸命中
        public static const Item_RecoinDodge              :int = 19;   /// 重铸闪避
        public static const Item_RecoinMaxHP              :int = 20;   /// 重铸生命值上限
        public static const Item_RecoinAttackFreq         :int = 21;   /// 重铸攻击速度(Attack frequency)
        public static const Item_RecoinResistPct          :int = 22;   /// 重铸格挡百分比*10000
        public static const Item_RecoinHitbackPct         :int = 23;   /// 重铸反击百分比*10000
        public static const Item_RecoinFatalAttackPct     :int = 24;   /// 重铸爆击(致命攻击)*10000
        public static const Item_RecoinMaxSP              :int = 25;   /// 重铸精气值上限
        public static const Item_Power                    :int = 26;   /// 能力值
        public static const Item_Expire                   :int = 27;   /// 到期时间
        public static const WEntity_SceneId               :int = 28;   /// 世界实体的场景ID
        public static const WEntity_PosX                  :int = 29;   /// 世界实体位置X
        public static const WEntity_PosY                  :int = 30;   /// 世界实体位置Y
        public static const Creature_Race                 :int = 31;   /// 种族
        public static const Creature_Vocation             :int = 32;   /// 职业
        public static const Creature_Gender               :int = 33;   /// 性别
        public static const Creature_Level                :int = 34;   /// 等级
        public static const Creature_Nation               :int = 35;   /// 国家
        public static const Creature_WizardId             :int = 36;   /// 精灵ID
        public static const Creature_MasterUID            :int = 37;   /// 主人ID
        public static const Creature_PracticeLevel        :int = 38;   /// 修仙等级
        public static const Creature_FightPower           :int = 39;   /// 战力
        public static const Creature_Attack               :int = 40;   /// 攻击
        public static const Creature_Defence              :int = 41;   /// 防御
        public static const Creature_CurHp                :int = 42;   /// 当前生命
        public static const Creature_MaxHp                :int = 43;   /// 生命值上限
        public static const Creature_Speed                :int = 44;   /// 速度
        public static const Creature_Fatal                :int = 45;   /// 暴击
        public static const Creature_Tenacity             :int = 46;   /// 韧性
        public static const Creature_Vampire              :int = 47;   /// 吸血
        public static const Creature_CutHurt              :int = 48;   /// 减伤
        public static const Creature_ReflexHurt           :int = 49;   /// 反伤
        public static const Creature_LgnoreDefense        :int = 50;   /// 无视防御
        public static const Creature_OutAttack            :int = 51;   /// 卓越攻击
        public static const Creature_AttackPerc           :int = 52;   /// 攻击加成
        public static const Creature_AppendHurt           :int = 53;   /// 附加伤害
        public static const Creature_RegainHp             :int = 54;   /// 每秒回血
        public static const Creature_Hit                  :int = 55;   /// 命中
        public static const Creature_Dodge                :int = 56;   /// 闪避
        public static const Creature_HatredIncrease       :int = 57;   /// 仇恨产生速度
        public static const Creature_Skill1               :int = 58;   /// 当前技能1
        public static const Creature_Skill2               :int = 59;   /// 当前技能2
        public static const Creature_Skill3               :int = 60;   /// 当前技能3
        public static const Creature_Skill4               :int = 61;   /// 当前技能4
        public static const Creature_Skill5               :int = 62;   /// 当前技能5
        public static const Creature_Skill6               :int = 63;   /// 当前技能6
        public static const Player_UserId                 :int = 64;   /// 帐号ID
        public static const Player_ActorId                :int = 65;   /// 角色数据库ID
        public static const Player_Exp                    :int = 66;   /// 经验(experience)
        public static const Player_CurSP                  :int = 67;   /// 精气值(Stamina Point)
        public static const Player_MaxSP                  :int = 68;   /// 精气值上限
        public static const Player_Credit                 :int = 69;   /// 声望
        public static const Player_Stamina                :int = 70;   /// 体力
        public static const Player_Flower                 :int = 71;   /// 鲜花
        public static const Player_QuestLevel             :int = 72;   /// 主任务级别
        public static const Player_StoryLevel             :int = 73;   /// 剧情级别
        public static const Player_BagSize                :int = 74;   /// 背包栏有效个数
        public static const Player_Pay                    :int = 75;   /// 充值
        public static const Player_Name                   :int = 76;   /// 角色名
        public static const Player_KinName                :int = 77;   /// 家族名
        public static const Player_Kin                    :int = 78;   /// 家族
        public static const Player_Skill                  :int = 79;   /// 技能
        public static const Player_Team                   :int = 80;   /// 队伍
        public static const Player_Camp                   :int = 81;   /// 阵营
        public static const Player_Right                  :int = 82;   /// 玩家权限
        public static const Player_Money                  :int = 83;   /// 元宝
        public static const Player_BindMoney              :int = 84;   /// 银两
        public static const Player_BakSceneId             :int = 85;   /// 备份的场景ID
        public static const Player_BakPosX                :int = 86;   /// 备份的位置X
        public static const Player_BakPosY                :int = 87;   /// 备份的位置Y
        public static const Player_Title                  :int = 88;   /// 当前称号
        public static const Player_Flags1                 :int = 89;   /// 标志1
        public static const Player_Flags2                 :int = 90;   /// 标志2
        public static const Player_Flags3                 :int = 91;   /// 标志3
        public static const GameObj_Type                  :int = 92;   /// 游戏对象类型
        public static const Portal_DestSceneId            :int = 93;   /// 传送门的目标场景
        public static const Portal_DestPortal             :int = 94;   /// 传送门的关联点
        public static const Monster_Saved                 :int = 95;   /// 怪物（保留字段）
        public static const Npc_Saved                     :int = 96;   /// NPC（保留字段）
        public static const Buddy_Saved                   :int = 97;   /// 伙伴（保留字段）


        public static const AttrN:Array = [
             0,    //  0. Entity_UID                    实体UID
             1,    //  1. Item_ItemId                   物品ID
             2,    //  2. Item_Guid                     唯一标识
             3,    //  3. Item_BindFlags                绑定标志
             4,    //  4. Item_Num                      物品数量
             5,    //  5. Item_StrongLevel              强化等级
             6,    //  6. Item_MagicId                  阵纹ID
             7,    //  7. Item_Slots                    插槽数
             8,    //  8. Item_Slot1                    插槽1
             9,    //  9. Item_Slot2                    插槽2
            10,    // 10. Item_Slot3                    插槽3
            11,    // 11. Item_Slot4                    插槽4
            12,    // 12. Item_Slot5                    插槽5
            13,    // 13. Item_RecoinTimes              重铸次数
            14,    // 14. Item_RecoinForceAttack        重铸武力攻击
            15,    // 15. Item_RecoinSpellAttack        重铸法术攻击
            16,    // 16. Item_RecoinForceDefense       重铸武力防御
            17,    // 17. Item_RecoinSpellDefense       重铸法术防御
            18,    // 18. Item_RecoinPresent            重铸命中
            19,    // 19. Item_RecoinDodge              重铸闪避
            20,    // 20. Item_RecoinMaxHP              重铸生命值上限
            21,    // 21. Item_RecoinAttackFreq         重铸攻击速度(Attack frequency)
            22,    // 22. Item_RecoinResistPct          重铸格挡百分比*10000
            23,    // 23. Item_RecoinHitbackPct         重铸反击百分比*10000
            24,    // 24. Item_RecoinFatalAttackPct     重铸爆击(致命攻击)*10000
            25,    // 25. Item_RecoinMaxSP              重铸精气值上限
            26,    // 26. Item_Power                    能力值
            27,    // 27. Item_Expire                   到期时间
             1,    // 28. WEntity_SceneId               世界实体的场景ID
             2,    // 29. WEntity_PosX                  世界实体位置X
             3,    // 30. WEntity_PosY                  世界实体位置Y
             4,    // 31. Creature_Race                 种族
             5,    // 32. Creature_Vocation             职业
             6,    // 33. Creature_Gender               性别
             7,    // 34. Creature_Level                等级
             8,    // 35. Creature_Nation               国家
             9,    // 36. Creature_WizardId             精灵ID
            10,    // 37. Creature_MasterUID            主人ID
            11,    // 38. Creature_PracticeLevel        修仙等级
            12,    // 39. Creature_FightPower           战力
            13,    // 40. Creature_Attack               攻击
            14,    // 41. Creature_Defence              防御
            15,    // 42. Creature_CurHp                当前生命
            16,    // 43. Creature_MaxHp                生命值上限
            17,    // 44. Creature_Speed                速度
            18,    // 45. Creature_Fatal                暴击
            19,    // 46. Creature_Tenacity             韧性
            20,    // 47. Creature_Vampire              吸血
            21,    // 48. Creature_CutHurt              减伤
            22,    // 49. Creature_ReflexHurt           反伤
            23,    // 50. Creature_LgnoreDefense        无视防御
            24,    // 51. Creature_OutAttack            卓越攻击
            25,    // 52. Creature_AttackPerc           攻击加成
            26,    // 53. Creature_AppendHurt           附加伤害
            27,    // 54. Creature_RegainHp             每秒回血
            28,    // 55. Creature_Hit                  命中
            29,    // 56. Creature_Dodge                闪避
            30,    // 57. Creature_HatredIncrease       仇恨产生速度
            31,    // 58. Creature_Skill1               当前技能1
            32,    // 59. Creature_Skill2               当前技能2
            33,    // 60. Creature_Skill3               当前技能3
            34,    // 61. Creature_Skill4               当前技能4
            35,    // 62. Creature_Skill5               当前技能5
            36,    // 63. Creature_Skill6               当前技能6
            37,    // 64. Player_UserId                 帐号ID
            38,    // 65. Player_ActorId                角色数据库ID
            39,    // 66. Player_Exp                    经验(experience)
            40,    // 67. Player_CurSP                  精气值(Stamina Point)
            41,    // 68. Player_MaxSP                  精气值上限
            42,    // 69. Player_Credit                 声望
            43,    // 70. Player_Stamina                体力
            44,    // 71. Player_Flower                 鲜花
            45,    // 72. Player_QuestLevel             主任务级别
            46,    // 73. Player_StoryLevel             剧情级别
            47,    // 74. Player_BagSize                背包栏有效个数
            48,    // 75. Player_Pay                    充值
            49,    // 76. Player_Name                   角色名
            50,    // 77. Player_KinName                家族名
            51,    // 78. Player_Kin                    家族
            52,    // 79. Player_Skill                  技能
            53,    // 80. Player_Team                   队伍
            54,    // 81. Player_Camp                   阵营
            55,    // 82. Player_Right                  玩家权限
            56,    // 83. Player_Money                  元宝
            57,    // 84. Player_BindMoney              银两
            58,    // 85. Player_BakSceneId             备份的场景ID
            59,    // 86. Player_BakPosX                备份的位置X
            60,    // 87. Player_BakPosY                备份的位置Y
            61,    // 88. Player_Title                  当前称号
            62,    // 89. Player_Flags1                 标志1
            63,    // 90. Player_Flags2                 标志2
            64,    // 91. Player_Flags3                 标志3
             4,    // 92. GameObj_Type                  游戏对象类型
             5,    // 93. Portal_DestSceneId            传送门的目标场景
             6,    // 94. Portal_DestPortal             传送门的关联点
            37,    // 95. Monster_Saved                 怪物（保留字段）
            37,    // 96. Npc_Saved                     NPC（保留字段）
            37     // 97. Buddy_Saved                   伙伴（保留字段）

        ];

        public static const AttrIdx:Array = [
             0,    //  0. Entity_UID                    实体UID
             2,    //  1. Item_ItemId                   物品ID
             3,    //  2. Item_Guid                     唯一标识
             5,    //  3. Item_BindFlags                绑定标志
             6,    //  4. Item_Num                      物品数量
             7,    //  5. Item_StrongLevel              强化等级
             8,    //  6. Item_MagicId                  阵纹ID
             9,    //  7. Item_Slots                    插槽数
            10,    //  8. Item_Slot1                    插槽1
            12,    //  9. Item_Slot2                    插槽2
            14,    // 10. Item_Slot3                    插槽3
            16,    // 11. Item_Slot4                    插槽4
            18,    // 12. Item_Slot5                    插槽5
            20,    // 13. Item_RecoinTimes              重铸次数
            21,    // 14. Item_RecoinForceAttack        重铸武力攻击
            22,    // 15. Item_RecoinSpellAttack        重铸法术攻击
            23,    // 16. Item_RecoinForceDefense       重铸武力防御
            24,    // 17. Item_RecoinSpellDefense       重铸法术防御
            25,    // 18. Item_RecoinPresent            重铸命中
            26,    // 19. Item_RecoinDodge              重铸闪避
            27,    // 20. Item_RecoinMaxHP              重铸生命值上限
            28,    // 21. Item_RecoinAttackFreq         重铸攻击速度(Attack frequency)
            29,    // 22. Item_RecoinResistPct          重铸格挡百分比*10000
            30,    // 23. Item_RecoinHitbackPct         重铸反击百分比*10000
            31,    // 24. Item_RecoinFatalAttackPct     重铸爆击(致命攻击)*10000
            32,    // 25. Item_RecoinMaxSP              重铸精气值上限
            33,    // 26. Item_Power                    能力值
            34,    // 27. Item_Expire                   到期时间
             2,    // 28. WEntity_SceneId               世界实体的场景ID
             3,    // 29. WEntity_PosX                  世界实体位置X
             4,    // 30. WEntity_PosY                  世界实体位置Y
             5,    // 31. Creature_Race                 种族
             6,    // 32. Creature_Vocation             职业
             7,    // 33. Creature_Gender               性别
             8,    // 34. Creature_Level                等级
             9,    // 35. Creature_Nation               国家
            10,    // 36. Creature_WizardId             精灵ID
            11,    // 37. Creature_MasterUID            主人ID
            13,    // 38. Creature_PracticeLevel        修仙等级
            14,    // 39. Creature_FightPower           战力
            15,    // 40. Creature_Attack               攻击
            16,    // 41. Creature_Defence              防御
            17,    // 42. Creature_CurHp                当前生命
            18,    // 43. Creature_MaxHp                生命值上限
            19,    // 44. Creature_Speed                速度
            20,    // 45. Creature_Fatal                暴击
            21,    // 46. Creature_Tenacity             韧性
            22,    // 47. Creature_Vampire              吸血
            23,    // 48. Creature_CutHurt              减伤
            24,    // 49. Creature_ReflexHurt           反伤
            25,    // 50. Creature_LgnoreDefense        无视防御
            26,    // 51. Creature_OutAttack            卓越攻击
            27,    // 52. Creature_AttackPerc           攻击加成
            28,    // 53. Creature_AppendHurt           附加伤害
            29,    // 54. Creature_RegainHp             每秒回血
            30,    // 55. Creature_Hit                  命中
            31,    // 56. Creature_Dodge                闪避
            32,    // 57. Creature_HatredIncrease       仇恨产生速度
            33,    // 58. Creature_Skill1               当前技能1
            34,    // 59. Creature_Skill2               当前技能2
            35,    // 60. Creature_Skill3               当前技能3
            36,    // 61. Creature_Skill4               当前技能4
            37,    // 62. Creature_Skill5               当前技能5
            38,    // 63. Creature_Skill6               当前技能6
            39,    // 64. Player_UserId                 帐号ID
            40,    // 65. Player_ActorId                角色数据库ID
            41,    // 66. Player_Exp                    经验(experience)
            42,    // 67. Player_CurSP                  精气值(Stamina Point)
            43,    // 68. Player_MaxSP                  精气值上限
            44,    // 69. Player_Credit                 声望
            45,    // 70. Player_Stamina                体力
            46,    // 71. Player_Flower                 鲜花
            47,    // 72. Player_QuestLevel             主任务级别
            48,    // 73. Player_StoryLevel             剧情级别
            49,    // 74. Player_BagSize                背包栏有效个数
            50,    // 75. Player_Pay                    充值
            51,    // 76. Player_Name                   角色名
            59,    // 77. Player_KinName                家族名
            67,    // 78. Player_Kin                    家族
            68,    // 79. Player_Skill                  技能
            69,    // 80. Player_Team                   队伍
            70,    // 81. Player_Camp                   阵营
            71,    // 82. Player_Right                  玩家权限
            72,    // 83. Player_Money                  元宝
            73,    // 84. Player_BindMoney              银两
            74,    // 85. Player_BakSceneId             备份的场景ID
            75,    // 86. Player_BakPosX                备份的位置X
            76,    // 87. Player_BakPosY                备份的位置Y
            77,    // 88. Player_Title                  当前称号
            78,    // 89. Player_Flags1                 标志1
            79,    // 90. Player_Flags2                 标志2
            80,    // 91. Player_Flags3                 标志3
             5,    // 92. GameObj_Type                  游戏对象类型
             6,    // 93. Portal_DestSceneId            传送门的目标场景
             7,    // 94. Portal_DestPortal             传送门的关联点
            39,    // 95. Monster_Saved                 怪物（保留字段）
            39,    // 96. Npc_Saved                     NPC（保留字段）
            39     // 97. Buddy_Saved                   伙伴（保留字段）

        ];

        public static const AttrType:Array = [
            "_Number" ,    //  0. Entity_UID                    实体UID
            "_uint"   ,    //  1. Item_ItemId                   物品ID
            "_Number" ,    //  2. Item_Guid                     唯一标识
            "_uint"   ,    //  3. Item_BindFlags                绑定标志
            "_uint"   ,    //  4. Item_Num                      物品数量
            "_uint"   ,    //  5. Item_StrongLevel              强化等级
            "_uint"   ,    //  6. Item_MagicId                  阵纹ID
            "_uint"   ,    //  7. Item_Slots                    插槽数
            "_Number" ,    //  8. Item_Slot1                    插槽1
            "_Number" ,    //  9. Item_Slot2                    插槽2
            "_Number" ,    // 10. Item_Slot3                    插槽3
            "_Number" ,    // 11. Item_Slot4                    插槽4
            "_Number" ,    // 12. Item_Slot5                    插槽5
            "_uint"   ,    // 13. Item_RecoinTimes              重铸次数
            "_uint"   ,    // 14. Item_RecoinForceAttack        重铸武力攻击
            "_uint"   ,    // 15. Item_RecoinSpellAttack        重铸法术攻击
            "_uint"   ,    // 16. Item_RecoinForceDefense       重铸武力防御
            "_uint"   ,    // 17. Item_RecoinSpellDefense       重铸法术防御
            "_uint"   ,    // 18. Item_RecoinPresent            重铸命中
            "_uint"   ,    // 19. Item_RecoinDodge              重铸闪避
            "_uint"   ,    // 20. Item_RecoinMaxHP              重铸生命值上限
            "_uint"   ,    // 21. Item_RecoinAttackFreq         重铸攻击速度(Attack frequency)
            "_uint"   ,    // 22. Item_RecoinResistPct          重铸格挡百分比*10000
            "_uint"   ,    // 23. Item_RecoinHitbackPct         重铸反击百分比*10000
            "_uint"   ,    // 24. Item_RecoinFatalAttackPct     重铸爆击(致命攻击)*10000
            "_uint"   ,    // 25. Item_RecoinMaxSP              重铸精气值上限
            "_uint"   ,    // 26. Item_Power                    能力值
            "_uint"   ,    // 27. Item_Expire                   到期时间
            "_uint"   ,    // 28. WEntity_SceneId               世界实体的场景ID
            "_uint"   ,    // 29. WEntity_PosX                  世界实体位置X
            "_uint"   ,    // 30. WEntity_PosY                  世界实体位置Y
            "_uint"   ,    // 31. Creature_Race                 种族
            "_uint"   ,    // 32. Creature_Vocation             职业
            "_uint"   ,    // 33. Creature_Gender               性别
            "_uint"   ,    // 34. Creature_Level                等级
            "_uint"   ,    // 35. Creature_Nation               国家
            "_uint"   ,    // 36. Creature_WizardId             精灵ID
            "_Number" ,    // 37. Creature_MasterUID            主人ID
            "_uint"   ,    // 38. Creature_PracticeLevel        修仙等级
            "_uint"   ,    // 39. Creature_FightPower           战力
            "_uint"   ,    // 40. Creature_Attack               攻击
            "_uint"   ,    // 41. Creature_Defence              防御
            "_uint"   ,    // 42. Creature_CurHp                当前生命
            "_uint"   ,    // 43. Creature_MaxHp                生命值上限
            "_uint"   ,    // 44. Creature_Speed                速度
            "_uint"   ,    // 45. Creature_Fatal                暴击
            "_uint"   ,    // 46. Creature_Tenacity             韧性
            "_uint"   ,    // 47. Creature_Vampire              吸血
            "_uint"   ,    // 48. Creature_CutHurt              减伤
            "_uint"   ,    // 49. Creature_ReflexHurt           反伤
            "_uint"   ,    // 50. Creature_LgnoreDefense        无视防御
            "_uint"   ,    // 51. Creature_OutAttack            卓越攻击
            "_uint"   ,    // 52. Creature_AttackPerc           攻击加成
            "_uint"   ,    // 53. Creature_AppendHurt           附加伤害
            "_uint"   ,    // 54. Creature_RegainHp             每秒回血
            "_uint"   ,    // 55. Creature_Hit                  命中
            "_uint"   ,    // 56. Creature_Dodge                闪避
            "_uint"   ,    // 57. Creature_HatredIncrease       仇恨产生速度
            "_uint"   ,    // 58. Creature_Skill1               当前技能1
            "_uint"   ,    // 59. Creature_Skill2               当前技能2
            "_uint"   ,    // 60. Creature_Skill3               当前技能3
            "_uint"   ,    // 61. Creature_Skill4               当前技能4
            "_uint"   ,    // 62. Creature_Skill5               当前技能5
            "_uint"   ,    // 63. Creature_Skill6               当前技能6
            "_uint"   ,    // 64. Player_UserId                 帐号ID
            "_uint"   ,    // 65. Player_ActorId                角色数据库ID
            "_uint"   ,    // 66. Player_Exp                    经验(experience)
            "_uint"   ,    // 67. Player_CurSP                  精气值(Stamina Point)
            "_uint"   ,    // 68. Player_MaxSP                  精气值上限
            "_uint"   ,    // 69. Player_Credit                 声望
            "_uint"   ,    // 70. Player_Stamina                体力
            "_uint"   ,    // 71. Player_Flower                 鲜花
            "_uint"   ,    // 72. Player_QuestLevel             主任务级别
            "_uint"   ,    // 73. Player_StoryLevel             剧情级别
            "_uint"   ,    // 74. Player_BagSize                背包栏有效个数
            "_uint"   ,    // 75. Player_Pay                    充值
            "_String" ,    // 76. Player_Name                   角色名
            "_String" ,    // 77. Player_KinName                家族名
            "_uint"   ,    // 78. Player_Kin                    家族
            "_uint"   ,    // 79. Player_Skill                  技能
            "_uint"   ,    // 80. Player_Team                   队伍
            "_uint"   ,    // 81. Player_Camp                   阵营
            "_uint"   ,    // 82. Player_Right                  玩家权限
            "_uint"   ,    // 83. Player_Money                  元宝
            "_uint"   ,    // 84. Player_BindMoney              银两
            "_uint"   ,    // 85. Player_BakSceneId             备份的场景ID
            "_uint"   ,    // 86. Player_BakPosX                备份的位置X
            "_uint"   ,    // 87. Player_BakPosY                备份的位置Y
            "_uint"   ,    // 88. Player_Title                  当前称号
            "_uint"   ,    // 89. Player_Flags1                 标志1
            "_uint"   ,    // 90. Player_Flags2                 标志2
            "_uint"   ,    // 91. Player_Flags3                 标志3
            "_uint"   ,    // 92. GameObj_Type                  游戏对象类型
            "_uint"   ,    // 93. Portal_DestSceneId            传送门的目标场景
            "_uint"   ,    // 94. Portal_DestPortal             传送门的关联点
            "_uint"   ,    // 95. Monster_Saved                 怪物（保留字段）
            "_uint"   ,    // 96. Npc_Saved                     NPC（保留字段）
            "_uint"        // 97. Buddy_Saved                   伙伴（保留字段）

        ];

        public static const AttrFlags:Array = [
            0x00001002,    //  0. Entity_UID                    实体UID
            0x00001001,    //  1. Item_ItemId                   物品ID
            0x00001001,    //  2. Item_Guid                     唯一标识
            0x00000001,    //  3. Item_BindFlags                绑定标志
            0x00000101,    //  4. Item_Num                      物品数量
            0x00000101,    //  5. Item_StrongLevel              强化等级
            0x00000001,    //  6. Item_MagicId                  阵纹ID
            0x00000001,    //  7. Item_Slots                    插槽数
            0x00000001,    //  8. Item_Slot1                    插槽1
            0x00000001,    //  9. Item_Slot2                    插槽2
            0x00000001,    // 10. Item_Slot3                    插槽3
            0x00000001,    // 11. Item_Slot4                    插槽4
            0x00000001,    // 12. Item_Slot5                    插槽5
            0x00000001,    // 13. Item_RecoinTimes              重铸次数
            0x00000001,    // 14. Item_RecoinForceAttack        重铸武力攻击
            0x00000001,    // 15. Item_RecoinSpellAttack        重铸法术攻击
            0x00000001,    // 16. Item_RecoinForceDefense       重铸武力防御
            0x00000001,    // 17. Item_RecoinSpellDefense       重铸法术防御
            0x00000001,    // 18. Item_RecoinPresent            重铸命中
            0x00000001,    // 19. Item_RecoinDodge              重铸闪避
            0x00000001,    // 20. Item_RecoinMaxHP              重铸生命值上限
            0x00000001,    // 21. Item_RecoinAttackFreq         重铸攻击速度(Attack frequency)
            0x00000001,    // 22. Item_RecoinResistPct          重铸格挡百分比*10000
            0x00000001,    // 23. Item_RecoinHitbackPct         重铸反击百分比*10000
            0x00000001,    // 24. Item_RecoinFatalAttackPct     重铸爆击(致命攻击)*10000
            0x00000001,    // 25. Item_RecoinMaxSP              重铸精气值上限
            0x00000001,    // 26. Item_Power                    能力值
            0x00000001,    // 27. Item_Expire                   到期时间
            0x00000001,    // 28. WEntity_SceneId               世界实体的场景ID
            0x00000101,    // 29. WEntity_PosX                  世界实体位置X
            0x00000101,    // 30. WEntity_PosY                  世界实体位置Y
            0x00001002,    // 31. Creature_Race                 种族
            0x00001002,    // 32. Creature_Vocation             职业
            0x00001002,    // 33. Creature_Gender               性别
            0x00000102,    // 34. Creature_Level                等级
            0x00001002,    // 35. Creature_Nation               国家
            0x00000002,    // 36. Creature_WizardId             精灵ID
            0x00000002,    // 37. Creature_MasterUID            主人ID
            0x00000102,    // 38. Creature_PracticeLevel        修仙等级
            0x00000101,    // 39. Creature_FightPower           战力
            0x00000101,    // 40. Creature_Attack               攻击
            0x00000101,    // 41. Creature_Defence              防御
            0x00000111,    // 42. Creature_CurHp                当前生命
            0x00000121,    // 43. Creature_MaxHp                生命值上限
            0x00000101,    // 44. Creature_Speed                速度
            0x00000101,    // 45. Creature_Fatal                暴击
            0x00000101,    // 46. Creature_Tenacity             韧性
            0x00000101,    // 47. Creature_Vampire              吸血
            0x00000101,    // 48. Creature_CutHurt              减伤
            0x00000101,    // 49. Creature_ReflexHurt           反伤
            0x00000101,    // 50. Creature_LgnoreDefense        无视防御
            0x00000101,    // 51. Creature_OutAttack            卓越攻击
            0x00000101,    // 52. Creature_AttackPerc           攻击加成
            0x00000101,    // 53. Creature_AppendHurt           附加伤害
            0x00000101,    // 54. Creature_RegainHp             每秒回血
            0x00000100,    // 55. Creature_Hit                  命中
            0x00000100,    // 56. Creature_Dodge                闪避
            0x00000100,    // 57. Creature_HatredIncrease       仇恨产生速度
            0x00000102,    // 58. Creature_Skill1               当前技能1
            0x00000102,    // 59. Creature_Skill2               当前技能2
            0x00000102,    // 60. Creature_Skill3               当前技能3
            0x00000102,    // 61. Creature_Skill4               当前技能4
            0x00000102,    // 62. Creature_Skill5               当前技能5
            0x00000102,    // 63. Creature_Skill6               当前技能6
            0x00001001,    // 64. Player_UserId                 帐号ID
            0x00001002,    // 65. Player_ActorId                角色数据库ID
            0x00001101,    // 66. Player_Exp                    经验(experience)
            0x00001111,    // 67. Player_CurSP                  精气值(Stamina Point)
            0x00000121,    // 68. Player_MaxSP                  精气值上限
            0x00001101,    // 69. Player_Credit                 声望
            0x00000101,    // 70. Player_Stamina                体力
            0x00000001,    // 71. Player_Flower                 鲜花
            0x00000101,    // 72. Player_QuestLevel             主任务级别
            0x00000101,    // 73. Player_StoryLevel             剧情级别
            0x00000101,    // 74. Player_BagSize                背包栏有效个数
            0x00001102,    // 75. Player_Pay                    充值
            0x00001002,    // 76. Player_Name                   角色名
            0x00001002,    // 77. Player_KinName                家族名
            0x00000002,    // 78. Player_Kin                    家族
            0x00000002,    // 79. Player_Skill                  技能
            0x00000002,    // 80. Player_Team                   队伍
            0x00000002,    // 81. Player_Camp                   阵营
            0x00001001,    // 82. Player_Right                  玩家权限
            0x00001101,    // 83. Player_Money                  元宝
            0x00001101,    // 84. Player_BindMoney              银两
            0x00000001,    // 85. Player_BakSceneId             备份的场景ID
            0x00000101,    // 86. Player_BakPosX                备份的位置X
            0x00000101,    // 87. Player_BakPosY                备份的位置Y
            0x00000102,    // 88. Player_Title                  当前称号
            0x00000001,    // 89. Player_Flags1                 标志1
            0x00000001,    // 90. Player_Flags2                 标志2
            0x00000001,    // 91. Player_Flags3                 标志3
            0x00001002,    // 92. GameObj_Type                  游戏对象类型
            0x00001002,    // 93. Portal_DestSceneId            传送门的目标场景
            0x00001002,    // 94. Portal_DestPortal             传送门的关联点
            0x00001002,    // 95. Monster_Saved                 怪物（保留字段）
            0x00001002,    // 96. Npc_Saved                     NPC（保留字段）
            0x00001002     // 97. Buddy_Saved                   伙伴（保留字段）

        ];
    }
}

