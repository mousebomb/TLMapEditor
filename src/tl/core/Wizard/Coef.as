package tl.core.Wizard
{
	import tl.frameworks.model.CSV.SGCsvManager;

	public class Coef
	{
		public var forceAttack:CoefObject=new CoefObject();				//物理攻击(表中基础属性)
		public var forceDefense:CoefObject=new CoefObject();			//物理护甲(表中基础属性)
		public var spellAttack:CoefObject=new CoefObject();				//法术攻击(表中基础属性)
		public var spellDefense:CoefObject=new CoefObject();			//法术抗性(表中基础属性)
		public var ignoreForceDefense:CoefObject=new CoefObject();		//护甲穿透(表中基础属性)
		public var ignoreSpellDefense:CoefObject=new CoefObject();	    //抗性穿透(表中基础属性)
		public var stealHealth:CoefObject=new CoefObject();				//生命窃取(表中基础属性)
		public var attackSpeed:CoefObject=new CoefObject();				//攻击速度(表中基础属性)
		public var moveSpeed:CoefObject=new CoefObject();				//移动速度(表中基础属性)
		public var criticalHit:CoefObject=new CoefObject();				//暴击率(表中基础属性)
		public var criticalHitDamage:CoefObject=new CoefObject();		//暴击伤害(表中基础属性)
		public var maxHp:CoefObject=new CoefObject();					//血量上限(表中基础属性)
		public var lifeSpeed:CoefObject=new CoefObject();	            //生命恢复速度(表中基础属性)
		public var pvpStrength:CoefObject=new CoefObject();	            //pvp强度
		public var pvpTenacity:CoefObject=new CoefObject();	            //pvp韧性
		public var pvpHurtZoom:CoefObject=new CoefObject();	            //PVP伤害缩放比
		public var pvpControlZoom:CoefObject=new CoefObject();	        //PVP控制缩放比
		public var skillAttack:CoefObject=new CoefObject();	            //技能攻击
		public var hurtRemit:CoefObject=new CoefObject();	            //伤害减免
		public var skillDamage:CoefObject=new CoefObject();	            //技能伤害
		public function Coef()
		{

		}
		public function InIt():void 
		{
			var args:Array=SGCsvManager.getInstance().table_coef.DataArray;
			forceAttack.refresh(args[0]);				//物理攻击(表中基础属性)
			forceDefense.refresh(args[1]);			    //物理护甲(表中基础属性)
			spellAttack.refresh(args[2]);				//法术攻击(表中基础属性)
			spellDefense.refresh(args[3]);			    //法术抗性(表中基础属性)
			ignoreForceDefense.refresh(args[4]);		//护甲穿透(表中基础属性)
			ignoreSpellDefense.refresh(args[5]);	    //抗性穿透(表中基础属性)
			stealHealth.refresh(args[6]);				//生命窃取(表中基础属性)
			attackSpeed.refresh(args[7]);				//攻击速度(表中基础属性)
			moveSpeed.refresh(args[8]);				    //移动速度(表中基础属性)
			criticalHit.refresh(args[9]);				//暴击率(表中基础属性)
			criticalHitDamage.refresh(args[10]);		//暴击伤害(表中基础属性)
			maxHp.refresh(args[11]);					//血量上限(表中基础属性)
			lifeSpeed.refresh(args[12]);	            //生命恢复速度(表中基础属性)
			pvpStrength.refresh(args[13]);	            //pvp强度
			pvpTenacity.refresh(args[14]);	            //pvp韧性
			pvpHurtZoom.refresh(args[15]);	            //PVP伤害缩放比
			pvpControlZoom.refresh(args[16]);	        //PVP控制缩放比
			skillAttack.refresh(args[17]);	            //技能攻击
			hurtRemit.refresh(args[18]);	            //伤害减免
			skillDamage.refresh(args[19]);	            //技能伤害
		}
	}
}