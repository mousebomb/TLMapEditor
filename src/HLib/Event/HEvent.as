package HLib.Event
{
	import starling.events.Event;

	public class HEvent extends Event
	{
		public static const Fps_Pulsating:String = "Fps_Pulsating";				//fps脉动事件
		public static const Fps_Dormancy:String = "Fps_Dormancy";				//fps休眠事件
		
		public function HEvent(type:String, data:Object=null, bubbles:Boolean=false)
		{
			super(type,bubbles,data);
		}
	}
}