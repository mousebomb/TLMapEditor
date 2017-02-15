/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.mapeditor.ui.CreateFileUI;

	public class NewMapUICmd extends Command
	{
		public static var ui :CreateFileUI;
		public function NewMapUICmd()
		{
			super();
		}

		override public function execute():void
		{
			if(!ui)
				ui = new CreateFileUI();
			if(ui.parent)
			{
				ui.parent.removeChild(ui)
			}	else {
				contextView.addChild(ui);
			}
		}
	}
}
