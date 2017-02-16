/**
 * Created by Administrator on 2017/2/15.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.frameworks.TLEvent;

	import tl.mapeditor.ui.PopMenuBar;

	public class PopMenuBarCmd extends Command
	{
		[Inject]
		public var event: TLEvent;
		public static var ui :PopMenuBar
		public function PopMenuBarCmd()
		{
			super();
		}
		override public function execute():void
		{
			var vector:Vector.<String> = event.data
			if(!ui)
			{
				ui = new PopMenuBar();
			}
			if(vector.length < 10)
					ui.myWidth = 100;
			else
					ui.myWidth = 130;
			ui.menu = vector;
			if(!ui.parent)
			{
				contextView.addChild(ui);
			}	else {
				ui.parent.removeChild(ui);
			}

		}
	}
}
