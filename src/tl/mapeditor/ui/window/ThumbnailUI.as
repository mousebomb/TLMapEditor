/**
 * Created by Administrator on 2017/2/10.
 */
package tl.mapeditor.ui.window
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import tl.mapeditor.ui.common.MySprite;

	import tl.mapeditor.ui.common.MyTextField;

	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;

	/**缩略图*/
	public class ThumbnailUI extends UIBase
	{
		public var positionTxt:MyTextField;
		public var displayArea:MySprite;
		public var moveRect:Rectangle;
		private var displayAreaSprite:MySprite;
		private var _mapBd:Bitmap;
		//当前可拖动的显示区域
		public function ThumbnailUI()
		{
			super();
		}

		override public function init(title:String, $width:int = 100, $height:int = 100, bgColor:uint = 0x2F2E2E, hasCloseBtn:Boolean = true, isDrag:Boolean = true):void
		{
			if(this.isInit) return;
			this.isInit = true;
			super.init(title, $width, $height, bgColor, hasCloseBtn, isDrag);

			positionTxt = Tool.getMyTextField(100, 38, 12, 0xFFFFFF, "left", 2, true);
			this.addChild(positionTxt);
			positionTxt.mouseEnabled = positionTxt.mouseWheelEnabled = false;
			Tool.setDisplayGlowFilter(positionTxt);
			positionTxt.multiline = true;
			positionTxt.x = 6;
			positionTxt.y = 2;
			positionTxt.text = "x:0\ny:0";

			displayAreaSprite = new MySprite();
			this.addChild(displayAreaSprite);
			displayAreaSprite.mouseEnabled = false;

			displayAreaSprite.x = 10;
			displayAreaSprite.y = 30;
			moveRect = new Rectangle(0, 0, this.myWidth-20-32, this.myHeight-40-32);
			//_displayAreaSprite.scrollRect = _maskRect;
			//显示区域sprite
			displayArea = new MySprite();
			displayAreaSprite.addChild(displayArea);
			Tool.drawRectByGraphics(displayArea.graphics, null, 32, 32, 0, 0, 0, 0, 1, 0xFF0000);
			displayArea.buttonMode = true;
		}

		override protected function onClickClose(e:MouseEvent = null):void
		{
			super.onClickClose(e);
		}

		public function showThumbnailInfo(bmd:BitmapData):void
		{
			if(!_mapBd)
				_mapBd = new Bitmap(bmd);
			else
				_mapBd.bitmapData = bmd;
			_mapBd.width = this.myWidth - 20;
			_mapBd.height = this.myHeight - titleY - 15;
			displayAreaSprite.addChildAt(_mapBd, 0);
		}
	}
}
