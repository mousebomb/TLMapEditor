package tl.core.Wizard
{
	import Lib.DataSources.Skill;
	import Lib.Tool.Tool;

	import tl.core.old.WizardObject;


	public class WizardMath
	{
		private static var MyInstance:WizardMath;
		private var _Coef:Coef=new Coef();
		private var _OldId:int=0;
		private var _ObjectIdNum:int=0;
		
		private const _index_Param1:int = 2;		//参数1下标
		private const _index_Param2:int = 3;		//参数2下标
		private const _index_Param3:int = 4;		//参数3下标
		private const _index_Param4:int = 5;		//参数4下标
		private const _index_ForceDefense:int = 8;	//防御方物理伤害减免百分比下标
		private const _index_SpellDefense:int = 9;	//防御方法术伤害减免百分比下标
		private const _index_ForceAttack:int = 22;	//攻击方普通物理攻击伤害输出下标
		private const _index_SpellAttack:int = 23;	//攻击方普通法术攻击伤害输出下标
		private const _index_PvpData:int = 20;		//PVP系数百分比下标
		
		public function WizardMath()
		{
			if( MyInstance ){
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			MyInstance=this;
		}
		public static function getInstance():WizardMath 
		{
			if ( MyInstance == null ) 
			{				
				MyInstance = new WizardMath();
			}
			return MyInstance;
		}
		public function InIt():void{
			_Coef.InIt();
		}
		/**
		 * 取s方向上距离t点 distance远的坐标点,如果两点距离小于distance则返回空
		 * @param sPoint
		 * @param tPoint
		 * @param distance
		 * @return 
		 * 
		 */
		public function getEId():int
		{	
			var _ObjectId:int=0;
			var _Date:Date=new Date();
			var _NowId:int=int(""+_Date.getHours()+""+_Date.getMinutes()+""+_Date.getSeconds());
			if(_OldId==_NowId){
				_ObjectIdNum++;
			}
			else{
				_OldId=_NowId;
				_ObjectIdNum=0;
			}
			_ObjectId=_OldId+_ObjectIdNum;
			//trace("getObjectId:"+_ObjectId);
			return _ObjectId;
		}
		/**
		 * 计算伤害值
		 * @param sObject	: 执行攻击的精灵
		 * @param tOjbect	: 接收伤害的精灵
		 * @param skill		: 使用的技能
		 */
		public function countDamage(sObject:WizardObject,tObject:WizardObject,skill:Skill):Array
		{
			var _Result:Array=new Array();
//			//决断是否要加BUFF
//			if(skill.buffId!="0"){
//				if(critica(skill.buffProb/10000)){
//					var _Buff:Buff=new Buff();
//					_Buff.refresh(skill.buffId);
//					tObject.addBuff(_Buff);
//					_Result.push([WizardKey.FirAction_AddBuff,skill, skill.buffId]);
//				}
//			}
//			//判断是否为爆击;
//			var _CriticaCoef:Number=critica(sObject.criticalHit/10000)?1+sObject.criticalHitDamage/10000:1;
//			//计算技能攻击
//			var _SkillAttack:Number=0;
//			if(skill.propType==1){//0表示此技能为物理系技能
//				_SkillAttack=sObject.forceAttack*skill.attackProp/10000+skill.attackNum;
//			}
//			else if(skill.propType==2){
//				_SkillAttack=sObject.magicAttack*skill.attackProp/10000+skill.attackNum;
//			}
//			//计算伤害减免
//			//（1-攻击方穿透百分比）*防御方护甲或抗性/(（1-攻击方穿透百分比）*防御方护甲或抗性+攻击方等级*参数1)
//			var _HurtRemit:Number=0;
//			if(skill.propType==1){//1表示此技能为物理系技能
//				_HurtRemit=(1-sObject.pForceDefence/10000)*tObject.forceDefence/((1-sObject.pForceDefence/10000)*tObject.forceDefence+sObject.level*_Coef.hurtRemit.param1)
//			}
//			else if(skill.propType==2){
//				_HurtRemit=(1-sObject.pMagicDefence/10000)*tObject.magicDefence/((1-sObject.pMagicDefence/10000)*tObject.magicDefence+sObject.level*_Coef.hurtRemit.param1)
//			}
//			//计算buff减伤
//			var _BuffHurtRemit:Number=0;
//			for(var i:int=0;i<tObject.buffArgs.length;i++){
//				if(tObject.buffArgs[i].type=WizardKey.BuffType_NoHarm){
//					_BuffHurtRemit+=tObject.buffArgs[i].propParam1/10000;
//				}
//			}
//			//计算防御方PVP伤害缩放比
//			var _PvpHurtZoom:Number=1;
//			//计算技能伤害
//			//技能攻击*（1-防御方减伤）*（1-防御方BUFF减伤）*攻击方PVP伤害缩放系数百分比*爆击百分比
//			var _SkillDamage:Number=_SkillAttack*(1-_HurtRemit)*(1-_BuffHurtRemit)*_PvpHurtZoom*_CriticaCoef;
//			HTrace.myTrace(""+sObject.name+" use "+skill.name +" attack->"+tObject.name+" damage:"+_SkillDamage);
//			if(_SkillDamage!=0){
//				tObject.nowHp-=_SkillDamage;
//				if(tObject.nowHp>tObject.maxHp){
//					tObject.nowHp=tObject.maxHp;
//				}
//				_Result.push([WizardKey.FirAction_Damage,skill, int(_SkillDamage),_CriticaCoef]);
//			}
			return _Result;
		}	
		/**
		 * 决断是否为暴击 
		 * @param value
		 * @return 
		 * 
		 */
		private function critica(value:Number):Boolean{
			var _RandNum:int=Tool.randomNum(1,10000);
			if(_RandNum/10000<=value){
				return true;
			}else{
				return false;
			}
		}
	}
}