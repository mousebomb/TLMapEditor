/**
 * Created by gaord on 2016/12/13.
 */
package tl.mapeditor.ui
{
	import tl.mapeditor.ToolBoxType;
	import tl.mapeditor.ui.common.MyButton;
	import tl.mapeditor.ui.common.MySprite;
	import tl.utils.Tool;

	import tool.StageFrame;

	/** 80宽 工具条 */
	public class OperationBar extends MySprite
	{
		public static  var btnNameVec:Vector.<String> = Vector.<String>([
			ToolBoxType.BAR_NAME_6, ToolBoxType.BAR_NAME_7, ToolBoxType.BAR_NAME_8,
			ToolBoxType.BAR_NAME_11, ToolBoxType.BAR_NAME_12, ToolBoxType.BAR_NAME_13,
			ToolBoxType.BAR_NAME_14, ToolBoxType.BAR_NAME_15, ToolBoxType.BAR_NAME_16, ToolBoxType.BAR_NAME_27,
			ToolBoxType.BAR_NAME_30, ToolBoxType.BAR_NAME_28, ToolBoxType.BAR_NAME_9, ToolBoxType.BAR_NAME_10]);
		public function OperationBar()
		{
			init();
		}
		private function init():void
		{
			if(this.isInit)
				return;
			this.isInit = true;
			//实例化按钮
			var len:uint = btnNameVec.length;
			var btn:MyButton;
			var locationX:int = 5;
			for(var i:int = 0; i < len; i++)
			{
				btn = Tool.getMyBtn(btnNameVec[i], 70);
				btn.name = btnNameVec[i];
				this.addChild(btn);
				btn.x = locationX;
				btn.y = 15 + i * (btn.myHeight + 5);
				btn.selected = false;
			}
		}

		override  public function onResize():void
		{
			var vw:int = 90;
			var vh:int = StageFrame.stage.stageHeight;
			this.drawRect(vw, vh, 0x2F2E2E);
		}


	}
}
