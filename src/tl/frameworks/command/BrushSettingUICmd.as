/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.mapeditor.ui.window.BrushSettingUI;

	/**地形笔刷设置*/
	public class BrushSettingUICmd extends Command
	{
		public static var ui :BrushSettingUI;
		public function BrushSettingUICmd()
		{
			super();
		}

		override public function execute():void
		{
			if(!ui)
			{
				ui = new BrushSettingUI();
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
