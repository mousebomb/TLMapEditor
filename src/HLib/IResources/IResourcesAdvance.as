package HLib.IResources
{
	import HLib.Tool.HLog;	
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;

	public class IResourcesAdvance
	{
		private static var MyInstance:IResourcesAdvance;
		private var _loader:Loader;
		private var _ResArgs:Array;
		private var _NowResName:String;
		private var _IsInIt:Boolean=false;
		private var _delayArgs:Array = [];
		private var _errorLength:int;
		private var _time:int;
		public var addOnce:int;
		public function IResourcesAdvance()
		{
			if( MyInstance ){
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			MyInstance=this;
		}
		public static function getInstance():IResourcesAdvance{
			if(!MyInstance){
				MyInstance=new IResourcesAdvance();	
			}
			return MyInstance;
		}
		public function Initial():void{
			var _List:Array=[
				"BF_Fir",
				"WorldMap",
				"AreaMap11",
				"Maps_Barrier_Lt",
				"M_Yinying",
				"Skill_1001",
				"Skill_1011_sf",
				"Skill_1011_fx",
				"Skill_1011_sj",
				"Skill_4001_sj",
				"Skill_4002_sj",
				"Skill_4003_sf",
				"Skill_4003_fx",
				"Skill_4003_sj",
				"Skill_4004_sf",
				"Skill_4004_fx",
				"Skill_4004_sj",
				"M_Bailonglu",
				"M_Elang",
				"Skill_Against",
				"S_Longtan",
				"Maps_Barrier_Dss2",
				"Monsterimage1",
				"Roleimage",
				"Candysta",
				"Maps_Shangu",
				"M_Heiyidh",
				"Maps_Barrier_Yps",
				"S_Yuping",
				"Maps_Gongdian",
				"S_Qingdiyuan",
				"Maps_Dongfu",
				"AreaMap12",
				"Buddyimage1"
			];
			_ResArgs=new Array();
			for(var i:int=0;i<_List.length;i++){
				_ResArgs.push(_List[i]);
			}
			Next();
			_IsInIt=true;
		}
		public function InIt():void{
//			if(_IsInIt) return;
//			_ResArgs=SGCsvManager.getInstance().table_advance.FindColumn("Name");
//			_ResArgs.shift();
//			_ResArgs.shift();
//			_ResArgs.pop();
//			_IsInIt=true;
//			delayLoadNext()
			/*Next();*/
		}
		private function Next():void{
			if(_ResArgs==null) return;
			if(addOnce > 1)
			{
				delayLoadNext();
			}	else {
				if(_ResArgs.length > 0) 
				{
					_NowResName=_ResArgs.shift();
				}	else {
					if(_delayArgs.length > 0)
					{
						if(_errorLength == _delayArgs.length)
						{
							if(_time > 1)
								return;
							else
								_time ++;
						}
						_errorLength = _delayArgs.length;
						_NowResName=_delayArgs.shift();
					}	else 
						return;
				}
				if(IResourcePool.getInstance().getResource(_NowResName)==null){
					if(_NowResName.length > 0)
						loaderSource()
				}else{
					Next();
				}
			}
		}
		private function loaderSource():void
		{
			_loader = new Loader;
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			_loader.load(new URLRequest(IResourceManager.getInstance().Config.ResourceUrl+"assets/"+_NowResName+".swf" + IResourcePool.getInstance().getVersion(_NowResName)));
			HLog.getInstance().appMsg("Loading "+_NowResName+" in IResourcesAdvance go");
		}
		private function onComplete(e:Event):void{
			HLog.getInstance().appMsg(_NowResName+" has loaded in IResourcesAdvance.");
			IResourcePool.getInstance().addResource(_NowResName,e.target as LoaderInfo);
			Next();
		}
		private function onError(e:IOErrorEvent):void {
			_delayArgs.push(_NowResName);
			HLog.getInstance().appMsg("找不到加载需要的资源文件！Loading "+_NowResName +"    There was an errorin IResourcesAdvance.");
			Next();
		}
		public function AddRes(key:String):void{
			var _Index:int=_ResArgs.indexOf(key);
			if(_Index>-1) return;
			if(_ResArgs.length>0){
				_ResArgs.push(key);
			}
			else{
				_ResArgs.push(key);
				Next();
			}

		}
		public function TakeOver(key:String):void{
			if(_ResArgs==null) return;
			if(_ResArgs.length<1) return;
			var _Index:int=_ResArgs.indexOf(key);
			if(_Index<0)return;
			if(_NowResName==key){
				_loader.close();
				_loader.removeEventListener(IResourceEvent.Complete,onComplete);
				HLog.getInstance().appMsg(_NowResName+" be take overin IResourcesAdvance.");
				Next();
				return;
			}
			
		}
		private function delayLoadNext():void
		{
			setTimeout(Next,2000);
		}
		public function RefAI():void{
			RefAI_Fir();
			RefAI_Tower();
			RefAI_Abyss();
		}
		public function RefAI_Fir():void{
			
		}
		public function RefAI_Tower():void{
			
		}
		public function RefAI_Abyss():void{
			
		}
	}
}