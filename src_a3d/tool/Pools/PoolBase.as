package tool.Pools
{

	public class PoolBase
	{
		private var _objVec:Vector.<IPoolObject>;
		private var _maxSize:uint;
		private var _checkExists:Boolean;
		public function PoolBase(maxSize:uint = 100, checkExists:Boolean = true)
		{
			_objVec = new Vector.<IPoolObject>();
			_maxSize = maxSize;
			_checkExists = checkExists;
		}
		
		protected function getObject1(cls:Class, ...args):*
		{
			if (_objVec.length)
			{
				var obj:IPoolObject = _objVec.pop();
				obj.initPoolObject(args);
				return obj;
			}
			switch(args.length)
			{
				case 0:
				{
					return new cls();
					break;
				}
				case 1:
				{
					return new cls(args[0]);
					break;
				}
				case 2:
				{
					return new cls(args[0], args[1]);
					break;
				}
					
				case 3:
				{
					return new cls(args[0], args[1], args[2]);
					break;
				}
					
				case 4:
				{
					return new cls(args[0], args[1], args[2], args[3]);
					break;
				}
					
				default:
				{
					throw new Error("构造对象参数过多-->" + cls + "(" + args + ")");
					break;
				}
			}
		}
		
		protected function recycle1(obj:IPoolObject):void
		{
			if (obj == null)
			{
				return;
			}
			if (_checkExists && _objVec.indexOf(obj) != -1)
			{
				throw new Error("重复回收同一对象-->" + obj);
			}
			
			if (_objVec.length < _maxSize)
			{
				obj.clearPoolObject();
				_objVec.push(obj);
			}
			else
			{
				obj.dispose();
			}
		}
	}
}