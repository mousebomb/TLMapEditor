/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;
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
			view.init("快捷键显示", 420, 340);
			view.x = StageFrame.stage.stageWidth - view.myWidth >> 1 ;
			view.y = 32;
			_value ='Ctrl + N' + spacing + '新建文件' + '\n' +
					'Ctrl + O' + spacing + '打开文件' + '\n' +
					'Ctrl + S' + spacing + '保存文件' + '\n' +
					'Ctrl + G' + spacing + '新建刚体' + '\n' +
					'Ctrl + Q' + spacing + '显示网格' + '\n' +
					'   Z    ' + spacing + '关闭所有UI界面' + '\n' +
					'Ctrl + Z' + spacing + '单步撤销(尚未支持)' + '\n';

			_label ='       B' + spacing + '地形设置' + '\n' +
					'       T' + spacing + '贴图设置' + '\n' +
					'       L' + spacing + '区域设置' + '\n' +
					'       R' + spacing + '统计界面' + '\n' +
					'       E' + spacing + '图层界面' + '\n' +
					'       X' + spacing + '模型编辑' + '\n'+
					'       M' + spacing + '模型列表' + '\n' +
					'       F' + spacing + '属性界面' + '\n' +
					'       H' + spacing + '缩略地图' + '\n' +
					'       V' + spacing + '取消刷子' + '\n'+
					'  PageUp' + spacing + '抬高镜头' + '\n'+
					'PageDown' + spacing + '降低镜头' + '\n'+
					'   Enter' + spacing + '重置镜头高度' + '\n'+
							"";
			undeteText();
			addContextListener(NotifyConst.CLOSE_ALL_UI, onClose);
		}

		private function onClose(event:*):void
		{
			if(view.parent)
				view.parent.removeChild(view)
		}

		private function undeteText():void
		{
			view.typeTxt.text = _label;
			view.valueTxt.text = _value;
		}
	}
}
