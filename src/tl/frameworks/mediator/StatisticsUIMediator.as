/**
 * Created by Administrator on 2017/2/17.
 */
package tl.frameworks.mediator
{
	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;

	import tl.frameworks.model.TLEditorMapModel;

	import tl.mapeditor.ui.window.StatisticsUI;

	import tool.StageFrame;

	public class StatisticsUIMediator extends Mediator
	{
		[Inject]
		public var view: StatisticsUI ;
		[Inject]
		public var mapModel: TLEditorMapModel;
		private var _label:String;
		private var _value:String;
		public function StatisticsUIMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			super.onRegister();

			view.init("统计面板", 420, 360);
			view.x = StageFrame.stage.stageWidth - view.myWidth >> 1;
			view.y = StageFrame.stage.stageHeight - view.myHeight >> 1;

			_label = _value = '';

			addContextListener(NotifyConst.MAP_VO_INITED , onMapInit);
			onMapInit(null);
		}
		private function onMapInit(e:TLEvent):void
		{
			//默认选第一个
			if(!mapModel.mapVO) return;

			var leng:int = mapModel.mapVO.entityGroupNames.length;
			var half:int = leng >> 1;
			var wLeng:int;
			for (var i:int = 0; i < leng; i++)
			{
				var type:String = mapModel.mapVO.entityGroupNames[i];
				wLeng = mapModel.mapVO.entityGroups[type].length;
				if(i < half || half == 1)
				{
					_label += type + ':' + wLeng + '\n'
				}	else {
					_value += type + ':' + wLeng + '\n'
				}

			}
			view.typeTxt.text = _label;
			view.valueTxt.text = _value;
		}
	}
}
