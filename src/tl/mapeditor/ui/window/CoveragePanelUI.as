/**
 * Created by Administrator on 2017/2/10.
 */
package tl.mapeditor.ui.window
{

	import fl.controls.List;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;

	import tl.mapeditor.ui.common.MyScrollBar;

	import tl.mapeditor.ui.common.MySprite;
	import tl.mapeditor.ui.common.MyTextField;
	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;

	/**图层面板界面*/
	public class CoveragePanelUI extends UIBase
	{
		public var myScrollBar:MyScrollBar;
		public var scrollTarget:MySprite;
		public var rendererSpr:MySprite;
		public function CoveragePanelUI()
		{
			super();
		}

		override public function init(title:String, $width:int = 100, $height:int = 100, bgColor:uint = 0x2F2E2E, hasCloseBtn:Boolean = true, isDrag:Boolean = true):void
		{
			if(this.isInit) return;
			this.isInit = true;
			super.init(title, $width, $height, bgColor, hasCloseBtn, isDrag);


			var bgSpr:MySprite = new MySprite();
			Tool.drawRectByGraphics(bgSpr.graphics, null, this.myWidth-20, this.myHeight-60, 0x191818, 1, 0, 0, 1, 0x3D3D3D);
			bgSpr.x = 10;
			bgSpr.y = 50;
			this.addChild(bgSpr)

			scrollTarget = new MySprite();
			bgSpr.addChild(scrollTarget);


			var bmd:BitmapData = new renderer_up();
			var bm:Bitmap = new Bitmap(bmd);
			bm.width = this.myWidth - 55;
			bm.visible = false;
			scrollTarget.addChild(bm);

			var text:MyTextField;
			myScrollBar = new MyScrollBar();
			bgSpr.addChild(myScrollBar);
			myScrollBar.InIt(12, this.myHeight-70);
			myScrollBar.x = this.myWidth - 45;
			myScrollBar.y = 5;

			myScrollBar.scrollTarget = scrollTarget;
			rendererSpr = new MySprite();
		}
		private function iconFunction (obj:Object):Bitmap
		{
			return new Bitmap(new Skin_add_up())
		}
		private function wizardLabelFunction (obj:Object):String
		{
			return obj.toString();
		}
		private function wizardIconFunction (obj:Object):Bitmap
		{
			return null;
		}

		override protected function onClickClose(e:MouseEvent = null):void
		{
			super.onClickClose(e);
		}
	}
}
