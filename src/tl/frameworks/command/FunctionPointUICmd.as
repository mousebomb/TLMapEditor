/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.mapeditor.ui.window.FunctionPointUI;

	/**功能点设置*/
	public class FunctionPointUICmd extends Command
	{
		public static var ui :FunctionPointUI;
		public function FunctionPointUICmd()
		{
			super();
		}
		override public function execute():void
		{
			if(!ui)
			{
				ui = new FunctionPointUI();
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
