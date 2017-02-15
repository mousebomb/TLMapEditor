package tl.core.Wizard
{
	import flash.events.Event;
	
	public class MyEvent extends Event
	{
		public var data:Object;
		public function MyEvent(type:String, $data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = $data;
		}
	}
}