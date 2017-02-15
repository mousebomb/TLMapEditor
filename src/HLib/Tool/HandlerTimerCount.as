package HLib.Tool
{
	import flash.utils.getTimer;

	public class HandlerTimerCount
	{
		private var timerArgs:Array=new Array();
		private var index:int=0;
		public function HandlerTimerCount()
		{
		}
		public function getTimerOnce(key:String):void{
			if(timerArgs.length==0){
				timerArgs.push([key,getTimer()]);
			}
			else{
//				var mTimer:Number=getTimer()-timerArgs[timerArgs.length-1][1];
//				timerArgs.push([key,mTimer]);
				timerArgs.push([key,getTimer()]);
			}

		}
		public function clearArgs():void{
			timerArgs.length=0;
		}
		public function showOnHLog():void{
			if(index<10){
				index++;
				return;
			}
			index=0;
			//HLog.getInstance().addLog("------------------");
			trace("------------------");
			for(var i:int=0;i<timerArgs.length;i++){
				if(i==0){
					//HLog.getInstance().addLog("##>>"+timerArgs[i][0]+">"+0);
					trace("##>>"+timerArgs[i][0]+">"+0);
				}
				else{
					//HLog.getInstance().addLog("##>>"+timerArgs[i][0]+">"+timerArgs[i][1]);
					trace("##>>"+timerArgs[i][0]+">"+Number(timerArgs[i][1]-timerArgs[i-1][1]));
				}
			}
		}
	}
}