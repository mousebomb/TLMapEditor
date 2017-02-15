package tool.event
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import tool.MyError;
	
	public class Away3DDispatcher extends EventDispatcher
	{
		private static var _myDispatcher:Away3DDispatcher;
		
		public function Away3DDispatcher()
		{
			if(_myDispatcher) throw new MyError();
			_myDispatcher = this;
		}
		
		public static function getInstance():Away3DDispatcher
		{
			_myDispatcher ||= new Away3DDispatcher();
			return _myDispatcher;
		}
		
		override public function dispatchEvent(event:Event):Boolean
		{
			//添加log派发次数记录
			
			return super.dispatchEvent(event);
		}
		
		
	}
}