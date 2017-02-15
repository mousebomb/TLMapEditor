package tl.core.Wizard
{
	/**
	 * 精灵智能控制类
	 * @author 黄栋 & 李舒浩
	 */

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	import tl.Net.MsgKey;
	import tl.Net.Socket.Connect;
	import tl.core.DataSources.Skill;
	import tl.core.old.MyDispatcher;
	import tl.core.old.WizardObject;
	import tl.utils.HPointUtil;
	import tl.utils.HashMap;

	public class WizardAI extends WizardWalker
	{
		public var skillArgs:Array = new Array();	   //技能列表	
		public var npcScope:uint = 150;				//NPC触发范围 
		
		/**
		 * NPC点坐标,用于离开NPC指定范围时关闭NPC窗口,NULL时为不执行检测关闭
		 * @param value
		 */		
		public function set npcPoint(value:Point):void
		{
			_npcPoint = value;
		}
		public function get npcPoint():Point  {  return _npcPoint;  }
		private var _npcPoint:Point;
		
//		private var _Timer:Timer;						//AI执行定时器
//		private var _TimerStep:int=1000;
		private var _IsFir:Boolean=false;
		private var _IsMainActor:Boolean=false;
		private var _InCity:Boolean=true;				//是否在主城中
		private var _Status:String="Status_Stand";
		private var _FTargetArgs:Array=new Array();	//友方目标AI对象列表
		private var _ETargetArgs:Array=new Array();	//敌方目标AI对象列表
		private var _NTargetArgs:Array=new Array();   //当前目标AI对象
		private var _TargetPoint:Point;               //目标坐标点
		private var _NowSkill:Skill;                  //下一下要使用的技能
		private var _NextSkillPoint:Point;            //技能目标点
		private var _ComboArgs:Array=["1016","1031","1046","1061","1076"];
		private var _WizardSkepHash:HashMap;
		
		private var _detectionTime:Timer;				//检测用定时器
		private var _skillHash:HashMap = new HashMap;	//技能数据
		
		public function WizardAI(){  }		
		public function InIt():void
		{
//			if(!_Timer){
//				_Timer = new Timer(_TimerStep);
//				_Timer.addEventListener(TimerEvent.TIMER, onTimer);
//			}
			this.status=WizardKey.Status_Stand;
			this.addEventListener(WizardKey.Action_MoveStart,onMoveStart);		//开始移动执行
			this.addEventListener(WizardKey.Action_Destination,onDestination);	//到底目标点后执行
		}	
//		public function start():void{
//			if(!_Timer) return;
//			_Timer.start();
//		}
//		public function stop():void{
//			if(!_Timer) return;
//			_Timer.reset();
//			_Timer.stop();
//			this.isFir=false;
//		}
		public function set isFir(value:Boolean):void
		{
			_IsFir=value;
		}
		public function get isFir():Boolean{ return _IsFir; }
		public function set status(value:String):void
		{
			_Status=value;
		}
		public function get status():String{ return _Status; }
		
		public function set myTargetPoint(value:Point):void
		{
			_TargetPoint=value;
		}
		public function get myTargetPoint():Point{ return _TargetPoint; }
		
		public function set nextSkillPoint(value:Point):void
		{
			if(!_NowSkill) return;
			_NextSkillPoint=value;
		}
		public function get nextSkillPoint():Point{ return _NextSkillPoint; }
		
		public function get fTargetArgs():Array{ return _FTargetArgs; }
		public function get eTargetArgs():Array{ return _ETargetArgs; }
		public function get nTargetArgs():Array{ return _NTargetArgs; }
		/** 清除AI **/
		public function clearAI():void
		{
//			this.stop();
			_IsFir=false;
			_FTargetArgs.length=0;
			_ETargetArgs.length=0;
			_NTargetArgs.length=0;
			if(skillArgs)
			{
				var len:int = skillArgs.length;
				for(var i:int = 0; i < len; i++)
				{
					if(skillArgs[i]==null) continue;
					skillArgs[i].clear();
				}
				skillArgs.length = 0;
			}
		}
		/**查找目标*/
		public function getTarget(onlyId:Number):WizardAI
		{
			var _WizardAI:WizardAI;
			var i:int;
			var len:int = _ETargetArgs.length;
			for(i = 0; i < len; i++){
				if(onlyId==_ETargetArgs[i].myWizardOjbect.onlyId){
					_WizardAI=_ETargetArgs[i];
					break;
				}
			}
			len = _FTargetArgs.length;
			for(i = 0; i < len; i++){
				if(onlyId==_FTargetArgs[i].myWizardOjbect.onlyId){
					_WizardAI=_FTargetArgs[i];
					break;
				}
			}
			return _WizardAI;
		}
		/**添加目标*/
		public function addTarget(wizardAI:WizardAI,faction:int=0,idx:int=-1):void
		{
			var tIdx:int=-1;
			if(faction==0){
				tIdx=_FTargetArgs.indexOf(wizardAI);
				if(tIdx>-1) return;
				if(idx==-1){
					_FTargetArgs.push(wizardAI);
				}
				else{
					_FTargetArgs.splice(idx,0,wizardAI);
				}
			}
			else{
				tIdx=_ETargetArgs.indexOf(wizardAI);
				if(tIdx>-1) return;
				if(idx==-1){
					_ETargetArgs.push(wizardAI);
				}
				else{
					_ETargetArgs.splice(idx,0,wizardAI);
				}
			}
		}
		/**删除目标*/
		public function deleteTarget(wizardAI:WizardAI):void
		{
			var _Idx:int=_ETargetArgs.indexOf(wizardAI);
			if(_Idx>-1){
				_ETargetArgs.splice(_Idx,1);
			}
			else{
				_Idx=_FTargetArgs.indexOf(wizardAI);
				if(_Idx<0) return;
				_FTargetArgs.splice(_Idx,1);
			}
		}
		/**
		 * 移动目标
		 * @param wizardAI
		 * @param tFaction 0为友方,1为敌方
		 * @param idx 移动目标位置的索引
		 */
		public function moveTarget(wizardAI:WizardAI,tFaction:int,idx:int=0):void
		{
			var _EIdx:int=_ETargetArgs.indexOf(wizardAI);
			var _FIdx:int=_FTargetArgs.indexOf(wizardAI);
			if(_EIdx<0&&_FIdx<0) return;
			var sFaction:int=_EIdx>-1?1:0;
			if(sFaction==0){
				if(tFaction==0){
					_FTargetArgs.splice(_FIdx,1);
					addTarget(wizardAI,0,idx);
				}
				else{
					_FTargetArgs.splice(_FIdx,1);
					addTarget(wizardAI,1,idx);
				}
			}
			else{
				if(tFaction==0){
					_ETargetArgs.splice(_EIdx,1);
					addTarget(wizardAI,0,idx);
				}
				else{
					_ETargetArgs.splice(_EIdx,1);
					addTarget(wizardAI,1,idx);
				}
			}
		}
//		private function onTimer(e:TimerEvent):void
//		{
//
//		}
		override protected function onMoveStart():void
		{
			this.status=WizardKey.Status_Move;
			this.playAction(ActionName.run);
			//开启定时器,实时检测是否走到了传送阵
			startHitTestTime();
		}
		/** 到达目标点执行 **/
		override protected function onDestination():void
		{
//			this.dispatchEvent(new MyEvent(WizardKey.FirAction_PlayAction,ActionName.confront));
			//判断是否为死亡击飞到达的目标点
			if(this.status==WizardKey.Status_Dead)
			{
				dead();
			}
			else
			{
				this.status=WizardKey.Status_Stand;
				this.moveSpeed=12;
				this.playAction(ActionName.stand);
				//移除检测定时器
				closeHitTestTime();
				//移动到目的地,执行对应处理
				DestinationManage.getInstance().destination();
			}
		}
		/** 执行检测定时器 **/
		private function startHitTestTime():void
		{
//			if(this.Entity_UID != HMapSources.getInstance().mainWizardObject.Entity_UID) return;
//			if(!_detectionTime)
//			{
//				_detectionTime = new Timer(2000);
//				_detectionTime.addEventListener(TimerEvent.TIMER, onDetection);
//			}
//			_isStartTimer = true;
//			_detectionTime.start();
		}
		/** 停止检测定时器 **/
		private function closeHitTestTime():void
		{
//			if(this.Entity_UID != HMapSources.getInstance().mainWizardObject.Entity_UID) return;
//			if(_detectionTime)
//				_detectionTime.stop();
//			if(_isStartTimer)
//				onDetection();	//停止定时器后再执行多一次检测,因为有可能到达目的地时没有检测到
//			_isStartTimer = false;
		}
		private var _isStartTimer:Boolean = false;
		/** 定时检测 **/
		private function onDetection(e:TimerEvent = null):void
		{
//			var mapdata:HMapData = HMapSources.getInstance().mapData;
//			var mainWizardX:int = this.x;
//			var mainWizardY:int = this.y;
//			var mainWizardPoint:Point = new Point(mainWizardX, mainWizardY);
//			
//			//自动拾取
//			if(Configuration.AUTO_COLLECT)//开启自动拾取才自动拾取
//				ModuleEventDispatcher.getInstance().ModuleCommunication(ComEventKey.KeyBoard_PickUpItem);
//			//检测离开NPC
//			if(_npcPoint)
//			{
//				if( Tool.getTwoPointsRange(mainWizardPoint, _npcPoint) > npcScope)
//				{
//					ModuleEventDispatcher.getInstance().dispatchEvent(new ModuleEvent("LeaveNPC"));
//					_npcPoint = null;
//				}
//			}
//			//循环检测是否在传送阵范围内
//			var sceneID:int = -1;
//			var arr:Array = mapdata.jumpPoints;
//			var len:int = arr.length;
//			var isStop:Boolean = false;
//			for(var i:int = 0; i < len; i++)
//			{
//				if( Tool.getTwoPointsRange(mainWizardPoint, new Point(arr[i][0], arr[i][1])) <= 50)
//				{
//					sceneID = int(arr[i][4]);
//					isStop = true;
//					break;
//				}
//			}
//			if(sceneID == -1) return;
//			HMapSources.getInstance().changeMapBySceneID(sceneID);
//			if(isStop) _detectionTime.stop();
		}
		
		/**
		 * 播放动作
		 * @param $actionName	: 动作名
		 * @param $timeLength	: 动作回调执行的时间
		 */		
		public function playAction($actionName:String, $timeLength:Number=0):void
		{
			_actionName = $actionName;
			this.dispatchEvent(new MyEvent(WizardKey.FirAction_PlayAction,[$actionName, $timeLength]));
		}
		private var _actionName:String;
		public function get actionName():String { return _actionName; } 
		/** 播放动作结束执行 **/
		public function actionPlayOver(actionName:String=""):void
		{
			if(actionName=="") return;
			if(this.status==WizardKey.Status_Move) return;
			if(this.status==WizardKey.Status_Dead)
			{
				MyDispatcher.getInstance().dispatch(WizardKey.FirAction_WizardClear,this.Entity_UID);
				return;
			}
			this.status=WizardKey.Status_Stand;
			this.playAction(ActionName.stand);
		}
//		public function refreshWizardUnit():void{
//			if(this.type!=0) return;
//			this.dispatchEvent(new MyEvent(WizardKey.Action_BindingUnit,[WizardKey.WizardUnit_RightArms,"1002","righthand"]));
//			this.dispatchEvent(new MyEvent(WizardKey.Action_BindingUnit,[WizardKey.WizardUnit_Wing,"1261","back"]));
//			if(this.inCity){
//				this.dispatchEvent(new MyEvent(WizardKey.Action_BindingUnit,[WizardKey.WizardUnit_Mount,"1201","ride"]));
//			}
//			else{
//				this.dispatchEvent(new MyEvent(WizardKey.Action_RemoveBindingUnit,[WizardKey.WizardUnit_Mount,"1201","ride"]));
//			}
//		}
		/** 初始化添加技能列表 **/
		public function initSkill():void
		{
			skillArgs.length=0;
			var i:int;
			var _Skill:Skill;
			for(i = 1; i < 7; i++)
			{				
				if(this["Creature_Skill"+i]!=0){
					_Skill = _skillHash.get(this["Creature_Skill"+i]);
					if(_Skill == null)
					{
						_Skill = new Skill();
						_Skill.refresh(""+this["Creature_Skill"+i]);
						_skillHash.put(this["Creature_Skill"+i], _Skill)
					}
					this.addSkill(_Skill);
				}else{
					this.addSkill(null);
				}
			}
			var _Length:int = skillArgs.length;
			for(i = 0; i < _Length-1; i++)
			{
				if(skillArgs[i] && skillArgs[i].type==1 && skillArgs[i].combo[0]!="0")
				{
					for(var j:int = 0; j < skillArgs[i].combo.length; j++)
					{
						_Skill = _skillHash.get(skillArgs[i].combo[j]);
						if(_Skill == null)
						{
							_Skill = new Skill();
							_Skill.refresh(skillArgs[i].combo[j]);
							_skillHash.put(skillArgs[i].combo[j], _Skill);
						}
						this.addSkill(_Skill);
					}
				}
			}
		}
		/** 使用鼠标自动技能 **/
		public function useMouseSkill(point:Point):void
		{
//			//判断是否在范围内
//			var mouseSkill:String = SkillManager.getInstance().getCurSkillSeriesFirstSkill().id;
//			var skill:Skill = getSkill(mouseSkill);
//			var mainWizardPoint:Point = new Point(this.x, this.y);
//			var arr:Array = [
//				 this.Creature_Skill1
//				,this.Creature_Skill2
//				,this.Creature_Skill3
//				,this.Creature_Skill4
//				,this.Creature_Skill5
//				,this.Creature_Skill6
//			];
//			var skillIndex:int = arr.indexOf( int(mouseSkill) );
//			
//			if( Tool.getTwoPointsRange(mainWizardPoint, point) <= int(skill.rangeParams[0]))
//			{
//				ModuleEventDispatcher.getInstance().ModuleCommunication(ComEventKey.KeyBoard_UseSkill, { killid:skillIndex, point:point, isDown:true });
//			}
//			else
//			{
//				DestinationManage.getInstance().moveType = 2;	//使用自动技能标识
//				DestinationManage.getInstance().mutualObject = { skillIndex:skillIndex, point:point };
//				//计算范围点
//				var a:Number = mainWizardPoint.x - point.x;
//				var b:Number = mainWizardPoint.y - point.y;
//				var c:Number = Math.sqrt(a*a + b*b);
//				//计算b1
//				var c1:int = int(skill.rangeParams[0]) - int(skill.rangeParams[0])/6;
//				var b1:Number = b / c * c1;
//				var a1:Number = a / c * c1;
//				
//				//走到范围点
//				var pathArgs:Array = HMap3D.getInstance().getServerPathArgs(new Point(point.x + a1, point.y + b1));
//				if(!pathArgs)
//				{
//					DestinationManage.getInstance().destination();
//					return;
//				}
//				HMapSources.getInstance().entityMove(pathArgs[0]);
//				pathArgs[1].shift();
//				HMapSources.getInstance().mainWizardObject.targetPath = pathArgs[1];
//			}
		}
		
		/** 移除技能 **/
		public function getSkill(skillId:String):Skill
		{
			var _Skill:Skill;
			for(var i:int = 0; i < skillArgs.length; i++)
			{
				if(skillArgs[i]!=null&&skillArgs[i].id==skillId){
					_Skill=skillArgs[i];
					break;
				}
			}
			return _Skill;
		}
		/** 添加技能 **/
		public function addSkill(skill:Skill):void
		{
			skillArgs.push(skill);
		}
		/** 移除技能 **/
		public function removeSkill(skill:Skill):void
		{
			var _Idx:int=skillArgs.indexOf(skill);
			if(_Idx<0) return;
			skillArgs.splice(_Idx,1);
			skill=null;
		}
		/** 驱动技能**/
		public function driveSkill(skill:Skill,tPoint:Point=null,tUID:Number=0.1):void
		{
			var _Skill:Skill=skill;
			if(!_Skill) return;
			if(!tPoint){
				tPoint=new Point(0,0);
			}
			_Skill.sUID=this.Entity_UID;
			_Skill.tPoint=tPoint;
			var _SkillID:String=_Skill.id;
			if(_ComboArgs.indexOf(_SkillID)>-1) {
				_SkillID="1001";
			}
			Connect.getInstance().sendServer(MsgKey.MsgType_Client,MsgKey.MsgId_Battle_UseSkill,[int(_SkillID),Number(0.1),int(tPoint.x),int(tPoint.y)]);
			useSkill(_Skill);
		}
		/**使用技能*/
		public function useSkill(skill:Skill):void
		{
			_IsFir=true;
			_NowSkill=skill;
			if(this.isMainActor&&this.status==WizardKey.Status_Move){
				this.enforceStop();
			}
			this.getTargetDirec(skill.tPoint.x,skill.tPoint.y);		//获取目标方向
			this.status=WizardKey.Status_Attack;					//设置状态
			this.playAction(_NowSkill.action,_NowSkill.castTime);	//播放指定动作
			//判断是否有自身特效,显示自身特效
			if(skill.myEffect.length>1){
				this.dispatchEvent(new MyEvent(WizardKey.FirAction_PlayEffect,_NowSkill.myEffect));
				//MyDispatcher.getInstance().dispatch(WizardKey.FirAction_PlayEffect,[0,_NowSkill.myEffect,_NowSkill.sUID]);
			}
			//处理音效播放
			if(skill.mySound!="0"&&this.isMainActor){
				MyDispatcher.getInstance().dispatch(WizardKey.FirAction_PlySound,["sound",skill.mySound,0]);
			}
		}
		/**使用技能第二阶段*/
		public function useSkillStage2():void
		{
			//[特效类型，特效名称，特效目标，]
			if(!_NowSkill) return;
			if(_NowSkill.rangeEffect.length>1){
				MyDispatcher.getInstance().dispatch(WizardKey.FirAction_PlayEffect,[0,_NowSkill.rangeEffect,_NowSkill.sUID]);
			}
			if(_NowSkill.middleEffect.length>1){
				 MyDispatcher.getInstance().dispatch(WizardKey.FirAction_PlayEffect,[1,_NowSkill.middleEffect,_NowSkill.sUID,_NowSkill.tPoint.x,_NowSkill.tPoint.y]);
			}
			//处理音效播放
			if(_NowSkill.rangeSound!="0"){
				MyDispatcher.getInstance().dispatch(WizardKey.FirAction_PlySound,["sound",_NowSkill.rangeSound,0]);
			}
			if(_NowSkill.earthQuake.length>1){
				MyDispatcher.getInstance().dispatch(WizardKey.FirAction_Earthquake,_NowSkill.earthQuake);
			}
			if(_NowSkill.flashLight.length>1){
				MyDispatcher.getInstance().dispatch(WizardKey.FirAction_FlashLight,[_NowSkill.flashLight[0],_NowSkill.flashLight[1]/1000,_NowSkill.flashLight[2]/1000]);
			}
		}
		/**取消技能*/
		public function cancelSkill():void
		{
			_NowSkill=null;
			_NextSkillPoint=null;
			this.playAction(ActionName.stand);
			//this.dispatchEvent(new MyEvent(WizardKey.FirAction_cancelSkill));
		}
		/**依据不同的技能判断技能使用的必要性*/
		public function handleSkillMust(skill:Skill):Boolean
		{
			var _IsMust:Boolean=false;
			if(skill.baseValue<=0||skill.extraValue<=0){
				for(var i:int=0;i<_FTargetArgs.length;i++){
					if(_FTargetArgs[i].myWizardObject.nowHp<_FTargetArgs[i].myWizardObject.maxHp){
						this.moveTarget(_FTargetArgs[i],0,0);
						_IsMust=true;
						break;
					}
				}
			}else{
				_IsMust=true;
			}
			return _IsMust;
		}
		/**依据不同的技能需求处理与目标的距离逻辑*/
		public function handleDistance(skill:Skill,tPoint:Point=null):Boolean
		{
			//判断距离是否达到要求
			var _tPoint:Point;
			if(tPoint){
				_tPoint=HPointUtil.getDisTancePoint(
					new Point(this.x,this.y),
					tPoint,
					skill.distance
				);				
			}else{
				_tPoint=HPointUtil.getDisTancePoint(
					new Point(this.x,this.y),
					new Point(_NTargetArgs[0].myWizardObject.myX,_NTargetArgs[0].myWizardObject.myY),
					skill.distance
				);
			}
			if(!_tPoint){
				if(this.isMoveNow){
					this.dispatchEvent(new MyEvent(WizardKey.FirAction,[WizardKey.FirAction_StopMove]));
				}
				return true

			}
			else{
				if(skill.distance>100){	//如果是远程攻击
					this.dispatchEvent(new MyEvent(WizardKey.FirAction,[WizardKey.FirAction_MoveToTarget,_tPoint]));
				}
				else{//如果是近战
					_tPoint=_NTargetArgs[0].myWizardObject.getHoldPoint(this.x,this.y);
					this.dispatchEvent(new MyEvent(WizardKey.FirAction,[WizardKey.FirAction_MoveToTarget,_tPoint]));
				}
				return false;
			}
		}
		/**受到技能攻击*/
		public function acceptSkill(skill:Skill,args:Array):void
		{
			//[UID targetUid（目标UID）, byte result（技能结果: 0-闪避 1-命中 2-暴击）, int value（数值，负值为扣血，正值为加血）, ulong buffId（添加的BUFF索引）, byte physicEffect（物理效果: 0-无 1-击退 2-击飞 3-击倒）, MapPos deltaPos（偏移位置，有物理效果时才填充该值）] * n 			
			//计算血量
			if(Math.abs(args[2])>this.Creature_CurHp){
				this.Creature_CurHp=0;
			}
			else{
				this.Creature_CurHp+=args[2];
			}
			if(this.type==3) return;
			//处理物理效果
			if(args[4]==0){//无特理效果，只是受到攻击
				if(this.isMainActor){
					if(this.status==WizardKey.Status_Stand){//如果对象正在攻击中，则不被打断
						this.status=WizardKey.Status_Struck;
						this.playAction(ActionName.struck);
					}
				}
				else{
					this.status=WizardKey.Status_Struck;
					this.playAction(ActionName.struck);
				}

			}
			else if(args[4]==1){//击退
				physicalMove(new Point(args[5],args[6]),0);
			}
			else if(args[4]==2){//击飞
				physicalMove(new Point(args[5],args[6]),1);
			}else if(args[4]==3){//击倒
				this.playAction(ActionName.struckFall);
				MyDispatcher.getInstance().dispatch(WizardKey.FirAction_Bounce,this.Entity_UID);
			}
			//处理特效播放
			if(skill.struckEffect.length>1){
				this.dispatchEvent(new MyEvent(WizardKey.FirAction_PlayEffect,skill.struckEffect));
			}
			//处理破碎播放
			/*if(skill.struckBroken.length>1){
				MyDispatcher.getInstance().dispatch(WizardKey.FirAction_PlayEffect,[0,skill.struckBroken,this.Entity_UID]);
			}*/
			//处理溅血播放
			/*if(skill.struckBlood.length>1){
				MyDispatcher.getInstance().dispatch(WizardKey.FirAction_PlayEffect,[0,skill.struckBlood,this.Entity_UID]);
			}*/
			
			//处理音效播放
			if(skill.struckSound!="0"){
				MyDispatcher.getInstance().dispatch(WizardKey.FirAction_PlySound,["sound",skill.struckSound,0]);
			}
			//处理掉血数字
			MyDispatcher.getInstance().dispatch(WizardKey.FirAction_Damage,args);
			//处理BUFF
			if(args[3]!=0){
				this.dispatchEvent(new MyEvent(WizardKey.FirAction_AddBuff,args[3]));
			}
		}
		/**死亡*/
		public function dead():void
		{
			_IsFir=false;
			this.status=WizardKey.Status_Dead;
			MyDispatcher.getInstance().dispatch(WizardKey.FirAction_Dead, this.Entity_UID);
			if(this.type == WizardObject.TYPE_3)
			{
				MyDispatcher.getInstance().dispatch(WizardKey.FirAction_PlySound,["sound","Skill_posui2",0]);
				this.dispatchEvent(new MyEvent(WizardKey.FirAction_PlayEffect,["skill_struckxiangzi","zhaoji",0]));
			}
		}
		/**物理位移（击退，击飞）*/
		public function physicalMove(tPoint:Point,type:int=0):void
		{
			if(type==0){
				this.moveSpeed=24;
				this.playAction(ActionName.struckBack);
			}
			else if(type==1){
				this.moveSpeed=48;
				this.playAction(ActionName.struckPly);
			}
			this.nowTargetPoint= tPoint;
			this.countXY();
		}
		public function set isMainActor(value:Boolean):void
		{
			_IsMainActor = value;
		}
		public function get isMainActor():Boolean  {  return _IsMainActor;  }
		/** 当前使用的技能 **/
		public function get nowSkill():Skill  {  return _NowSkill;  }

		public function set wizardSkepHash(value:HashMap):void
		{
			_WizardSkepHash = value;
		}
		public function get wizardSkepHash():HashMap  {  return _WizardSkepHash;  }
		/**
		 * 是否在主城中
		 * @param value
		 */		
		public function set inCity(value:Boolean):void
		{
			_InCity = value;
		}
		public function get inCity():Boolean  {  return _InCity;  }
		
		override public function dispose():void
		{
			super.dispose();
			
			this.removeEventListener(WizardKey.Action_MoveStart,onMoveStart);		//开始移动执行
			this.removeEventListener(WizardKey.Action_Destination,onDestination);	//到底目标点后执行
			
			_FTargetArgs.length = 0;
			_FTargetArgs = null;
			_ETargetArgs.length = 0;
			_ETargetArgs = null;
			_NTargetArgs.length = 0;
			_NTargetArgs = null;
			_TargetPoint = null;
			_NowSkill = null;
			_NextSkillPoint = null;
			skillArgs.length = 0;
			skillArgs = null;
			_ComboArgs.length = 0;
			_ComboArgs = null;
			if(_WizardSkepHash)
				_WizardSkepHash.clear();
			_WizardSkepHash = null;
			if(_detectionTime)
			{
				_detectionTime.stop();
				_detectionTime.removeEventListener(TimerEvent.TIMER, onDetection);
			}
			_detectionTime = null;
			_skillHash.clear();
			_skillHash = null;
		}

	}
}