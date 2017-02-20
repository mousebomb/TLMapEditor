/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import org.robotlegs.mvcs.Mediator;

	import tl.mapeditor.ui.window.HelpUI;

	import tool.StageFrame;

	/**快捷键显示*/
	public class HelpUIMediator extends Mediator
	{
		[Inject]
		public var view: HelpUI;
		private var _label:String;
		private var _value:String;
		public function HelpUIMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			super.onRegister();

			 var spacing:String = '        '
			view.init("快捷键显示", 420, 240);
			view.x = StageFrame.stage.stageWidth - view.myWidth >> 1;
			view.y = StageFrame.stage.stageHeight - view.myHeight >> 1;
			_label ='Ctrl + N' + spacing + '新建文件' + '\n' +
					'Ctrl + O' + spacing + '打开文件' + '\n' +
					'Ctrl + S' + spacing + '保存文件' + '\n' +
					'Ctrl + G' + spacing + '新建刚体' + '\n' +
					'Ctrl + Q' + spacing + '显示网格' + '\n' +
					'Ctrl + D' + spacing + '模型列表' + '\n' +
					'Ctrl + F' + spacing + '属性界面' + '\n' +
					'Ctrl + H' + spacing + '缩略地图' + '\n' +
					'Ctrl + V' + spacing + '取消刷子' + '\n';

			_value ='Ctrl + B' + spacing + '打开贴图刷' + '\n' +
					'Ctrl + T' + spacing + '打开区域刷' + '\n' +
					'Ctrl + L' + spacing + '打开地形刷' + '\n' +
					'Ctrl + R' + spacing + '打开统计界面' + '\n' +
					'Ctrl + E' + spacing + '打开图层界面' + '\n' +
					'Ctrl + X' + spacing + '打开模型编辑' + '\n';
			undeteText();
		}

		private function undeteText():void
		{
			view.typeTxt.text = _label;
			view.valueTxt.text = _value;
		}
	}
}
