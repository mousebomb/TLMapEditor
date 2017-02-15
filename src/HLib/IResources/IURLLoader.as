package HLib.IResources
{
	import Base.Loading;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class IURLLoader extends URLLoader
	{
		private var GroupKey:int=-1;
		private var _GroupArray:Array=new Array;
		private var _GroupData:Array=new Array();
		private var _EventKey:String="";
		public function IURLLoader()
		{
			super();
		}
		public function ILoad(url:String,eventType:String="ILoader",context:LoaderContext=null):void{
			_EventKey=url;
			this.load(new URLRequest(_EventKey));
			if(GroupKey>-1&&GroupKey<_GroupArray.length){
				this.addEventListener(ProgressEvent.PROGRESS,onGroupProgress);
			}
			else{
				this.addEventListener(ProgressEvent.PROGRESS,onProgress);				
			}
			
			this.addEventListener(Event.COMPLETE,onComplete);
		}
		public function IGroupLoad(grouparray:Array):void{
			_GroupArray=grouparray;
			GroupKey=0;
			_EventKey=_GroupArray[GroupKey];
			this.ILoad(_EventKey);
			//			this.addEventListener(ProgressEvent.PROGRESS,onGroupProgress);
			//			this.addEventListener(Event.COMPLETE,onComplete);
		}
		private function onGroupProgress(e:ProgressEvent):void{
			Loading.getInstance().setGroupProgress(Number(e.bytesLoaded),Number(e.bytesTotal),Number(GroupKey),Number(_GroupArray.length-1));
		}
		private function onProgress(e:ProgressEvent):void{
			Loading.getInstance().setProgress(Number(e.bytesLoaded),Number(e.bytesTotal));
		}
		private function onComplete(e:Event):void{
			if(GroupKey<0){
				this.dispatchEvent(new ILoadEvent(_EventKey,(e.target as URLLoader).data));
			}else
			{			
				if(GroupKey<_GroupArray.length)
				{					
					_GroupData.push((e.target as URLLoader).data);
					GroupKey++;
					if(GroupKey==_GroupArray.length){
						GroupKey=-1;
						this.dispatchEvent(new ILoadEvent(ILoadEvent.GROUPCOMPLETE,_GroupData));						
					}
					else{
						this.ILoad(_GroupArray[GroupKey]);						
					}					
				}
			}
			
		}
	}
}