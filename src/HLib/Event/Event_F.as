package HLib.Event
{
	import flash.events.Event;
	
	public class Event_F extends Event
	{		
		public var data:Object;
		public function Event_F(type:String,object:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data=object;
			super(type, bubbles, cancelable);
		}
	}
}