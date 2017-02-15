package tl.core.Wizard
{
	import com.greensock.TweenMax;

	import flash.geom.Point;

	import tl.core.DataSources.Player;
	import tl.core.old.Node;

	public class WizardWalker extends Player
	{
		public var x:Number=0;
		public var y:Number=0;
		public var h:Number=0;
		public var angle:int=0;
		public var rotationX:int=0;
		public var rotationY:int=0;
		public var rotationZ:int=0;
		private var _DircArgs:Array=[0,7,6,5,4,3,2,1];							//2d到3D方向的转换，好像差了45度的样子，好奇怪的问题
		private var _CallBacks:Vector.<Function> = new Vector.<Function>();	//每帧执行回调方法	
		private var _Direc:int = 0;											//模型方向
		private var _TargetPath:Array;											//行走路径数组
		private var _NowTargetPoint:Point;										//当前目标点坐标
		private var _r:Number=0;												//圆的半径
		private var _xo:Number=0;		    									//圆心
		private var _yo:Number=0;		    									//圆心
		private var _xxuan:Number=0;											//正弦值
		private var _yxuan:Number=0;											//余弦值
		
		private var _IsAllowMove:Boolean = true;								//是否允许移动
		private var _IsMoveNow:Boolean = false;								//是否正在移动
		
		private var _MoveSpeed:int = 12;										//移动速度
		private var _StruckPlySpeed:int = 24;									//击飞速度
		
		public var circlePointArgs:Array=[];      								//周围8个点列表
		public var circlePointHoldArgs:Array=[];  								//周围8个点占领标识列表
		public function WizardWalker()
		{
		}
		/**
		 * 添加每帧执行回调方法
		 * @param value	: 执行方法
		 */		
		public function addCallBack(value:Function):void
		{
			var index:int = _CallBacks.indexOf(value);
			if(index > -1) return;
			_CallBacks.push(value);
		}
		/**
		 * 移除每帧执行回调方法
		 * @param value	: 执行方法
		 */		
		public function removeCallBack(value:Function):void
		{
			var index:int = _CallBacks.indexOf(value);
			if(index < 0) return;
			_CallBacks.splice(index, 1);
		}
		/** 清空回调方法 **/
		public function clearCallBacks():void  {  
			_CallBacks.length = 0;  
		}
		
		/** 每帧执行方法 **/
		public function onEnterFrame():void
		{
			refreshMove();	
			if(_CallBacks.length == 0) return;
			for each(var callBack:Function in _CallBacks)	callBack();
		}	
		/**
		 * 人物移动速度(默认12像素)
		 * @param value	: 移动速度
		 */		
		public function set moveSpeed(value:int):void
		{
			if(value < 1) value = 1;
			_MoveSpeed = value;
		}
		public function get moveSpeed():int  {  
			return _MoveSpeed;  
		}
		/**
		 * 设置模型方向
		 * @param value	: 模型方向
		 */		
		public function set direc(value:int):void
		{
			_Direc = value;
//			angle = 45*_DircArgs[value];//奇怪的问题，应该是直接45*value才对啊？45*value;
			this.dispatchEvent(new MyEvent(WizardKey.Action_DiecChange,angle));
		}
		public function get direc():int  {  
			return _Direc;  
		}
		/**
		 * 设置移动目标点
		 * @param value	: 目标点路径数组([point, point, point])
		 */		
		public function set targetPath(value:Array):void
		{
			if(!this.isAllowMove) return;
			_TargetPath = value;
			var _TargetNode:Node=_TargetPath.shift();
			_NowTargetPoint = new Point(_TargetNode.pointX,_TargetNode.pointY);	//获取第一个行走点
			_IsMoveNow=true;
			onMoveStart();
			//执行计算移动
			countXY();
			//执行方向改变
			countDirec();
		}
		public function get targetPath():Array  {  
			return _TargetPath;  
		}
		public function goonPath():void
		{
			if(!this.isAllowMove) return;
			if(_TargetPath.length<1) return;
			var _TargetNode:Node=_TargetPath.shift();
			_NowTargetPoint = new Point(_TargetNode.pointX,_TargetNode.pointY);	//获取第一个行走点
			//执行计算移动
			countXY();
			//执行方向改变
			countDirec();
		}
		/**
		 * 是否移动标识
		 * @param value	: true:执行移动 false:不执行移动
		 */
		public function set isAllowMove(value:Boolean):void  {  
			_IsAllowMove = value;  
		}
		public function get isAllowMove():Boolean  {  
			return _IsAllowMove;  
		}
/**************************************************** 私有方法 *************************************************/
		/** 移动计算 **/
		public function countXY():void
		{
			if(!_NowTargetPoint) return;
			var $x:Number = _NowTargetPoint.x;
			var $y:Number = _NowTargetPoint.y;
			
			var a:Number = Math.abs($x - this.x);     				//计算三角形的a边
			var b:Number = Math.abs($y - this.y);     				//计算三角形的b边
			var c:Number = Math.sqrt(Math.pow(a, 2) + Math.pow(b, 2));	//计算三角形的c边
			_xo = $x;	//圆心
			_yo = $y;	//圆心
			_r = c;		//半径
			_xxuan = (this.x - _xo)/_r;	//计算正弦值
			_yxuan = (this.y - _yo)/_r;	//计算余弦值
		}
		/**
		 * 执行计算方向
		 */		
		public function countDirec():void
		{
			if(!_NowTargetPoint) return;
			//当前目标点的位置
			var $x:Number = _NowTargetPoint.x;
			var $y:Number = _NowTargetPoint.y;
			//获取斜边与对边
			var nx:Number = $x - this.x;
			var ny:Number = $y - this.y;
			//计算斜边
			var r:Number = Math.sqrt(nx*nx+ny*ny);
			//计算cos
			var cos:Number = nx / r;
			//计算角度
			angle = int(Math.floor(Math.acos(cos)*180/Math.PI));	
			//角度转换
			if(ny < 0)	angle =- angle;
			//判断角度
			var nowDirec:int;
			if(angle > 337 || angle < 23)	nowDirec = 0;
			else if(angle > 292)		nowDirec = 1;
			else if(angle > 247)		nowDirec = 2;
			else if(angle > 202)		nowDirec = 3;
			else if(angle > 157)		nowDirec = 4;
			else if(angle > 112)		nowDirec = 5;
			else if(angle > 67)			nowDirec = 6;
			else						nowDirec = 7;
			if(nowDirec != direc)
			{
				direc = nowDirec;
				onDirecChange();	//调用方向改变事件
			}
			TweenMax.to(this, 0.5, {rotationY:angle});
		}
		/** 执行移动 **/
		public function refreshMove():void
		{
			if(_r <= 0) return;
			_r -= _MoveSpeed;           //缩小半径
			if(_r <= 0)
			{
				//如果移动到目标点了,执行下一个点移动
				if(_TargetPath&&_TargetPath.length > 0){
					goonPath();
				}
				else{	
					//如果不需要移动了则调用到达目标点方法
					_IsMoveNow=false;
					onDestination();
				}
			}
			else
			{
				this.x =_xo + _xxuan * _r;        //改变mc的X坐标
				this.y =_yo + _yxuan * _r;        //改变mc的Y坐标
			}
		}
		/** 强制停止移动 **/
		public function enforceStop():void{
			_r=0;
			_IsMoveNow=false;
			_NowTargetPoint=null;
			_TargetPath=null;
			onDestination();
		}
		public function refreshCirclePoint(distance:Number=100):void
		{
			circlePointArgs[0]=new Point(this.x+distance,this.y);
			circlePointArgs[1]=new Point(this.x+distance*Math.sin(45/180*Math.PI),this.y-distance*Math.cos(45/180*Math.PI));
			circlePointArgs[2]=new Point(this.x,this.y-distance);
			circlePointArgs[3]=new Point(this.x-distance*Math.sin(45/180*Math.PI),this.y-distance*Math.cos(45/180*Math.PI));
			circlePointArgs[4]=new Point(this.x-distance,this.y);
			circlePointArgs[5]=new Point(this.x-distance*Math.sin(45/180*Math.PI),this.y+distance*Math.cos(45/180*Math.PI));
			circlePointArgs[6]=new Point(this.x,this.y+distance);
			circlePointArgs[7]=new Point(this.x+distance*Math.sin(45/180*Math.PI),this.y+distance*Math.cos(45/180*Math.PI));
			for(var i:int=0;i<8;i++){
				circlePointHoldArgs[i]=0;
			}
		}
		public function refreshCircleDirec():void{
			for(var i:int=0;i<8;i++){
				circlePointHoldArgs[i]=0;
			}
		}
		public function getTargetDirec(tX:Number,tY:Number):int{
			//当前目标点的位置
			var $x:Number = tX;
			var $y:Number = tY;
			//获取斜边与对边
			var nx:Number = $x - this.x;
			var ny:Number = $y - this.y;
			//计算斜边
			var r:Number = Math.sqrt(nx*nx+ny*ny);
			//计算cos
			var cos:Number = nx / r;
			//计算角度
			angle = int(Math.floor(Math.acos(cos)*180/Math.PI));	
			//角度转换
			if(ny < 0)	angle = -angle;
			//判断角度
			var nowDirec:int;
			if(angle > 337 || angle < 23)	nowDirec = 0;
			else if(angle > 292)		nowDirec = 1;
			else if(angle > 247)		nowDirec = 2;
			else if(angle > 202)		nowDirec = 3;
			else if(angle > 157)		nowDirec = 4;
			else if(angle > 112)		nowDirec = 5;
			else if(angle > 67)			nowDirec = 6;
			else						nowDirec = 7;
			
			TweenMax.to(this, 0.3, {rotationY:angle});
			return nowDirec;
		}
		public function getHoldPoint(tX:Number,tY:Number):Point{
			if(_IsMoveNow){
				refreshCirclePoint();
			}
			var _Direc:int=this.getTargetDirec(tX,tY);
			var _Point:Point;
			if(circlePointHoldArgs[_Direc]==0){
				circlePointHoldArgs[_Direc]=1;
				_Point=circlePointArgs[_Direc];
				return _Point;
			}
			for(var i:int=0;i<8;i++){
				if(circlePointHoldArgs[i]==0){
					circlePointHoldArgs[i]=1;
					_Point=circlePointArgs[i];
					break;
				}
			}
			if(!_Point){
				_Point=circlePointArgs[_Direc];
			}
			return _Point;
		}
		/** 开始移动时执行此方法,需要用时重写 **/
		protected function onMoveStart():void  { 
			this.dispatchEvent(new MyEvent(WizardKey.Action_MoveStart));
		}
		/** 方向改变执行方法,需要用时重写 **/
		protected function onDirecChange():void  { 
			//this.dispatchEvent(new MyEvent(WizardKey.Action_DiecChange));
		}
		/** 到达目标点执行方法,需要用时重写 **/
		protected function onDestination():void  { 
			this.dispatchEvent(new MyEvent(WizardKey.Action_Destination));
		}
		
		public function get isMoveNow():Boolean
		{
			return _IsMoveNow;
		}
		
		public function set isMoveNow(value:Boolean):void
		{
			_IsMoveNow = value;
		}

		public function get nowTargetPoint():Point
		{
			return _NowTargetPoint;
		}

		public function set nowTargetPoint(value:Point):void
		{
			_NowTargetPoint = value;
		}

		public function dispose():void
		{
			_DircArgs.length = 0;
			_DircArgs = null;
			_CallBacks.length = 0;
			_CallBacks = null;
			if(_TargetPath)
				_TargetPath.length = 0;
			_TargetPath = null;
			_NowTargetPoint = null;
			circlePointArgs.length = 0;
			circlePointArgs = null;
			circlePointHoldArgs.length = 0;
			circlePointHoldArgs = null;
			
			_isDispose = true;
		}
		private var _isDispose:Boolean = false;
		public function get isDispose():Boolean { return _isDispose; }

	}
}