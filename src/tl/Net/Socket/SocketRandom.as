package tl.Net.Socket
{
	public class SocketRandom
	{
		private var _HoldRand:int;
		public function SocketRandom()
		{
		}
		public function srand(value:int):void{
			_HoldRand=value;
		}
		public function rand():int{
			return ((_HoldRand = _HoldRand * 214013+ 2531011) >> 16) & 0x7fff ;
		}
	}
}