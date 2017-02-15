package tl.core.DataSources
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	import tl.Net.MsgKey;

	public class Entity extends EventDispatcher
	{
		public var DataArray:Array;
		public var Entity_Type             : int      ;     //实体类型
	
    public var Entity_UID                    : Number    ;     //  0  0 Entity_UID                     实体UID

		
		public function Entity()
		{
		}
		
		//KeyArgs 服务端用二进制0/1来表示哪些数据需要更新
		public function RefreshEntity(data:ByteArray,_AttrList:Array):void{
			if(DataArray==null){
				DataArray=new Array(_AttrList.length);
			}			
			var _keyLength:int=data.readInt();
			var KeyArgs:Array=new Array();
			for(var i:int=0;i<int(_keyLength/4);i++){
				KeyArgs.push(data.readInt());
			}
			var ss:int=data.readInt();
			for(i=0;i<_AttrList.length;i++){
				//利用位与与位移算法来判断当前数据是否要更新
				if(int(KeyArgs[int(i>>5)]&(1<<(i&31)))!=0){
					ReadData(data,Attr.AttrType[_AttrList[i]],i);
				}
			}
			
        Entity_UID                    = DataArray[ 0]; //  0  0 实体UID

		}
		
		public function set EntityType(value:int):void{
			Entity_Type=value;
		}
		public function get EntityType():int{
			return Entity_Type;
		}
		public function ReadData(dataArgs:ByteArray,length:String,key:int):void{
			switch(length)
			{
				case MsgKey._int:
					DataArray[key]=dataArgs.readInt();
					break;
				case MsgKey._float:
					DataArray[key]=dataArgs.readFloat();
					break;
				case MsgKey._boolean:
					DataArray[key]=dataArgs.readBoolean();
					break;
				case MsgKey._byte:
					DataArray[key]=dataArgs.readByte();
					break;
				case MsgKey._double:
					DataArray[key]=dataArgs.readDouble();
					break;
				case MsgKey._String:
					DataArray[key]=dataArgs.readUTF();
					break;
				case MsgKey._unit:
					DataArray[key]=dataArgs.readUnsignedInt();
					break;
				default:
					DataArray[key]=dataArgs.readUTFBytes(int(length));
					break;
			}
		}
	}
}