package HLib.Net.Socket
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import Modules.Common.MsgKey;

	public class Order extends ByteArray
	{
		public var orderLength:int;//消息长度
		public var MsgType:int;//目标端点
		public var MsgId:int;//目标模块码
		private var _bodyArray:Array;//消息体数组
		private var _bodyObject:Array;//消息体对象
		public function Order()
		{
			_tmpBytes.endian = Endian.LITTLE_ENDIAN;
			_tmpBytes1.endian = Endian.LITTLE_ENDIAN;
		}
		public function setMsgHead(_MsgType:int = 0, _MsgId:int = 0):void
		{
			MsgType=_MsgType;
			MsgId=_MsgId;				
			this.endian =  Endian.LITTLE_ENDIAN;
		}
		
		private var _tmpBytes1:ByteArray = new ByteArray();
		private var _tmpBytes:ByteArray = new ByteArray();
		public function writeBody(valueArray:Array):void
		{
			_tmpBytes.clear();
			orderLength = 4;
			var tmpLen:int = valueArray.length;
			for(var i:int = 0; i < tmpLen; ++i)
			{
				if(valueArray[i] is String)
				{ 
					_tmpBytes1.clear();
					_tmpBytes1.writeUTFBytes(valueArray[i]);
					
					_tmpBytes.writeShort(_tmpBytes1.length + 1);
					_tmpBytes.writeBytes(_tmpBytes1);
					_tmpBytes.writeByte(0);
				}
				else if(valueArray[i] is int)
				{
					_tmpBytes.writeInt(valueArray[i]);
				}
				else if(valueArray[i] is Number)
				{
					_tmpBytes.writeDouble(valueArray[i]);
				}
				else if(valueArray[i] is ByteArray)
				{
					_tmpBytes.writeBytes(valueArray[i]);
				}
				else if(valueArray[i] is Boolean) 
				{
					_tmpBytes.writeBoolean(valueArray[i]);
				}
				else 
				{
					throw new Error("AaronEncoder 参数类型有错误")
				}
			}
			orderLength += _tmpBytes.length;
			this.writeShort(orderLength);
			this.writeShort(MsgType);
			this.writeShort(MsgId);
			this.writeBytes(_tmpBytes);
		}
		
		public function addVariable(value:*):void
		{
			if((value is String) || (value is int) || (value is Number) || (value is ByteArray))
			{
				//this.push(value);
			}
			else
			{
				throw new Error("Order addVariable 传入的数据类型错误");
			}
		}

		public function ItoString():String
		{
			return "orderLength:" + orderLength +"  MsgType:" + MsgType + "  MsgId:" + MsgId+"  Boey:--";// + this.toString(); 
		}
		
		public function getMsgHead():void
		{
			if(this.bytesAvailable<4) 
			{
				return;
			}
			orderLength = this.bytesAvailable;
			MsgType = int(this.readShort());
			MsgId = int(this.readShort());
			//body=this.toString();
		}
		
//		public function get BodyArray():Array{
//			if(_bodyArray==null){
//				_bodyArray=GetBodyArray()
//			}
//			else{}
//		}
		public function GetBodyObject(DataLengthArray:Array,AttributeArray:Array):Object
		{
			var _Object:Object = new Object();			
			var bytes:int = this.bytesAvailable;
			var type:String;
			var i:int=0;

			while (bytes)
			{
				if(i>DataLengthArray.length-1) return _Object;
				type = DataLengthArray[i];
				//trace("type", type);

				switch(type)
				{
					case MsgKey._int:
						_Object.AttributeArray[i]=this.readInt();
						i++;
						break;
					case MsgKey._float:
						_Object.AttributeArray[i]=this.readFloat();
						i++;
						break;
					case MsgKey._boolean:
						_Object.AttributeArray[i]=this.readBoolean();
						i++;
						break;
					case MsgKey._byte:
						_Object.AttributeArray[i]=this.readByte();
						i++;
						break;
					case MsgKey._double:
						_Object.AttributeArray[i]=this.readDouble();
						i++;
						break;
					case MsgKey._String:
						_Object.AttributeArray[i]=this.readUTF();
						i++;
						break;
					default:
						_Object.AttributeArray[i]=this.readUTFBytes(int(type));
						i++;
						break;
				}
				bytes = this.bytesAvailable;
			}		
			return _Object;
		}
		public function GetBodyArray(DataLengthArray:Array):Array
		{
			var _Array:Array = new Array();			
			var bytes:int = this.bytesAvailable;
			var type:String;
			var i:int=0;
			while (bytes)
			{
				if(i>DataLengthArray.length-1) return _Array;
				type = DataLengthArray[i];				
				switch(type)
				{
					case MsgKey._int:
						_Array.push(this.readInt());
						i++;
						break;
					case MsgKey._float:
						_Array.push(this.readFloat());
						i++;
						break;
					case MsgKey._boolean:
						_Array.push(this.readBoolean());
						i++;
						break;
					case MsgKey._byte:
						_Array.push(this.readByte());
						i++;
						break;
					case MsgKey._double:
						_Array.push(this.readDouble());
						i++;
						break;
					case MsgKey._String:
						_Array.push(this.readUTF());
						i++;
						break;
					case MsgKey._short:
						_Array.push(this.readShort());
						i++;
						break;
					default:
						_Array.push(this.readUTFBytes(int(type)));
						i++;
						break;
				}
				bytes = this.bytesAvailable;
			}		
			return _Array;
		}
	}
}