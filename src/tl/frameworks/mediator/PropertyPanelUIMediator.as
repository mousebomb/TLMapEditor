/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import org.robotlegs.mvcs.Mediator;

	import tl.mapeditor.ui.window.PropertyPanelUI;

	/**属性面板*/
	public class PropertyPanelUIMediator extends Mediator
	{
		[Inject]
		public var view:PropertyPanelUI
		public function PropertyPanelUIMediator()
		{
			super();
		}
		override public function onRegister():void
		{
			super.onRegister();

			view.init("属性面板", 260, 180);
			view.x = 90;
			view.y = 32 + 160;
		}
	}
}
