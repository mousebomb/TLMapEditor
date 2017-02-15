package HLib.WizardBase
{
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import HLib.Event.Dispatcher_F;
	import HLib.Event.Event_F;
	import HLib.Event.ModuleEventDispatcher;
	import HLib.MapBase.Node;
	import HLib.Pools.ObjectPools;
	
	import Modules.Wizard.WizardKey;
	import Modules.Wizard.Move.TweenObjectProxy;
	
	import away3d.core.math.MathConsts;
	
	public class WizardWalker extends WizardMark//Player
	{
		public var x:Number = 0;
		public var y:Number = 0;
/*
		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			if (_isMainActor)
			{
				this;
			}
			_y = value;
		}*/

		public var z:Number = 0;
		
		public var initAngle:int = 0;
		public var angle:int = 0;
		public var rotationX:int=0;
		public var rotationY:int=0;
		public var rotationZ:int=0;
		public var isTweenRocation:Boolean = true;								//是否使用tweenLite做rocation旋转
		
		private var _targetPath:Array;											//行走路径数组
		private var _nextPoint:Point;										//当前目标点坐标
		private var _r:Number=0;												//圆的半径
		private var _xo:Number=0;		    									//圆心
		private var _yo:Number=0;		    									//圆心
		private var _xxuan:Number=0;											//正弦值
		private var _yxuan:Number=0;											//余弦值
		protected var _IsMoveNow:Boolean = false;								//是否正在移动
		
		protected var _tweenProxy:TweenObjectProxy;

		public function get tweenProxy():TweenObjectProxy
		{
			return _tweenProxy;
		}

		/**
		 * 设置状态
		 * @param value	: WizardKey.as
		 */		
		public function set status(value:String):void	
		{
			_status = value;
		}
		
		public function get status():String	
		{ 
			return _status; 
		}
		private var _status:String="Status_Stand";
		
		/** 初始速度 **/
		public var MoveSpeedNow:int = 12;										//初始速度(此速度是用于一些例如击飞等效果还原用的速度,此值与初始设置的moveSpeed相同)
		
		public function WizardWalker()
		{  
			_tweenProxy = ObjectPools.getTweenProxy(this);//new TweenObjectProxy(this);
		}
		
		/**
		 * 设置移动目标点
		 * @param value	: 目标点路径数组([point, point, point])
		 */		
		public function set targetPath(value:Array):void
		{
			_targetPath = value;
			
			if(_targetPath == null || _targetPath.length < 1)
			{
				enforceStopAndDispatchEvent();
				return;
			}
			
			if(this.isDead) 
			{
				return;	//如果死亡了则不允许移动
			}
			
			if(this.isMainActor)
			{
				//世界地图显示路径
				ModuleEventDispatcher.getInstance().ModuleCommunication("worldMapShowPath", value);
				if(value.length > 0)
				{
					Dispatcher_F.getInstance().dispatch("changeStageFrameRate", 60);
					WizardKey.stageFrameRate[0] = 60;
				}
			}
			
			
			_lastTime = getTimer();
			
			_IsMoveNow = true;
			
			onMoveStart();
			
			goonPath();
		}
		
		public function get targetPath():Array  
		{  
			return _targetPath;  
		}
		
		/** 执行下一个点移动 **/
		private function goonPath():void
		{
			var tarNode:Node = _targetPath.shift();
			if(!_nextPoint)
			{
				_nextPoint = new Point(tarNode.pointX, tarNode.pointY);	//获取第一个行走点
			}
			else
			{
				_nextPoint.setTo(tarNode.pointX, tarNode.pointY);
			}
			//执行计算移动
			countXY();
			//执行方向改变
			countDirec();
			
			refreshMove();
		}
		
		/**************************************************** 私有方法 *************************************************/
		private var _lastTime:Number = 0;				//上一次时间
		//		private var _Frame:int=31;
		private  var _mvSpeed:Number = 12;
		public  var isWeltering:Boolean = false;		//是否在翻滚中
		
		//		private const TMP_VAL1:Number = 1 / (60 / 31);
		//		private const TMP_VAL2:Number = 1 / 1000;
		private const TMP_VAL:Number = 31 / 1000;
		private var _residueDist:Number = 0;
		
		/** 执行移动 **/
		public function refreshMove():void
		{
			if (_IsMoveNow == false)
			{
				return;
			}
			var nowTime:Number = getTimer();
			var perTime:Number = nowTime - _lastTime;
			_lastTime = nowTime;
			_mvSpeed = MoveSpeedNow * perTime * TMP_VAL;
			
			if (_residueDist)
			{
				_mvSpeed += _residueDist;
				_residueDist = 0;
			}
			_r -= _mvSpeed;
			
			if(_r <= 0)
			{
				//如果移动到目标点了,执行下一个点移动
				if(_targetPath && _targetPath.length > 0)
				{
					_residueDist = _mvSpeed;
					
					goonPath();
				}
				else
				{	
					//设置一下当前玩家的位置为目标位置
					if(_nextPoint)
					{
						this.x = _nextPoint.x;
						this.z = _nextPoint.y;
					}
					
					enforceStopAndDispatchEvent();
				}
			}
			else
			{
				this.x = _xo + _xxuan * _r;        //改变mc的X坐标
				this.z = _yo + _yxuan * _r;        //改变mc的Y坐标
				
				//判断是否为移动动作,当前正在移动时如果不是移动动作则执行播放移动
				if(_status != WizardKey.Status_Move && _status != WizardKey.Status_Attack && _status != WizardKey.Status_Dead) 
				{
					onMoveStart();
				}
			}
		}
		
		private static var _myPoint:Point = new Point;
		/** 移动计算 **/
		private function countXY():void
		{
			_xo = _nextPoint.x;
			_yo = _nextPoint.y;
			_myPoint.setTo(this.x, this.z)
			_r = Point.distance(_myPoint, _nextPoint);	//与目标点距离
			if(_r < 1)
			{
				if(_targetPath && _targetPath.length > 0)
				{
					goonPath();
				}
				else
				{
					enforceStopAndDispatchEvent();
				}
			}
			else
			{
				_xxuan = (this.x - _xo) / _r;	//计算正弦值
				_yxuan = (this.z - _yo) / _r;	//计算余弦值
			}
		}
		
		/**
		 * 执行计算方向
		 */		
		private function countDirec():void
		{
			if (_IsMoveNow == false)
			{
				return;
			}
			
			//获取斜边与对边
			var nx:Number = _nextPoint.x - this.x;
			var ny:Number = _nextPoint.y - this.z;
			
			var tmpa:Number = Math.atan2(ny, nx) * MathConsts.RADIANS_TO_DEGREES;
			
			if (tmpa < 0)
			{
				tmpa += 360;
			}
			//设置角度旋转方向
			setDirec(tmpa);
		}
		
		protected var _canRot:Boolean = true;
		/**
		 * 设置模型旋转方向
		 * @param $angle	: 角度
		 */		
		protected function setDirec(tmpAngle:int):void
		{
			if (this.rotationY == tmpAngle || _canRot ==  false)
			{
				return;
			}
			if(isTweenRocation)
			{
				TweenLite.killTweensOf(this);
				
				var tmpAngle1:Number = rotationY % 360;
				tmpAngle1 = tmpAngle1 < 0 ? 360 + tmpAngle1 : tmpAngle1;
				var tmpAngle2:Number = tmpAngle % 360;
				tmpAngle2 = tmpAngle2 < 0 ? 360 + tmpAngle2 : tmpAngle2;
				//判断当前角度与要改变的角度,做对应处理
				var flag:Boolean = Math.abs(tmpAngle1 - tmpAngle2) < 180;
				
				rotationY = tmpAngle1;
				if (flag)
				{
					TweenLite.to(this, 0.3, {rotationY:tmpAngle2});
				}
				else
				{
					if (tmpAngle2 > tmpAngle1)
					{
						TweenLite.to(this, 0.3, {rotationY:tmpAngle2 - 360});
					}
					else
					{
						TweenLite.to(this, 0.3, {rotationY:tmpAngle2 + 360});
					}
				}
			}
			else
			{
				this.rotationY = tmpAngle;
			}
		}
		
		public function enforceStopAll():void
		{
			enforceStopAndDispatchEvent();
			_tweenProxy.stop();
		}
		
		/** 强制停止移动 **/
		public function enforceStopAndDispatchEvent():void
		{
			if (_IsMoveNow)
			{
				enforceStop();
				
				onDestination();
			}
		}
		
		protected function enforceStop():void
		{
			_xo = 0;
			_yo = 0;
			_r = 0;
			_residueDist = 0;
			_IsMoveNow = false;
			_nextPoint = null;
			_targetPath = null;
		}
		
		public function setAngleFromXY(tX:Number, tY:Number):void
		{
			
			//获取斜边与对边
			var nx:Number = tX - this.x;
			var ny:Number = tY - this.z;
			
			var tmpa:Number = Math.atan2(ny, nx) * MathConsts.RADIANS_TO_DEGREES;
			
			if (tmpa < 0)
			{
				tmpa += 360;
			}
			
			angle = tmpa;
			//判断当前角度与要改变的角度,做对应处理
			setDirec(tmpa);
		}
		
		/** 开始移动时执行此方法,需要用时重写 **/
		protected function onMoveStart():void  
		{
			this.dispatchEvent(new Event_F(WizardKey.Action_MoveStart));
		}
		
		/** 到达目标点执行方法,需要用时重写 **/
		protected function onDestination():void  
		{ 
			isWeltering = false;
			this.dispatchEvent(new Event_F(WizardKey.Action_Destination));
			if(this.isMainActor)
			{
				//到达目标点以后减少帧率
				Dispatcher_F.getInstance().dispatch("changeStageFrameRate", 31);
				WizardKey.stageFrameRate[0] = 31;
			}
		}
		
		public function get isMoveNow():Boolean
		{
			return _IsMoveNow;
		}
		
		public function set isMoveNow(value:Boolean):void
		{
			_IsMoveNow = value;
		}
		
		override public function dispose():void
		{
			_targetPath = null;
			_nextPoint = null;
			
			ObjectPools.recycleTweenProxy(_tweenProxy);
			_tweenProxy = null;
			
			super.dispose();
		}
	}
}