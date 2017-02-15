package tl.core.Wizard.Move
{
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import HLib.MapBase.Node;
	
	public class WalkMove extends MoveBase
	{
		//		private static const 
		/** 初始速度 **/
		public var MoveSpeedNow:int = 12;										//初始速度(此速度是用于一些例如击飞等效果还原用的速度,此值与初始设置的moveSpeed相同)
		
		private var _tarPaths:Array;
		
		private var _state:uint;
		
		public function WalkMove()
		{
			super();
		}
		
		public function get tarPaths():Array
		{
			return _tarPaths;
		}
		
		private var _idx:int;
		public function set tarPaths(paths:Array):void
		{
			_tarPaths = paths;
			
			_isOver = false;
			
			if (_tarPaths.length >= 2)
			{
				var node1:Node = _tarPaths[0];
				var node2:Node = _tarPaths[1];
				setPos(node1.x, 0, node1.y, node2.x, 0, node2.y);
				
				_idx = 0;
				_state = 1;
			}
		}
		
		private function setNextNode():void
		{
			var node1:Node = _tarPaths[_idx];
			var node2:Node = _tarPaths[_idx + 1];
			setPos(node1.x, 0, node1.y, node2.x, 0, node2.y);
		}
		
		private var _lastTime:uint;
		private static const TMP_VAL:Number = 31 / 1000;
		override public function update():void
		{
			if (_state == 1)
			{
				if (_idx < _tarPaths.length - 2)
				{
					++_idx;
					setNextNode();
					countXY();
					countDirec();
					_state = 2;
				}
				else
				{
					_tarPaths = null;
					_state = 0;
					_isOver = true;
				}
			}
			else if (_state == 2)
			{
				var nowTime:uint = getTimer();
				var perTime:Number =  nowTime - _lastTime;
				
				var tmpSpeed:Number = MoveSpeedNow * perTime * TMP_VAL;
				
				_lastTime = nowTime;
				
				_r -= tmpSpeed;
				
				if(_r <= 0)
				{
					_curPos.setTo(_endPos.x, _endPos.y, _endPos.z);
					_state = 1;
				}
				else
				{
					_curPos.x = _startPos.x + _xxuan * _r;        //改变mc的X坐标
					_curPos.z = _startPos.z + _zxuan * _r;        //改变mc的X坐标
				}
			}
		}
		
		private var _r:Number;
		private var _xxuan:Number;
		private var _zxuan:Number;
		/** 移动计算 **/
		public function countXY():void
		{
			_r = Vector3D.distance(_startPos, _endPos);
			_xxuan = _distPos.x / _r;	//计算正弦值
			_zxuan = _distPos.z / _r;	//计算余弦值
		}
		
		/**
		 * 执行计算方向
		 */		
		protected function countDirec():void
		{
			//当前目标点的位置
			var $x:Number = _endPos.x;
			var $y:Number = _endPos.z;
			//获取斜边与对边
			var nx:Number = $x - _startPos.x;
			var ny:Number = $y - _startPos.z;
			//计算斜边
			var r:Number = Math.sqrt(nx*nx+ny*ny);
			//计算斜边
			var cos:Number = nx / r;
			//计算角度
			var angle:int = int(Math.floor(Math.acos(cos) * 180 / Math.PI));
			//角度转换
			if(ny < 0)
			{
				angle = 360 - angle;
			}
			
			if (_rotate.y != angle)
			{
				_rotateDirty = true;
				_rotate.y = angle;
			}
		}
	}
}