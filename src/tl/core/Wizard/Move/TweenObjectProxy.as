package tl.core.Wizard.Move
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import tool.Pools.IPoolObject;
	
	public class TweenObjectProxy implements IPoolObject
	{
		private var _tarObj:*;
		
		public function get tarObj():*
		{
			return _tarObj;
		}
		
		public function set tarObj(value:*):void
		{
			_tarObj = value;
		}
		
		
		public function TweenObjectProxy(obj:*)
		{
			_tarObj = obj;
		}
		
		public function get x():Number
		{
			return _tarObj.x;
		}
		
		public function set x(val:Number):void
		{
			if (isNaN(val))
			{
				val = 0;
			}
			_tarObj.x = val;
		}
		
		public function get y():Number
		{
			return _tarObj.y;
		}
		
		public function set y(val:Number):void
		{
			if (isNaN(val))
			{
				val = 0;
			}
			_tarObj.y = val;
		}
		
		
		public function get z():Number
		{
			return _tarObj.z;
		}
		
		public function set z(val:Number):void
		{
			if (isNaN(val))
			{
				val = 0;
			}
			_tarObj.z = val;
		}
		
		
		public function get scaleX():Number
		{
			return _tarObj.scaleX;
		}
		
		public function set scaleX(val:Number):void
		{
			if (isNaN(val))
			{
				val = 0.0001;
			}
			_tarObj.scaleX = val;
		}
		
		
		public function get scaleY():Number
		{
			return _tarObj.scaleY;
		}
		
		public function set scaleY(val:Number):void
		{
			if (isNaN(val))
			{
				val = 0.0001;
			}
			_tarObj.scaleY = val;
		}
		
		
		public function get scaleZ():Number
		{
			return _tarObj.scaleZ;
		}
		
		public function set scaleZ(val:Number):void
		{
			if (isNaN(val))
			{
				val = 0.0001;
			}
			_tarObj.scaleZ = val;
		}
		
		public function get alpha():Number
		{
			return _tarObj.alpha;
		}
		
		public function set alpha(val:Number):void
		{
			if (isNaN(val))
			{
				val = 0;
			}
			_tarObj.alpha = val;
		}
		
		public function to(delay:Number, data:Object):void
		{
			if (_tarObj)
			{
				TweenLite.to(this, delay, data);
			}
		}
		
		public function maxTo(delay:Number, data:Object):void
		{
			if (_tarObj)
			{
				TweenMax.to(this, delay, data);
			}
		}
		
		public function stop():void
		{
			if (_tarObj)
			{
				TweenLite.killTweensOf(this);
				TweenMax.killTweensOf(this);
			}
		}
		
		// 从池中取出已有对象时触发
		public function initPoolObject(data:Object = null):void
		{
			_tarObj = data[0];
		}
		
		// 回收到池时触发 
		public function clearPoolObject():void
		{
			if (_tarObj)
			{
				TweenLite.killTweensOf(this);
				TweenMax.killTweensOf(this);
				
				_tarObj = null;
			}
		}
		
		public function dispose():void
		{
			clearPoolObject();
		}
	}
}