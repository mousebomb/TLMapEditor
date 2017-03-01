/**
 * Created by gaord on 2016/12/26.
 */
package tl.core.role.model
{
	public class RoleVO
	{

		/** 配置表内的数据 */
		public var csvVO:CsvRoleVO ;

		public function RoleVO()
		{
		}

		public var x :Number;
		public var z :Number;

		/**浮空*/
		private var _float:Number = 0.0;


		public var Player_UserId                 : uint      ;     // 125 70 Player_UserId                  帐号ID
		public var Player_ActorId                : uint      ;     // 126 71 Player_ActorId                 角色ID
		public var Player_Exp                    : Number     ;     // 127 72 Player_Exp                     经验
		public var Player_Stamina                : uint      ;     // 128 73 Player_Stamina                 体力
		public var Player_MaxStamina             : uint      ;     // 129 74 Player_MaxStamina              体力上限
		public var Player_Credit                 : uint      ;     // 130 75 Player_Credit                  声望(荣誉)
		public var Player_ArmyLevel              : uint      ;     // 131 76 Player_ArmyLevel               军衔
		public var Player_CreditMaximum          : uint      ;     // 132 77 Player_CreditMaximum           声望(荣誉)的历史最大值
		public var Player_QuestLevel             : uint      ;     // 133 78 Player_QuestLevel              主任务级别
		public var Player_WeaponStrongLv         : uint      ;     // 134 79 Player_WeaponStrongLv          武器强化等级
		public var Player_BagSize                : uint      ;     // 135 80 Player_BagSize                 背包栏有效个数
		public var Player_Name                   : String    ;     // 136 81 Player_Name                    角色名
		public var Player_VipCard                : uint      ;     // 137 97 Player_VipCard                 VIP卡
		public var Player_Vip                    : uint      ;     // 138 98 Player_Vip                     VIP等级
		public var Player_VipExp                 : uint      ;     // 139 99 Player_VipExp                  VIP经验值
		public var Player_Exploit                : uint      ;     // 140 100 Player_Exploit                 功勋
		public var Player_CurWorldId             : uint      ;     // 141 101 Player_CurWorldId              所在世界ID
		public var Player_Right                  : uint      ;     // 142 102 Player_Right                   玩家权限
		public var Player_Pay                    : uint      ;     // 143 103 Player_Pay                     充值总数
		public var Player_Money                  : uint      ;     // 144 104 Player_Money                   元宝(魔晶)
		public var Player_Gold                   : Number      ;     // 145 105 Player_Gold                    银两(金币)
		public var Player_GiftGold               : uint      ;     // 146 106 Player_GiftGold                礼券
		public var Player_BakSceneId             : uint      ;     // 147 107 Player_BakSceneId              备份的场景ID
		public var Player_BakPosX                : uint      ;     // 148 108 Player_BakPosX                 备份的位置X
		public var Player_BakPosY                : uint      ;     // 149 109 Player_BakPosY                 备份的位置Y
		public var Player_Title                  : uint      ;     // 150 110 Player_Title                   当前称号
		public var Player_Flags1                 : uint      ;     // 151 111 Player_Flags1                  标志1
		public var Player_Flags2                 : uint      ;     // 152 112 Player_Flags2                  标志2
		public var Player_Flags3                 : uint      ;     // 153 113 Player_Flags3                  标志3
		public var Player_WeaponLeft             : uint      ;     // 154 114 Player_WeaponLeft              左手武器
		public var Player_WeaponRight            : uint      ;     // 155 115 Player_WeaponRight             右手武器
		public var Player_Fetch                  : uint      ;     // 156 116 Player_Fetch                   提取元宝数量
		public var Player_HBIntegral             : uint      ;     // 157 117 Player_HBIntegral              图鉴积分
		public var Player_PKModle                : uint      ;     // 158 118 Player_PKModle                 PK模式
		public var Player_WeaponSoulLvId         : uint      ;     // 159 119 Player_WeaponSoulLvId          当前灌入的器魂等级ID
		public var Player_Integral               : uint      ;     // 160 120 Player_Integral                积分(捕鱼兑换)
		public var Player_Energy                 : uint      ;     // 161 121 Player_Energy                  能量值
		public var Player_StallNickName          : String    ;     // 162 122 Player_StallNickName           摆摊昵称
		/**浮空*/
		public function get float():Number
		{
			return _float;
		}

		public function set float(value:Number):void
		{
			_float = value;
		}
	}
}
