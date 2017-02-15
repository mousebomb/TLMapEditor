/**
 * Created by Administrator on 2017/2/9.
 */
package tl.mapeditor.ui
{
	import tl.mapeditor.ToolBoxType;
	import tl.mapeditor.ui.common.MyButton;
	import tl.mapeditor.ui.common.MySprite;
	import tl.utils.Tool;

	import tool.StageFrame;

	public class Toolbar extends MySprite
	{
		public static var btnNameVec:Vector.<String> = Vector.<String>([ ToolBoxType.BAR_NAME_1, ToolBoxType.BAR_NAME_2, ToolBoxType.BAR_NAME_3 , ToolBoxType.BAR_NAME_4, ToolBoxType.BAR_NAME_5]);

		public function Toolbar()
		{
			init();
		}

		private function init():void
		{
			if(this.isInit)
					return;
			this.isInit = true;
			var len:uint = btnNameVec.length;
			var btn:MyButton;
			for(var i:int = 0; i < len; i++)
			{
				btn = Tool.getMyBtn(btnNameVec[i], 70);
				btn.name = btnNameVec[i];
				this.addChild(btn);
				btn.x = i * 85 + 90;
				btn.y = 5;
				btn.selected = false;
			}
		}

		override  public function onResize():void
		{
			var vw:int = StageFrame.stage.stageWidth;
			var vh:int = 32;
			this.drawRect(vw, vh, 0x333333);
		}

	}
}
