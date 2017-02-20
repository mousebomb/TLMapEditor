/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import fl.data.DataProvider;

	import flash.events.Event;

	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import org.mousebomb.framework.Notify;

	import org.robotlegs.mvcs.Mediator;

	import tl.core.old.WizardObject;
	import tl.core.role.RolePlaceVO;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;
	import tl.frameworks.model.CSV.SGCsvManager;
	import tl.frameworks.model.TLEditorMapModel;

	import tl.mapeditor.ui.window.CoveragePanelUI;

	import tool.StageFrame;

	/**图层面板*/
	public class CoveragePanelUIMediator extends Mediator
	{
		[Inject]
		public var view:CoveragePanelUI;
		[Inject]
		public var mapModel:TLEditorMapModel;
		private var _vector:Vector.<String>;
		public function CoveragePanelUIMediator()
		{
			super();
		}
		override public function onRegister():void
		{
			super.onRegister();

			_vector = WizardBarMediator.menuVec;
			view.init("图层面板", 460, 470);
			view.x = StageFrame.stage.stageWidth - view.myWidth >> 1;
			view.y = StageFrame.stage.stageHeight - view.myHeight >> 1;
			eventMap.mapListener(view.typeList, Event.CHANGE, onTypeChange);
			eventMap.mapListener(view.wizardList, Event.CHANGE, onWizardObjectChanged);
			onMapInit(null);
			addContextListener(NotifyConst.MAP_VO_INITED , onMapInit);
			view.parent.removeChild(view)
		}
		private function onMapInit(e:TLEvent):void
		{
			//默认选第一个
			if(!mapModel.mapVO) return;
			var data:DataProvider = new DataProvider();
			var leng:int = mapModel.mapVO.entityGroupNames.length;
			if(leng == 0) return;
			for (var i:int=0; i<leng; i++)
			{
				data.addItem({type:mapModel.mapVO.entityGroupNames[i]})
			}
			view.typeList.dataProvider = data;
			//默认选第一项
			view.typeList.selectedIndex = 0;
			var type:String = mapModel.mapVO.entityGroupNames[0];
			showWizardType(type);
		}

		/** 选择类型后 **/
		private function onTypeChange(event:Event):void
		{
			var index:int   = view.typeList.selectedIndex;
			var type:String = mapModel.mapVO.entityGroupNames[index];
			showWizardType(type);
		}
		private function showWizardType(type:String):void
		{
			// 显示实体列表
			var vo:RolePlaceVO;
			var data2:DataProvider =new DataProvider();
			var leng:int = mapModel.mapVO.entityGroups[type].length
			for (var i:int = 0; i < leng; i++)
			{
				vo = mapModel.mapVO.entityGroups[type][i];
				data2.addItem(vo);
			}
			view.wizardList.dataProvider = data2;
		}
		private function onWizardObjectChanged(event:Event):void
		{
			var vo :RolePlaceVO = view.wizardList.selectedItem as RolePlaceVO;
			if(!vo ) return;
			dispatchWith(NotifyConst.STATUS,false,"选择模型ID"+vo.wizardId +" "+vo.wizard.vo.name);
			//实例化精灵
			dispatchWith(NotifyConst.SELECT_WIZARD_PREVIEW,false , vo.wizard.vo);

			trace(StageFrame.renderIdx,"WizardBarMediator/onChanged");
		}
	}
}
