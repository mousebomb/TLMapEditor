/**
 * Created by gaord on 2017/2/7.
 */
package tl.frameworks
{
	import flash.events.Event;

	public class TLEvent extends Event
	{
		public var data:*;
		public function TLEvent(type :String , data :* )
		{
			super (type,false,false);
			this.data = data;

		}
	}
}
