package HLib.Pools
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import tool.StageFrame;

	public class AutoCountPoolBase extends EventDispatcher
	{
		
		public function AutoCountPoolBase()
		{
			StageFrame.addGameFun(onCheckPool);
		}
		
		protected function checkPoolObject():void
		{
			
		}
		
		private var _checkKeep:uint;
		private function onCheckPool(evt:Event = null):void
		{
			if (++_checkKeep > 60)
			{
				_checkKeep = 0;
				
				checkPoolObject();
			}
		}
		
		public function dispose():void
		{
			StageFrame.removeGameFun(onCheckPool);
		}
	}
}