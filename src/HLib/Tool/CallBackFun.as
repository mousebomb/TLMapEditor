package HLib.Tool
{
	public class CallBackFun
	{
		private var _funs:Vector.<Function>;
		
		public function CallBackFun()
		{
			_funs = new Vector.<Function>();
		}
		
		public function addFun(fun:Function):void
		{
			if (fun != null && _funs.indexOf(fun) == -1)
			{
				_funs.push(fun);
			}
		}
		
		public function removeFun(fun:Function):void
		{
			var idx:int = _funs.indexOf(fun);
			if (idx != -1)
			{
				_funs[idx] = _funs[_funs.length - 1];
				_funs.pop();
			}
		}
		
		public function exec(...args):void
		{
			for each (var fun:Function in _funs)
			{
				fun.apply(null, args);
			}
		}
		
		public function clear():void
		{
			_funs.length = 0;
		}
		
		public function dispose():void
		{
			_funs = null;
		}
	}
}