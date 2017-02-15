 package HLib.Tool
{
	/**
	 * 功能开启判断类(游戏中所有功能开启状态类)
	 * @author 郑利本 
	 * ps:直接获取对应功能布尔值,true为开启状态,false为未开启状态
	 */	
	
	

	import Modules.DataSources.Quest;
	import Modules.DataSources.QuestSources;
	import Modules.Dungeon.manager.DungeonManager;
	import Modules.Map.HMapSources;
	
	import starling.events.EventDispatcher;
	
	public class FunctionOpen extends EventDispatcher
	{
		private static var _functionOpen:FunctionOpen;
		
		//************************任务到达开启状态*************************//
		/**镶嵌 */
		public var EquipMosaic:Boolean = false;			
		/**技能 */
		public var Skill:Boolean = false;					
		/**首充 */
		public var FirstPay:Boolean = false;				
		/**精采活动 */
		public var Activity:Boolean = false;				
		/** 开服七天*/
		public var Sevendays:Boolean = false;				
		/**副本大厅 */
		public var Hallpoints:Boolean = false;				
		/**强化 */
		public var EquipStreng:Boolean = false;			
		/**坐骑 */
		public var Mount:Boolean = false;					
		/**翅膀 */
		public var Wing:Boolean = false;					
		/**构装 */
		public var Packaging:Boolean = false; 		
		/**炼金 */
		public var Alchemist:Boolean = false; 		
		/**血脉 */
		public var EquiBlood:Boolean = false; 			
		/**时装 */
		public var Fashion:Boolean = false; 			
		/**好友 */
		public var Friends:Boolean = false;				
		/**阵营 */
		public var Camp:Boolean = false;			
		/**鉴定 */
		public var EquipAuthenticate:Boolean = false;			
		/**重铸*/
		public var EquipRecast:Boolean = false;	
		/**传承*/
		public var EquipInherit:Boolean = true;
		/**分解 */
		public var EquipResolve:Boolean = false;			
		/** 合成*/
		public var EquipCompound:Boolean = false;		
		/** 排行榜*/
		public var Rank:Boolean = false;
		/** 投资*/
		public var Invest:Boolean = false;
		/** 竞技场*/
		public var Arena:Boolean = false;
		/** 英雄成就*/
		public var Achieve:Boolean = false;
		/** Boss争夺*/
		public var BossFight:Boolean = false;
		/** 活跃度*/
		public var Daily:Boolean = false;
		/** 任务刷星*/
		public var InitQuest:Boolean = false;
		/** 要塞*/
		public var Fortress:Boolean = false;
		public var Fortress1:Boolean = false;
		public var Fortress2:Boolean = false;
		public var Fortress3:Boolean = false;
		public var Fortress4:Boolean = false;
		public var Fortress5:Boolean = false;
		public var Fortress6:Boolean = false;
		public var Fortress7:Boolean = false;
		public var Fortress8:Boolean = false;
		public var Fortress9:Boolean = false;
		/**器魂*/
		public var WeaponSoul:Boolean = false;
		/**战姬*/
		public var WarConcubine:Boolean = false;
		/**图鉴*/
		public var SoulBook:Boolean = false;
		/**签到*/
		public var Sign:Boolean;
		/**资源找回*/
		public var Retrieve:Boolean;
		/**小助手*/
		public var Assistant:Boolean;
		/**献祭*/
		public var Worship:Boolean;
		/**脉宠*/
		public var EquiBloodPet:Boolean;
		/**星阵*/
		public var StarArray:Boolean;
		/**至尊天下*/
		public var Becket:Boolean;
		/**启福*/
		public var Qifu:Boolean;
		//************************限时开启状态*************************//
		public var midAutumn:Boolean = false;				//中秋节活动
		private var _lengthArr:Array = [];					//可操作项列表
//		private var _dateHash:HashMap = new HashMap;		//已开放功能列表

		private var _isInit:Boolean;						//是否初始化标志
		public var DataActivity:Boolean
		public var NetherRemains:Boolean
		public var RushAbyss:Boolean
		public var LostTower:Boolean
		public var TeamLevel:Boolean
		public var VipLevel:Boolean
		public var ServicesBattleField:Boolean
		public var SealPlace:Boolean
		public var EndDayBattleField:Boolean
		public var GuardGoddess:Boolean
		public var MagicChess:Boolean
		public var AutoFighting:Boolean
		public var Socially:Boolean
		public var Mall:Boolean
		public var EquipmentView:Boolean				//装备视图
		public var SecondSkills:Boolean
		public var ThirdSkills:Boolean
		public var FusingItem:Boolean
		public var SkillRune:Boolean
		public var DailyCharge:Boolean
		public var Escort:Boolean;
		public var BranchGuide:Boolean;
		public var CampDonate:Boolean;
		public var CampSkillsGetting:Boolean;
		public var PetBloodPack:Boolean;
		public var Gold:Boolean; //天坛宝藏
		/**黄钻功能开放*/
		public var QQVip:Boolean = true;
		public function FunctionOpen()
		{
			if(_functionOpen)
				throw new Error("单例只能实例化一次,请用 getInstance() 取实例");
			_functionOpen = this;
		}
		
		public static function getInstance():FunctionOpen
		{
			if(!_functionOpen)
			{
				_functionOpen = new FunctionOpen();
			}
			return _functionOpen;
		}
		/**更新功能开放列表*/
		public function firstUpdateFunction():void
		{
			_lengthArr = [];
			var arr:Array = QuestSources.getInstance().functionHash.values;
			var leng:int = arr.length;
			for(var i:int=0; i<leng; i++)
			{
				if(arr[i].currentStep < 100)
				{
					if(arr[i].Name == "Camp")
					{
						if(HMapSources.getInstance().mainWizardObject.Player_QuestLevel > int(arr[i].QuestLv))
							this[arr[i].Name] = true;
						else if(HMapSources.getInstance().mainWizardObject.Player_QuestLevel == int(arr[i].QuestLv)) {
							var list:Array = String(arr[i].ExtraFactor).split("|");
							var quest:Quest = QuestSources.getInstance().getQuestByID(list[1]);
							if(quest)
							{
								if(quest.questState == 2)
									this[arr[i].Name] = true;
								else
									this[arr[i].Name] = false;
							}	else 
								this[arr[i].Name] = false;
						}	else 
							this[arr[i].Name] = false;
					}	else{
						if(!arr[i].Name == ""){
							this[arr[i].Name] = true;
						}
					}
						
						
//					date = SGCsvManager.getInstance().table_freshen.FindToObject(arr[i].Name);
//					if(date)
//						_dateHash.put(arr[i].Name, date);
//					if(arr[i].Name == "EquipMosaic")
//					{
//						EquipInherit = EquipResolve = EquipCompound = true; 
//						date = SGCsvManager.getInstance().table_freshen.FindToObject("EquipInherit");
//						if(date)
//							_dateHash.put("EquipInherit", date);
//						date = SGCsvManager.getInstance().table_freshen.FindToObject("EquipResolve");
//						if(date)
//							_dateHash.put("EquipResolve", date);
//						date = SGCsvManager.getInstance().table_freshen.FindToObject("EquipCompound");
//						if(date)
//							_dateHash.put("EquipCompound", date);
//					}
				}	else{
					if(!arr[i].Name == ""){
						this[arr[i].Name] = false;
					}
				}	
			}
//			_lengthArr = _dateHash.values;
			if(!_isInit)
				_isInit = true;
			this.dispatchEventWith("UpdateOpenFunction",false, arr[arr.length-1]);
			DungeonManager.getInstance().countTotalDungeonCount();
		}

		public function get lengthArr():Array
		{
			return _lengthArr;
		}

		/**是否初始化标志*/
		public function get isInit():Boolean
		{
			return _isInit;
		}

		public function set isInit(value:Boolean):void
		{
			_isInit = value;
		}

	}
}