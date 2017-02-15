/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.mapeditor.ui.window.PropertyPanelUI;

	/**属性面板*/
	public class PropertyPanelCmd extends Command
	{
		public static var ui :PropertyPanelUI ;
		public function PropertyPanelCmd()
		{
			super();
		}

		override public function execute():void
		{
			if(!ui)
			{
				ui = new PropertyPanelUI();
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
