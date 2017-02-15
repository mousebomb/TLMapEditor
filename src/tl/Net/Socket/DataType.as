package tl.Net.Socket
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class DataType
	{
		public static function Short(value:int):ByteArray
		{
			var _Short:ByteArray=new ByteArray();
			_Short.endian =  Endian.LITTLE_ENDIAN;
			_Short.writeShort(value);
			return _Short;
		}
		public static function Byte(value:int):ByteArray
		{
			var _Byte:ByteArray=new ByteArray();
			_Byte.endian =  Endian.LITTLE_ENDIAN;
			_Byte.writeByte(value);
			return _Byte;
		}
		public static function Int(value:int):ByteArray
		{
			var _Byte:ByteArray=new ByteArray();
			_Byte.endian =  Endian.LITTLE_ENDIAN;
			_Byte.writeInt(value);
			return _Byte;
		}
	}
}