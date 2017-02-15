/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import org.robotlegs.mvcs.Mediator;

	import tl.mapeditor.ui.window.ThumbnailUI;

	/**缩略图*/
	public class ThumbnailUIMediator extends Mediator
	{

		[Inject]
		public var view:ThumbnailUI;
		public function ThumbnailUIMediator()
		{
			super();
		}
		override public function onRegister():void
		{
			super.onRegister();

			view.init("缩略图", 260, 160);
			view.x = 90;
			view.y = 32;
		}


		override public function onRemove():void
		{
			super.onRemove();
		}
	}
}
