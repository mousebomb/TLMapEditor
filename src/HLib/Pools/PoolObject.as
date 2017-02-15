package HLib.Pools
{
	import flash.utils.getTimer;
	
	import tool.Pools.IPoolObject;
	
	public class PoolObject implements IPoolObject
	{
		private var _data:*;
		public var rt:uint;
		private var _startTime:uint;
		
		public function PoolObject(data:* = null, rt:uint = 300000):void
		{
			_startTime = getTimer();
			this._data = data;
			this.rt = rt;
		}
		
		public function resetTime():void
		{
			_startTime = getTimer();
		}
		
		public function get isPassDue():Boolean
		{
			if (rt == 0)
			{
				return false;
			}
			else
			{
				var tmpTime:uint = getTimer() - _startTime;
				if (tmpTime > rt)
				{
					return true;
				}
			}
			return false;
		}
		
		public function get data():*
		{
			resetTime();
			return _data;
		}
		
		public function set data(val:*):void
		{
			resetTime();
			_data = val;
		}
		
		protected function disposeData():void
		{
			/*if(data is Bitmap)
			{
				(data as Bitmap).bitmapData.dispose();
			}
			else if(data is BitmapData)
			{
				(data as BitmapData).dispose();
			}
			else if(data is Array || data is Dictionary)
			{
				for each (var subData:* in data)
				{
					disposeData(subData);
				}
			}
			else if(data is LoaderInfo)
			{
				LoaderInfo(data).loader.unloadAndStop();
			}
			else if (data is Loader)
			{
				Loader(data).unloadAndStop();
			}
			else if (data is IPoolObject)
			{
				data.dispose();
			}*/
		}
		
		public function initPoolObject(data:Object = null):void
		{
			
		}
		
		public function clearPoolObject():void
		{
			
		}
		
		public function dispose():void
		{
			disposeData();
			
			_data = null;
		}
	}
}