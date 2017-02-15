package tl.Net.Socket
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import tl.Net.MsgKey;

	public class Order extends ByteArray
	{
		public var orderLength:int;//消息长度
		public var MsgType:int;//目标端点
		public var MsgId:int;//目标模块码
		private var _bodyArray:Array;//消息体数组
		private var _bodyObject:Array;//消息体对象
		public function Order(){}
		public function setMsgHead(_MsgType:int = 0, _MsgId:int = 0):void
		{
			MsgType=_MsgType;
			MsgId=_MsgId;				
			this.endian =  Endian.LITTLE_ENDIAN;
		}
		public function writeBody(valueArray:Array):void{
			orderLength=4;
			for(var i:int=0;i<valueArray.length;i++){
				if(valueArray[i] is String){ 
					var _byte:ByteArray=new ByteArray();
					_byte.endian=Endian.LITTLE_ENDIAN;
					_byte.writeUTFBytes(valueArray[i]);
					orderLength+=_byte.length+3;
					_byte=null;
				}
				else if(valueArray[i] is int) orderLength+=4;
				else if(valueArray[i] is Number) orderLength+=8;
				else if(valueArray[i] is ByteArray) orderLength+=valueArray[i].length;
				else if(valueArray[i] is Boolean)  orderLength+=1;
				else throw new Error("AaronEncoder 参数类型有错误")
			}
			this.writeShort(orderLength);
			this.writeShort(MsgType);
			this.writeShort(MsgId);
			for(i=0;i<valueArray.length;i++){
				if(valueArray[i] is String) writeLength(valueArray[i],valueArray[i].length);
				else if(valueArray[i] is int) this.writeInt(int(valueArray[i]));
				else if(valueArray[i] is Number) this.writeDouble(Number(valueArray[i]));
				else if(valueArray[i] is ByteArray) this.writeBytes(valueArray[i] as ByteArray);
				else if(valueArray[i] is Boolean)  this.writeBoolean(Boolean(valueArray[i]));
				else throw new Error("AaronEncoder 参数类型有错误")
					
//				switch(valueArray[i][0])
//				{
//					case MsgKey._int:
//						this.writeInt(valueArray[i][1]);
//						break;
//					case MsgKey._float:
//						this.writeFloat(valueArray[i][1]);
//						break;
//					case MsgKey._boolean:
//						this.writeBoolean(valueArray[i][1]);
//						break;
//					case MsgKey._byte:
//						this.writeByte(valueArray[i][1]);
//						break;
//					case MsgKey._double:
//						this.writeDouble(valueArray[i][1]);
//						break;
//					case MsgKey._String:
//						this.writeUTFBytes(valueArray[i][1]);
//						break;
//					case MsgKey._short:
//						this.writeShort(valueArray[i][1]);
//						break;
//					default:
//						this.writeLength(valueArray[i][1],int(valueArray[i][0]));
//						this.writeByte(0);
//						break;
//				}
			}
		}
		public function writeLength(value:String,length:int):void{
			var num:int=length-value.length;
			var _byte:ByteArray=new ByteArray();
			_byte.endian=Endian.LITTLE_ENDIAN;
			_byte.writeUTFBytes(value);
			this.writeShort(_byte.length+1);			
			this.writeUTFBytes(value);
			if(num>0){
				for(var i:int=0;i<num;i++){
					this.writeByte(0);
				}
			}
			this.writeByte(0);
			_byte=null;
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
		public function getMsgHead():void{
			if(this.bytesAvailable<4) return;
			orderLength=this.bytesAvailable;
			MsgType=int(this.readShort());
			MsgId=int(this.readShort());
			//body=this.toString();
		}
//		public function get BodyArray():Array{
//			if(_bodyArray==null){
//				_bodyArray=GetBodyArray()
//			}
//			else{}
//		}
		public function GetBodyObject(DataLengthArray:Array,AttributeArray:Array):Object{
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
		public function GetBodyArray(DataLengthArray:Array):Array{
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