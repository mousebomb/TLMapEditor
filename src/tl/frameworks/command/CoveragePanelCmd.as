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
		public function CoveragePanelCmd()
		{
		}

		override public function execute():void
		{
			var ui : CoveragePanelUI = new CoveragePanelUI();
			contextView.addChild(ui);
		}
	}
}
