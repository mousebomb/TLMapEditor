package tl.Net.Socket
{	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class Encoder
	{
		private var _byte:ByteArray = new ByteArray();	
		
		public function Encoder()
		{
		}
		
		
		public function str2Wstr(s:String):ByteArray
		{
			var L:int = s.length;
			var re:ByteArray = new ByteArray();
			
			for(var i:int = 0; i<L; i++)
			{
				var t:int = int(s.charCodeAt(i).toString(10));
				re.writeByte(t & 255);
				re.writeByte(t>>8);
			}
			re.writeByte(0);
			re.writeByte(0);
			return re;
		}
		
		private function writeWstr(s:String):void
		{
			var b:ByteArray = str2Wstr(s);
			
			//_byte.writeByte(AaronTokenType.TYPE_WIDESTR);
			_byte.writeInt(b.length);
			_byte.writeBytes(b,0,b.length);
			
		}
		
		public function getByte(order:Order):ByteArray
		{
			_byte.endian =  Endian.LITTLE_ENDIAN;
			_byte.writeShort(order.orderLength);
			_byte.writeShort(order.MsgType);
			_byte.writeShort(order.MsgId);
			//_byte.writeBytes(order.body,0,order.body.length);
			
//			writeInt(order.sourcePoint);
//			writeInt(order.endPoint);
//			writeInt(order.modlueKey);
//			writeInt(order.msgKey);
//			
//			var L:int = order.body.length;
//			for(var i:int = 0; i<L; i++)
//			{
//				var item:* = order.body[i];
//				
//				if(item is String) writeString(String(item))
//				else if(item is int) writeInt(int(item))
//				else if(item is Number) writeNum(Number(item))
//				else if(item is ByteArray) writeByte(item as ByteArray)
//				else if(item is WString)  writeWstr((item as WString).getStr())	
//				else throw new Error("AaronEncoder 参数类型有错误")
//			}
			return _byte;
		}
		
		private function writeInt(i:int):void
		{
			//_byte.writeByte(AaronTokenType.TYPE_INT);
			_byte.writeInt(i);
		}
		
		private function writeNum(n:Number):void
		{
			//_byte.writeByte(AaronTokenType.TYPE_FLOAT);
			_byte.writeFloat(n);
		}
		
		private function writeString(s:String):void
		{
			var b:ByteArray = new ByteArray();// = str2Wstr(s);
			b.writeUTFBytes(s);
			
			//_byte.writeByte(AaronTokenType.TYPE_STRING);
			//加一位的结束符
			_byte.writeInt(b.length+1);
			_byte.writeBytes(b,0,b.length);
			_byte.writeByte(0);
		}
		
		private function writeByte(b:ByteArray):void
		{
			//_byte.writeByte(AaronTokenType.TYPE_BINARY);
			_byte.writeInt(b.length);
			_byte.writeBytes(b,0,b.length);
		}
	}
}