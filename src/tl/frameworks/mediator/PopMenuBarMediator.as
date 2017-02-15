/**
 * Created by Administrator on 2017/2/9.
 */
package tl.frameworks.mediator
{
	import HLib.Tool.Tool;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;

	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.model.vo.CreateMapVO;
	import tl.mapeditor.Config;
	import tl.mapeditor.ToolBoxType;

	import tl.mapeditor.ui.PopMenuBar;
	import tl.mapeditor.ui.common.MyTextButton;

	public class PopMenuBarMediator extends Mediator
	{
		public function PopMenuBarMediator()
		{
			super();
		}

		[Inject]
		public var view: PopMenuBar;
		private var _file:File;
		private var _fileFilter:FileFilter = new FileFilter("*.tlmap", "*.tlmap");

		override public function onRegister():void
		{
			super.onRegister();

			addViewListener(MouseEvent.CLICK,onItemClick)
		}

		private function onItemClick(event:MouseEvent):void
		{
			if(event.target is MyTextButton)
			{
				var btnName:String = event.target.name;
				switch (btnName)
				{
					case ToolBoxType.BAR_NAME_17 :
						dispatchWith(NotifyConst.NEW_MAP_UI);
						break;
					case ToolBoxType.BAR_NAME_18 :
						_file = new File();
						_file.addEventListener(Event.SELECT, onSelect, false, 0, true);			//选择后派发
						_file.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
						_file.browseForOpen("打开地图文件", [_fileFilter]);
						break;
					case ToolBoxType.BAR_NAME_19 :
						dispatchWith(NotifyConst.SAVE_MAP,false);
						break;
					case ToolBoxType.BAR_NAME_25 :
						dispatchWith(NotifyConst.NEW_BRUSHSETTING_UI);
						break;
					case ToolBoxType.BAR_NAME_26 :
						dispatchWith(NotifyConst.NEW_COVERAGEPANEL_UI);
						break;
					case ToolBoxType.BAR_NAME_31 :
						dispatchWith(NotifyConst.NEW_LONG_UI);
						break;
					default :
						dispatchWith(NotifyConst.SWITCH_TOOLBOX, false, btnName);
						break;
				}
			}


		}
		/** 选择完成执行 **/
		private function onSelect(e:Event):void
		{
			var url:String = _file.nativePath;
			var fileName:String = String(_file.name).split(".")[0];
			//_file.load();

			dispatchWith(NotifyConst.LOAD_MAP,false,_file);
			//dispatchWith(NotifyConst.LOAD_MAP,false,File.desktopDirectory.resolvePath(Config.MAP_URL+_file.name));
		}
		/** 文件加载完成 **/
		private function onLoadComplete(e:Event):void
		{
			_file.removeEventListener(Event.SELECT, onSelect);
			_file.removeEventListener(Event.COMPLETE, onLoadComplete);
			//解析xml
			var bytes:ByteArray = ByteArray(e.target.data);
		}
	}
}
