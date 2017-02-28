/**
 * Created by gaord on 2016/12/15.
 */
package tl.frameworks.mediator
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	import org.mousebomb.framework.Notify;
	import org.robotlegs.mvcs.Mediator;

	import tl.core.old.WizardObject;
	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;
	import tl.frameworks.model.CSV.SGCsvManager;
	import tl.mapeditor.ToolBoxType;
	import tl.mapeditor.ui.common.MyButton;
	import tl.mapeditor.ui.common.MyPageButton;
	import tl.mapeditor.ui.window.WizardBarUI;

	import tool.StageFrame;

	public class WizardBarMediator extends Mediator
	{
		public function WizardBarMediator()
		{
			super();
		}

		private static var nextId : int =0;
		public var id :int =0;

		[Inject]
		public var view: WizardBarUI;
		[Inject]
		public var csvModel:SGCsvManager;

		/** 模型 分分类的列表*/
		private var _modelDataVec:Vector.<Array>;
		private var _isControl:Boolean;

		override public function onRegister():void
		{
			id = nextId++;
			trace(StageFrame.renderIdx,"[WizardBarMediator]/onRegister",id);
			view.onSelectModelCallBack = onSelectModelCallBack;
			view.init("模型库", 260, 546);
			addContextListener(NotifyConst.SELECT_WIZARDOBJECT_TYPE, onSelectType)
			eventMap.mapListener(view.searchBtn,MouseEvent.CLICK, onClickSearch);
			eventMap.mapListener(view.selectBtn, MouseEvent.CLICK, onClickSelect);
			eventMap.mapListener(view.modelPageBtn,MyPageButton.PAGING, onPaging);
			eventMap.mapListener(view.stage,KeyboardEvent.KEY_DOWN, onKeyDown);
			eventMap.mapListener(view.stage,KeyboardEvent.KEY_UP, onKeyUp);
			addViewListener(MouseEvent.MOUSE_DOWN,onRotationDown);
			addViewListener(MouseEvent.MOUSE_UP,onRotationUp);
			addViewListener(MouseEvent.MOUSE_OUT,onRotationUp);
			onCsvLoaded( null );
			addContextListener(NotifyConst.CSV_LOADED, onCsvLoaded);
			onResize();
			//eventMap.mapListener(view.stage,Event.RESIZE, onResize);
			view.moveUI = onViewMove;
			dispatchWith(NotifyConst.UI_PREVIEW_SHOW, false, {x:view.x + 10, y:view.y + 35});
			addContextListener(NotifyConst.CLOSE_ALL_UI, onClose);
			//
			_rotationTimer = new Timer(30);
			eventMap.mapListener(_rotationTimer,TimerEvent.TIMER,onRotationOnce);
		}

		private function onRotationDown(e:MouseEvent):void
		{
			if(e.target is MyButton)
			{
				switch (e.target.name)
				{
					case "left":
						_rotationSpeed = -10;
						_rotationTimer.start();
						break;
					case "right":
						_rotationSpeed = 10;
						_rotationTimer.start();
						break;
				}
			}
		}

		private function onRotationUp(e:MouseEvent):void
		{
			if (e.target is MyButton && (e.target.name == "left" || e.target.name == "right"))
			{
				_rotationTimer.stop();
				_rotationTimer.reset();
			}
		}

		private var _rotationSpeed :int = 0;
		private var _rotationTimer :Timer  ;
		private function onRotationOnce(e:TimerEvent ):void
		{
			dispatchWith(NotifyConst.WIZARD_PREVIEW_ROTATE, false,_rotationSpeed);
		}

		private function onKeyUp(event:KeyboardEvent):void
		{
			trace(StageFrame.renderIdx,"[WizardBarMediator]/onKeyUp",id);
			switch (event.keyCode)
			{
				case Keyboard.V :
					if(event.ctrlKey && _selectWizard)
						dispatchWith(NotifyConst.UI_START_ADD_WIZARD,false, _selectWizard);
				case Keyboard.CONTROL :
					_isControl = true;
					break;
			}
		}


		private function onKeyDown(event:KeyboardEvent):void
		{
			trace(StageFrame.renderIdx,"[WizardBarMediator]/onKeyDown",id);
			switch (event.keyCode)
			{
				case Keyboard.CONTROL :
					_isControl = true;
					break;
			}
		}

		private function onClose(event:*):void
		{
			if(view.parent)
				view.parent.removeChild(view)
		}

		private function onSelectType(event:TLEvent):void
		{
			var name:String = event.data as String;
			var index:int = menuVec.indexOf(name);
			onMenuSelectCallBack(index);
		}
		private function onViewMove():void
		{
			TLMapEditor.view3DForPreview.x = view.x + 10;
			TLMapEditor.view3DForPreview.y = view.y + 35;
		}

		private function onClickSelect(event:MouseEvent):void
		{
			ToolBoxType.popmenuX = view.x + view.myWidth;
			var mh:int = 18.5*menuVec.length;
			var vh:int = StageFrame.stage.stageHeight - mh;
			var vy:int = view.y + view.selectBtn.y ;
			if(vy + mh*.5 < StageFrame.stage.stageHeight)
				ToolBoxType.popmenuY = vy - mh * .5;
			else
				ToolBoxType.popmenuY = vh;
			dispatchWith(NotifyConst.NEW_POPMENUBAR_UI, false, menuVec);
		}

		override public function onRemove():void
		{
			trace(StageFrame.renderIdx,"[WizardBarMediator]/onRemove",id);
			view.onSelectModelCallBack = null;
			view.moveUI = null;
			dispatchWith(NotifyConst.UI_PREVIEW_HIDE);
			_rotationTimer.reset();
			_rotationTimer=null;
		}

		private function onResize(e:* = null):void
		{

			view.x = 90;
			view.y = StageFrame.stage.stageHeight - view.myHeight;
			onViewMove();
		}

		//菜单内容
		public static const menuVec:Vector.<String> = Vector.<String>(
				[
					"英雄", "Npc", "场景特效", "搜捡怪物", "怪物", "Boss怪物", "受击破碎特效", "受击溅血特效", "翅膀", "坐骑"
					, "武器", "搜检部件（点击打开）", "场景小精灵", "镖车", "地表模型", "建筑模型", "野外BOSS", "阻挡特效", "功能性特效", "界面展示模型",
					"怪物（有尸体）", "特效模型（同场景特效）", "特效怪物（只显示血条）", "固定不动怪", "友方Boss怪物", "竞技场用怪", "特效怪（没有鼠标事件）",
					"宠物", "搜捡部件（需要攻击）", "采集类型", "篝火专用", "可以被占领的生物", "要塞支持类建筑", "要塞防御类建筑", "要塞陷阱", "掉落物品"
				]);
		private var wizardVector:Array;

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
			if(!_modelDataVec[index])
			{
				return;
			}
			//设置数据
			wizardVector = _modelDataVec[index];
			//设置类型文本显示
			view.modelTypeText.text = menuVec[index];
			var len:int = wizardVector.length;
			view.modelPageBtn.maxPage = int(len/_showNum) + 1;
			view.modelPageBtn.nowPage = 1;
		}

		/** 当前选中的模型 */
		private var _curSelectedWizardObject :WizardObject ;
		private const _showNum:int = 13;
		private var _nowWizardObjectArr:Array;
		private var _selectWizard:WizardObject;			//当前选中模型

		/** 当前选中的模型 */
		public function get curSelectedWizardObject():WizardObject
		{
			return _curSelectedWizardObject;
		}

		/** 选择模型执行 **/
		private function onSelectModelCallBack(index:uint):void
		{
			trace(StageFrame.renderIdx,"[WizardBarMediator]/onSelectModelCallBack",id);
			if(!_nowWizardObjectArr || _nowWizardObjectArr.length <= index) return;
			//实例化精灵
			var wo :WizardObject = _nowWizardObjectArr[index];
			if(wo == null ) return;
			view.modelIdText.text = wo.id;
			_selectWizard = wo;
			dispatchWith(NotifyConst.STATUS,false,"选择模型ID"+wo.id +" "+wo.name);
			//实例化精灵
			dispatchWith(NotifyConst.SELECT_WIZARD_PREVIEW,false , wo);
		}

		private function onPaging(event:Event):void
		{
			var pag:int = view.modelPageBtn.nowPage;
			_nowWizardObjectArr = wizardVector.slice((pag-1)*_showNum, pag*_showNum);
			var len:int = _nowWizardObjectArr.length;
			var vector:Vector.<Array> = new Vector.<Array>(len, true);
			for(var i:int = 0; i < len; i++)
				vector[i] = ["", _nowWizardObjectArr[i].id, _nowWizardObjectArr[i].name];//第一个空字符串是因为0是显示按钮用的,用个空字符串填充
			//设置数据
			view.modelListVC.setData(vector);
		}
		/**点击查找按钮*/
		private function onClickSearch(event:MouseEvent):void
		{
			var id:String = view.modelIdText.text;
			var leng:int = wizardVector.length;
			var obj:WizardObject
			for (var i:int = 0; i < leng; i++)
			{
				obj = wizardVector[i];
				if(obj.id == id)
				{
					view.modelPageBtn.nowPage = int(i/_showNum) + 1;
					break;
				}
			}
		}

	}
}
