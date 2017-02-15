/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import org.robotlegs.mvcs.Mediator;

	import tl.mapeditor.ui.window.HelpUI;

	/**快捷键显示*/
	public class HelpUIMediator extends Mediator
	{
		[Inject]
		public var view: HelpUI;
		public function HelpUIMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			super.onRegister();

			view.init("快捷键显示", 260, 155);
		}
	}
}
