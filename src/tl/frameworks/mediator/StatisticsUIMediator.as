/**
 * Created by Administrator on 2017/2/17.
 */
package tl.frameworks.mediator
{
	import org.robotlegs.mvcs.Mediator;

	import tl.mapeditor.ui.window.StatisticsUI;

	import tool.StageFrame;

	public class StatisticsUIMediator extends Mediator
	{
		[Inject]
		public var view: StatisticsUI ;
		private var _label:String;
		private var _value:String;
		public function StatisticsUIMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			super.onRegister();

			view.init("快捷键显示", 420, 360);
			view.x = StageFrame.stage.stageWidth - view.myWidth >> 1;
			view.y = StageFrame.stage.stageHeight - view.myHeight >> 1;

			_label = _value = '';
			var vector:Vector.<String> = WizardBarMediator.menuVec;
			var leng:int = vector.length;
			var half:int = leng >> 1;
			for (var i:int = 0; i < leng; i++)
			{
				if(i < half)
				{
					_label += vector[i] + ':0\n'
				}	else {
					_value += vector[i] + ':0\n'
				}

			}
			undeteText();
		}

		private function undeteText():void
		{
			view.typeTxt.text = _label;
			view.valueTxt.text = _value;
		}
	}
}
