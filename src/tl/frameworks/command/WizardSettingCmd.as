/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.core.old.WizardObject;

	import tl.frameworks.TLEvent;
	import tl.frameworks.model.WizardSettingModel;

	import tl.mapeditor.ui.window.ThumbnailUI;
	import tl.mapeditor.ui.window.WizardSettingUI;

	public class WizardSettingCmd extends Command
	{
		[Inject]
		public var event: TLEvent;
		[Inject]
		public var model: WizardSettingModel;
		private static var ui :WizardSettingUI;
		public function WizardSettingCmd()
		{
			super();
		}

		override public function execute():void
		{
			if(!ui || !event.data)
			{
				if(!event.data) return;
				ui = new WizardSettingUI();
			}
			if(!event.data)
			{
				if(ui.parent)
				{
					ui.parent.removeChild(ui)
				}	else {
					contextView.addChild(ui);
				}
			}	else {
				model.showObj = event.data ;
				contextView.addChild(ui);
			}

		}
	}
}
