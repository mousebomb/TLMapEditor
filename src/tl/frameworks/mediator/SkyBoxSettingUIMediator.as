/**
 * Created by Administrator on 2017/2/18.
 */
package tl.frameworks.mediator
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	import org.robotlegs.mvcs.Mediator;

	import tl.core.GPUResProvider;

	import tl.frameworks.NotifyConst;

	import tl.frameworks.model.SkyBoxTextureListModel;
	import tl.mapeditor.ui.common.MyButton;

	import tl.mapeditor.ui.window.SkyBoxSettingUI;

	import tool.StageFrame;

	/**设置天空盒子*/
	public class SkyBoxSettingUIMediator extends Mediator
	{
		[Inject]
		public var view: SkyBoxSettingUI;
		[Inject]
		public var model: SkyBoxTextureListModel;
		[Inject]
		public var gpuRes:GPUResProvider;
		private var _sourceArr:Array;
		public function SkyBoxSettingUIMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			super.onRegister();

			view.init('设置天空盒', 360, 240);
			view.x = StageFrame.stage.stageWidth - view.myWidth >> 1;
			view.y = StageFrame.stage.stageHeight - view.myHeight >> 1;
			var len:int = view.vectorBtn.length;
			for(var i:int=0; i<len; i++)
			{
				view.vectorBtn[i].addEventListener(MouseEvent.CLICK, onClickBtn)
			}
			addViewListener(NotifyConst.SKYBOX_TEXTURES_LIST_LOADED,onListComplete);
			if(model.list)
				onListComplete(null)
		}

		private function onClickBtn(event:MouseEvent):void
		{
			var btn:MyButton = event.currentTarget as MyButton;

			dispatchWith(NotifyConst.TOOL_SKYBOX_SET,false, btn.label);
		}

		private function onListComplete(event:*):void
		{
			_sourceArr = [];
			var len:int = view.vectorBtn.length;
			var leng:int = model.list.length;
			for(var i:int=0; i<len; i++)
			{
				if(i<leng)
				{
					view.vectorBtn[i].visible = true;
					view.vectorBtn[i].label = model.list[i].name;
				}	else{
					view.vectorBtn[i].visible = false;
				}
			}
		}
	}
}
