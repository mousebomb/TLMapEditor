/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.text.TextField;
	import flash.utils.ByteArray;

	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.model.vo.CreateMapVO;
	import tl.mapeditor.ToolBoxType;
	import tl.mapeditor.ui.CreateFileUI;
	import tl.mapeditor.ui.common.MyButton;
	import tl.mapeditor.ui.common.MyTextField;

	import tool.StageFrame;

	public class CreateFileUIMediator extends Mediator
	{
		[Inject]
		public var view:CreateFileUI;
		private var _mapW:uint = 1024;			//地图宽度
		private var _mapH:uint = 1024;			//地图高度
		private var _mapN:String = '新地图';		//地图名称
		private var _oldInput:String;			//原来的输入文本
		private var _mapFile:File;
		private var _fileFilter:FileFilter = new FileFilter("*.png", "*.png");
		//地图高度图文件
		public function CreateFileUIMediator()
		{
			super();
		}


		override public function onRegister():void
		{
			super.onRegister();

			view.init("新建地图", 260, 155);
			view.x = StageFrame.stage.stageWidth - view.myWidth >> 1;
			view.y = StageFrame.stage.stageHeight - view.myHeight >> 1;

			addViewListener(MouseEvent.CLICK,onItemClick);
			eventMap.mapListener(view.inputTextW, Event.CHANGE, onTextChange)
			eventMap.mapListener(view.inputTextW, FocusEvent.FOCUS_IN, onTextFocusIn)
			eventMap.mapListener(view.inputTextW, FocusEvent.FOCUS_OUT, onTextFocusOut);

			eventMap.mapListener(view.inputTextH, Event.CHANGE, onTextChange);
			eventMap.mapListener(view.inputTextH, FocusEvent.FOCUS_OUT, onTextFocusOut);
			eventMap.mapListener(view.inputTextH, FocusEvent.FOCUS_IN, onTextFocusIn);

			eventMap.mapListener(view.inputTextN, Event.CHANGE, onTextChange);
			eventMap.mapListener(view.inputTextN, FocusEvent.FOCUS_OUT, onTextFocusOut);
			eventMap.mapListener(view.inputTextN, FocusEvent.FOCUS_IN, onTextFocusIn);

			eventMap.mapListener(view.inputTextN, Event.CHANGE, onTextChange);
			eventMap.mapListener(view.inputTextN, FocusEvent.FOCUS_OUT, onTextFocusOut);
			eventMap.mapListener(view.inputTextN, FocusEvent.FOCUS_IN, onTextFocusIn);
		}

		private function onItemClick(event:MouseEvent):void
		{
			if(event.target is MyButton)
			{
				if(event.target.name == ToolBoxType.CREATE_FILE)
				{
					if(view && view.parent)
							view.parent.removeChild(view)
					dispatchWith(NotifyConst.NEW_MAP, false,new CreateMapVO(_mapW, _mapH, _mapN, _mapFile));
				}	else if(event.target.name == '选择高度图') {
					_mapFile = new File();
					_mapFile.addEventListener(Event.SELECT, onSelect, false, 0, true);			//选择后派发
					//_mapFile.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
					_mapFile.browseForOpen("选择高度图", [_fileFilter]);
				}
			}
		}

		/** 发生改变执行 **/
		private function onTextChange(event:Event):void
		{
			var textField:MyTextField = MyTextField(event.currentTarget);
			switch(textField.name)
			{
				case "地图宽度":	//列数
					_mapW = uint(textField.text);
					break;
				case "地图高度"://图片前缀
					_mapH = uint(textField.text);
					break;
				case "地图命名"://图片目录
					_mapN = textField.text;
					break;
			}
		}
		/** 输入文本获得焦点执行 **/
		private function onTextFocusIn(e:FocusEvent):void
		{
			var textField:MyTextField = MyTextField(e.currentTarget);

			switch(textField.name)
			{
				case "地图宽度":	//列数
					_oldInput = _mapW.toString();
					break;
				case "地图高度"://图片前缀
					_oldInput = _mapH.toString();
					break;
				case "地图命名"://图片目录
					_oldInput = _mapN;
					break;
			}
			textField.text = "";
		}
		/** 输入文本失去焦点执行 **/
		private function onTextFocusOut(e:FocusEvent):void
		{
			var textField:MyTextField = MyTextField(e.currentTarget);
			if(textField.text != '')	return;
			var text:String = '';
			switch(textField.name)
			{
				case "地图宽度":	//列数
					text = _mapW.toString();
					break;
				case "地图高度"://图片前缀
					text = _mapH.toString();
					break;
				case "地图命名"://图片目录
					text = _mapN;
					break;
			}
			textField.text = text
		}

		/** 选择完成执行 **/
		private function onSelect(e:Event):void
		{
			var url:String = _mapFile.nativePath;
			//名字
			var fileName = String(_mapFile.name).split(".")[0];
			//_mapFile.load();
		}
		/** 文件加载完成 **/
		private function onLoadComplete(e:Event):void
		{
			_mapFile.removeEventListener(Event.SELECT, onSelect);
			_mapFile.removeEventListener(Event.COMPLETE, onLoadComplete);
			var bytes:ByteArray = ByteArray(e.target.data);
		}
	}
}
