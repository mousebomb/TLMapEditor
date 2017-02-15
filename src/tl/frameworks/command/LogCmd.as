/**
 * Created by Administrator on 2017/2/13.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.frameworks.TLEvent;
	import tl.frameworks.model.LogModel;

	public class LogCmd extends Command
	{
		public function LogCmd()
		{
			super();
		}

		[Inject]
		public var e:TLEvent;
		[Inject]
		public var logModel:LogModel;

		override public function execute():void
		{
			logModel._log += e.data+"\n";
		}
	}
}
