/**
 * Created by Administrator on 2017/2/10.
 */
package tl.mapeditor.ui.window
{
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
		private var _displayAreaSprite:MySprite;
		private var _thumbnailSprite:MySprite;
		private var _maskRect:Rectangle;
		private var displayArea:MySprite;				//当前可拖动的显示区域
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

			_displayAreaSprite = new MySprite();
			this.addChild(_displayAreaSprite);
			_displayAreaSprite.mouseEnabled = false;

			_thumbnailSprite = new MySprite();
			_displayAreaSprite.addChild(_thumbnailSprite);
			Tool.drawRectByGraphics(_thumbnailSprite.graphics, null, 32, 32);
			_thumbnailSprite.width = this.myWidth-10;
			_thumbnailSprite.height = this.myHeight-titleY-15;
			_displayAreaSprite.x = (this.myWidth - _thumbnailSprite.width)/2;
			_displayAreaSprite.y = titleY + 5;
			//mask
			_maskRect = new Rectangle(0, 0, _thumbnailSprite.width, _thumbnailSprite.height);
			_displayAreaSprite.scrollRect = _maskRect;
			//显示区域sprite
			displayArea = new MySprite();
			_displayAreaSprite.addChild(displayArea);
			displayArea.buttonMode = true;
		}

		override protected function onClickClose(e:MouseEvent = null):void
		{

			super.onClickClose(e);
		}
	}
}
