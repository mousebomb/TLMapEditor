package tl.Net.Socket
{		
	import flash.utils.ByteArray;

	public class Encoding
	{
		public var _AaronEncoder:Encoder=new Encoder();
		public var _AaronDecoder:Decoder=new Decoder();
		public function Encoding()
		{
			
		}
		
		public function encode(o:Order):ByteArray 
		{	
			return _AaronEncoder.getByte(o);
		}
		
		public function decode( b:ByteArray ):Order
		{
			return _AaronDecoder.getOrder(b);
		}
	}
}