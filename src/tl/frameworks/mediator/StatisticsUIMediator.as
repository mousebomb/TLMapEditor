/**
 * Created by Administrator on 2017/2/17.
 */
package tl.frameworks.mediator
{
	import flash.text.StageTextInitOptions;

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

			addContextListener(NotifyConst.MAP_VO_INITED , onMapInit);
			addContextListener(NotifyConst.GROUP_WIZARD_LIST_CHANGED, onMapInit);
			onMapInit(null);
		}
		private function onMapInit(e:TLEvent):void
		{
			//默认选第一个
			if(!mapModel.mapVO) return;

			_label = _value = '';

			var leng:int = mapModel.mapVO.entityGroupNames.length;
			var half:int = leng >> 1;
			var wLeng:int;
			var arr:Array;
			var wName:String;
			var index:int;
			var wn:int ;
			for (var i:int = 0; i < leng; i++)
			{
				arr = [];
				var type:String = mapModel.mapVO.entityGroupNames[i];
				wLeng = mapModel.mapVO.entityGroups[type].length;
				for (var j:int=0; j<wLeng; j++)
				{
					wName = mapModel.mapVO.entityGroups[type][j].wizard.vo.name;
					index = arr.indexOf(wName)
					if(index < 0)
					{
						arr.push(wName, 1);
					}	else {
						wn = arr[index + 1];
						wn ++;
						arr[index + 1] = wn;
					}
				}
				var lab:String = '';
				var al:int = arr.length;
				for(j=0; j<al; j+=2)
				{
					lab += '        ' + arr[j] + ':' + arr[j + 1] + '\n';
				}

				if(i < half || half == 0)
				{
					_label += type + ':' + wLeng + '\n' + lab + '\n';
				}	else {
					_value += type + ':' + wLeng + '\n' + lab + '\n';
				}

			}
			view.typeTxt.text = _label;
			view.valueTxt.text = _value;
		}
	}
}
