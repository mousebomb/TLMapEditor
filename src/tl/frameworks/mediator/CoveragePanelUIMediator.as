/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import org.robotlegs.mvcs.Mediator;

	import tl.mapeditor.ui.window.CoveragePanelUI;

	/**图层面板*/
	public class CoveragePanelUIMediator extends Mediator
	{
		[Inject]
		public var view:CoveragePanelUI;
		public function CoveragePanelUIMediator()
		{
			super();
		}
		override public function onRegister():void
		{
			super.onRegister();

			view.init("图层面板", 260, 155);
		}
	}
}
