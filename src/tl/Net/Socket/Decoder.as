package tl.Net.Socket
{
	import flash.utils.ByteArray;		
	
	//解析
	public class Decoder
	{
		private var _value:Array;
		public function Decoder(){
			
		}
		public function getOrder(_byte:ByteArray):Order{
			//_byte.endian =  Endian.LITTLE_ENDIAN;
			var _Order:Order=new Order();
			_Order.orderLength=int(_byte.readShort());
			_Order.MsgType=int(_byte.readShort());
			_Order.MsgId=int(_byte.readShort());
			//_byte.readBytes(_Order.body=new ByteArray(),0,_byte.bytesAvailable);
			return 	_Order;
		}
//		private function wstr2utf(ba:ByteArray):String
//		{
//			var L:int = ba.length -2;//减去最后的两个结束符
//			L = L/2;
//			var re:String = "";
//			for(var i:int; i<L; i++)
//			{
//				var item:ByteArray = new ByteArray();
//				//刚好倒过来的 
//				item[0] = ba[1 + i*2];
//				item[1] = ba[0 + i*2];
//				//trace(item[0], item[1])
//				var t:int = int(item[0]<<8) + item[1];
//				re += String.fromCharCode(t);
//			}
//			return re;
//		}
//		
//		private function w2s(ba:ByteArray):String
//		{
//			if(ba.length >2) throw new Error("w2s参数不对");
//			var utf:ByteArray = new ByteArray();
//			utf[0] = 0xE0|(ba[0]>>4);
//			utf[1] = 0x80|((ba[0]&15)<<2 | ba[1]>>6);
//			utf[2] = 0x80|(ba[1]&0x3F);
//			trace(utf.toString(),"==>", ba[0],ba[1])
//			return utf.toString();
//		}
//		
//		
//		public function getValue(_byte:ByteArray):Array
//		{
//			_value = new Array();
//			
//			_byte.endian =  Endian.LITTLE_ENDIAN;
//			
//			var bytes:int = _byte.bytesAvailable;
//			var type:int;
//			var L:int;
//			
//			while (bytes)
//			{
//				type = _byte.readByte();
//				//trace("type", type);
//				
//				switch(type)
//				{
//					case AaronTokenType.TYPE_INT:
//						_value.push(_byte.readInt());
//						break;
//					case AaronTokenType.TYPE_FLOAT:
//						_value.push(_byte.readFloat());
//						break;
//					case AaronTokenType.TYPE_STRING:
//						L = _byte.readInt();
//						trace("String ",L)
//						_value.push(_byte.readUTFBytes(L));
//						break;
//					case AaronTokenType.TYPE_WIDESTR:
//						L = _byte.readInt();
//						var btte:ByteArray = new ByteArray();
//						_byte.readBytes(btte,0,uint(L));
//						_value.push(wstr2utf(btte));
//						break;
//					case AaronTokenType.TYPE_BINARY:
//						L = _byte.readInt();
//						var btte2:ByteArray = new ByteArray();
//						_byte.readBytes(btte2,0,uint(L));
//						_value.push(btte2);
//						break;
//				}
//				bytes = _byte.bytesAvailable;
//			}
//			return _value;
//		}
	}
}
