/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.mapeditor.ui.window.CoveragePanelUI;

	/**图层面板*/
	public class CoveragePanelCmd extends Command
	{
		private static var ui:CoveragePanelUI
		public function CoveragePanelCmd()
		{
		}

		override public function execute():void
		{
			if(!ui)
			{
				ui = new CoveragePanelUI();
			}
			if(ui.parent)
			{
				ui.parent.removeChild(ui)
			}	else {
				contextView.addChild(ui);
			}

		}
	}
}
