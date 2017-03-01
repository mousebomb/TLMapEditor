/**
 * Created by Administrator on 2017/3/1.
 */
package tl.frameworks.mediator
{
	import flash.events.MouseEvent;

	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.model.TLEditorMapModel;
	import tl.mapeditor.ui.window.CoveragePanelUI;

	import tl.mapeditor.ui.window.CreateCoverageUI;

	import tool.StageFrame;

	public class CreateCoverageUIMediator extends Mediator
	{
		[Inject]
		public var view: CreateCoverageUI;
		[Inject]
		public var mapModel: TLEditorMapModel;
		private var _createValue:String = '';
		public function CreateCoverageUIMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			view.init("图层创建", 260, 120);
			view.x = StageFrame.stage.stageWidth - view.myWidth >> 1;
			view.y = StageFrame.stage.stageHeight - view.myHeight >> 1;
			_createValue ='新建图层' + view.createValue;
			view.createTxt.text = _createValue;
			eventMap.mapListener(view.closeBtn, MouseEvent.CLICK, onClickClose)
		}

		private function onClickClose(event:MouseEvent):void
		{
			if(view.parent)
			{
				view.parent.removeChild(view);
				var coverage:String = view.createTxt.text;
				if(coverage == '') return;
				if(coverage == _createValue)
					view.createId ++;
				mapModel.addEntityGroup(coverage)
			}
		}
	}
}
