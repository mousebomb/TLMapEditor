package tl.core.Wizard
{
	import flash.events.Event;
	
	public class WizardEvent extends Event
	{
		public static const UPDATE_DATA:String = "WizardEvent_UpdateData";
		
		public static const UPDATE_HP:String = "WizardEvent_UpdateHp";
		
		public function WizardEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new WizardEvent(type, bubbles, cancelable);
		}
	}
}