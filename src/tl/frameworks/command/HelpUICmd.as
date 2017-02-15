/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.mapeditor.ui.window.HelpUI;

	/**快捷键显示*/
	public class HelpUICmd extends Command
	{
		public function HelpUICmd()
		{
			super();
		}

		override public function execute():void
		{
			var ui :HelpUI = new HelpUI();
			contextView.addChild(ui);
		}
	}
}
