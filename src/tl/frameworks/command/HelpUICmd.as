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
		public static var ui:HelpUI;
		public function HelpUICmd()
		{
			super();
		}

		override public function execute():void
		{
			if(!ui)
			{
				ui = new HelpUI();
			}
			if(ui.parent)
			{
				ui.parent.removeChild(ui)
			} 	else {
				contextView.addChild(ui);
			}
		}
	}
}
