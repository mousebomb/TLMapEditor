package tl.core.old
{
	import flash.events.Event;

	public class ModuleEvent extends Event
	{
		public static const ModuleCommunication:String="ModuleCommunication";
		
		public var data:Object;

		public function ModuleEvent(type:String, object:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, object);
			data = object;
		}
	}
}