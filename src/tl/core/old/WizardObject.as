package tl.core.old
{
	import tl.core.Wizard.*;
	/**
	 * 精灵属性对象
	 * @author 李舒浩
	 */

	import tl.Net.Socket.Order;
	import tl.core.DataSources.Buff;
	import tl.core.DataSources.Item;

	public class WizardObject extends WizardAI
	{		
		/** 英雄 **/
		public static const TYPE_0:int = 0;	//英雄
		/** Npc **/
		public static const TYPE_1:int = 1;	//Npc
		/** 场景特效 **/
		public static const TYPE_2:int = 2;	//场景特效
		/** 部件怪物 **/
		public static const TYPE_3:int = 3;	//部件怪物
		/** 怪物 **/
		public static const TYPE_4:int = 4;	//怪物
		/** Boss怪物 **/
		public static const TYPE_5:int = 5;	//Boss怪物
		/** 受击破碎特效 **/
		public static const TYPE_6:int = 6;	//受击破碎特效
		/** 受击溅血特效 **/
		public static const TYPE_7:int = 7;	//受击溅血特效
		/** 翅膀 **/
		public static const TYPE_8:int = 8;	//翅膀
		/** 坐骑 **/
		public static const TYPE_9:int = 9;	//坐骑
		/** 武器 **/
		public static const TYPE_10:int = 10;	//武器
		/** 搜检部件 **/
		public static const TYPE_11:int = 11;	//搜检部件
		/** 场景小精灵 **/
		public static const TYPE_12:int = 12;	//场景小精灵
		/** 镖车 **/
		public static const TYPE_13:int = 13;	//镖车
		/** 地表模型 **/
		public static const TYPE_14:int = 14;	//地表模型
		/** 掉落物品 **/
		public static const TYPE_99:int = 99;	//掉落物品
		
		//---------------其它属性区-----------------------------------------------
		public var isMove:Boolean=false;			//是否在移动中
		public var isEnforceMove:Boolean=false;	//是否在强制移动中
		public var buffArgs:Array=new Array();		//buff列表
		public var itemArgs:Array=new Array();		//装备item(保存的是装备EID)

		//驱动人物回调方法
		public var addBufCallBack:Function;		//添加buff回调
		public var removeBuffCallBack:Function;	//移除buff回调
		
		private var _myMountId:uint;				//坐骑action表Id
		private var _myWingsId:uint;				//翅膀action表Id
		private var _leftEquipId:uint;				//左手武器action表Id
		private var _rightEquipId:uint;			//右手武器action表Id
		
		public function WizardObject() { 
			
		}
		public function refreshWizardObject(order:Order):void
		{
			this.RefreshPlayer(order);
			this.refreshByTable(""+this.Creature_WizardId);
			this.dispatchEvent(new MyEvent(WizardKey.Refresh_WizardObject));
		}
		public function updataItem(item:Item,direcProp:int=1):void{
//			forceAttack        +=direcProp*item.forceAttack;
//			forceDefence       +=direcProp*item.forceDefence;
//			magicAttack        +=direcProp*item.magicAttack;
//			magicDefence       +=direcProp*item.magicDefence;
//			pForceDefence      +=direcProp*item.pForceDefence;
//			pMagicDefence      +=direcProp*item.pMagicDefence;				
//			stealHp            +=direcProp*item.stealHp;
//			attackSpeed        +=direcProp*item.attackSpeed;
//			moveSpeed          +=direcProp*item.moveSpeed;
//			criticalHit        +=direcProp*item.criticalHit;
//			criticalHitDamage  +=direcProp*item.criticalHitDamage;
//			maxHp              +=direcProp*item.maxHp;
//			hpRecover          +=direcProp*item.hpRecover;
//			strong             +=direcProp*item.strong;
//			tenacity           +=direcProp*item.tenacity;
		}
		public function updataBuff(buff:Buff,direcProp:int=1):void{
//			if(direcProp==1){
//				forceAttack        =int(forceAttack         *(1+buff.forceAttackProp));
//				forceDefence       =int(forceDefence        *(1+buff.forceDefenceProp));
//				magicAttack        =int(magicAttack         *(1+buff.magicAttackProp));
//				magicDefence       =int(magicDefence        *(1+buff.magicDefenceProp));
//				pForceDefence      =int(pForceDefence       *(1+buff.pForceDefenceProp));
//				pMagicDefence      =int(pMagicDefence       *(1+buff.pMagicDefenceProp));				
//				stealHp            =int(stealHp             *(1+buff.stealHpProp));
//				attackSpeed        =int(attackSpeed         *(1+buff.attackSpeedProp));
//				moveSpeed          =int(moveSpeed           *(1+buff.moveSpeedProp));
//				criticalHit        =int(criticalHit         *(1+buff.criticalHitProp));
//				criticalHitDamage  =int(criticalHitDamage   *(1+buff.criticalHitDamageProp));
//				maxHp              =int(maxHp               *(1+buff.maxHpProp));
//				hpRecover          =int(hpRecover           *(1+buff.hpRecoverProp));
//				strong             =int(strong              *(1+buff.strongProp));
//				tenacity           =int(tenacity            *(1+buff.tenacityProp));
//			}
//			else{
//				forceAttack        =int(forceAttack        /(1+buff.forceAttackProp));
//				forceDefence       =int(forceDefence       /(1+buff.forceDefenceProp));
//				magicAttack        =int(magicAttack        /(1+buff.magicAttackProp));
//				magicDefence       =int(magicDefence       /(1+buff.magicDefenceProp));
//				pForceDefence      =int(pForceDefence      /(1+buff.pForceDefenceProp));
//				pMagicDefence      =int(pMagicDefence      /(1+buff.pMagicDefenceProp));				
//				stealHp            =int(stealHp            /(1+buff.stealHpProp));
//				attackSpeed        =int(attackSpeed        /(1+buff.attackSpeedProp));
//				moveSpeed          =int(moveSpeed          /(1+buff.moveSpeedProp));
//				criticalHit        =int(criticalHit        /(1+buff.criticalHitProp));
//				criticalHitDamage  =int(criticalHitDamage  /(1+buff.criticalHitDamageProp));
//				maxHp              =int(maxHp              /(1+buff.maxHpProp));
//				hpRecover          =int(hpRecover          /(1+buff.hpRecoverProp));
//				strong             =int(strong             /(1+buff.strongProp));
//				tenacity           =int(tenacity           /(1+buff.tenacityProp));
//			}
//			forceAttack        +=direcProp*buff.forceAttack;
//			forceDefence       +=direcProp*buff.forceDefence;
//			magicAttack        +=direcProp*buff.magicAttack;
//			magicDefence       +=direcProp*buff.magicDefence;
//			pForceDefence      +=direcProp*buff.pForceDefence;
//			pMagicDefence      +=direcProp*buff.pMagicDefence;				
//			stealHp            +=direcProp*buff.stealHp;
//			attackSpeed        +=direcProp*buff.attackSpeed;
//			moveSpeed          +=direcProp*buff.moveSpeed;
//			criticalHit        +=direcProp*buff.criticalHit;
//			criticalHitDamage  +=direcProp*buff.criticalHitDamage;
//			maxHp              +=direcProp*buff.maxHp;
//			hpRecover          +=direcProp*buff.hpRecover;
//			strong             +=direcProp*buff.strong;
//			tenacity           +=direcProp*buff.tenacity;
		}
		/** 清除方法 **/
//		public function clearWizardObject():void
//		{	
//			isMove=false;
//			this.clearAI();
//			this.clearBuff();
//			if(buffArgs)	buffArgs.length = 0;
//			if(itemArgs)	itemArgs.length = 0;
//		}
		/** 清除Buff方法 **/
		public function clearBuff():void
		{
			var len:int = buffArgs.length;
			for(var i:int = 0; i < len; i++){
				this.removeBuff(buffArgs[i]);
			}
			buffArgs.length=0;
		}
		/*public function refreshItem():void{
			var _Item:Item;
			for(var i:int=0;i<itemArgs.length;i++){
				//_Item=ItemSources.getInstance().getItemByUID(itemArgs[i]);
				changeProp(_Item);
			}
		}*/
		/** 初始化被动技能 **/
		public function initPassiveSkill():void{
//			if(!skillList || skillList.length < 1||skillList[0]=="0") return;
//			for(var i:int = 0; i < skillList.length; i++){
//				if(skillList[i].skillType==0){
//					var _Buff:Buff=new Buff();
//					_Buff.refresh(skillList[i].buffId);
//					this.addBuff(_Buff);
//				}
//			}
		}
		/** BUFF跳跃 **/
		public function jumpBuff(buff:Buff):void{
//			switch(buff.type)
//			{
//				case 3:	//持续伤害
//					this.nowHp-=buff.numParam1;
//					this.dispatchEvent(new ModuleEvent("BuffJump_Damage",buff.numParam1));
//					if(this.nowHp<=0){
//						this.dispatchEvent(new ModuleEvent("BuffJump_Dead"));	
//					}
//					break;
//				case 4:	//持续回血
//					this.nowHp+=buff.numParam1;
//					this.dispatchEvent(new ModuleEvent("BuffJump_Damage",-buff.numParam1));
//					break;
//				default:
//					break;
//			}
		}
		/** 是否有此BUFF **/
		public function hasBuff($buff:Buff):Boolean
		{
			for each(var buff:Buff in buffArgs)
			{
				if(buff.id == $buff.id) return true;
			}
			return false;
		}
		/**
		 * 获取指定ID BUFF
		 * @param id
		 * @return 
		 */		
		public function getBuff(id:String):Buff
		{
			for each(var buff:Buff in buffArgs)
			{
				if(buff.id == id) return buff;
			}
			return null;
		}
		/**
		 * 更新BUFF
		 * @param $buff
		 */		
		public function updateBuff($buff:Buff):void
		{
			var len:int = buffArgs.length;
			for(var i:int = 0 ; i < len; i++)
			{
				if(buffArgs[i].id == $buff.id)
				{
					buffArgs[i].nowTime = $buff.nowTime;
					break;
				}
			}
		}
		
		/** 添加BUFF **/
		public function addBuff($buff:Buff):void
		{
			if(hasBuff($buff)) 
			{
				updateBuff($buff);
				return;
			}
			buffArgs.push($buff);
			updataBuff($buff);
			$buff.timeEndCallBack = onTimeEndCallBack;	//BUFF时间结束回调
//			$buff.refreshCallBack = onRefreshCallBack;	//每秒刷新回调
			//执行添加回调
			if(addBufCallBack != null) addBufCallBack($buff);
		}
		/** buff时间到执行回调 **/
		private function onTimeEndCallBack($buff:Buff):void
		{
			removeBuff($buff.id);
			//
		}
		/** 每秒刷新执行回调 **/
//		private function onRefreshCallBack($buff:Buff):void
//		{
//			//驱动人物状态显示
//		}
		
		/** 移除BUFF **/
		public function removeBuff($buffID:String):void
		{
			var len:int = buffArgs.length;
			for(var i:int = 0; i < len; i++)
			{
				if(buffArgs[i].id == $buffID)
				{
					buffArgs.splice(i, 1);
					break;
				}
			}
			//执行添加回调
			if(removeBuffCallBack != null) removeBuffCallBack($buffID);
		}
		
		/** 添加仇恨 **/
		public function addHatred(_OnlyId:Number,value:int):void
		{

		}
		/** 减少仇恨 **/
		public function cutHatred(_OnlyId:Number,value:int):void
		{
			
		}
		
		/**
		 * 坐骑
		 * @param value	: 当前要骑乘/卸下的坐骑action表ID
		 * @param state	: 上下马状态(0:下马 1:上马)
		 */
		public function setMyMount(value:uint, state:int):void
		{
			_myMountId = value;
			if(state == 1)
			{
				//上马
				_isRide = true;
				this.dispatchEvent(new MyEvent(WizardKey.Action_BindingUnit, [WizardKey.WizardUnit_Mount, _myMountId, "ride"]));
			}
			else
			{
				//下马
				_isRide = false;
				this.dispatchEvent(new MyEvent(WizardKey.Action_RemoveBindingUnit, [WizardKey.WizardUnit_Mount, _myMountId, "ride"]));
			}
			//派发一下事件更新动作显示
			this.playAction(this.actionName);//ActionName.stand);
		}
		public function get myMountId():uint  {  return _myMountId;  }
		/** 是否骑乘状态 **/
		public function get isRide():Boolean  {  return _isRide;  }
		private var _isRide:Boolean;
		/**
		 * 翅膀
		 * @param value	: 当前要装备/卸下的翅膀action表ID
		 * @param state	: 装备/卸下状态(0:卸下 1:装备)
		 */		
		public function setMyWings(value:uint, state:int):void
		{
			_myWingsId = value;
			if(state == 1)	//装备翅膀
				this.dispatchEvent(new MyEvent(WizardKey.Action_BindingUnit, [WizardKey.WizardUnit_Wing, _myWingsId, "back"]));
			else			//卸下翅膀
				this.dispatchEvent(new MyEvent(WizardKey.Action_RemoveBindingUnit, [WizardKey.WizardUnit_Wing, _myWingsId, "back"]));
		}
		public function get myWingsId():uint  {  return _myWingsId;  }
		/**
		 * 装备/卸下武器
		 * @param leftId	: 左手武器action表Id
		 * @param rightId	: 右手武器action表Id
		 * @param leftState	: 左手武器状态(0:卸下 1:装备)
		 * @param rightStatr: 右手武器状态(0:卸下 1:装备)
		 * 
		 */		
		public function setMyEquip(leftId:uint, rightId:uint, leftState:int, rightStatr:int):void
		{
			_leftEquipId = leftId;
			_rightEquipId = rightId;
			//左手武器
			if(leftState == 0)	//装备武器
				this.dispatchEvent(new MyEvent(WizardKey.Action_RemoveBindingUnit, [WizardKey.WizardUnit_LeftArms, _leftEquipId, "lefthand"]));
			else				//卸下武器
				this.dispatchEvent(new MyEvent(WizardKey.Action_BindingUnit, [WizardKey.WizardUnit_LeftArms, _leftEquipId, "lefthand"]));
				
			//右手武器
			if(rightStatr == 0)
				this.dispatchEvent(new MyEvent(WizardKey.Action_RemoveBindingUnit, [WizardKey.WizardUnit_RightArms, _rightEquipId, "righthand"]));
			else
				this.dispatchEvent(new MyEvent(WizardKey.Action_BindingUnit, [WizardKey.WizardUnit_RightArms, _rightEquipId, "righthand"]));
		}
		
		override public function dispose():void
		{
			if(this.isDispose) return;
			super.dispose();
			buffArgs.length = 0;
			buffArgs = null;
			itemArgs.length = 0;
			itemArgs = null;
			
			addBufCallBack = null;
			removeBuffCallBack = null;
		}

	}
}