/**
 * Created by gaord on 2016/12/27.
 */
package tl.core.role.model
{
	import away3d.debug.Debug;

	import tl.frameworks.model.CSV.SGCsvManager;

	/** 表配的角色VO */
	public class TableRoleVO
	{
		public function TableRoleVO()
		{
		}




		//---------------配置表基础属性区----------------------------------------
		public var id:String;//#生物编号
		public var name:String;//生物名称
		public var resId:int;//资源ID
		public var level:int;//等级
		public var type:int;//生物类型
		public var aiList:Array;//生物AI
		public var moveSpeedTable:int;//移动速度
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
		public var spoilsQuality:int;//怪物类型
		public var spoils:Array;//掉落组
		public var bindFun:Array;//绑定功能
		public var exp:int;//经验值
		public var refreshTime:int;//刷新时间
		public var say:String;//语言
		public var scaling:int;//缩放比例
		public var alphaBlending:int;//开启透明通道
		public var createEffect:String;//出生特效
		public var deathEffect:String;//死亡特效
		public var wizardTile:String;//精灵称号
		public var spoilsForKiller:Array;//掉落组(最后一刀)
		public var spoilsForHurt:Array;//掉落组(最大伤害)
		public var userType:int;//使用者类型
		/** 是否显示名字条|阵营图标|VIP图标|血条|分阵营|分组|军阶|称号

		 是否显示名字条|BOSS图标|功能图标|名字颜色|颜色分阵营|颜色分组|是否血条|是否可选中|选中光圈


		 |0]是否显示名字条:0显示，1不显示
		 |1]BOSS图标:0不显示，1小bOSS图标，2大boss图标
		 |2]功能图标:0不显示，资源名表示显示
		 |3]名字颜色:0红色，1绿色，2浅蓝色，3黄色，4白色，5紫色
		 |4]颜色分阵营:0不分阵营，1分阵营，分阵营的情况下：我方统一为绿色，敌方统一为红色
		 |5]颜色分组:0不分组，1分组，分组的情况下：我方统一为绿色，对方统一为红色
		 |6]是否血条:0显示，1不显示
		 |7]是否可选:0可选中，1不可选中 不选中则不响应该鼠标事件
		 |8]选中光圈:0无光圈，1绿色光圈，2蓝色光圈，3红色光圈*/
				   public var wizardNameColor:Array;//怪物名字颜色标识
		public var PhysicalHoldout:Array;//物理抗性
		public var SpoilsType:int;//掉落类型
		public var RangeEffect:String;//范围特效
		public var stopDirection:Boolean//是否停止转向
		public var isHideInMap:Boolean//是否在世界地图中是否显示
		public var needForLevel:int;//需要要塞等级
		public var isLongShowMap:int;	//小地图、世界地图固定显示

		/** 足迹类型：0:不显示；1：2条腿；2：4条腿；3：6条腿；4：原点生成 */
		public var footprintType:int;

		public function refreshByTable(wizardId:String):void
		{
			if (id == wizardId)
			{
				return;
			}

			var args:Array = SGCsvManager.getInstance().table_wizard.FindRow(wizardId);
			if (!args)
			{
				track("TableRoleVO/refreshByTable" ,"Wizard表中找不到生物-->ID:" + wizardId);
				return;
			}

			//更新数据
			id             = args[0];//#生物编号
			name           = args[1];//生物名称
			resId          = int(args[2]);//资源ID
			level          = int(args[3]);//等级
			type           = int(args[4]);//生物类型
			aiList         = args[5].split("|");//生物AI
			moveSpeedTable = int(args[6]);//移动速度
			skillList      = args[7].split("|");//技能列表
			attack         = int(args[8]);//攻击
			defense        = int(args[9]);//防御
			curHp          = Number(args[10]);//生命值
			crit           = int(args[11]);//暴击
			tenacity       = int(args[12]);//韧性
			appendHurt     = int(args[13]);//附加伤害
			outAttack      = int(args[14]);//卓越攻击
			attackPerc     = int(args[15]);//攻击加成
			lgnoreDefense  = int(args[16]);//无视防御
			absorbHurt     = int(args[17]);//吸收伤害
			defenseSuccess = int(args[18]);//防御成功率
			defensePerc    = int(args[19]);//防御加成
			outHurtPerc    = int(args[20]);//减伤比例
			vampire        = int(args[21]);//吸血
			spoilsQuality  = int(args[22]);//怪物类型
			spoils         = args[23].split("|");//掉落组
			bindFun        = args[24].split("|");//绑定功能

//			if (int(bindFun[0]) == 10)
//			{
//				fortreesVo = new NewFortressVo();
//				fortreesVo.refreshVoByID(bindFun[1]);
//			}

			exp             = int(args[25]);//经验值
			refreshTime     = int(args[26]);//刷新时间
			say             = args[27];//语言
			scaling         = int(args[28]);//缩放比例
			alphaBlending   = int(args[29]);//开启透明通道
			createEffect    = args[30];//出生特效
			deathEffect     = args[31];//死亡特效
			wizardTile      = args[32];//精灵称号
			spoilsForKiller = args[33].split("|");//掉落组(最后一刀)
			spoilsForHurt   = args[34].split("|");//掉落组(最大伤害)
			userType        = int(args[35]);//使用者类型
			var str:String  = args[36]
			if (type == 0)
			{
				wizardNameColor = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
			}
			else if (str == "0")
			{
				wizardNameColor = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
			}
			else
			{
				wizardNameColor = str.split("|");
				;//怪物名字颜色标识
			}
			PhysicalHoldout = args[37].split("|");//物理抗性
			SpoilsType      = int(args[38]);//掉落类型
			RangeEffect     = args[39];//范围特效
			stopDirection   = int(args[40]) > 0 ? true : false;//停止转向
			isLongShowMap   = int(args[41])
			isHideInMap     = int(args[41]) == 1 ? true : false;//是否显示
			needForLevel    = int(args[44]);
			footprintType   = int(args[45]);
			//生成特殊属性数据
			/*是否显示名字条|阵营图标|VIP图标|血条|分阵营|分组|军阶|称号
			 是否显示名字条|BOSS图标|功能图标|名字颜色|颜色分阵营|颜色分组|是否血条|是否可选中|选中光圈
			 |是否显示名字条:0显示，1不显示
			 |BOSS图标:0不显示，1小bOSS图标，2大boss图标
			 |功能图标:0不显示，资源名表示显示
			 |名字颜色:0红色，1绿色，2浅蓝色，3黄色，4白色，5紫色
			 |颜色分阵营:0不分阵营，1分阵营，分阵营的情况下：我方统一为绿色，敌方统一为红色
			 |颜色分组:0不分组，1分组，分组的情况下：我方统一为绿色，对方统一为红色
			 |是否血条:0显示，1不显示
			 |是否可选:0可选中，1不可选中 不选中则不响应该鼠标事件
			 |选中光圈:0无光圈，1绿色光圈，2蓝色光圈，3红色光圈

			 主角名字颜色分阵营的方案
			 1，玩家切换为阵营攻击模式，则对方阵营玩家名字是红色
			 3，玩家切换为和平攻击模式，则对方阵营玩家名字是浅蓝色
			 3，玩家看自已阵营的玩家为白色，无阵营看有阵营也是白色
			 4，玩家召唤物，宠物的颜色同主人名字颜色
			 5，自已召唤物，宠物的名字颜色为绿色*/
		}

	}
}
