/**
 * Created by gaord on 2016/12/15.
 */
package tl.frameworks.mediator
{
	import fl.data.DataProvider;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	import org.mousebomb.framework.GlobalFacade;
	import org.mousebomb.framework.MediatorBase;
	import org.mousebomb.framework.Notify;
	import org.robotlegs.mvcs.Mediator;

	import tl.core.role.Role;
	import tl.core.old.WizardObject;
	import tl.frameworks.NotifyConst;
	import tl.frameworks.model.CSV.SGCsvManager;
	import tl.mapeditor.Config;
	import tool.StageFrame;

	public class WizardBarMediator extends Mediator
	{
		public function WizardBarMediator()
		{
			super();
		}

		[Inject]
		public var view:WizardBar;
		[Inject]
		public var csvModel:SGCsvManager;

		/** 模型 分分类的列表*/
		private var _modelDataVec:Vector.<Array>;

		override public function onRegister():void
		{
			//
			view.assetList.iconField=null;
			view.assetList.labelField = "name";
			view.assetList.addEventListener(Event.CHANGE, onChanged);
			view.addBtn.addEventListener(MouseEvent.CLICK, onAddClick);
			view.closeBtn.addEventListener(MouseEvent.CLICK, onCloseClick)
			//
			addContextListener(NotifyConst.CSV_LOADED, onCsvLoaded);
			onResize();
			eventMap.mapListener(view.stage,Event.RESIZE, onResize);
			onCsvLoaded( null );
		}
		private  function onCloseClick(event:MouseEvent):void
		{

			if(view && view.parent) {
				view.parent.removeChild(view);
			}
		}

		private function onAddClick(event:MouseEvent):void
		{

		}


		override public function onRemove():void
		{

			dispatchWith(NotifyConst.UI_PREVIEW_HIDE);
//			dispatchWith(NotifyConst.UI_PREVIEW_SHOW,false,{x,y});
		}

		private function onResize(e:* = null):void
		{
			view.y = 500;
			view.assetList.height = StageFrame.stage.stageHeight - view.y - 240;
			view.x = 90//StageFrame.stage.stageWidth - 200;
			TLMapEditor.view3DForPreview.x = view.x + 10;
			TLMapEditor.view3DForPreview.y = view.y + 20;
			view.addBtn.y = view.assetList.y + view.assetList.height+10;
		}

		//菜单内容
		public static const menuVec:Vector.<String> = Vector.<String>(
				[
					"英雄", "Npc", "场景特效", "搜捡怪物", "怪物", "Boss怪物", "受击破碎特效", "受击溅血特效", "翅膀", "坐骑"
					, "武器", "搜检部件（点击打开）", "场景小精灵", "镖车", "地表模型", "建筑模型", "野外BOSS", "阻挡特效", "功能性特效", "界面展示模型",
					"怪物（有尸体）", "特效模型（同场景特效）", "特效怪物（只显示血条）", "固定不动怪", "友方Boss怪物", "竞技场用怪", "特效怪（没有鼠标事件）",
					"宠物", "搜捡部件（需要攻击）", "采集类型", "篝火专用", "可以被占领的生物", "要塞支持类建筑", "要塞防御类建筑", "要塞陷阱", "掉落物品"
				]);

		private function onCsvLoaded(n:Notify):void
		{
			dispatchWith(NotifyConst.STATUS, false, "加载完毕");

			//默认选第一个
			if (!_modelDataVec)
			{
				var array:Array    = csvModel.table_wizard.DataArray;
				_modelDataVec      = new Vector.<Array>(menuVec.length, true);
				var i:int          = 0;
				var dic:Dictionary = new Dictionary();
				var wizardObject:WizardObject;
				for each(var arr:Array in array)
				{
					if (int(arr[0]) == 0) continue;
					wizardObject = new WizardObject();
					wizardObject.refreshByTable(arr[0]);

					i = int(wizardObject.type);
					if (i >= menuVec.length) i = menuVec.length - 1;

					_modelDataVec[i] ||= [];
					_modelDataVec[i].push(wizardObject);
				}
			}
			//默认选第一项
			onMenuSelectCallBack(0);
		}

		/** 选择类型后 **/
		private function onMenuSelectCallBack(index:int):void
		{
			//设置类型文本显示
			view.nameTf.text = menuVec[index];
			//设置数据
			// 显示实体列表
			view.assetList.dataProvider = new DataProvider(_modelDataVec[index]);
		}

		/** 当前选中的模型 */
		private var _curSelectedWizardObject :WizardObject ;

		/** 当前选中的模型 */
		public function get curSelectedWizardObject():WizardObject
		{
			return _curSelectedWizardObject;
		}

		private function onChanged(event:Event):void
		{
			var wo :WizardObject = view.assetList.selectedItem as WizardObject;
			if(wo == null ) return;
			dispatchWith(NotifyConst.STATUS,false,"选择模型ID"+wo.id +" "+wo.name);
			//实例化精灵
			dispatchWith(NotifyConst.SELECT_WIZARD_PREVIEW,false , wo);

			trace(StageFrame.renderIdx,"WizardBarMediator/onChanged");
		}


	}
}
