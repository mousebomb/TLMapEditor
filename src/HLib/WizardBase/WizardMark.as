package HLib.WizardBase
{
	/**
	 * 精灵标识类,如死亡状态,乘骑状态,乘骑数据等
	 * @author 李舒浩
	 */	
	import Modules.DataSources.Player;
	
	public class WizardMark extends Player
	{
		private var _isDead:Boolean = false;

		/** 死亡状态,true:死亡 false:非死亡 **/
		public function get isDead():Boolean
		{
			return _isDead;
		}

		/**
		 * @private
		 */
		public function set isDead(value:Boolean):void
		{
			_isDead = value;
		}

		/** 是否战斗中(1:战斗中 0:非战斗中) **/
		public var isBattle:Boolean = false;
		
		private var _stealthType:int=0;
		/** 是否隐身中(0:非隐身中,1:隐身中 ,2:半隐身) **/
		public function get stealthType():int
		{
			return _stealthType;
		}
		/**
		 * @private
		 */
		public function set stealthType(value:int):void
		{
			if (_stealthType != value)
			{
				_stealthType = value;
			}
		}
		
		/** 是否无敌中(1:无敌 0:正常状态) **/
		public var isInvincible:Boolean = false;
		/** 是否限制移动(1:限制 0:非限制) **/
		public var buffRestrictionMove:Boolean = false;
		/** 是否限制使用技能(1:限制 0:非限制) **/
		public var buffRestrictionUseSkill:Boolean = false;
		/** 是否摆摊状态(1:摆摊 0:非摆摊) **/
		public var isStallNick:Boolean = false;
		/** 是否在献祭中(1:献祭中 0:非献祭中) **/
		public var isWorship:Boolean = false;
		/** 是否占领伊城(1:占领 0:没占领) **/
		public var isOccupation:Boolean = false;
		protected var _isTourCity:Boolean = false;

		/** 是否伊城城主(1:是 0:否) **/
		public var isSanto:Boolean = false;
		
		/**
		 *是否是城主 
		 */	
		public var ischengzhu:Boolean = false;
		/** 是否能使用技能  **/
		public var canUseSkill:Boolean = true;
		/** 是否可以移动,有技能释放中没结束的话不能移动 **/
		public var canMove:Boolean = true;	
		/** 坐骑资源ID **/
		public var mountResId:String = "0";
		private var _footprintsItemId:int;
		public var footPrintsItemIdStr:String;

		/** 坐骑足迹物品ID **/
		public function get footprintsItemId():int
		{
			return _footprintsItemId;
		}

		/**
		 * @private
		 */
		public function set footprintsItemId(value:int):void
		{
			_footprintsItemId = value;
			footPrintsItemIdStr = value.toString();
		}

		/** 坐骑挂式物品ID **/
		public var hangingIdItemId:String = "0";
		/** 是否在名字前面显示服务器号 **/
		public var isShowCurWorldId:Boolean = true;
		protected var _inMyEyes:Boolean = false;
		
		/** 是否试用技能击中了目标 true:已经击中 false:未击中 **/
		public var isUseSkillHit:Boolean = true;
		/** 是否在试用技能过程中 **/
		public var isDriveingSkill:Boolean = false;
		public var killerUid:Number = 0;
		
		public var masterName:String="";
		
		/** 选中精灵UID **/
		public function set selectWizardUID(value:Number):void
		{
			if(!_isMainActor)
			{
				return;
			}
			_selectWizardUID = value;
		}
		
		public function get selectWizardUID():Number 
		{  
			return _selectWizardUID;  
		}
		private var _selectWizardUID:Number = 0;
		
		/** 是否为主角 **/
		public function set isMainActor(value:Boolean):void
		{ 
			_isMainActor = value; 
		}
		public function get isMainActor():Boolean 
		{
			return _isMainActor;
		}
		protected var _isMainActor:Boolean = false;
		
		/** 竞技场排名 **/
		public var arenaRank:int = 0;
		
		/** 是否骑乘状态 **/
		public function get isRide():Boolean 
		{  
			return _isRide;
		}
		public function set isRide(value:Boolean):void 
		{ 
			_isRide = value;
		}
		protected var _isRide:Boolean;
		
		/** 是否穿上了翅膀 **/
		public function get isHasWings():Boolean 
		{ 
			return _isHasWings; 
		}
		protected var _isHasWings:Boolean;
		
		public function WizardMark() 
		{
			super();
		}
	}
}