package tool
{
	import flash.events.EventDispatcher;

	public class FrameWorkerBase extends EventDispatcher
	{
		private var _vecs:Vector.<Function>;
		private var _isPlay:Boolean = true;
		
		public function FrameWorkerBase()
		{
			_vecs = new Vector.<Function>();
			
			StageFrame.addFrameWorker(this);
		}
		
		public function get isStart():Boolean
		{
			return _isPlay;
		}
		
		public function start():void
		{
			_isPlay = true;
			StageFrame.addFrameWorker(this);
		}
		
		public function stop():void
		{
			_isPlay = false;
			StageFrame.removeFrameWorker(this);
		}
		
		protected function addFun_1(fun:Function):void
		{
			var idx:int = _vecs.indexOf(fun);
			if (idx == -1)
			{
				_vecs.push(fun);
				_vecDirty = true;
			}
		}
		
		private var _vecDirty:Boolean;
		
		protected function removeFun_1(fun:Function):void
		{
			var idx:int = _vecs.indexOf(fun);
			if (idx != -1)
			{
				_vecs[idx] = _vecs[_vecs.length - 1];
				_vecs.pop();
				_vecDirty = true;
			}
		}
		
		public function hasFun(fun:Function):Boolean
		{
			return _vecs.indexOf(fun) != -1;
		}
		
		public function update():void
		{
			if (_isPlay == false)
			{
				return;
			}
			var len:uint = _vecs.length;
			for (var i:int = 0; i < len; ++i)
			{
				_vecs[i]();
				if (_vecDirty)
				{
					len = _vecs.length;
					_vecDirty = false;
				}
			}
		}
		
		public function clearVec():void
		{
			stop();
			_vecs.length = 0;
		}
		
		public function get length():uint
		{
			return _vecs.length;
		}
		
		public function dispose():void
		{
			clearVec();
			_vecs = null;
		}
	}
}