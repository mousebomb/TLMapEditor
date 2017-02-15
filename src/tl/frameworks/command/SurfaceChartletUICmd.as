/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.mapeditor.ui.window.SurfaceChartletUI;

	/**地表贴图面板*/
	public class SurfaceChartletUICmd extends Command
	{
		private static var ui :SurfaceChartletUI;
		public function SurfaceChartletUICmd()
		{
			super();
		}

		override public function execute():void
		{
			if(!ui)
			{
				ui = new SurfaceChartletUI();
			}
			if(ui.parent)
			{
				ui.parent.removeChild(ui);
			}	else {
				contextView.addChild(ui);
			}
		}
	}
}
