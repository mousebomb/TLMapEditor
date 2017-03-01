/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import flash.events.MouseEvent;

	import org.robotlegs.mvcs.Mediator;

	import tl.core.role.RolePlaceVO;
	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;
	import tl.frameworks.model.TLEditorMapModel;
	import tl.mapeditor.ui.common.MyScrollBarRenderer;
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
		private var _selectType:String;
		private var _selectedRenderer:MyScrollBarRenderer;
		private var _rendererVector:Vector.<MyScrollBarRenderer>
		public function CoveragePanelUIMediator()
		{
			super();
		}
		override public function onRegister():void
		{
			super.onRegister();

			_vector = WizardBarMediator.menuVec;
			view.init("图层面板", 320, 470);
			view.x = StageFrame.stage.stageWidth - view.myWidth;
			view.y = 32;
			onMapInit(null);
			addContextListener(NotifyConst.MAP_VO_INITED , onMapInit);
			addContextListener(NotifyConst.GROUP_ADDED,onMapInit);
			addContextListener(NotifyConst.GROUP_WIZARD_LIST_CHANGED, onWizardObjcetUpdate);
			addContextListener(NotifyConst.GROUP_WIZARD_LI_CHANGED, onWizardObjcetUpdate);
			addContextListener(NotifyConst.CLOSE_ALL_UI, onClose);
			addContextListener(NotifyConst.CLOSE_ALL_UI, onClose);
		}

		private function onClose(event:*):void
		{
			if(view.parent)
				view.parent.removeChild(view)
		}
		private function onMapInit(e:TLEvent):void
		{
			//默认选第一个
			if(!mapModel.mapVO) return;
			var leng:int = mapModel.mapVO.entityGroupNames.length;
			if(leng == 0) return;
			var arr:Array = [];
			var obj:*;
			while(view.scrollTarget.numChildren>1)
			{
				obj = view.scrollTarget.removeChildAt(1);
				if(obj is MyScrollBarRenderer)
					arr.push(obj);
			}
			var renderer:MyScrollBarRenderer;
			_rendererVector = new <MyScrollBarRenderer>[];
			for (var i:int=0; i<leng; i++)
			{
				if(arr.length > 0)
					renderer = arr.pop();
				else
					renderer = new MyScrollBarRenderer();
				view.scrollTarget.addChild(renderer);
				renderer.init(view.myWidth-65, 30);
				renderer.name = i + '';
				renderer.updateRenderer({label:mapModel.mapVO.entityGroupNames[i], type:1, index:i}, true);
				renderer.y = i * 32;
				renderer.x = 0;
				renderer.addEventListener(MouseEvent.CLICK, onClickBtn, false, 0, true);
				_rendererVector.push(renderer);
			}
			if(arr.length > 0)
				renderer = arr.shift();
			else
				renderer = new MyScrollBarRenderer();
			view.scrollTarget.addChild(renderer);
			renderer.init(view.myWidth-105, 30);
			renderer.updateRenderer({label:'添加图层', type:0, index:-1}, false);
			renderer.y = i * 32;
			renderer.x = 20;
			renderer.addEventListener(MouseEvent.CLICK, onClickBtn, false, 0, true);
			_rendererVector.push(renderer);
			view.myScrollBar.scrollTarget = view.scrollTarget;

			if(_selectedRenderer)
			{
				var index:int = _rendererVector.indexOf(_selectedRenderer);
				_selectType = mapModel.mapVO.entityGroupNames[index];
			}	else {
				_selectType = mapModel.mapVO.entityGroupNames[0];
				_selectedRenderer = _rendererVector[0];
			}
			_selectedRenderer.isSelected = true;
			showWizardType();
			view.stage.focus=null;
		}

		private function onClickBtn(event:MouseEvent):void
		{
			var target:MyScrollBarRenderer = event.currentTarget as MyScrollBarRenderer;
			if(target.rendererData.type == 0)
			{
				//创建图层
				dispatchWith(NotifyConst.NEW_CREATE_COVERAGE_UI,false);
			}	else if(target.rendererData.type == 1) {
				//选中图层
				if(_selectedRenderer == target)
				{
					_selectedRenderer.isSelected = !_selectedRenderer.isSelected;
				}	else {
					_selectedRenderer.isSelected = false;
					_selectedRenderer = target;
					var index:int = _rendererVector.indexOf(_selectedRenderer);
					_selectType = mapModel.mapVO.entityGroupNames[index];
					_selectedRenderer.isSelected = true;
				}
				showWizardType();
			}	else if(target.rendererData.type == 2) {
				//选中精灵
				var vo :RolePlaceVO = target.rendererData.rolePlaceVO;
				if(!vo ) return;
				dispatchWith(NotifyConst.UI_SELECT_WIZARD, false, vo);
			}
			view.stage.focus=null;
		}
		/**显示选中图层的精灵数据*/
		private function showWizardType():void
		{
			var vo:RolePlaceVO;
			var leng:int = mapModel.mapVO.entityGroups[_selectType].length;

			mapModel.selectedGroupName = _selectedRenderer.rendererData.label;
			var arr:Array = [];
			while(view.rendererSpr.numChildren)
			{
				arr.push(view.rendererSpr.removeChildAt(0));
			}
			var renderer:MyScrollBarRenderer;
			for (var i:int = 0; i < leng; i++)
			{
				vo = mapModel.mapVO.entityGroups[_selectType][i];
				if(arr.length > 0)
					renderer = arr.pop();
				else
					renderer = new MyScrollBarRenderer();
				view.rendererSpr.addChild(renderer);
				renderer.init(view.myWidth-85, 30);
				renderer.updateRenderer({label:vo.toString(), rolePlaceVO:vo, type:2}, false);
				renderer.y = i * 32;
				renderer.x = 10;
				renderer.addEventListener(MouseEvent.CLICK, onClickBtn, false, 0, true);
			}
			view.rendererSpr.myHeight = 32 * leng;
			if(_selectedRenderer.isSelected)
				view.scrollTarget.addChild(view.rendererSpr);
			else if(view.rendererSpr.parent)
				view.rendererSpr.parent.removeChild(view.rendererSpr);
			var vy:int;
			leng = _rendererVector.length;
			for(i=0; i<leng; i++)
			{
				_rendererVector[i].y = vy;
				vy += _rendererVector[i].myHeight + 2;
				if(_selectedRenderer.isSelected && i == _selectedRenderer.rendererData.index)
				{
					view.rendererSpr.y = vy;
					vy += view.rendererSpr.myHeight;
				}
			}
			view.myScrollBar.scrollTarget = view.scrollTarget;
		}
		/**刷新当前图层数据*/
		private function onWizardObjcetUpdate(event:*):void
		{
			showWizardType();
		}

		override public function onRemove():void
		{
			super.onRemove();
			_selectedRenderer = null;
		}
	}
}
