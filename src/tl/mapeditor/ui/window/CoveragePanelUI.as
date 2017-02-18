/**
 * Created by Administrator on 2017/2/10.
 */
package tl.mapeditor.ui.window
{

	import away3d.core.render.BackgroundImageRenderer;

	import fl.containers.BaseScrollPane;
	import fl.controls.List;
	import fl.controls.ScrollBar;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import org.mousebomb.ui.ScrollContainer;

	import tl.core.old.WizardObject;

	import tl.mapeditor.ui.common.MyButton;
	import tl.mapeditor.ui.common.MySprite;
	import tl.mapeditor.ui.common.MyTextField;

	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;

	/**图层面板界面*/
	public class CoveragePanelUI extends UIBase
	{
		public var typeList:List;
		public var wizardList:List;
		public function CoveragePanelUI()
		{
			super();
		}

		override public function init(title:String, $width:int = 100, $height:int = 100, bgColor:uint = 0x2F2E2E, hasCloseBtn:Boolean = true, isDrag:Boolean = true):void
		{
			if(this.isInit) return;
			this.isInit = true;
			super.init(title, $width, $height, bgColor, hasCloseBtn, isDrag);

			var text:MyTextField = Tool.getMyTextField(190, -1, 12, 0x999999, "center");
			this.addChild(text);
			text.x = 10;
			text.y = titleY + 5;
			text.text = '类型选择';

			bgSpr = new MySprite();
			this.addChild(bgSpr);
			Tool.drawRectByGraphics(bgSpr.graphics, null, 190, 410, 0x191818, 1, 0, 0, 1, 0x3D3D3D);
			bgSpr.x = 10;
			bgSpr.y = 50;
			typeList = new List();
			typeList.setSize(180, 400)
			bgSpr.addChild(typeList);
			typeList.labelField = 'type';
			typeList.iconFunction = iconFunction;
			typeList.x = 5;
			typeList.y = 5;

			text = Tool.getMyTextField(240, -1, 12, 0x999999, "center");
			this.addChild(text);
			text.x = 190;
			text.y = titleY + 5;
			text.text = '模型选择';

			var bgSpr:MySprite;
			bgSpr = new MySprite();
			this.addChild(bgSpr);
			Tool.drawRectByGraphics(bgSpr.graphics, null, 240, 410, 0x191818, 1, 0, 0, 1, 0x3D3D3D);
			bgSpr.x = 210;
			bgSpr.y = 50;

			wizardList = new List();
			bgSpr.addChild(wizardList);
			wizardList.x = 5;
			wizardList.y = 5;
			wizardList.setSize(230, 400);
			wizardList.labelField = 'name';
			wizardList.iconField = 'name';
		}
		private function iconFunction (obj:Object):Bitmap
		{
			return new Bitmap(new Skin_add_up())
		}

		override protected function onClickClose(e:MouseEvent = null):void
		{
			super.onClickClose(e);
		}
	}
}
