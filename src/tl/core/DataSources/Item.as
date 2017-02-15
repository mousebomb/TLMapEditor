package tl.core.DataSources
{
	import flash.utils.ByteArray;

	import tl.frameworks.model.CSV.SGCsvManager;

	public class Item extends Entity
	{
		public var AttrList:Array = [
			
			0,     // Entity_UID                     实体UID
			1,     // Item_ItemId                    物品ID
			2,     // Item_Guid                      唯一标识
			3,     // Item_BindFlags                 绑定标志
			4,     // Item_Num                       物品数量
			5,     // Item_Slots                     插槽数
			6,     // Item_Slot1                     插槽1
			7,     // Item_Slot2                     插槽2
			8,     // Item_Slot3                     插槽3
			9,     // Item_Slot4                     插槽4
			10,     // Item_Attack                    (基本)攻击
			11,     // Item_Defense                   (基本)防御
			12,     // Item_CurHp                     (基本)生命值
			13,     // Item_Crit                      (基本)暴击
			14,     // Item_Tenacity                  (基本)韧性
			15,     // Item_AppendHurt                (基本)附加伤害
			16,     // Item_OutAttack                 (基本)卓越攻击
			17,     // Item_AttackPerc                (基本)攻击加成
			18,     // Item_LgnoreDefense             (基本)无视防御
			19,     // Item_AbsorbHurt                (基本)吸收伤害
			20,     // Item_DefenseSuccess            (基本)防御成功率
			21,     // Item_DefensePerc               (基本)防御加成
			22,     // Item_OutHurtPerc               (基本)减伤比例
			23,     // Item_Vampire                   (基本)吸血 
			24,     // Item_Power                     能力值
			25,     // Item_Expire                    到期时间
			26,     // Item_StrongLevel               强化等级
			27,     // Item_StrongAttack              (强化)攻击
			28,     // Item_StrongDefense             (强化)防御
			29,     // Item_StrongCurHp               (强化)生命值
			30,     // Item_StrongCrit                (强化)暴击
			31,     // Item_StrongTenacity            (强化)韧性
			32,     // Item_StrongAppendHurt          (强化)附加伤害
			33,     // Item_StrongOutAttack           (强化)卓越攻击
			34,     // Item_StrongAttackPerc          (强化)攻击加成
			35,     // Item_StrongLgnoreDefense       (强化)无视防御
			36,     // Item_StrongAbsorbHurt          (强化)吸收伤害
			37,     // Item_StrongDefenseSuccess      (强化)防御成功率
			38,     // Item_StrongDefensePerc         (强化)防御加成
			39,     // Item_StrongOutHurtPerc         (强化)减伤比例
			40,     // Item_StrongVampire             (强化)吸血 
			41,     // Item_RecoinTimes               重铸次数
			42,     // Item_RecoinAttack              (重铸)攻击
			43,     // Item_RecoinDefense             (重铸)防御
			44,     // Item_RecoinCurHp               (重铸)生命值
			45,     // Item_RecoinCrit                (重铸)暴击
			46,     // Item_RecoinTenacity            (重铸)韧性
			47,     // Item_RecoinAppendHurt          (重铸)附加伤害
			48,     // Item_RecoinOutAttack           (重铸)卓越攻击
			49,     // Item_RecoinAttackPerc          (重铸)攻击加成
			50,     // Item_RecoinLgnoreDefense       (重铸)无视防御
			51,     // Item_RecoinAbsorbHurt          (重铸)吸收伤害
			52,     // Item_RecoinDefenseSuccess      (重铸)防御成功率
			53,     // Item_RecoinDefensePerc         (重铸)防御加成
			54,     // Item_RecoinOutHurtPerc         (重铸)减伤比例
			55,     // Item_RecoinVampire             (重铸)吸血 
			56,     // Item_IdentifyTimes             鉴定次数
			57,     // Item_IdentifyAttack            (鉴定)攻击
			58,     // Item_IdentifyDefense           (鉴定)防御
			59,     // Item_IdentifyCurHp             (鉴定)生命值
			60,     // Item_IdentifyCrit              (鉴定)暴击
			61,     // Item_IdentifyTenacity          (鉴定)韧性
			62,     // Item_IdentifyAppendHurt        (鉴定)附加伤害
			63,     // Item_IdentifyOutAttack         (鉴定)卓越攻击
			64,     // Item_IdentifyAttackPerc        (鉴定)攻击加成
			65,     // Item_IdentifyLgnoreDefense     (鉴定)无视防御
			66,     // Item_IdentifyAbsorbHurt        (鉴定)吸收伤害
			67,     // Item_IdentifyDefenseSuccess    (鉴定)防御成功率
			68,     // Item_IdentifyDefensePerc       (鉴定)防御加成
			69,     // Item_IdentifyOutHurtPerc       (鉴定)减伤比例
			70,     // Item_IdentifyVampire           (鉴定)吸血
			71,     // Item_Bless                     祝福值
			
		];
		
		//----------------客户端刷新的数据-----------------------------------------------------
		public var args:Array;
		public var Item_Id:String;//#物品编号
		public var Item_IconPack:String;//图标资源包
		public var Item_IconName:String;//图标类名
		public var Item_ModelName:String;//模型名
		public var Item_Name:String;//物品名称
		public var Item_Type:int;//物品类型
		public var Item_ItemExp:String;//物品说明
		public var Item_OutputExp:String;//产出说明
		public var Item_UseExp:String;//使用说明
		public var Item_LevelLimit:int;//等级限制
		public var Item_JobLimit:int;//职业限制
		public var Item_Bind:int;//绑定
		public var Item_Position:int;//穿戴位置
		public var Item_OverlapCount:int;//叠加上限
		public var Item_Quality:int;//物品品质
		public var Item_StrongLv:int;//强化等级
		public var Item_GrooveNum:int;//凹槽数量
		public var Item_SkillId:int;//技能ID
		public var Item_SetList:Array;//套装ID列表
		public var Item_ItemValue:int;//物品价值
		public var Item_SellPrice:int;//出售价格
		public var Item_ExpiredTime:int;//过期时间
		public var Item_PrivateData:Array;//私有数据
		public var Item_EmbedData:Array;//镶嵌数据
		public var Attack:int;//攻击
		public var Defense:int;//防御
		public var CurHp:int;//生命值
		public var Crit:int;//暴击
		public var Tenacity:int;//韧性
		public var AppendHurt:Array;//附加伤害
		public var OutAttack:Array;//卓越攻击
		public var AttackPerc:Array;//攻击加成
		public var LgnoreDefense:Array;//无视防御
		public var AbsorbHurt:Array;//吸收伤害
		public var DefenseSuccess:Array;//防御成功率
		public var DefensePerc:Array;//防御加成
		public var OutHurtPerc:Array;//减伤比例
		public var Vampire:Array;//吸血
		public var Gemrank:int ;//宝石等级
		public var Idx:int;    //背包位置
		
		
		//----------------服务端刷新的数据-----------------------------------------------------
		public var Item_ItemId                   : uint      ;     //  1  2 Item_ItemId                    物品ID
		public var Item_Guid                     : Number    ;     //  2  3 Item_Guid                      唯一标识
		public var Item_BindFlags                : uint      ;     //  3  5 Item_BindFlags                 绑定标志
		public var Item_Num                      : uint      ;     //  4  6 Item_Num                       物品数量
		public var Item_Slots                    : uint      ;     //  5  7 Item_Slots                     插槽数
		public var Item_Slot1                    : Number    ;     //  6  8 Item_Slot1                     插槽1
		public var Item_Slot2                    : Number    ;     //  7 10 Item_Slot2                     插槽2
		public var Item_Slot3                    : Number    ;     //  8 12 Item_Slot3                     插槽3
		public var Item_Slot4                    : Number    ;     //  9 14 Item_Slot4                     插槽4
		public var Item_Attack                   : uint      ;     // 10 16 Item_Attack                    (基本)攻击
		public var Item_Defense                  : uint      ;     // 11 17 Item_Defense                   (基本)防御
		public var Item_CurHp                    : uint      ;     // 12 18 Item_CurHp                     (基本)生命值
		public var Item_Crit                     : uint      ;     // 13 19 Item_Crit                      (基本)暴击
		public var Item_Tenacity                 : uint      ;     // 14 20 Item_Tenacity                  (基本)韧性
		public var Item_AppendHurt               : uint      ;     // 15 21 Item_AppendHurt                (基本)附加伤害
		public var Item_OutAttack                : uint      ;     // 16 22 Item_OutAttack                 (基本)卓越攻击
		public var Item_AttackPerc               : uint      ;     // 17 23 Item_AttackPerc                (基本)攻击加成
		public var Item_LgnoreDefense            : uint      ;     // 18 24 Item_LgnoreDefense             (基本)无视防御
		public var Item_AbsorbHurt               : uint      ;     // 19 25 Item_AbsorbHurt                (基本)吸收伤害
		public var Item_DefenseSuccess           : uint      ;     // 20 26 Item_DefenseSuccess            (基本)防御成功率
		public var Item_DefensePerc              : uint      ;     // 21 27 Item_DefensePerc               (基本)防御加成
		public var Item_OutHurtPerc              : uint      ;     // 22 28 Item_OutHurtPerc               (基本)减伤比例
		public var Item_Vampire                  : uint      ;     // 23 29 Item_Vampire                   (基本)吸血 
		public var Item_Power                    : uint      ;     // 24 30 Item_Power                     能力值
		public var Item_Expire                   : uint      ;     // 25 31 Item_Expire                    到期时间
		public var Item_StrongLevel              : uint      ;     // 26 32 Item_StrongLevel               强化等级
		public var Item_StrongAttack             : uint      ;     // 27 33 Item_StrongAttack              (强化)攻击
		public var Item_StrongDefense            : uint      ;     // 28 34 Item_StrongDefense             (强化)防御
		public var Item_StrongCurHp              : uint      ;     // 29 35 Item_StrongCurHp               (强化)生命值
		public var Item_StrongCrit               : uint      ;     // 30 36 Item_StrongCrit                (强化)暴击
		public var Item_StrongTenacity           : uint      ;     // 31 37 Item_StrongTenacity            (强化)韧性
		public var Item_StrongAppendHurt         : uint      ;     // 32 38 Item_StrongAppendHurt          (强化)附加伤害
		public var Item_StrongOutAttack          : uint      ;     // 33 39 Item_StrongOutAttack           (强化)卓越攻击
		public var Item_StrongAttackPerc         : uint      ;     // 34 40 Item_StrongAttackPerc          (强化)攻击加成
		public var Item_StrongLgnoreDefense      : uint      ;     // 35 41 Item_StrongLgnoreDefense       (强化)无视防御
		public var Item_StrongAbsorbHurt         : uint      ;     // 36 42 Item_StrongAbsorbHurt          (强化)吸收伤害
		public var Item_StrongDefenseSuccess     : uint      ;     // 37 43 Item_StrongDefenseSuccess      (强化)防御成功率
		public var Item_StrongDefensePerc        : uint      ;     // 38 44 Item_StrongDefensePerc         (强化)防御加成
		public var Item_StrongOutHurtPerc        : uint      ;     // 39 45 Item_StrongOutHurtPerc         (强化)减伤比例
		public var Item_StrongVampire            : uint      ;     // 40 46 Item_StrongVampire             (强化)吸血 
		public var Item_RecoinTimes              : uint      ;     // 41 47 Item_RecoinTimes               重铸次数
		public var Item_RecoinAttack             : uint      ;     // 42 48 Item_RecoinAttack              (重铸)攻击
		public var Item_RecoinDefense            : uint      ;     // 43 49 Item_RecoinDefense             (重铸)防御
		public var Item_RecoinCurHp              : uint      ;     // 44 50 Item_RecoinCurHp               (重铸)生命值
		public var Item_RecoinCrit               : uint      ;     // 45 51 Item_RecoinCrit                (重铸)暴击
		public var Item_RecoinTenacity           : uint      ;     // 46 52 Item_RecoinTenacity            (重铸)韧性
		public var Item_RecoinAppendHurt         : uint      ;     // 47 53 Item_RecoinAppendHurt          (重铸)附加伤害
		public var Item_RecoinOutAttack          : uint      ;     // 48 54 Item_RecoinOutAttack           (重铸)卓越攻击
		public var Item_RecoinAttackPerc         : uint      ;     // 49 55 Item_RecoinAttackPerc          (重铸)攻击加成
		public var Item_RecoinLgnoreDefense      : uint      ;     // 50 56 Item_RecoinLgnoreDefense       (重铸)无视防御
		public var Item_RecoinAbsorbHurt         : uint      ;     // 51 57 Item_RecoinAbsorbHurt          (重铸)吸收伤害
		public var Item_RecoinDefenseSuccess     : uint      ;     // 52 58 Item_RecoinDefenseSuccess      (重铸)防御成功率
		public var Item_RecoinDefensePerc        : uint      ;     // 53 59 Item_RecoinDefensePerc         (重铸)防御加成
		public var Item_RecoinOutHurtPerc        : uint      ;     // 54 60 Item_RecoinOutHurtPerc         (重铸)减伤比例
		public var Item_RecoinVampire            : uint      ;     // 55 61 Item_RecoinVampire             (重铸)吸血 
		public var Item_IdentifyTimes            : uint      ;     // 56 62 Item_IdentifyTimes             鉴定次数
		public var Item_IdentifyAttack           : uint      ;     // 57 63 Item_IdentifyAttack            (鉴定)攻击
		public var Item_IdentifyDefense          : uint      ;     // 58 64 Item_IdentifyDefense           (鉴定)防御
		public var Item_IdentifyCurHp            : uint      ;     // 59 65 Item_IdentifyCurHp             (鉴定)生命值
		public var Item_IdentifyCrit             : uint      ;     // 60 66 Item_IdentifyCrit              (鉴定)暴击
		public var Item_IdentifyTenacity         : uint      ;     // 61 67 Item_IdentifyTenacity          (鉴定)韧性
		public var Item_IdentifyAppendHurt       : uint      ;     // 62 68 Item_IdentifyAppendHurt        (鉴定)附加伤害
		public var Item_IdentifyOutAttack        : uint      ;     // 63 69 Item_IdentifyOutAttack         (鉴定)卓越攻击
		public var Item_IdentifyAttackPerc       : uint      ;     // 64 70 Item_IdentifyAttackPerc        (鉴定)攻击加成
		public var Item_IdentifyLgnoreDefense    : uint      ;     // 65 71 Item_IdentifyLgnoreDefense     (鉴定)无视防御
		public var Item_IdentifyAbsorbHurt       : uint      ;     // 66 72 Item_IdentifyAbsorbHurt        (鉴定)吸收伤害
		public var Item_IdentifyDefenseSuccess   : uint      ;     // 67 73 Item_IdentifyDefenseSuccess    (鉴定)防御成功率
		public var Item_IdentifyDefensePerc      : uint      ;     // 68 74 Item_IdentifyDefensePerc       (鉴定)防御加成
		public var Item_IdentifyOutHurtPerc      : uint      ;     // 69 75 Item_IdentifyOutHurtPerc       (鉴定)减伤比例
		public var Item_IdentifyVampire          : uint      ;     // 70 76 Item_IdentifyVampire           (鉴定)吸血
		public var Item_Bless                    : uint      ;     // 71 77 Item_Bless                     祝福值
		
		
		
		public function Item()
		{
		}
		public function RefreshItem(data:ByteArray):void{
			if(data!=null){
				this.RefreshEntity(data,AttrList);			
				Item_ItemId                   = DataArray[ 1]; //  1  2 物品ID
				Item_Guid                     = DataArray[ 2]; //  2  3 唯一标识
				Item_BindFlags                = DataArray[ 3]; //  3  5 绑定标志
				Item_Num                      = DataArray[ 4]; //  4  6 物品数量
				Item_Slots                    = DataArray[ 5]; //  5  7 插槽数
				Item_Slot1                    = DataArray[ 6]; //  6  8 插槽1
				Item_Slot2                    = DataArray[ 7]; //  7 10 插槽2
				Item_Slot3                    = DataArray[ 8]; //  8 12 插槽3
				Item_Slot4                    = DataArray[ 9]; //  9 14 插槽4
				Item_Attack                   = DataArray[10]; // 10 16 (基本)攻击
				Item_Defense                  = DataArray[11]; // 11 17 (基本)防御
				Item_CurHp                    = DataArray[12]; // 12 18 (基本)生命值
				Item_Crit                     = DataArray[13]; // 13 19 (基本)暴击
				Item_Tenacity                 = DataArray[14]; // 14 20 (基本)韧性
				Item_AppendHurt               = DataArray[15]; // 15 21 (基本)附加伤害
				Item_OutAttack                = DataArray[16]; // 16 22 (基本)卓越攻击
				Item_AttackPerc               = DataArray[17]; // 17 23 (基本)攻击加成
				Item_LgnoreDefense            = DataArray[18]; // 18 24 (基本)无视防御
				Item_AbsorbHurt               = DataArray[19]; // 19 25 (基本)吸收伤害
				Item_DefenseSuccess           = DataArray[20]; // 20 26 (基本)防御成功率
				Item_DefensePerc              = DataArray[21]; // 21 27 (基本)防御加成
				Item_OutHurtPerc              = DataArray[22]; // 22 28 (基本)减伤比例
				Item_Vampire                  = DataArray[23]; // 23 29 (基本)吸血 
				Item_Power                    = DataArray[24]; // 24 30 能力值
				Item_Expire                   = DataArray[25]; // 25 31 到期时间
				Item_StrongLevel              = DataArray[26]; // 26 32 强化等级
				Item_StrongAttack             = DataArray[27]; // 27 33 (强化)攻击
				Item_StrongDefense            = DataArray[28]; // 28 34 (强化)防御
				Item_StrongCurHp              = DataArray[29]; // 29 35 (强化)生命值
				Item_StrongCrit               = DataArray[30]; // 30 36 (强化)暴击
				Item_StrongTenacity           = DataArray[31]; // 31 37 (强化)韧性
				Item_StrongAppendHurt         = DataArray[32]; // 32 38 (强化)附加伤害
				Item_StrongOutAttack          = DataArray[33]; // 33 39 (强化)卓越攻击
				Item_StrongAttackPerc         = DataArray[34]; // 34 40 (强化)攻击加成
				Item_StrongLgnoreDefense      = DataArray[35]; // 35 41 (强化)无视防御
				Item_StrongAbsorbHurt         = DataArray[36]; // 36 42 (强化)吸收伤害
				Item_StrongDefenseSuccess     = DataArray[37]; // 37 43 (强化)防御成功率
				Item_StrongDefensePerc        = DataArray[38]; // 38 44 (强化)防御加成
				Item_StrongOutHurtPerc        = DataArray[39]; // 39 45 (强化)减伤比例
				Item_StrongVampire            = DataArray[40]; // 40 46 (强化)吸血 
				Item_RecoinTimes              = DataArray[41]; // 41 47 重铸次数
				Item_RecoinAttack             = DataArray[42]; // 42 48 (重铸)攻击
				Item_RecoinDefense            = DataArray[43]; // 43 49 (重铸)防御
				Item_RecoinCurHp              = DataArray[44]; // 44 50 (重铸)生命值
				Item_RecoinCrit               = DataArray[45]; // 45 51 (重铸)暴击
				Item_RecoinTenacity           = DataArray[46]; // 46 52 (重铸)韧性
				Item_RecoinAppendHurt         = DataArray[47]; // 47 53 (重铸)附加伤害
				Item_RecoinOutAttack          = DataArray[48]; // 48 54 (重铸)卓越攻击
				Item_RecoinAttackPerc         = DataArray[49]; // 49 55 (重铸)攻击加成
				Item_RecoinLgnoreDefense      = DataArray[50]; // 50 56 (重铸)无视防御
				Item_RecoinAbsorbHurt         = DataArray[51]; // 51 57 (重铸)吸收伤害
				Item_RecoinDefenseSuccess     = DataArray[52]; // 52 58 (重铸)防御成功率
				Item_RecoinDefensePerc        = DataArray[53]; // 53 59 (重铸)防御加成
				Item_RecoinOutHurtPerc        = DataArray[54]; // 54 60 (重铸)减伤比例
				Item_RecoinVampire            = DataArray[55]; // 55 61 (重铸)吸血 
				Item_IdentifyTimes            = DataArray[56]; // 56 62 鉴定次数
				Item_IdentifyAttack           = DataArray[57]; // 57 63 (鉴定)攻击
				Item_IdentifyDefense          = DataArray[58]; // 58 64 (鉴定)防御
				Item_IdentifyCurHp            = DataArray[59]; // 59 65 (鉴定)生命值
				Item_IdentifyCrit             = DataArray[60]; // 60 66 (鉴定)暴击
				Item_IdentifyTenacity         = DataArray[61]; // 61 67 (鉴定)韧性
				Item_IdentifyAppendHurt       = DataArray[62]; // 62 68 (鉴定)附加伤害
				Item_IdentifyOutAttack        = DataArray[63]; // 63 69 (鉴定)卓越攻击
				Item_IdentifyAttackPerc       = DataArray[64]; // 64 70 (鉴定)攻击加成
				Item_IdentifyLgnoreDefense    = DataArray[65]; // 65 71 (鉴定)无视防御
				Item_IdentifyAbsorbHurt       = DataArray[66]; // 66 72 (鉴定)吸收伤害
				Item_IdentifyDefenseSuccess   = DataArray[67]; // 67 73 (鉴定)防御成功率
				Item_IdentifyDefensePerc      = DataArray[68]; // 68 74 (鉴定)防御加成
				Item_IdentifyOutHurtPerc      = DataArray[69]; // 69 75 (鉴定)减伤比例
				Item_IdentifyVampire          = DataArray[70]; // 70 76 (鉴定)吸血
				Item_Bless                    = DataArray[71]; // 71 77 祝福值
				
			}
			
			RefreshItemById(Item_ItemId.toString(),false);
		}
		
		public function RefreshItemById(itemId:String, flg:Boolean = true):void{
			args=SGCsvManager.getInstance().table_item.FindRow(itemId);
			if(args == null) return;
			Item_Id=args[0];//#物品编号
			Item_IconPack=args[1];//图标资源包
			Item_IconName=args[2];//图标类名
			Item_ModelName=args[3];//模型名
			Item_Name=args[4];//物品名称
			Item_Type=int(args[5]);//物品类型
			Item_ItemExp=args[6];//物品说明
			Item_OutputExp=args[7];//产出说明
			Item_UseExp=args[8];//使用说明
			Item_LevelLimit=int(args[9]);//等级限制
			Item_JobLimit=int(args[10]);//职业限制
			Item_Bind=int(args[11]);//绑定
			Item_Position=int(args[12]);//穿戴位置
			Item_OverlapCount=int(args[13]);//叠加上限
			Item_Quality=int(args[14]);//物品品质
			Item_StrongLv=int(args[15]);//强化等级
			Item_GrooveNum=int(args[16]);//凹槽数量
			Item_SkillId=int(args[17]);//技能ID
			Item_SetList=args[18].split("|");//套装ID列表
			Item_ItemValue=int(args[19]);//物品价值
			Item_SellPrice=int(args[20]);//出售价格
			Item_ExpiredTime=int(args[21]);//过期时间
			Item_PrivateData=args[22].split("|");//私有数据
			Item_EmbedData=args[23].split("|");//镶嵌数据
			if(flg)
			{
				Item_Attack = Attack=int(args[24]);//攻击
				Item_Defense = Defense=int(args[25]);//防御
				Item_CurHp = CurHp=int(args[26]);//生命值
				Item_Crit = Crit=int(args[27]);//暴击
				Item_Tenacity = Tenacity=int(args[28]);//韧性
				AppendHurt=args[29].split("|");//附加伤害
				OutAttack=args[30].split("|");//卓越攻击
				AttackPerc=args[31].split("|");//攻击加成
				LgnoreDefense=args[32].split("|");//无视防御
				AbsorbHurt=args[33].split("|");//吸收伤害
				DefenseSuccess=args[34].split("|");//防御成功率
				DefensePerc=args[35].split("|");//防御加成
				OutHurtPerc=args[36].split("|");//减伤比例
				Vampire=args[37].split("|");//吸血
				Gemrank=int(args[38]);				//宝石等级
			}	else {
				Attack=int(args[24]);//攻击
				Defense=int(args[25]);//防御
				CurHp=int(args[26]);//生命值
				Crit=int(args[27]);//暴击
				Tenacity=int(args[28]);//韧性
				AppendHurt=args[29].split("|");//附加伤害
				OutAttack=args[30].split("|");//卓越攻击
				AttackPerc=args[31].split("|");//攻击加成
				LgnoreDefense=args[32].split("|");//无视防御
				AbsorbHurt=args[33].split("|");//吸收伤害
				DefenseSuccess=args[34].split("|");//防御成功率
				DefensePerc=args[35].split("|");//防御加成
				OutHurtPerc=args[36].split("|");//减伤比例
				Vampire=args[37].split("|");//吸血
				Gemrank=int(args[38]);				//宝石等级
			}
			
		}
	}
}


