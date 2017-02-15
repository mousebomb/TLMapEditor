//package HLib.WizardBase
//{
//	/**
//	 * 模型实体,提供公用的方法,所有模型最基类
//	 * @author 李舒浩
//	 */	
//	import flash.geom.Point;
//	
//	import HLib.UICom.BaseClass.HSprite3D;
//	
//	public class WizardEntity extends HSprite3D
//	{
//		private var _CallBacks:Vector.<Function> = new Vector.<Function>();	//每帧执行回调方法	
//		private var _Direc:int = 0;		//模型方向
//		private var _TargetPath:Array;		//行走路径数组
//		private var _NowTarget:Point;		//当前目标点坐标
//		
//		private var _r:Number=0;			//圆的半径
//		private var _xo:Number=0;		    //圆心
//		private var _yo:Number=0;		    //圆心
//		private var _xxuan:Number=0;		//正弦值
//		private var _yxuan:Number=0;		//余弦值
//		
//		private var _IsAllowMove:Boolean = true;	//是否允许移动
//		private var _IsMoveNow:Boolean = false;	//是否正在移动
//		
//		private var _MoveSpeed:int = 12;	//移动速度
//		private var _FunctionArgs:Array=new Array();	//每帧执行方法组
//		
//		public function WizardEntity()  {  
//			super();  
//		}
//		
///**************************************************** 公共方法 *************************************************/
//		/**
//		 * 添加每帧执行回调方法
//		 * @param value	: 执行方法
//		 */		
//		public function addCallBack(value:Function):void
//		{
//			var index:int = _CallBacks.indexOf(value);
//			if(index > -1) return;
//			_CallBacks.push(value);
//		}
//		/**
//		 * 移除每帧执行回调方法
//		 * @param value	: 执行方法
//		 */		
//		public function removeCallBack(value:Function):void
//		{
//			var index:int = _CallBacks.indexOf(value);
//			if(index < 0) return;
//			_CallBacks.splice(index, 1);
//		}
//		/** 清空回调方法 **/
//		public function clearCallBacks():void  {  
//			_CallBacks.length = 0;  
//		}
//		
//		/** 每帧执行方法 **/
//		public function onEnterFrame():void
//		{
//			refreshMove();	
//			if(_CallBacks.length == 0) return;
//			for each(var callBack:Function in _CallBacks)	callBack();
//		}	
//		/**
//		 * 人物移动速度(默认12像素)
//		 * @param value	: 移动速度
//		 */		
//		public function set moveSpeed(value:int):void
//		{
//			if(value < 1) value = 1;
//			_MoveSpeed = value;
//		}
//		public function get moveSpeed():int  {  return _MoveSpeed;  }
//		/**
//		 * 设置模型方向
//		 * @param value	: 模型方向
//		 */		
//		public function set direc(value:int):void
//		{
//			_Direc = value;
//			var angle:int = 45*value;
//			this.rotationY = angle;
//		}
//		public function get direc():int  {  return _Direc;  }
//		/**
//		 * 设置移动目标点
//		 * @param value	: 目标点路径数组([point, point, point])
//		 */		
//		public function set targetPath(value:Array):void
//		{
//			if(!this.isAllowMove) return;
//			_TargetPath = value;
//			_NowTarget = _TargetPath.shift();	//获取第一个行走点
//			//执行计算移动
//			countXY();
//			//执行方向改变
//			countDirec();
//		}
//		public function get targetPath():Array  {  return _TargetPath;  }
//		/**
//		 * 是否移动标识
//		 * @param value	: true:执行移动 false:不执行移动
//		 */
//		public function set isAllowMove(value:Boolean):void  {  
//			_IsAllowMove = value;  
//		}
//		public function get isAllowMove():Boolean  {  
//			return _IsAllowMove;  
//		}
//		
///**************************************************** 私有方法 *************************************************/
//		/** 移动计算 **/
//		private function countXY():void
//		{
//			if(!_NowTarget) return;
//			var $x:Number = _NowTarget.x;
//			var $y:Number = _NowTarget.y;
//			
//			var a:Number = Math.abs($x - this.x);     				//计算三角形的a边
//			var b:Number = Math.abs($y - this.z);     				//计算三角形的b边
//			var c:Number = Math.sqrt(Math.pow(a, 2) + Math.pow(b, 2));	//计算三角形的c边
//			_xo = $x;	//圆心
//			_yo = $y;	//圆心
//			_r = c;		//半径
//			_xxuan = (this.x - _xo)/_r;	//计算正弦值
//			_yxuan = (this.z - _yo)/_r;	//计算余弦值
//		}
//		/**
//		 * 执行计算方向
//		 */		
//		private function countDirec():void
//		{
//			if(!_NowTarget) return;
//			//当前目标点的位置
//			var $x:Number = _NowTarget.x;
//			var $y:Number = _NowTarget.y;
//			//获取斜边与对边
//			var nx:Number = $x - this.x;
//			var ny:Number = $y - this.z;
//			//计算斜边
//			var r:Number = Math.sqrt(nx*nx+ny*ny);
//			//计算cos
//			var cos:Number = nx / r;
//			//计算角度
//			var angle:int = int(Math.floor(Math.acos(cos)*180/Math.PI));	
//			//角度转换
//			if(ny < 0)	angle = 360 - angle;
//			//判断角度
//			var nowDirec:int;
//			if(angle > 337 || angle < 23)	nowDirec = 0;
//			else if(angle > 292)		nowDirec = 1;
//			else if(angle > 247)		nowDirec = 2;
//			else if(angle > 202)		nowDirec = 3;
//			else if(angle > 157)		nowDirec = 4;
//			else if(angle > 112)		nowDirec = 5;
//			else if(angle > 67)			nowDirec = 6;
//			else						nowDirec = 7;
//			if(nowDirec != direc)
//			{
//				direc = nowDirec;
//				onDirecChange();	//调用方向改变事件
//			}
//		}
//		/** 执行移动 **/
//		private function refreshMove():void
//		{
//			if(_r <= 0) return;
//			_r -= _MoveSpeed;           //缩小半径
//			if(_r <= 0)
//			{
//				//如果移动到目标点了,执行下一个点移动
//				if(_TargetPath.length > 0)
//					_NowTarget = _TargetPath.shift();
//				else	//如果不需要移动了则调用到达目标点方法
//					_IsMoveNow=false;
//					onDestination();
//			}
//			else
//			{
//				this.x = this.myX = _xo + _xxuan * _r;        //改变mc的X坐标
//				this.z = this.myZ = _yo + _yxuan * _r;        //改变mc的Y坐标
//				_IsMoveNow=true
//			}
//		}
///**************************************************** 重写方法 *************************************************/
//		/** 方向改变执行方法,需要用时重写 **/
//		protected function onDirecChange():void  {  }
//		/** 到达目标点执行方法,需要用时重写 **/
//		protected function onDestination():void  {  }
//
//		public function get isMoveNow():Boolean
//		{
//			return _IsMoveNow;
//		}
//
//		public function set isMoveNow(value:Boolean):void
//		{
//			_IsMoveNow = value;
//		}
//
//
//	}
//}