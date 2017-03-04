/**
 * Created by gaord on 2017/3/1.
 */
package tl.core.role.model
{
	public class CsvRoleVO
	{

		/*#生物编号*/
		public var Id:String;
		/*生物名称*/
		public var Name:String;
		/*资源ID*/
		public var ResName:String;
		/*等级*/
		public var Level:int;
		/** 默认图层（编辑器用） */
		public var Layer:int;
		/**资源分类*/
		public var ResType:int;
		/*生物类型*/
		public var Type:int;
		/*生物AI*/
		public var AiList:Array;
		/*倒地时间*/
		public var FallTime:int;
		/*技能列表*/
		public var SkillList:Array;
		/*攻击*/
		public var Attack:int;
		/*防御*/
		public var Defense:int;
		/*生命值*/
		public var CurHp:int;
		/*暴击*/
		public var Crit:int;
		/*韧性*/
		public var Tenacity:int;
		/*附加伤害*/
		public var AppendHurt:int;
		/*卓越攻击*/
		public var OutAttack:int;
		/*攻击加成*/
		public var AttackPerc:int;
		/*无视防御*/
		public var LgnoreDefense:int;
		/*吸收伤害*/
		public var AbsorbHurt:int;
		/*防御成功率*/
		public var DefenseSuccess:int;
		/*防御加成*/
		public var DefensePerc:int;
		/*减伤比例*/
		public var OutHurtPerc:int;
		/*吸血*/
		public var Vampire:int;
		/*掉落品质*/
		public var SpoilsQuality:int;
		/*掉落组*/
		public var Spoils:Array;
		/*绑定功能*/
		public var BindFun:Array;
		/*经验值*/
		public var Exp:int;
		/*语言*/
		public var Say:String;
		/*缩放比例*/
		public var Scaling:int;
		/*开启透明通道*/
		public var AlphaBlending:int;
		/*出生特效*/
		public var CreateEffect:String;
		/*死亡特效*/
		public var DeathEffect:String;
		/*精灵称号*/
		public var WizardTile:String;
		/*掉落组(最后一刀)*/
		public var SpoilsForKiller:Array;
		/*掉落组(最大伤害)*/
		public var SpoilsForHurt:Array;
		/*使用者类型*/
		public var UserType:int;
		/*怪物名字颜色标识*/
		public var WizardNameColor:int;
		/*物理抗性*/
		public var PhysicalHoldout:Array;
		/*掉落类型*/
		public var SpoilsType:int;
		public var RangeEffect:String;
		public var Label:String;


	}
}
