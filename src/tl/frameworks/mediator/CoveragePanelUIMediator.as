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

	import tl.frameworks.NotifyConst;
	import tl.frameworks.model.CSV.SGCsvManager;

	import tl.mapeditor.ui.window.CoveragePanelUI;

	import tool.StageFrame;

	/**图层面板*/
	public class CoveragePanelUIMediator extends Mediator
	{
		[Inject]
		public var view:CoveragePanelUI;
		[Inject]
		public var csvModel:SGCsvManager;
		private var _modelDataVec:Vector.<Array>;
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
			var data:DataProvider = new DataProvider();
			var leng:int = _vector.length;
			for (var i:int=0; i<leng; i++)
			{
				data.addItem({type:_vector[i], data:i})
			}
			view.typeList.dataProvider = data;
			addContextListener(NotifyConst.CSV_LOADED, onCsvLoaded);
			eventMap.mapListener(view.typeList, Event.CHANGE, onTypeChange);
			eventMap.mapListener(view.wizardList, Event.CHANGE, onWizardObjectChanged);
			onCsvLoaded(null);
		}
		private function onCsvLoaded(n:Notify):void
		{
			//默认选第一个
			if (!_modelDataVec)
			{
				var array:Array    = csvModel.table_wizard.DataArray;
				_modelDataVec      = new Vector.<Array>(_vector.length, true);
				var i:int          = 0;
				var dic:Dictionary = new Dictionary();
				var wizardObject:WizardObject;
				for each(var arr:Array in array)
				{
					if (int(arr[0]) == 0) continue;
					wizardObject = new WizardObject();
					wizardObject.refreshByTable(arr[0]);

					i = int(wizardObject.type);
					if (i >= _vector.length) i = _vector.length - 1;

					_modelDataVec[i] ||= [];
					_modelDataVec[i].push(wizardObject);
				}
			}
			//默认选第一项
			view.typeList.selectedIndex = 0;
			view.wizardList.dataProvider  = new DataProvider(_modelDataVec[0]);
		}

		/** 选择类型后 **/
		private function onTypeChange(event:Event):void
		{
			var index:int = view.typeList.selectedIndex;
			// 显示实体列表
			view.wizardList.dataProvider  = new DataProvider(_modelDataVec[index]);
			// 显示实体列表
			//view.assetList.dataProvider = new DataProvider(_modelDataVec[index]);
		}
		private function onWizardObjectChanged(event:Event):void
		{
			var wo :WizardObject = view.wizardList.selectedItem as WizardObject;
			if(wo == null ) return;
			dispatchWith(NotifyConst.STATUS,false,"选择模型ID"+wo.id +" "+wo.name);
			//实例化精灵
			dispatchWith(NotifyConst.SELECT_WIZARD_PREVIEW,false , wo);

			trace(StageFrame.renderIdx,"WizardBarMediator/onChanged");
		}
	}
}
