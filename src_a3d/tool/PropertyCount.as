package tool
{
	import flash.utils.getTimer;

	public class PropertyCount
	{
		private static var MyInstance:PropertyCount;
		private var _hashMap:HashMap=new HashMap();
		private var _nodeNameVec:Vector.<String>=new Vector.<String>();
		private var _keyCountHashMap:HashMap=new HashMap();
		private var isOpen:Boolean=false;
		public function PropertyCount()
		{
			if( MyInstance ){
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			MyInstance=this;
		}
		public static function getInstance():PropertyCount 
		{
			if ( MyInstance == null ) 
			{				
				MyInstance = new PropertyCount();
			}
			return MyInstance;
		}
		public function startCount():void
		{
			isOpen=true;
		}
		public function stopCount():void
		{
			isOpen=false;
		}
		public function keyOnceStart(key:String,childKey:String,nodeKey:String="root"):void
		{
			if(!isOpen) return;	
			_hashMap.put(key+"_"+childKey+"_start",[nodeKey,getTimer()]);
		}
		public function keyOnceEnd(key:String,childKey:String,nodeKey:String="root"):void
		{
			if(!isOpen) return;
			if(!_hashMap.containsKey(key)){
				_hashMap.put(key,[nodeKey,0]);	
			}
			var sArgs:Array=_hashMap.get(key+"_"+childKey+"_start");
			if(sArgs){
				var nowCountTimer:Number=_hashMap.get(key)[1];
				nowCountTimer+=getTimer()-Number(sArgs[1]);
				_hashMap.put(key,[nodeKey,nowCountTimer]);
				_hashMap.remove(key+"_"+childKey+"_start");
			}
		}
		public function keyFilterStart(key:String,filterKey:String,nodeKey:String="root"):void
		{
			if(!isOpen) return;	
			var tArgs:Array=key.split(filterKey);
			keyStart(tArgs[0],nodeKey);
		}
		public function keyFilterEnd(key:String,filterKey:String,nodeKey:String="root"):void
		{
			var tArgs:Array=key.split(filterKey);
			keyEnd(tArgs[0],nodeKey);
		}
		public function keyStart(key:String,nodeKey:String="root"):void
		{
			if(!isOpen) 
			{
				return;	
			}
			_hashMap.put(key+"_start",[nodeKey,getTimer()]);
		}
		public function keyEnd(key:String,nodeKey:String="root"):void
		{
			if(!isOpen) return;
			if(!_hashMap.containsKey(key+"_start")) return;
			if(!_hashMap.containsKey(key)){
				_hashMap.put(key,[nodeKey,0]);	
			}
			if(_nodeNameVec.indexOf(nodeKey)<0){
				_nodeNameVec.push(nodeKey);
			}
			var nowCountTimer:Number=_hashMap.get(key)[1];
			nowCountTimer+=getTimer()-Number(_hashMap.get(key+"_start")[1]);
			_hashMap.put(key,[nodeKey,nowCountTimer]);
		}
		public function keyCount(Key:String,value:int):void
		{
			_keyCountHashMap.put(Key,value);
		}
		public function clearMe():void
		{
			_hashMap.clear();
			_nodeNameVec.length=0;
			_keyCountHashMap.clear();
			isOpen=false;
		}
		public function get log():String
		{
			var _log:String="------------------\n";
			var _nodeSArgs:Array=[];
			var _tS:String="";
			var _tA:Array;
			var _tI:int=-1;
			var _tKeyArgs:Array;
			for(var i:int=0;i<_hashMap.keys.length;i++)
			{
				_tS="";
				_tKeyArgs=_hashMap.keys[i].split("_");
				if(_tKeyArgs[_tKeyArgs.length-1]=="start") continue;
				_tA=_hashMap.get(_hashMap.keys[i]);
				_tS+="    -->"+_hashMap.keys[i]+">"+Number(_tA[1])+"\n";
				_tI= _nodeNameVec.indexOf(_tA[0]);
				if(_tI<0) continue;
				if(_nodeSArgs[_tI]){
					_nodeSArgs[_tI]+=_tS;
				}
				else{
					_nodeSArgs[_tI]=_tS;
				}
			}
			for(i=0;i<_nodeNameVec.length;i++){
				_log+=_nodeNameVec[i]+"\n";
				_log+=_nodeSArgs[i];
			}
			_log+="KeyCount\n"
			for(i=0;i<_keyCountHashMap.keys.length;i++){
				_log+="    -->"+_keyCountHashMap.keys[i]+">"+Number(_keyCountHashMap.get(_keyCountHashMap.keys[i]))+"\n";
			}
			return _log;
		}
	}
}