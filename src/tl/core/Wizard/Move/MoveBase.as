package tl.core.Wizard.Move
{
	import flash.geom.Vector3D;
	
	import away3d.errors.AbstractMethodError;
	
	import tool.Pools.IPoolObject;
	
	public class MoveBase implements IPoolObject
	{
//		public static const LINE_MOVE_TYPE:uint = 0;
		
//		public var cls_type:uint;
		
		protected var _startPos:Vector3D;
		protected var _endPos:Vector3D;
		protected var _distPos:Vector3D;
		
		protected var _rotateDirty:Boolean;
		protected var _rotate:Vector3D;
		
		protected var _curPos:Vector3D;
		
		protected var _isOver:Boolean;
		
		public function MoveBase()
		{
			_startPos = new Vector3D();
			_endPos = new Vector3D();
			_curPos = new Vector3D();
			_distPos = new Vector3D();
			
			_rotate = new Vector3D();
		}
		
		public function setVals(pos1:Vector3D, pos2:Vector3D):void
		{
			_startPos.setTo(pos1.x, pos1.y, pos1.z);
			_endPos.setTo(pos2.x, pos2.y, pos2.z);
			_distPos.setTo(pos2.x - pos1.x, pos2.y - pos1.y, pos2.z - pos1.z);
			
			_isOver = false;
		}
		
		public function setPos(x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number):void
		{
			_startPos.setTo(x1, y1, z1);
			_endPos.setTo(x2, y2, z2);
			_distPos.setTo(x2 - x1, y2 - y1, z2 - z1);
			
			_isOver = false;
		}
		
		public function get isOver():Boolean
		{
			return _isOver;
		}
		
		public function update():void
		{
			throw new AbstractMethodError("Move抽象方法");
		}
		
		public function get curPos():Vector3D
		{
			return _curPos;
		}
		
		// 从池中取出已有对象时触发
		public function initPoolObject(data:Object = null):void
		{
			
		}
		
		// 回收到池时触发 
		public function clearPoolObject():void
		{
			
		}
		
		public function dispose():void
		{
			
		}
		
		public function get rotateDirty():Boolean
		{
			return _rotateDirty;
		}
		
		public function get rotate():Vector3D
		{
			_rotateDirty = false;
			return _rotate;
		}
	}
}