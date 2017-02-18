/**
 * Created by Administrator on 2017/2/17.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.mapeditor.ui.window.StatisticsUI;
	/**统计界面*/
	public class StatisticsCmd extends Command
	{
		private static var ui:StatisticsUI;
		public function StatisticsCmd()
		{
			super();
		}

		override public function execute():void
		{
			if(!ui)
			{
				ui = new StatisticsUI();
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
