/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.mapeditor.ui.window.ThumbnailUI;

	public class ThumbnailUICmd extends Command
	{
		private static var ui :ThumbnailUI;
		public function ThumbnailUICmd()
		{
			super();
		}

		override public function execute():void
		{
			if(!ui)
			{
				ui = new ThumbnailUI();
			}
			if(ui.parent)
			{
				ui.parent.removeChild(ui);
			}
			else
			{
				contextView.addChild(ui);
			}
		}
	}
}
