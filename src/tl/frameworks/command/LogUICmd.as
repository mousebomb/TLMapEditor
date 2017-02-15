/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.mapeditor.ui.window.LogUI;

	/**日志显示*/
	public class LogUICmd extends Command
	{
		public function LogUICmd()
		{
			super();
		}

		override public function execute():void
		{
			var ui :LogUI = new LogUI();
			contextView.addChild(ui);
		}
	}
}
