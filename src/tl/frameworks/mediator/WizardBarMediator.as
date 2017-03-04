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
	import flash.utils.Timer;

	import org.mousebomb.framework.Notify;
	import org.robotlegs.mvcs.Mediator;

	import tl.core.role.model.CsvResTypeVO;

	import tl.core.role.model.CsvRoleVO;
	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;
	import tl.frameworks.model.CsvDataModel;
	import tl.frameworks.model.WizardResTypeModel;
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
		public var csvModel:CsvDataModel;
		[Inject]
		public var resTypeModel:WizardResTypeModel;

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
			if(csvModel.table_wizard.size)
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
			var resType:int = resTypeModel.resTypeByName[name];
			onMenuSelectCallBack(resType);
		}
		private function onViewMove():void
		{
			TLMapEditor.view3DForPreview.x = view.x + 10;
			TLMapEditor.view3DForPreview.y = view.y + 35;
		}

		private function onClickSelect(event:MouseEvent):void
		{
			ToolBoxType.popmenuX = view.x + view.myWidth;
			var mh:int = 18.5*resTypeModel.resTypeCount;
			var vh:int = StageFrame.stage.stageHeight - mh;
			var vy:int = view.y + view.selectBtn.y ;
			if(vy + mh*.5 < StageFrame.stage.stageHeight)
				ToolBoxType.popmenuY = vy - mh * .5;
			else
				ToolBoxType.popmenuY = vh;
			dispatchWith(NotifyConst.NEW_POPMENUBAR_UI, false, resTypeModel.resTypeAsArray);
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

		private var wizardVector:Array;

		private function onCsvLoaded(n:Notify):void
		{
			dispatchWith(NotifyConst.STATUS, false, "加载完毕");

			// 整理分类方式 采用栋哥配置表里的
			resTypeModel.parseResTypes( csvModel );

			//默认选第一项
			onMenuSelectCallBack(resTypeModel.resTypeByName[resTypeModel.resTypeAsArray[0]]);
		}

		/** 选择类型后 **/
		private function onMenuSelectCallBack(resType:int):void
		{
			if(!resTypeModel.modelByResType[resType])
			{
				return;
			}
			//设置数据
			wizardVector = resTypeModel.modelByResType[resType];
			//设置类型文本显示
			view.modelTypeText.text = (csvModel.table_restype.get(resType) as CsvResTypeVO).Name;
			var len:int = wizardVector.length;
			view.modelPageBtn.maxPage = int(len/_showNum) + 1;
			view.modelPageBtn.nowPage = 1;
		}

		/** 当前选中的模型 */
		private var _curSelectedWizardObject :CsvRoleVO ;
		private const _showNum:int = 13;
		private var _nowWizardObjectArr:Array;
		private var _selectWizard:CsvRoleVO;			//当前选中模型

		/** 当前选中的模型 */
		public function get curSelectedWizardObject():CsvRoleVO
		{
			return _curSelectedWizardObject;
		}

		/** 选择模型执行 **/
		private function onSelectModelCallBack(index:uint):void
		{
			trace(StageFrame.renderIdx,"[WizardBarMediator]/onSelectModelCallBack",id);
			if(!_nowWizardObjectArr || _nowWizardObjectArr.length <= index) return;
			//实例化精灵
			var wo :CsvRoleVO = _nowWizardObjectArr[index];
			if(wo == null ) return;
			view.modelIdText.text = wo.Id;
			_selectWizard = wo;
			dispatchWith(NotifyConst.STATUS,false,"选择模型ID"+wo.Id +" "+wo.Name);
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
				vector[i] = ["", _nowWizardObjectArr[i].Id, _nowWizardObjectArr[i].Name];//第一个空字符串是因为0是显示按钮用的,用个空字符串填充
			//设置数据
			view.modelListVC.setData(vector);
		}
		/**点击查找按钮*/
		private function onClickSearch(event:MouseEvent):void
		{
			var id:String = view.modelIdText.text;
			var leng:int = wizardVector.length;
			var obj:CsvRoleVO;
			for (var i:int = 0; i < leng; i++)
			{
				obj = wizardVector[i];
				if(obj.Id == id)
				{
					view.modelPageBtn.nowPage = int(i/_showNum) + 1;
					break;
				}
			}
		}

	}
}
