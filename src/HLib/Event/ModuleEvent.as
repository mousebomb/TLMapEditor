package HLib.Event
{
	import starling.core.starling_internal;
	import starling.events.Event;

	use namespace starling_internal;

	public class ModuleEvent extends Event
	{
		public static const ModuleCommunication:String="ModuleCommunication";

		public function ModuleEvent(type:String,object:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, object);
		}




		/**
		 * 池子
		 *  因为操作不了private的 target，所以回收不彻底，会导致之前的显示对象短暂时间留存引用;
		 *  所以建议使用starling原生Event；用ModuleEvent只是为了兼容
		 * */
		private static var sEventPool:Vector.<ModuleEvent> = new <ModuleEvent>[];

		public static function fromPool(type:String,  data:Object=null):ModuleEvent
		{
			if (sEventPool.length) return (sEventPool.pop().starling_internal::reset(type, false, data) as ModuleEvent);
			else return new ModuleEvent(type, data,false);
		}

		public static function toPool(event:ModuleEvent):void
		{
			sEventPool[sEventPool.length] = event; // avoiding 'push'
		}

	}
}
