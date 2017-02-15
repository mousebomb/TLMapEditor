/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.mapeditor.ui.window.ZoneSettingUI;

	/**区域设置*/
	public class ZoneSettingUICmd extends Command
	{
		public static var ui :ZoneSettingUI
		public function ZoneSettingUICmd()
		{
			super();
		}
		override public function execute():void
		{
			if(!ui)
			{
				ui = new ZoneSettingUI();
			}
			if(!ui.parent)
			{
				contextView.addChild(ui);
			}	else {
				ui.parent.removeChild(ui);
			}

		}
	}
}
