/**
 * Created by Administrator on 2017/3/1.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.mapeditor.ui.window.CreateCoverageUI;

	public class CreateCoverageCmd extends Command
	{
		public static var ui:CreateCoverageUI;
		public function CreateCoverageCmd()
		{
			super();
		}
		override public function execute():void
		{
			if(!ui)
			{
				ui = new CreateCoverageUI();
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
