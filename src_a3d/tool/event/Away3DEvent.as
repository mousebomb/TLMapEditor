package tool.event
{
	import flash.events.Event;
	
	public class Away3DEvent extends Event
	{
		public var data:Object;
		public function Away3DEvent(type:String, $data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = $data;
		}
	}
}